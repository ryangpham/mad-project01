import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._internal();
  static final PreferencesService instance = PreferencesService._internal();

  static const String _budgetKey = 'budget';
  static const String _priceFilterKey = 'price_filter';
  static const String _distanceFilterKey = 'distance_filter';

  // Budget
  Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }

  Future<double?> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey);
  }

  //Price Filter ($, $$, $$$)
  Future<void> savePriceFilter(String price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_priceFilterKey, price);
  }

  Future<String?> getPriceFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_priceFilterKey);
  }

  // Distance Filter
  Future<void> saveDistanceFilter(double distance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_distanceFilterKey, distance);
  }

  Future<double?> getDistanceFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_distanceFilterKey);
  }
}
