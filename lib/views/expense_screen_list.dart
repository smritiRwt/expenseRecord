import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/views/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseController controller = Get.put(ExpenseController());

  ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return Center(
                child: Text(
                  'Total: \$${controller.totalExpense.value.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.expenses.isEmpty) {
          return const Center(
            child: Text(
              'No expenses added yet.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.expenses.length,
          itemBuilder: (context, index) {
            final expense = controller.expenses[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(
                  Icons.monetization_on,
                  color: Colors.teal,
                  size: 32.0,
                ),
                title: Text(
                  expense.description,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category: ${expense.category}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      'Amount: \$${expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.teal,
                        size: 20,
                      ),
                      onPressed: () {
                        Get.to(() => AddExpenseScreen(expense: expense));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        _confirmDelete(context, expense.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddExpenseScreen()); // Navigate to add expense screen
        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Function to confirm expense deletion
  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Expense"),
        content: const Text("Are you sure you want to delete this expense?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteExpense(id); // Delete the expense
              Get.back(); // Close the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expense deleted successfully')),
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
