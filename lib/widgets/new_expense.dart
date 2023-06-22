import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

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

  @override
  void dispose(){
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
          Row(children: [
            ElevatedButton(
              onPressed: () {
                print(_titleController.text);
              },
              child: const Text('Save Expense'),
            ),
          ]),
        ],
      ),
    );
  }
}
