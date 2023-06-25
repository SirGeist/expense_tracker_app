import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/cupertino.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // One way to store values
  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  // Second way
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();

    // First date is today - 1 year, but everything is today
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    // Code afterwards will wait for the previous info
    // Now we are assigning the user picked date for display
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Building adaptive apps by using Platform class to build for other platforms
  // If it is ios display cupertino dialog box, otherwise display default
  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // Checking if the input areas are empty
    // If they are empty, display a message stating
    // that input is invalid
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();

      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Contains extra information about UI elements that may overlap with
    // certain parts of the UI
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    // Using layoutbuilder to build dynamic layouts
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            // always have 16 pixels on the bottom padding but add extra space that is
            // taken up by the keyboard
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width > 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          // 1st way to store data
                          //onChanged: _saveTitleInput,
                          // 2nd way to store data (more efficient because need more
                          // text field and don't want to manually manage)
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    // 1st way to store data
                    //onChanged: _saveTitleInput,
                    // 2nd way to store data (more efficient because need more
                    // text field and don't want to manually manage)
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          // Shows the text on the drop down
                          value: _selectedCategory,
                          // A specific enum value is mapped to the value
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),

                                // Making it into a list
                              )
                              .toList(),
                          onChanged: (value) {
                            // If the user hasn't chosen a category, display nothing
                            if (value == null) {
                              return;
                            }

                            // Otherwise, display the selected categories value
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Displays date text next to the calendar icon
                            // Also we use the ! at the end of _selectDate to force date that selectDate will
                            // never be null (because we checked for it previously)
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Displays date text next to the calendar icon
                            // Also we use the ! at the end of _selectDate to force date that selectDate will
                            // never be null (because we checked for it previously)
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                // Adding more space between the amount row and the row after
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(children: [
                    const Spacer(),

                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        // Pops the modal by pressing the "cancel button"
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ])
                else
                  // Row with dropdown, cancel, and save expense
                  Row(children: [
                    // DropDown Button
                    DropdownButton(
                        // Shows the text on the drop down
                        value: _selectedCategory,
                        // A specific enum value is mapped to the value
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),

                              // Making it into a list
                            )
                            .toList(),
                        onChanged: (value) {
                          // If the user hasn't chosen a category, display nothing
                          if (value == null) {
                            return;
                          }

                          // Otherwise, display the selected categories value
                          setState(() {
                            _selectedCategory = value;
                          });
                        }),

                    // Spacing out the category dropdown and the other buttons
                    const Spacer(),

                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        // Pops the modal by pressing the "cancel button"
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ]),
              ],
            ),
          ),
        ),
      );
    });
  }
}
