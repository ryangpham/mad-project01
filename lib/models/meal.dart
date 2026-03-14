class Meal {
  final int? id;
  final String mealName;
  final String restaurantName;
  final double price;
  final String date;

  Meal ({
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

  factory Map.fromMap(Map<String, dynamic> map) {
   return Meal(
      id: map['id'],
      mealName: map['mealName'],
      restaurantName: map['restaurantName'],
      price: map['price'],
      date: map['date'],
    ); 
  }
}
