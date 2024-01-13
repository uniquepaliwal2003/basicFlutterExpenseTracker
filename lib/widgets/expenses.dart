import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
class Expenses extends StatefulWidget{
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Flutter Course",
      amount:19.99,
      date:DateTime.now(),
      category: Category.work
    ),
    Expense(
      title: "Cinema",
      amount:10.99,
      date:DateTime.now(),
      category: Category.leisure
    ),
  ];
  void _openAExpenseOverlay(){
    showModalBottomSheet( useSafeArea: true,  isScrollControlled :true ,context: context, builder: (ctx)=> NewExpense( addExpense: addExpense,));
  }
  void _removeExpense(Expense expense){
    final index = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense deleted"),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(label: "Undo" , onPressed: (){
          setState(() {
            _registeredExpenses.insert(index, expense );
          });
        },),
      )
    );
  }
  void addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }
  @override
  Widget build(BuildContext context) {
    final width =  MediaQuery.of(context).size.width;
    Widget showScreen =const Center(child:  Text("No item found , Plz add a item"));
    if( _registeredExpenses.isNotEmpty ){
      showScreen = width < 500 ? 
      Column(children: [
        Chart(expenses: _registeredExpenses),
        Expanded(child: ExpenseList(expenses: _registeredExpenses , removeExpense: _removeExpense ,))
      ],)
      :
      Row(children: [
        Expanded(child: Chart(expenses: _registeredExpenses)),
        //  Chart(expenses: _registeredExpenses),
        Expanded(child: ExpenseList(expenses: _registeredExpenses , removeExpense: _removeExpense ,))
      ],)
    ;
    }
    return  Scaffold( 
      appBar: AppBar(
        title:const Text('Expense Tracker'),
        actions: [IconButton(onPressed: _openAExpenseOverlay, icon:const Icon(Icons.add) )]
      ),
      body:  showScreen
    );
  }
}
