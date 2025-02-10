import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseChart({required this.expenses});

  @override
  Widget build(BuildContext context) {
    Map<String, double> expenseData = {};

    for (var expense in expenses) {
      expenseData.update(expense.category, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    List<PieChartSectionData> sections = expenseData.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
        color: Colors.primaries[expenseData.keys.toList().indexOf(entry.key) %
            Colors.primaries.length],
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Expense Distribution",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(PieChartData(sections: sections)),
            ),
          ],
        ),
      ),
    );
  }
}
