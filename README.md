# Smart Savings & Expense Budgeting App

A modern, feature-rich Flutter app for personal finance management, inspired by **Wallet by BudgetBakers**. Manage accounts, track expenses, set budgets, and achieve savings goals with a beautiful, intuitive interface.

## Features

### 1. **Dashboard** 📊
- Total balance across all accounts
- Monthly & weekly spending overview
- Budget progress indicators
- Savings goal progress bars
- Quick access to recent transactions

### 2. **Accounts** 💰
- Manage multiple accounts (Cash, Bank, Mobile Money)
- View account balances
- Add, edit, and delete accounts
- Support for multiple currencies
- Total balance calculation

### 3. **Transactions** 💸
- Add income & expense transactions
- Auto and manual categorization
- Recurring transactions support
- Search, filter, and edit history
- Transaction details and notes

### 4. **Budgets** 📈
- Create weekly and monthly budgets
- Category-based spending limits
- Visual progress indicators
- Alerts when nearing or exceeding limits
- Budget overview and tracking

### 5. **Savings Goals** 🎯
- Create custom savings goals
- Track progress visually
- Set deadlines and targets
- Priority levels (High, Medium, Low)
- Smart recommendations based on spending patterns

### 6. **Reports & Analytics** 📉
- Spending breakdown by category
- Monthly trend analysis
- Visual charts and summaries
- Export to CSV/PDF (premium feature)
- Detailed financial reports

## Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile development (iOS & Android)
- **Provider** - State management
- **GoRouter** - Navigation and routing

### Backend
- **Firebase** 
  - Authentication (Email + Social login)
  - Cloud Firestore (Real-time database)
  - Firebase Storage (Document storage)
  - Firebase Analytics

### Additional Libraries
- **fl_chart** - Data visualization
- **syncfusion_flutter_charts** - Advanced charting
- **hive** - Local storage
- **uuid** - Unique ID generation
- **intl** - Internationalization
- **pdf** & **printing** - Document export
- **in_app_purchase** - Premium subscriptions

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── core/
│   ├── models/              # Data models
│   │   ├── account_model.dart
│   │   ├── transaction_model.dart
│   │   ├── budget_model.dart
│   │   └── savings_goal_model.dart
│   ├── repositories/        # Data access layer
│   │   ├── auth_repository.dart
│   │   ├── accounts_repository.dart
│   │   ├── transactions_repository.dart
│   │   ├── budgets_repository.dart
│   │   └── savings_goals_repository.dart
│   ├── services/
│   │   └── service_locator.dart  # Dependency injection
│   ├── theme/
│   │   └── app_theme.dart   # App styling
│   └── navigation/
│       └── app_router.dart   # Route configuration
├── features/
│   ├── auth/                # Authentication
│   │   ├── providers/
│   │   └── screens/
│   ├── dashboard/           # Dashboard feature
│   │   ├── providers/
│   │   └── screens/
│   ├── accounts/            # Accounts management
│   │   ├── providers/
│   │   └── screens/
│   ├── transactions/        # Transaction tracking
│   │   ├── providers/
│   │   └── screens/
│   ├── budgets/             # Budget management
│   │   ├── providers/
│   │   └── screens/
│   ├── savings_goals/       # Savings goals
│   │   ├── providers/
│   │   └── screens/
│   ├── reports/             # Analytics & reports
│   │   └── screens/
│   └── settings/            # App settings
│       └── screens/
└── shared/
    └── screens/             # Shared UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Firebase project setup
- Android Studio or Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/smart-savings.git
   cd smart-savings
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project
   - Add Android and iOS apps
   - Download configuration files
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
   - Update `firebase_options.dart` with your credentials

4. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Setup

### Create Firestore Database Structure

```
users/
├── {userId}/
│   ├── accounts/
│   │   ├── {accountId}
│   │   └── ...
│   ├── transactions/
│   │   ├── {transactionId}
│   │   └── ...
│   ├── budgets/
│   │   ├── {budgetId}
│   │   └── ...
│   └── savings_goals/
│       ├── {goalId}
│       └── ...
```

### Firestore Rules (Development)

```
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

## Monetization Model

### Free Tier
- Manual transaction tracking
- Basic budgets (monthly only)
- Limited analytics
- Advertisements

### Premium Subscription ($4.99/month)
- Bank account sync
- Advanced analytics & reports
- Weekly budgeting
- Cloud backup
- No advertisements
- PDF/CSV export
- Priority support

## API Integration Roadmap

### Phase 1 (Current)
- Firebase Auth & Firestore
- Local data sync

### Phase 2 (Coming Soon)
- Bank account integration (Plaid API)
- Google/Apple Sign-in
- Cloud Sync

### Phase 3 (Future)
- Advanced analytics
- AI-powered spending insights
- Multi-currency support
- Bill reminders
- Expense splitting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@smartsavings.app or create an issue on GitHub.

## Roadmap

- [ ] Complete Firebase integration
- [ ] Implement all screens
- [ ] Add transaction categories
- [ ] Implement charts and analytics
- [ ] Add recurring transaction automation
- [ ] Implement notifications
- [ ] Add offline support
- [ ] Bank integration
- [ ] Multi-language support
- [ ] Premium subscription features

## Acknowledgments

- Inspired by **Wallet by BudgetBakers**
- Flutter community & packages
- Firebase documentation

---

**Made with ❤️ for your financial wellness**
