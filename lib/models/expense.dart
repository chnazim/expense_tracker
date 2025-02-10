import 'dart:ffi';

class Expense {
  int? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String username; // Added username field

  // Constructor
  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.username, // Include username in constructor
  });

  // fromJson method to map JSON to Expense object
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      title: json['title'] as String,
      amount: json['amount'] as double,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      // Convert string to DateTime
      username: json['username'] as String, // Parse username from JSON
    );
  }

  // toMap method to convert Expense object to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(), // Convert DateTime to string
      'username': username, // Include username in the map
    };
  }

  Map<String, dynamic> toJson() {
    return toMap(); // Just use the toMap method here
  }

  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    String? category,
    String? date,
    String? username,
  }) {
    return Expense(
      id: this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: this.date,
      username: username ?? this.username,
    );
  }
}
