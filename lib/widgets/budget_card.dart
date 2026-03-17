import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
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
    final progress = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);

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
            "\$${budget.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),
          Text("SPENT THIS WEEK\n\$${spent.toStringAsFixed(2)}"),
          const SizedBox(height: 6),
          Text("REMAINING\n\$${remaining.toStringAsFixed(2)}"),

          const SizedBox(height: 10),

          LinearProgressIndicator(value: progress, minHeight: 6),
        ],
      ),
    );
  }
}
