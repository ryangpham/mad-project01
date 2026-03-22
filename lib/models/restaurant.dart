class Restaurant {
  final int? id;
  final String name;
  final String price;
  final double distance;
  final String hours;

  // Constructor for the restaurant
  Restaurant({
    this.id,
    required this.name,
    required this.price,
    required this.distance,
    required this.hours,
  });

  // Convert Restaurant object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'distance': distance,
      'hours': hours,
    };
  }

  // Create Restaurant object from Map
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as String,
      distance: (map['distance'] as num).toDouble(),
      hours: map['hours'] as String,
    );
  }
}
