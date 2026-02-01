# Quick Start Guide

Get the Smart Savings app running in 5 minutes!

## 1. Prerequisites

Ensure you have:
- Flutter SDK (3.0+)
- Xcode (for iOS) or Android Studio (for Android)
- A Google account for Firebase

## 2. Clone & Install

```bash
cd smart-savings
flutter pub get
```

## 3. Firebase Setup (2 minutes)

### Option A: Quick Setup (Development)
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project called `smart-savings`
3. Enable Authentication → Email/Password
4. Create Firestore Database → Start in Production Mode
5. Copy your **Web API Key** from Project Settings
6. Update `firebase_options.dart` with your credentials

### Option B: Full Setup
Follow the detailed guide in [SETUP.md](SETUP.md)

## 4. Update Configuration

Edit `lib/firebase_options.dart` and replace placeholders:
```dart
// Get these from Firebase Console → Project Settings
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY', // Replace with actual key
  projectId: 'smart-savings', // Your project ID
  // ... other fields
);
```

## 5. Run the App

### Android
```bash
flutter run
```

### iOS
```bash
cd ios
pod install
cd ..
flutter run
```

### Web
```bash
flutter run -d chrome
```

## 6. Test Login

1. Tap **Sign Up**
2. Enter email and password
3. Tap **Sign Up**
4. You should see the Dashboard

## 7. Try Features

- **Add Account**: Tap the + button in Accounts tab
- **Add Transaction**: Tap the + button in Transactions tab
- **Create Budget**: Tap the + button in Budgets tab
- **Create Goal**: Navigate to Goals tab and tap + button

## 8. View Data in Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Open **Firestore Database**
3. Expand `users` → your user ID → `accounts`
4. You should see your created accounts!

## Troubleshooting

### "podspec for Firebase not found"
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

### "google-services.json not found"
- Download from Firebase Console → Project Settings → Add App → Android
- Place in `android/app/google-services.json`

### "MissingPluginException"
```bash
flutter clean
flutter pub get
flutter run
```

### "Invalid API Key"
- Check `firebase_options.dart` has correct credentials
- Verify in Firebase Console → Project Settings → API Keys

## Project Structure Overview

```
lib/
├── main.dart           ← Entry point
├── core/              ← Database, theme, routing
├── features/          ← Feature modules (auth, dashboard, etc.)
└── shared/            ← Shared UI components
```

## Key Files to Edit

1. **firebase_options.dart** - Your Firebase credentials
2. **lib/core/theme/app_theme.dart** - App colors and theme
3. **lib/core/navigation/app_router.dart** - Routes and navigation
4. **lib/features/*/screens/** - UI screens

## Next Steps

1. **Complete feature implementations** - Enhance dashboard, add charts, etc.
2. **Set up banking integration** - Connect to Plaid API
3. **Add push notifications** - Firebase Cloud Messaging
4. **Implement offline support** - Local Firestore caching
5. **Deploy to stores** - Google Play & App Store

## Important Files

- 📖 [README.md](README.md) - Full project documentation
- 🔧 [SETUP.md](SETUP.md) - Detailed Firebase setup guide
- 💻 [DEVELOPMENT.md](DEVELOPMENT.md) - Coding standards
- 📊 [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project overview

## Community & Support

- Flutter Community: https://flutter.dev/community
- Firebase Support: https://firebase.google.com/support
- Stack Overflow: Tag `flutter` and `firebase`

## Tips

✅ Use hot reload (`r` in terminal) for quick iterations
✅ Check the console for error messages
✅ Use Chrome DevTools for web debugging
✅ Read the error messages carefully - they usually help!
✅ Check Firestore rules if data isn't being saved

---

**You're all set!** 🎉 

Start building your personal finance app. Questions? Check the documentation or create an issue.

Happy coding! 🚀
