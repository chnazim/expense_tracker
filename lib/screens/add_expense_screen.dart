import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/database_helper.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final String username;
  final Function onExpenseAdded;

  AddExpenseScreen({
    required this.username,
    required this.onExpenseAdded,
  });

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<String> _categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Other"
  ];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.tealAccent[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              SizedBox(height: 12),
              _buildAmountField(),
              SizedBox(height: 12),
              _buildCategoryDropdown(),
              SizedBox(height: 24),
              _buildAddExpenseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: "Expense Title",
        labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.tealAccent[700]),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.tealAccent[700]!),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter an expense title";
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Amount",
        labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.tealAccent[700]),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.tealAccent[700]!),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the amount";
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return "Please enter a valid amount";
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: Text("Select Category", style: GoogleFonts.poppins()),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.tealAccent[700]),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.tealAccent[700]!),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category, style: GoogleFonts.poppins()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a category";
        }
        return null;
      },
    );
  }

  Widget _buildAddExpenseButton() {
    return ElevatedButton(
      onPressed: _addExpense,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: Colors.tealAccent[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      child: Text("Add Expense",
          style:
              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  void _addExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      final expense = Expense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory ?? "Other",
        username: widget.username,
        date: DateTime.now(),
      );

      // Add the expense to the database
      DatabaseHelper().insertExpense(expense).then((_) {
        // After adding the expense, refresh the data
        widget.onExpenseAdded();
        Navigator.pop(context);
      });
    }
  }
}
