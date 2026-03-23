import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  //Total budget set by the user
  final double budget;
  final double spent;
  final double remaining;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.spent,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    //Progress bar value from 0 to 1
    final progress = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);

    //Visual representation of budget usage
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("WEEKLY BUDGET"),
          const SizedBox(height: 4),
          Text(
            //Displays total budget
            "\$${budget.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          //Shows how much has been spent
          Text("SPENT THIS WEEK\n\$${spent.toStringAsFixed(2)}"),
          const SizedBox(height: 6),

          //Shows remaining balance
          Text("REMAINING\n\$${remaining.toStringAsFixed(2)}"),

          const SizedBox(height: 10),

          //Progress bar
          LinearProgressIndicator(value: progress, minHeight: 6),
        ],
      ),
    );
  }
}
