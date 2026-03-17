import 'package:flutter/material.dart';
import '../widgets/budget_card.dart';
import '../widgets/meal_card.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meals = [
      {"name": "Pizza Place", "price": 12.50, "date": "Mar 8"},
      {"name": "Burger Spot", "price": 15.00, "date": "Mar 7"},
      {"name": "Taco Restaurant", "price": 8.00, "date": "Mar 7"},
      {"name": "Coffee Shop", "price": 6.00, "date": "Mar 6"},
      {"name": "Sandwich Shop", "price": 6.00, "date": "Mar 6"},
    ];

    double weeklyBudget = 100;
    double spent = 47.50;
    double remaining = weeklyBudget - spent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Tracker"),
        actions: [
          TextButton(onPressed: () {}, child: const Text("Show Empty")),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            BudgetCard(
              budget: weeklyBudget,
              spent: spent,
              remaining: remaining,
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "LOGGED MEALS",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return MealCard(
                    name: meal["name"] as String,
                    price: meal["price"] as double,
                    date: meal["date"] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
