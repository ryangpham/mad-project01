class Meal {
  final int? id;
  final String mealName;
  final String restaurantName;
  final double price;
  final String date;

  Meal({
    this.id,
    required this.mealName,
    required this.restaurantName,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealName': mealName,
      'restaurantName': restaurantName,
      'price': price,
      'date': date,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int?,
      mealName: map['mealName'] as String,
      restaurantName: map['restaurantName'] as String,
      price: (map['price'] as num).toDouble(),
      date: map['date'] as String,
    );
  }
}
