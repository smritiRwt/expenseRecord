import 'package:expense_tracker/controller/expense_controller.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense; // Nullable parameter to handle editing
  const AddExpenseScreen({super.key, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final ExpenseController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  String? _category;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    // If editing, populate fields with existing expense data
    if (widget.expense != null) {
      _descriptionController =
          TextEditingController(text: widget.expense!.description);
      _amountController =
          TextEditingController(text: widget.expense!.amount.toString());
      _category = widget.expense!.category;
      _date = widget.expense!.date;
    } else {
      _descriptionController = TextEditingController();
      _amountController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? 'Add Expense' : 'Edit Expense',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Description input
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),

              // Amount input
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  return null;
                },
              ),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Food', 'Transport', 'Entertainment', 'Bills', 'Others']
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),

              // Date Picker (Optional: You could add a date picker if needed)
              SizedBox(height: 20),

              // Save button with validation
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final expense = Expense(
                      id: widget.expense?.id ??
                          DateTime.now().millisecondsSinceEpoch,
                      description: _descriptionController.text,
                      amount: double.parse(_amountController.text),
                      category: _category!,
                      date: _date,
                    );

                    if (widget.expense == null) {
                      controller.addExpense(expense); // Add new expense
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Expense added successfully')),
                      );
                    } else {
                      controller
                          .updateExpense(expense); // Update existing expense
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Expense updated successfully')),
                      );
                    }
                    Get.back(); // Close the screen after adding or editing
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(
                    widget.expense == null ? 'Add Expense' : 'Save Changes',
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
