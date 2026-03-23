import 'package:flutter/material.dart';

import '../data/restaurant_seed_data.dart';
import '../models/meal.dart';
import '../models/restaurant.dart';
import '../services/database_helper.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;
  // Restaurant passed from previous screen
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final DatabaseHelper _db = DatabaseHelper.instance;
  // makes sure database is ready before UI loads
  late final Future<void> _databaseReady;
  bool _isUpdatingFavorite = false;
  bool _isLoggingMeal = false;

  //favorite state
  bool _isFavorite = false;
  List<int> _favoriteIds = const [];

  @override
  void initState() {
    super.initState();
    _databaseReady = _initialize();
  }

// Normalize restaurant name for comparison
  String get _restaurantKey => widget.restaurant.name.trim().toLowerCase();

  //Initialize database and sync favorite state
  Future<void> _initialize() async {
    await _db.initializeDatabase();
    await _syncFavoriteState();
  }

  //Syncs the UI with database favorites
  Future<void> _syncFavoriteState() async {
    final favorites = await _db.getFavorites();
    final matchingIds = favorites
        .where(
          (favorite) => favorite.name.trim().toLowerCase() == _restaurantKey,
        )
        .map((favorite) => favorite.id)
        .whereType<int>()
        .toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _favoriteIds = matchingIds;
      _isFavorite = matchingIds.isNotEmpty;
    });
  }

  // add / remove restaurants from favorites
  Future<void> _toggleFavorite() async {
    if (_isUpdatingFavorite) {
      return;
    }

    setState(() {
      _isUpdatingFavorite = true;
    });

    try {
      if (_isFavorite) {
        var idsToRemove = _favoriteIds;
        if (idsToRemove.isEmpty) {
          final favorites = await _db.getFavorites();
          idsToRemove = favorites
              .where(
                (favorite) =>
                    favorite.name.trim().toLowerCase() == _restaurantKey,
              )
              .map((favorite) => favorite.id)
              .whereType<int>()
              .toList();
        }

        for (final id in idsToRemove) {
          await _db.removeFavorite(id);
        }

        if (!mounted) {
          return;
        }

        setState(() {
          _isFavorite = false;
          _favoriteIds = const [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites.')),
        );
        return;
      }

      final existingFavorites = await _db.getFavorites();
      final alreadyFavorited = existingFavorites
          .where(
            (favorite) => favorite.name.trim().toLowerCase() == _restaurantKey,
          )
          .map((favorite) => favorite.id)
          .whereType<int>()
          .toList();

      if (alreadyFavorited.isNotEmpty) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isFavorite = true;
          _favoriteIds = alreadyFavorited;
        });
        return;
      }

      // add to favorites
      final insertedId = await _db.addFavorite(
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

      setState(() {
        _isFavorite = true;
        _favoriteIds = [insertedId];
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to favorites.')));
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingFavorite = false;
        });
      }
    }
  }

  //Logs selected menu items as a meal in budget tracker
  Future<void> _logMealFromMenuItem(SeedMenuItem item) async {
    if (_isLoggingMeal) {
      return;
    }

    setState(() {
      _isLoggingMeal = true;
    });

    try {
      await _db.insertMeal(
        Meal(
          mealName: item.name,
          restaurantName: widget.restaurant.name,
          price: item.price,
          date: DateTime.now().toIso8601String(),
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged ${item.name} to your budget.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingMeal = false;
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
                    onPressed: _isUpdatingFavorite ? null : _toggleFavorite,
                    child: Text(
                      _isUpdatingFavorite
                          ? 'Updating...'
                          : (_isFavorite ? 'Favorited' : 'Add to Favorites'),
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
                        enabled: !_isLoggingMeal,
                        onTap: () => _logMealFromMenuItem(item),
                        title: Text(item.name),
                        subtitle: Text(
                          _isLoggingMeal
                              ? '${item.category} · Logging...'
                              : '${item.category} · Tap to log meal',
                        ),
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
