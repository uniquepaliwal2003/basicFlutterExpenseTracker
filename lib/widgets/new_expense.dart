import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key , required this.addExpense});
  final void Function(Expense expense) addExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _categorySelected = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  _presentDatepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }
  _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if( amountIsValid || _titleController.text.trim().isEmpty || _selectedDate == null ){
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title:  const Text("Invalid Input"),
        content:const Text("Please make sure you input correct title , amount , date and category"),
        actions: [TextButton(onPressed: (){Navigator.of(ctx).pop();}, child: const Text("Ok"))],
      ));
      return;
    }
    widget.addExpense(Expense(title: _titleController.text, amount: enteredAmount, date: _selectedDate!, category: _categorySelected));
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    final keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16, 58, 16, 16+keyboardSize),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('title')),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('Amount'), prefixText: '\$ '),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedDate == null
                          ? "Selected a date"
                          : formatter.format(_selectedDate!)),
                      IconButton(
                        onPressed: _presentDatepicker,
                        icon: const Icon(Icons.calendar_month),
                      )
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 29,),
              Row(
                children: [
                  DropdownButton(
                    value: _categorySelected,
                      items: Category.values
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text(e.name.toUpperCase())))
                          .toList(),
                      onChanged: (value) {
                        if( value == null ){
                          return;
                        }
                        setState(() {
                          _categorySelected = value;
                        });
                      }),
                      const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        _submitExpenseData();
                      },
                      child: const Text('Submit Expense'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
