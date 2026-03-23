import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._internal();
  static final PreferencesService instance = PreferencesService._internal();

  //Keys used in local storage of SharedPreferences
  static const String _budgetKey = 'budget';
  static const String _priceFilterKey = 'price_filter';
  static const String _distanceFilterKey = 'distance_filter';

  // Saves users's weekly budget locally on device
  Future<void> saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }

  //retrieves saved budget, returns null if not set
  Future<double?> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey);
  }

  //Price Filter ($, $$, $$$)
  Future<void> savePriceFilter(String price) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_priceFilterKey, price);
  }

  //Gets current price filter
  Future<String?> getPriceFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_priceFilterKey);
  }

  // Distance Filter in miles
  Future<void> saveDistanceFilter(double distance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_distanceFilterKey, distance);
  }

  Future<double?> getDistanceFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_distanceFilterKey);
  }
}
