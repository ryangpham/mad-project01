import 'package:flutter/material.dart';
import '../widgets/favorite_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = [
      {"name": "Pizza Place", "price": "\$\$", "distance": "0.2 mi"},
      {"name": "Burger Spot", "price": "\$\$", "distance": "0.4 mi"},
      {"name": "Asian Cuisine", "price": "\$\$", "distance": "0.9 mi"},
      {"name": "Sandwich Shop", "price": "\$\$", "distance": "0.7 mi"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          TextButton(onPressed: () {}, child: const Text("Show Empty")),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${favorites.length} saved restaurants",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return FavoriteCard(
                    name: item["name"]!,
                    price: item["price"]!,
                    distance: item["distance"]!,
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
