import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String name;
  final double price;
  final String date;
  final VoidCallback onRemove;

  const MealCard({
    super.key,
    required this.name,
    required this.price,
    required this.date,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)} • $date',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onRemove),
        ],
      ),
    );
  }
}
