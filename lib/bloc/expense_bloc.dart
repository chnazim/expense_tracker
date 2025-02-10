import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import '../core/database_helper.dart';
import '../core/auth_helper.dart';

// Events
abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  AddExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final int id;

  DeleteExpense(this.id);
}

// States
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseLoaded(this.expenses);
}

// BLoC Logic
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  ExpenseBloc() : super(ExpenseInitial()) {
    on<LoadExpenses>((event, emit) async {
      emit(ExpenseLoading());

      // Fetch the username (mocked in AuthHelper)
      final username = await AuthHelper.getUser();
      if (username != null) {
        // Get expenses filtered by username
        final expenses = await _dbHelper.getExpensesByUsername(username);
        emit(ExpenseLoaded(expenses));
      } else {
        emit(ExpenseLoaded([])); // No user found, return empty list
      }
    });

    on<AddExpense>((event, emit) async {
      final username = await AuthHelper.getUser();
      if (username != null) {
        // Associate the expense with the current username
        final expenseWithUser = event.expense.copyWith(username: username);
        await _dbHelper.insertExpense(expenseWithUser);
        add(LoadExpenses()); // Reload the expenses after adding
      }
    });

    on<DeleteExpense>((event, emit) async {
      await _dbHelper.deleteExpense(event.id);
      add(LoadExpenses()); // Reload the expenses after deletion
    });
  }
}
