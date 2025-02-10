import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../bloc/expense_bloc.dart';
import '../core/auth_helper.dart';
import '../core/database_helper.dart';
import '../models/expense.dart';
import '../screens/add_expense_screen.dart';
import '../screens/login_screen.dart';
import '../widgets/expense_chart.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "All";
  List<String> filterOptions = [
    "All",
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Other"
  ];
  String? profileName;
  List<Expense> userExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadProfileName();
  }

  _loadProfileName() async {
    final name = await AuthHelper.getUser();
    setState(() {
      profileName = name ?? "Guest";
    });
    _loadUserData(name);
  }

  _loadUserData(String? username) async {
    if (username != null) {
      final expensesData =
          await DatabaseHelper().getExpensesByUsername(username);

      if (expensesData.isNotEmpty) {
        setState(() {
          userExpenses = expensesData;
        });
      }
    }
  }

  // Filtered expenses logic
  List<Expense> get filteredExpenses {
    if (selectedFilter == "All") {
      return userExpenses;
    }
    return userExpenses
        .where((expense) => expense.category == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(themeProvider),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseLoaded) {
            setState(() {
              userExpenses = state.expenses;
            });
          }
        },
        child: _buildExpenseList(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar(ThemeProvider themeProvider) {
    return AppBar(
      title: Text("Expense Tracker", style: _getAppBarTitleStyle()),
      actions: [
        _buildProfileName(),
        _buildThemeToggleButton(themeProvider),
        _buildLogoutButton(),
      ],
    );
  }

  Padding _buildProfileName() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        profileName ?? "Loading...",
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  IconButton _buildThemeToggleButton(ThemeProvider themeProvider) {
    return IconButton(
      icon: Icon(
        themeProvider.themeMode == ThemeMode.dark
            ? Icons.wb_sunny
            : Icons.nightlight_round,
      ),
      onPressed: () => themeProvider.toggleTheme(),
    );
  }

  IconButton _buildLogoutButton() {
    return IconButton(
      icon: Icon(Icons.logout),
      onPressed: _showLogoutConfirmationDialog,
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () async {
                await AuthHelper.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  TextStyle _getAppBarTitleStyle() {
    return GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600);
  }

  // Expense List UI
  Widget _buildExpenseList() {
    return Column(
      children: [
        _buildExpenseChart(filteredExpenses),
        _buildFilterDropdown(),
        _buildExpenseItemList(filteredExpenses),
      ],
    );
  }

  // Filter dropdown widget
  Padding _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedFilter,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        items: filterOptions.map((filter) {
          return DropdownMenuItem(
            value: filter,
            child: Text(filter, style: GoogleFonts.poppins()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => selectedFilter = value!);
        },
      ),
    );
  }

  Padding _buildExpenseChart(List<Expense> filteredExpenses) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ExpenseChart(expenses: filteredExpenses),
    );
  }

  Expanded _buildExpenseItemList(List<Expense> filteredExpenses) {
    return Expanded(
      child: filteredExpenses.isEmpty
          ? _buildNoExpensesFoundMessage()
          : _buildExpenseListView(filteredExpenses),
    );
  }

  Center _buildNoExpensesFoundMessage() {
    return Center(
      child: Text(
        "No expenses found",
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  ListView _buildExpenseListView(List<Expense> filteredExpenses) {
    return ListView.builder(
      itemCount: filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = filteredExpenses[index];
        return _buildExpenseItem(expense);
      },
    );
  }

  Card _buildExpenseItem(Expense expense) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.tealAccent[700],
          child: Icon(Icons.attach_money, color: Colors.white),
        ),
        title: Text(
          expense.title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "\$${expense.amount.toStringAsFixed(2)} - ${expense.category}",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            BlocProvider.of<ExpenseBloc>(context)
                .add(DeleteExpense(expense.id!));
          },
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.tealAccent[700],
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                    username: profileName!,
                    onExpenseAdded: _reloadData, // Refresh data callback
                  ))),
    );
  }

  _reloadData() {
    _loadUserData(profileName);
  }
}
