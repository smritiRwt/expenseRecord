import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/services/db_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;
  var totalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  // Load expenses from the database
  Future<void> loadExpenses() async {
    final expensesList = await DatabaseHelper.instance.getExpenses();
    expenses.value = expensesList;
    _updateTotalExpense();
  }

  // Add an expense
  Future<void> addExpense(Expense expense) async {
    await DatabaseHelper.instance.insertExpense(expense);
    expenses.add(expense);
    _updateTotalExpense();
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await DatabaseHelper.instance.updateExpense(expense);
    int index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense;
    }
    _updateTotalExpense();
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.deleteExpense(id);
    expenses.removeWhere((expense) => expense.id == id);
    _updateTotalExpense();
  }

  // Update total expense
  void _updateTotalExpense() {
    totalExpense.value = expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}
