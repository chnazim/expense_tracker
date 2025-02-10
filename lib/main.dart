import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'bloc/expense_bloc.dart';
import 'core/auth_helper.dart';

// Theme Provider for Dark Mode
class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if user is logged in
  String? username = await AuthHelper.getUser();
  runApp(MyApp(startScreen: username == null ? LoginScreen() : HomeScreen()));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  MyApp({required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (context) => ExpenseBloc()..add(LoadExpenses())),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: startScreen,
          );
        },
      ),
    );
  }
}
