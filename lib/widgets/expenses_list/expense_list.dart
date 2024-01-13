import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key, required this.expenses ,required this.removeExpense});
  final List<Expense> expenses;
  final void Function(Expense expense) removeExpense;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
            onDismissed:(direction){ removeExpense(expenses[index]); } ,
            key: ValueKey(expenses[index]),
            background: Container(color: Theme.of(context).colorScheme.error,margin:const EdgeInsets.symmetric(horizontal: 16),),
            child: ExpenseItem(expenses[index])));
  }
}
