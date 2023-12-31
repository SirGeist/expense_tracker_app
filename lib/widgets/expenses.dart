import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 12,
      date: DateTime(2023, 12, 12),
      category: Category.work,
    ),
    Expense(
      title: 'Hamburger',
      amount: 30,
      date: DateTime(2021, 4, 17),
      category: Category.food,
    ),
  ];

  void _openAddExpenseOverlay() {
    // When you are in a class that extends state, context is automatically provided
    // The "context" value is metadata that has information on relation to other widgets
    showModalBottomSheet(

      // Staying away from device features like the camera that might affect
      // the UI; flutter will know how much space the camera takes up
      // scaffold use this internally
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    // Variable to keep track of expense indexes in case of undo
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    // Removing all expenses
    ScaffoldMessenger.of(context).clearSnackBars();

    // Show snackbar at the bottom of the device that will display
    // a message that shows an expense has been deleted
    // an icon will also be displayed to undo the deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Finding the width and height of the device
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding something!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // Switch based on whether device is an portrait or landscape mode
      body: width < 600
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(
                  child: mainContent,
                ), // passing the dummy code to the class
              ],
            )
          : Row(
              children: [
                // Using a expanded contraint as the chart to only take as much
                // width as available in the row after sizing the other row
                // children
                // Without Expanded() the double.infinity in chart.dart will
                // interfere with the row
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
