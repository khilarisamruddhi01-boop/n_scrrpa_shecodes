import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

enum AuthStatus { initial, authenticating, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? firebaseUser;
  final Map<String, dynamic>? userData;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.firebaseUser,
    this.userData,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? firebaseUser,
    Map<String, dynamic>? userData,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      userData: userData ?? this.userData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final ApiService _apiService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  AuthState build() {
    _apiService = ref.watch(apiServiceProvider);
    final sub = _auth.authStateChanges().listen(_onAuthStateChanged);
    ref.onDispose(() => sub.cancel());
    return AuthState(status: AuthStatus.initial);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      state = AuthState(status: AuthStatus.unauthenticated);
    } else {
      // Fetch user data from backend
      try {
        final response = await _apiService.get('/auth/me');
        state = AuthState(
          status: AuthStatus.authenticated,
          firebaseUser: user,
          userData: response.data,
        );
      } catch (e) {
        state = AuthState(
          status: AuthStatus.authenticated,
          firebaseUser: user,
          errorMessage: 'Failed to sync with backend',
        );
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.message);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String role,
    required Map<String, dynamic> extraData,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    try {
      // 1. Create user in Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // 2. Register in FastAPI to sync data and set custom claims
      await _apiService.post('/auth/register', data: {
        'uid': userCredential.user?.uid,
        'email': email,
        'role': role,
        ...extraData,
      });
      
      // 3. Force token refresh to get custom claims (role)
      await userCredential.user?.getIdToken(true);
      
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
