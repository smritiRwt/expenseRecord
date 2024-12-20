// lib/main.dart

import 'package:expense_tracker/views/expense_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseListScreen(),
    );
  }
}
