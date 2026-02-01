# Development Guidelines

This document provides guidelines for development and contribution to the Smart Savings app.

## Code Structure

### Models
- Located in `lib/core/models/`
- Should be immutable (use `final` fields)
- Implement `toMap()` and `fromMap()` for serialization
- Use `copyWith()` for creating modified copies

Example:
```dart
class Transaction {
  final String id;
  final String userId;
  final double amount;
  
  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      userId: map['userId'],
      amount: map['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
    };
  }

  Transaction copyWith({String? id, String? userId, double? amount}) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
    );
  }
}
```

### Repositories
- Located in `lib/core/repositories/`
- Handle all data access operations
- Use Firestore for cloud data
- Return data models, not raw maps
- Handle errors and exceptions

Example:
```dart
class TransactionsRepository {
  Future<List<Transaction>> getTransactions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .get();
      
      return snapshot.docs
          .map((doc) => Transaction.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
```

### Providers (State Management)
- Located in `lib/features/{feature}/providers/`
- Extend `ChangeNotifier`
- Handle business logic
- Manage UI state (loading, error, data)
- Call repositories to fetch/update data

Example:
```dart
class TransactionsProvider extends ChangeNotifier {
  final TransactionsRepository _repository;
  
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadTransactions(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _transactions = await _repository.getTransactions(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### Screens
- Located in `lib/features/{feature}/screens/`
- Use `Consumer` to access providers
- Keep UI logic minimal
- Delegate business logic to providers
- Use `SafeArea` for proper spacing

Example:
```dart
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId != null) {
      context.read<TransactionsProvider>().loadTransactions(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Consumer<TransactionsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          
          return ListView(
            children: provider.transactions
                .map((t) => TransactionTile(transaction: t))
                .toList(),
          );
        },
      ),
    );
  }
}
```

## Coding Standards

### Naming Conventions
- Classes: `PascalCase` (e.g., `TransactionModel`)
- Methods/Variables: `camelCase` (e.g., `getTransactions`)
- Constants: `camelCase` (e.g., `const maxAmount = 10000`)
- Files: `snake_case` (e.g., `transaction_model.dart`)

### Widget Conventions
- Use `const` constructors when possible
- Add `Key? key` parameter to all custom widgets
- Use `super(key: key)` in constructors
- Prefer stateless widgets when state is not needed

```dart
class MyWidget extends StatelessWidget {
  final String title;
  
  const MyWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(title));
  }
}
```

## Error Handling

### In Repositories
```dart
Future<List<Transaction>> getTransactions(String userId) async {
  try {
    final snapshot = await _firestore.collection(...).get();
    return snapshot.docs
        .map((doc) => Transaction.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  } catch (e) {
    rethrow; // Let provider handle the error
  }
}
```

### In Providers
```dart
Future<void> loadTransactions(String userId) async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    _transactions = await _repository.getTransactions(userId);
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}
```

### In Screens
```dart
Consumer<TransactionsProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (provider.errorMessage != null) {
      return Text('Error: ${provider.errorMessage}');
    }
    
    return ListView(...);
  },
)
```

## Testing

### Unit Tests
- Create test files in `test/` directory
- Test models, repositories, and providers
- Mock Firestore for repository tests

```dart
void main() {
  group('Transaction Model', () {
    test('should create transaction from map', () {
      final map = {
        'id': '1',
        'userId': 'user123',
        'amount': 100.0,
      };
      
      final transaction = Transaction.fromMap(map);
      
      expect(transaction.id, '1');
      expect(transaction.amount, 100.0);
    });
  });
}
```

### Widget Tests
- Test UI components and screens
- Use `testWidgets` for widget testing

```dart
void main() {
  testWidgets('TransactionTile displays amount', (tester) async {
    final transaction = Transaction(...);
    
    await tester.pumpWidget(
      MaterialApp(home: TransactionTile(transaction: transaction)),
    );
    
    expect(find.text('\$100.00'), findsOneWidget);
  });
}
```

## Performance Tips

1. **Use `const` constructors** - Reduces widget rebuilds
2. **Avoid rebuilding entire lists** - Use `IndexedStack` or `Visibility`
3. **Cache expensive computations** - Store in provider state
4. **Use `StreamBuilder` for real-time data** - Instead of polling
5. **Lazy load data** - Load only when needed
6. **Use pagination** - For large lists
7. **Optimize Firestore queries** - Add proper indexes

## Common Patterns

### Loading Data on Screen Init
```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId != null) {
      context.read<TransactionsProvider>().loadTransactions(userId);
    }
  });
}
```

### Displaying Loading/Error/Success States
```dart
Consumer<TransactionsProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) {
      return const LoadingWidget();
    }
    
    if (provider.errorMessage != null) {
      return ErrorWidget(message: provider.errorMessage!);
    }
    
    if (provider.transactions.isEmpty) {
      return const EmptyStateWidget();
    }
    
    return ListView(...);
  },
)
```

### Form Validation
```dart
if (_formKey.currentState!.validate()) {
  if (_emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email is required')),
    );
    return;
  }
  
  // Process form
}
```

## Resources

- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Firebase Best Practices](https://firebase.google.com/docs/rules/best-practices)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Provider Package Documentation](https://pub.dev/packages/provider)

## Questions?

Create an issue or discussion in the GitHub repository.
