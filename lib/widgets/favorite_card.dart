import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  final String name;
  final String price;
  final String distance;

  const FavoriteCard({
    super.key,
    required this.name,
    required this.price,
    required this.distance,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$price • $distance",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              // TODO: Navigate to details screen
            },
          ),

          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // TODO: Remove from favorites (SQFlite)
            },
          ),
        ],
      ),
    );
  }
}
