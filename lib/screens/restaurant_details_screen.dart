import 'package:flutter/material.dart';

import '../data/restaurant_seed_data.dart';
import '../models/restaurant.dart';
import '../services/database_helper.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  late final Future<void> _databaseReady;
  bool _isAddingFavorite = false;

  @override
  void initState() {
    super.initState();
    _databaseReady = _db.initializeDatabase();
  }

  Future<void> _addToFavorites() async {
    if (_isAddingFavorite) {
      return;
    }

    setState(() {
      _isAddingFavorite = true;
    });

    try {
      final existingFavorites = await _db.getFavorites();
      final alreadyFavorited = existingFavorites.any(
        (favorite) =>
            favorite.name.trim().toLowerCase() ==
            widget.restaurant.name.trim().toLowerCase(),
      );

      if (alreadyFavorited) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant is already in favorites.')),
        );
        return;
      }

      await _db.addFavorite(
        Restaurant(
          name: widget.restaurant.name,
          price: widget.restaurant.price,
          distance: widget.restaurant.distance,
          hours: widget.restaurant.hours,
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to favorites.')));
    } finally {
      if (mounted) {
        setState(() {
          _isAddingFavorite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = getSeededMenuForRestaurant(widget.restaurant.name);

    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name)),
      body: FutureBuilder<void>(
        future: _databaseReady,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to connect to local database.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const Icon(Icons.restaurant, size: 80),
                const SizedBox(height: 20),
                Text(
                  widget.restaurant.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Price: ${widget.restaurant.price}"),
                Text("Distance: ${widget.restaurant.distance} miles"),
                Text("Hours: ${widget.restaurant.hours}"),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: _isAddingFavorite ? null : _addToFavorites,
                    child: Text(
                      _isAddingFavorite ? 'Adding...' : 'Add to Favorites',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Menu Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                if (menuItems.isEmpty)
                  const Text('No menu items available for this restaurant.')
                else
                  ...menuItems.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.category),
                        trailing: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
