import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.restaurant, size: 80),

            const SizedBox(height: 20),

            Text(
              restaurant.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Price: ${restaurant.price}"),
            Text("Distance: ${restaurant.distance} miles"),
            Text("Hours: ${restaurant.hours}"),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Add to Favorites"),
            ),
          ],
        ),
      ),
    );
  }
}
