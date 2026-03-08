import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmailPassword(
    String email,
    String password, {
    String role = 'customer',
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    try {
      final apiService =
          ApiService(); // Use direct class or pass it via riverpod
      await apiService.post(
        '/auth/register',
        data: {
          "uid": userCredential.user!.uid,
          "email": userCredential.user!.email,
          "role": role,
        },
      );
      // Force token refresh so custom claims map instantly
      await userCredential.user?.getIdToken(true);
    } catch (e) {
      debugPrint('Failed to sync user with backend: $e');
      // depending on strictness could throw, but Firebase succeeded.
    }

    return userCredential;
  }

  Future<UserCredential?> signInWithGoogle({String role = 'customer'}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // Flow cancelled by user
      
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      final apiService = ApiService(); 
      await apiService.post(
        '/auth/google', // Use our new upsert route
        data: {
          "uid": userCredential.user!.uid,
          "email": userCredential.user!.email ?? '',
          "role": role,
        },
      );
      await userCredential.user?.getIdToken(true);
      return userCredential;
    } catch (e) {
      debugPrint('Google Sign In failed: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signInWithApple({String role = 'customer'}) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oAuthCredential);
      
      // Sync with FastAPI to create user if they don't exist and map role custom claims
      final apiService = ApiService(); 
      await apiService.post(
        '/auth/google', // The logic in backend/api/auth.py handles upserting Firebase UIDs perfectly for Apple too
        data: {
          "uid": userCredential.user!.uid,
          "email": userCredential.user!.email ?? appleCredential.email ?? '',
          "role": role,
        },
      );
      await userCredential.user?.getIdToken(true);

      return userCredential;
    } catch (e) {
      debugPrint('Apple Sign In failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String?> getIdToken() async {
    return await currentUser?.getIdToken();
  }

  Future<String?> getUserRole() async {
    if (currentUser == null) return null;
    final idTokenResult = await currentUser!.getIdTokenResult(
      true,
    ); // Force refresh to get latest claims
    return idTokenResult.claims?['role'] as String?;
  }
}
