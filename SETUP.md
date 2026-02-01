# Firebase Setup Guide for Smart Savings App

This guide provides step-by-step instructions to set up Firebase for the Smart Savings app.

## Prerequisites

- Google account
- Firebase CLI installed (`npm install -g firebase-tools`)
- Xcode (for iOS)
- Android Studio (for Android)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Create a new project**
3. Enter project name: `smart-savings`
4. Disable Google Analytics (optional)
5. Click **Create project**

## Step 2: Set Up Authentication

### Enable Email/Password Auth
1. In Firebase Console, go to **Authentication**
2. Click **Sign-in method**
3. Enable **Email/Password**
4. Save

### Enable Google Sign-In (Optional)
1. In **Sign-in method**, enable **Google**
2. Select your project support email
3. Save

## Step 3: Create Firestore Database

1. Go to **Cloud Firestore**
2. Click **Create database**
3. Select **Start in production mode**
4. Select region (choose closest to your location)
5. Click **Enable**

## Step 4: Configure Android

### Download Google Services File
1. In Firebase Console, go to **Project Settings**
2. Click **Add App** → **Android**
3. Enter:
   - Package name: `com.example.smart_savings`
   - App nickname: `Smart Savings Android`
4. Download `google-services.json`
5. Place it in `android/app/`

### Update Android Files

Edit `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

Edit `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.0.0')
}
```

## Step 5: Configure iOS

### Download GoogleService Info Plist
1. In Firebase Console, go to **Project Settings**
2. Click **Add App** → **iOS**
3. Enter:
   - Bundle ID: `com.example.smartSavings`
   - App nickname: `Smart Savings iOS`
4. Download `GoogleService-Info.plist`
5. Open Xcode: `open ios/Runner.xcworkspace`
6. Drag `GoogleService-Info.plist` into Xcode project
7. Make sure "Smart Savings" target is selected

### Update iOS Podfile

Edit `ios/Podfile` and uncomment the platform minimum version:
```ruby
platform :ios, '11.0'
```

## Step 6: Update Firebase Options

Edit `lib/firebase_options.dart`:

Replace the placeholders with your actual Firebase credentials from **Project Settings**:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  appId: 'YOUR_WEB_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  databaseURL: 'https://YOUR_PROJECT_ID.firebaseio.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  measurementId: 'YOUR_MEASUREMENT_ID',
);
```

## Step 7: Configure Firestore Security Rules

In Firebase Console, go to **Firestore Database** → **Rules** and replace with:

### Development Rules (for testing)
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      match /{document=**} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

### Production Rules (after testing)
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow create: if request.auth.uid != null;
      
      // Accounts subcollection
      match /accounts/{accountId} {
        allow read, write: if request.auth.uid == userId;
        allow delete: if request.auth.uid == userId && 
                         !exists(/databases/$(database)/documents/users/$(userId)/transactions/__name__=*[accountId==accountId]);
      }
      
      // Transactions subcollection
      match /transactions/{transactionId} {
        allow read, write: if request.auth.uid == userId;
      }
      
      // Budgets subcollection
      match /budgets/{budgetId} {
        allow read, write: if request.auth.uid == userId;
      }
      
      // Savings Goals subcollection
      match /savings_goals/{goalId} {
        allow read, write: if request.auth.uid == userId;
      }
    }
  }
}
```

## Step 8: Build & Run

### For Android
```bash
flutter clean
flutter pub get
flutter run
```

### For iOS
```bash
flutter clean
cd ios
pod install
cd ..
flutter pub get
flutter run
```

## Step 9: Test Firebase Connection

1. Run the app
2. Create an account
3. Try adding an account, transaction, or budget
4. Check Firebase Console → Firestore to verify data is being saved

## Troubleshooting

### iOS Build Fails
- Run `cd ios && pod deintegrate && pod install && cd ..`
- Clean build cache: `flutter clean`

### Android Build Fails
- Make sure `google-services.json` is in `android/app/`
- Sync gradle: In Android Studio, go to Tools → Android → Sync Now

### Firebase Connection Error
- Verify internet connection
- Check Firestore rules allow your operations
- Verify credentials in `firebase_options.dart`

### Emulator Testing
- For Android: `flutter run` automatically uses emulator
- For iOS: Run `open -a Simulator` then `flutter run`

## Next Steps

1. Set up [Firestore Indexes](https://console.firebase.google.com/project/_/firestore/indexes) if using complex queries
2. Configure [Cloud Storage](https://console.firebase.google.com/project/_/storage) for document backups
3. Set up [Firebase Analytics](https://console.firebase.google.com/project/_/analytics)
4. Configure [Firebase Messaging](https://console.firebase.google.com/project/_/notification) for push notifications

## Support

For more Firebase setup help, see:
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Plugin](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
