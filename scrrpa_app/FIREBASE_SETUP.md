# 🔥 Firebase Setup Guide for N-SCRRA

This comprehensive guide will walk you through setting up Firebase for the N-SCRRA application, including Authentication, Firestore, Storage, Cloud Messaging, and Analytics.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Create Firebase Project](#step-1-create-firebase-project)
3. [Enable Firebase Services](#step-2-enable-firebase-services)
4. [Configure Android App](#step-3-configure-android-app)
5. [Configure iOS App](#step-4-configure-ios-app)
6. [Install Flutter Firebase Packages](#step-5-install-flutter-firebase-packages)
7. [Initialize Firebase in Flutter](#step-6-initialize-firebase-in-flutter)
8. [Configure Firestore Security Rules](#step-7-configure-firestore-security-rules)
9. [Configure Storage Rules](#step-8-configure-storage-rules)
10. [Setup Backend Firebase Admin](#step-9-setup-backend-firebase-admin)
11. [Testing Firebase Connection](#step-10-testing-firebase-connection)
12. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before starting, ensure you have:

- ✅ Google Account
- ✅ Flutter SDK installed (3.11.0+)
- ✅ Android Studio (for Android development)
- ✅ Xcode (for iOS development - macOS only)
- ✅ Node.js (for Firebase CLI - optional but recommended)
- ✅ Internet connection

---

## Step 1: Create Firebase Project

### 1.1 Go to Firebase Console

Visit [Firebase Console](https://console.firebase.google.com/)

### 1.2 Create New Project

1. Click **"Add project"** or **"Create a project"**
2. Enter project name: `N-SCRRA` (or your preferred name)
3. Click **"Continue"**

### 1.3 Google Analytics (Optional but Recommended)

1. Toggle **"Enable Google Analytics for this project"** - **ON**
2. Click **"Continue"**
3. Select or create Google Analytics account
4. Accept terms and click **"Create project"**

### 1.4 Wait for Setup

Firebase will set up your project (takes 30-60 seconds)

---

## Step 2: Enable Firebase Services

### 2.1 Enable Authentication

1. In Firebase Console, click **"Authentication"** in left sidebar
2. Click **"Get started"**
3. Navigate to **"Sign-in method"** tab

#### Enable Email/Password Authentication
1. Click **"Email/Password"**
2. Toggle **"Enable"** - **ON**
3. (Optional) Toggle **"Email link (passwordless sign-in)"** - **ON**
4. Click **"Save"**

#### Enable Google Sign-In
1. Click **"Google"** in Sign-in providers
2. Toggle **"Enable"** - **ON**
3. Enter **Project support email**: your-email@example.com
4. Click **"Save"**

#### Enable Apple Sign-In (for iOS)
1. Click **"Apple"** in Sign-in providers
2. Toggle **"Enable"** - **ON**
3. You'll need to configure Apple Developer account details:
   - Service ID (from Apple Developer)
   - Team ID
   - Key ID
   - Private Key
4. Click **"Save"**

> **Note**: Apple Sign-In requires additional setup in Apple Developer Console

---

### 2.2 Enable Cloud Firestore

1. In left sidebar, click **"Firestore Database"**
2. Click **"Create database"**
3. Select location: Choose closest to your users (e.g., `us-central1`, `asia-south1`)
4. Choose starting mode:
   - **Production mode** (Recommended): Secure by default
   - **Test mode**: Open for 30 days (useful for development)
5. Click **"Enable"**

#### Create Initial Collections

Click **"Start collection"** and create these collections:

1. **users**
   - Document ID: Auto-ID
   - Fields:
     ```
     uid: string
     email: string
     displayName: string
     role: string (customer/supplier/admin)
     createdAt: timestamp
     ```

2. **orders**
   - Document ID: Auto-ID
   - Fields:
     ```
     orderId: string
     customerId: string
     supplierId: string
     status: string
     items: array
     createdAt: timestamp
     ```

3. **alerts**
   - Document ID: Auto-ID
   - Fields:
     ```
     type: string
     severity: string
     message: string
     userId: string
     isRead: boolean
     createdAt: timestamp
     ```

---

### 2.3 Enable Cloud Storage

1. Click **"Storage"** in left sidebar
2. Click **"Get started"**
3. Choose security rules:
   - Start in **production mode** (recommended)
   - Or **test mode** for development
4. Select storage location (same as Firestore)
5. Click **"Done"**

Storage bucket created: `your-project-id.appspot.com`

---

### 2.4 Enable Cloud Messaging (FCM)

1. Click **"Cloud Messaging"** in left sidebar
2. FCM is enabled by default with your project
3. No additional setup needed at this stage

---

### 2.5 Enable Firebase Analytics

1. Click **"Analytics"** in left sidebar
2. Analytics is automatically enabled if you selected it during project creation
3. Navigate to **"Events"** to see tracked events

---

### 2.6 Enable Remote Config (Optional)

1. Click **"Remote Config"** in left sidebar
2. Click **"Get started"**
3. Add parameters for dynamic configuration:

Example parameters:
```
maintenance_mode: false (boolean)
min_app_version: 1.0.0 (string)
api_base_url: https://your-api.com (string)
enable_ai_features: true (boolean)
```

---

## Step 3: Configure Android App

### 3.1 Register Android App

1. In Firebase Console, click the **Android icon** (or ⚙️ Settings → Project settings)
2. Click **"Add app"** → Select **Android**
3. Fill in details:
   - **Android package name**: `com.nscrra.scrrpa_app`
     (Get from `android/app/build.gradle` → `applicationId`)
   - **App nickname**: N-SCRRA Android (optional)
   - **Debug signing certificate SHA-1**: Required for Google Sign-In

### 3.2 Get SHA-1 Certificate

Open terminal and run:

```bash
# Windows (PowerShell)
cd android
./gradlew signingReport

# macOS/Linux
cd android
./gradlew signingReport
```

Look for **SHA-1** under **Variant: debug**:
```
SHA-1: 12:34:56:78:90:AB:CD:EF:...
```

Copy and paste into Firebase Console

### 3.3 Download google-services.json

1. Click **"Download google-services.json"**
2. Move the file to:
   ```
   scrrpa_app/android/app/google-services.json
   ```

### 3.4 Add Firebase SDK to Android

#### Edit `android/build.gradle`:

```gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath 'com.google.gms:google-services:4.4.0'  // Add this
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

#### Edit `android/app/build.gradle`:

Add at the **bottom** of the file:

```gradle
apply plugin: 'com.google.gms.google-services'  // Add this line
```

Add multidex support (if needed):

```gradle
android {
    defaultConfig {
        // ...
        multiDexEnabled true  // Add if you get multidex error
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'  // Add if needed
}
```

### 3.5 Update Android Manifest

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add internet permission -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <!-- For Firebase Messaging -->
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE"/>

    <application
        android:name="${applicationName}"
        android:label="N-SCRRA"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Firebase Messaging Service -->
        <service
            android:name="com.google.firebase.messaging.FirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
        
        <!-- ... rest of your config -->
    </application>
</manifest>
```

---

## Step 4: Configure iOS App

### 4.1 Register iOS App

1. In Firebase Console, click the **iOS icon** (⚙️ Settings → Project settings)
2. Click **"Add app"** → Select **iOS**
3. Fill in details:
   - **iOS bundle ID**: `com.nscrra.scrrpaApp`
     (Get from `ios/Runner.xcodeproj` → General → Bundle Identifier)
   - **App nickname**: N-SCRRA iOS (optional)
   - **App Store ID**: Leave blank for now

### 4.2 Download GoogleService-Info.plist

1. Click **"Download GoogleService-Info.plist"**
2. Open Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
3. Drag `GoogleService-Info.plist` into Runner folder in Xcode
4. ✅ Check **"Copy items if needed"**
5. ✅ Ensure **"Runner"** target is selected

### 4.3 Initialize Firebase in iOS

Edit `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import FirebaseCore  // Add this

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()  // Add this
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 4.4 Update Podfile

Edit `ios/Podfile`:

```ruby
platform :ios, '13.0'  # Update minimum iOS version

# Uncomment and update this line
# $iOSVersion = '13.0'

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Add this if you get build issues
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

### 4.5 Install iOS Dependencies

```bash
cd ios
pod install
cd ..
```

### 4.6 Configure Push Notifications (iOS)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** in Project Navigator
3. Go to **Signing & Capabilities**
4. Click **"+ Capability"**
5. Add **"Push Notifications"**
6. Add **"Background Modes"** and check:
   - ✅ Background fetch
   - ✅ Remote notifications

---

## Step 5: Install Flutter Firebase Packages

### 5.1 Update pubspec.yaml

Your `pubspec.yaml` already includes Firebase packages. Ensure versions are up-to-date:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase packages
  firebase_core: ^4.5.0
  firebase_auth: ^6.2.0
  cloud_firestore: ^6.1.3
  firebase_messaging: ^16.1.2
  firebase_remote_config: ^6.2.0
  firebase_storage: ^13.1.0
  firebase_analytics: ^12.1.3
  
  # Additional packages
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^7.0.1
```

### 5.2 Install Dependencies

```bash
flutter pub get
```

### 5.3 Install FlutterFire CLI (Recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase automatically
flutterfire configure
```

This will:
- ✅ Generate `lib/firebase_options.dart` automatically
- ✅ Configure all platforms
- ✅ Set up Firebase for your project

---

## Step 6: Initialize Firebase in Flutter

### 6.1 Create Firebase Options File

If you didn't use FlutterFire CLI, create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.nscrra.scrrpaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'com.nscrra.scrrpaApp',
  );
}
```

**Get these values from Firebase Console:**
- Go to ⚙️ Settings → Project settings
- Scroll to "Your apps"
- Click on each platform to see the config values

### 6.2 Initialize in main.dart

Edit `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N-SCRRA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
```

---

## Step 7: Configure Firestore Security Rules

### 7.1 Access Firestore Rules

1. Go to Firebase Console → Firestore Database
2. Click **"Rules"** tab

### 7.2 Set Production Rules

Replace with these secure rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    function isAdmin() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    function isSupplier() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'supplier';
    }
    
    function isCustomer() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'customer';
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && isOwner(userId);
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if isSignedIn() && (
        isOwner(resource.data.customerId) || 
        isOwner(resource.data.supplierId) || 
        isAdmin()
      );
      allow create: if isSignedIn() && (isCustomer() || isAdmin());
      allow update: if isSignedIn() && (
        isOwner(resource.data.customerId) || 
        isOwner(resource.data.supplierId) || 
        isAdmin()
      );
      allow delete: if isAdmin();
    }
    
    // Shipments collection
    match /shipments/{shipmentId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && (isSupplier() || isAdmin());
      allow update: if isSignedIn() && (isSupplier() || isAdmin());
      allow delete: if isAdmin();
    }
    
    // Alerts collection
    match /alerts/{alertId} {
      allow read: if isSignedIn() && (
        isOwner(resource.data.userId) || 
        isAdmin()
      );
      allow create: if isSignedIn();
      allow update: if isOwner(resource.data.userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Suppliers collection
    match /suppliers/{supplierId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && (isSupplier() || isAdmin());
      allow update: if isOwner(supplierId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Reports collection
    match /reports/{reportId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() && (
        isOwner(resource.data.createdBy) || 
        isAdmin()
      );
      allow delete: if isAdmin();
    }
    
    // Network analytics (read-only for most users)
    match /network/{nodeId} {
      allow read: if isSignedIn();
      allow write: if isAdmin();
    }
    
    // System settings (admin only)
    match /settings/{settingId} {
      allow read: if isSignedIn();
      allow write: if isAdmin();
    }
  }
}
```

### 7.3 Publish Rules

Click **"Publish"** to apply the rules.

---

## Step 8: Configure Storage Rules

### 8.1 Access Storage Rules

1. Go to Firebase Console → Storage
2. Click **"Rules"** tab

### 8.2 Set Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    function isAdmin() {
      return request.auth.token.admin == true;
    }
    
    // User profile images
    match /users/{userId}/profile/{allPaths=**} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && isOwner(userId);
    }
    
    // Order documents
    match /orders/{orderId}/{allPaths=**} {
      allow read: if isSignedIn();
      allow write: if isSignedIn();
    }
    
    // Reports
    match /reports/{reportId}/{allPaths=**} {
      allow read: if isSignedIn();
      allow write: if isSignedIn();
    }
    
    // Supplier documents
    match /suppliers/{supplierId}/{allPaths=**} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && (isOwner(supplierId) || isAdmin());
    }
    
    // Public assets
    match /public/{allPaths=**} {
      allow read: if true;
      allow write: if isAdmin();
    }
  }
}
```

### 8.3 Publish Rules

Click **"Publish"**.

---

## Step 9: Setup Backend Firebase Admin

### 9.1 Generate Service Account Key

1. Go to Firebase Console → ⚙️ Settings → Project settings
2. Click **"Service accounts"** tab
3. Click **"Generate new private key"**
4. Click **"Generate key"** to download JSON file
5. **Keep this file secure!** Never commit to version control

### 9.2 Move Service Account File

Rename and move to your backend directory:
```bash
mv ~/Downloads/your-project-xxxxx.json backend/firebase-service-account.json
```

### 9.3 Add to .gitignore

Edit `backend/.gitignore`:
```
firebase-service-account.json
*.json
.env
venv/
__pycache__/
```

### 9.4 Configure Backend Environment

Edit `backend/.env`:

```env
# Firebase Admin SDK
FIREBASE_SERVICE_ACCOUNT_PATH=./firebase-service-account.json
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com

# Or use individual credentials
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY_ID=your-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_KEY_HERE\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id
```

### 9.5 Initialize Firebase Admin in Backend

Create `backend/core/firebase.py`:

```python
import firebase_admin
from firebase_admin import credentials, auth, firestore, storage
import os
from dotenv import load_dotenv

load_dotenv()

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    try:
        # Check if already initialized
        firebase_admin.get_app()
        print("Firebase already initialized")
        return firebase_admin.get_app()
    except ValueError:
        # Not initialized, proceed with initialization
        
        # Option 1: Using service account file
        service_account_path = os.getenv('FIREBASE_SERVICE_ACCOUNT_PATH')
        if service_account_path and os.path.exists(service_account_path):
            cred = credentials.Certificate(service_account_path)
        else:
            # Option 2: Using environment variables
            cred = credentials.Certificate({
                "type": "service_account",
                "project_id": os.getenv('FIREBASE_PROJECT_ID'),
                "private_key_id": os.getenv('FIREBASE_PRIVATE_KEY_ID'),
                "private_key": os.getenv('FIREBASE_PRIVATE_KEY').replace('\\n', '\n'),
                "client_email": os.getenv('FIREBASE_CLIENT_EMAIL'),
                "client_id": os.getenv('FIREBASE_CLIENT_ID'),
                "auth_uri": "https://accounts.google.com/o/oauth2/auth",
                "token_uri": "https://oauth2.googleapis.com/token",
                "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            })
        
        firebase_admin.initialize_app(cred, {
            'storageBucket': os.getenv('FIREBASE_STORAGE_BUCKET')
        })
        
        print("Firebase initialized successfully")
        return firebase_admin.get_app()

# Firestore client
def get_firestore_client():
    return firestore.client()

# Storage client
def get_storage_bucket():
    return storage.bucket()

# Auth functions
def verify_firebase_token(token: str):
    """Verify Firebase ID token"""
    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception as e:
        print(f"Token verification failed: {e}")
        return None

def get_user_by_email(email: str):
    """Get user by email"""
    try:
        user = auth.get_user_by_email(email)
        return user
    except Exception as e:
        print(f"User not found: {e}")
        return None
```

---

## Step 10: Testing Firebase Connection

### 10.1 Test Flutter App

Create `lib/screens/test_firebase_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirebaseScreen extends StatelessWidget {
  const TestFirebaseScreen({super.key});

  Future<void> testFirebaseConnection() async {
    try {
      // Test Authentication
      print('Testing Firebase Auth...');
      final auth = FirebaseAuth.instance;
      print('✅ Firebase Auth initialized: ${auth.app.name}');
      
      // Test Firestore
      print('Testing Firestore...');
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('test').doc('test').set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Firebase is working!',
      });
      print('✅ Firestore write successful');
      
      final doc = await firestore.collection('test').doc('test').get();
      print('✅ Firestore read successful: ${doc.data()}');
      
      print('🎉 All Firebase services are working!');
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: testFirebaseConnection,
          child: const Text('Test Firebase Connection'),
        ),
      ),
    );
  }
}
```

Run the app and check the console for test results.

### 10.2 Test Backend Connection

Create `backend/test_firebase.py`:

```python
from core.firebase import initialize_firebase, get_firestore_client, verify_firebase_token
import datetime

def test_firebase():
    print("Testing Firebase Admin SDK...")
    
    try:
        # Initialize
        app = initialize_firebase()
        print(f"✅ Firebase initialized: {app.project_id}")
        
        # Test Firestore
        db = get_firestore_client()
        doc_ref = db.collection('test').document('backend_test')
        doc_ref.set({
            'message': 'Backend Firebase is working!',
            'timestamp': datetime.datetime.now(),
        })
        print("✅ Firestore write successful")
        
        doc = doc_ref.get()
        if doc.exists:
            print(f"✅ Firestore read successful: {doc.to_dict()}")
        
        print("🎉 All backend Firebase services are working!")
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    test_firebase()
```

Run:
```bash
cd backend
python test_firebase.py
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. **"Firebase App not initialized"**

**Solution:**
- Ensure `Firebase.initializeApp()` is called in `main.dart`
- Check that `firebase_options.dart` exists and has correct values
- Verify `google-services.json` / `GoogleService-Info.plist` are in correct locations

#### 2. **"Failed to get document because the client is offline"**

**Solution:**
```dart
// Enable offline persistence
await FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

#### 3. **Android Build Errors**

**Solution:**
- Clean and rebuild:
  ```bash
  cd android
  ./gradlew clean
  cd ..
  flutter clean
  flutter pub get
  flutter build apk
  ```

#### 4. **iOS CocoaPods Issues**

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

#### 5. **"Google Sign-In Failed"**

**Solution:**
- Verify SHA-1 certificate is added in Firebase Console
- Check that `google-services.json` is up to date
- Ensure Google Sign-In is enabled in Firebase Console

#### 6. **"Permission Denied" Errors**

**Solution:**
- Check Firestore Security Rules
- Verify user is authenticated
- Ensure user has correct role/permissions

#### 7. **Backend Firebase Admin Errors**

**Solution:**
- Verify service account JSON file exists
- Check environment variables are set correctly
- Ensure private key has `\n` newlines preserved

---

## 🔒 Security Best Practices

1. ✅ **Never commit** `google-services.json`, `GoogleService-Info.plist`, or service account keys
2. ✅ **Use environment variables** for sensitive data
3. ✅ **Enable App Check** to prevent API abuse
4. ✅ **Implement proper security rules** in Firestore and Storage
5. ✅ **Use HTTPS** for all API calls
6. ✅ **Rotate keys regularly** for production
7. ✅ **Enable Firebase App Check** for additional security
8. ✅ **Monitor usage** in Firebase Console

---

## 📊 Firebase Console Monitoring

### Where to Monitor:

1. **Authentication**: Console → Authentication → Users
2. **Firestore**: Console → Firestore → Data
3. **Storage**: Console → Storage → Files
4. **Functions**: Console → Functions (if using Cloud Functions)
5. **Analytics**: Console → Analytics → Dashboard
6. **Crashlytics**: Console → Crashlytics (if configured)

---

## 🚀 Next Steps

After Firebase setup is complete:

1. ✅ Implement authentication flows in your app
2. ✅ Create Firestore data models
3. ✅ Set up Cloud Messaging for push notifications
4. ✅ Configure Analytics events
5. ✅ Test all Firebase features thoroughly
6. ✅ Deploy security rules to production
7. ✅ Set up monitoring and alerts

---

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Firebase YouTube Channel](https://www.youtube.com/firebase)

---

## 💬 Support

If you encounter issues:

1. Check the [Firebase Status Dashboard](https://status.firebase.google.com/)
2. Review [FlutterFire GitHub Issues](https://github.com/firebase/flutterfire/issues)
3. Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase) with tag `firebase`
4. Join [Firebase Discord](https://discord.gg/BN2cgc3)

---

**Setup complete! 🎉 Your N-SCRRA app is now connected to Firebase.**
