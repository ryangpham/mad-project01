import '../models/restaurant.dart';

class SeedMenuItem {
  final String name;
  final double price;
  final String category;

  const SeedMenuItem({
    required this.name,
    required this.price,
    required this.category,
  });
}

//Data for local restaurants.
final List<Restaurant> seededRestaurants = [
  Restaurant(
    name: 'Krispy Krunchy Chicken',
    price: r'$',
    distance: 0.1,
    hours: 'Open until 5PM',
  ),
  Restaurant(
    name: 'Gotta Eat ATL',
    price: r'$',
    distance: 0.2,
    hours: 'Open until 8PM',
  ),
  Restaurant(
    name: 'Chick-fil-A',
    price: r'$$',
    distance: 0.2,
    hours: 'Open until 9PM',
  ),
  Restaurant(
    name: 'Panburys Double Crust Pies',
    price: r'$',
    distance: 0.3,
    hours: 'Open until 7PM',
  ),
  Restaurant(
    name: 'Aviva by Kameel',
    price: r'$$',
    distance: 0.4,
    hours: 'Open until 3PM',
  ),
  Restaurant(
    name: 'Anatolia Cafe',
    price: r'$$',
    distance: 0.3,
    hours: 'Open until 9PM',
  ),
  Restaurant(
    name: 'Moes Southwest Grill',
    price: r'$',
    distance: 0.2,
    hours: 'Open until 9PM',
  ),
  Restaurant(
    name: 'Subway',
    price: r'$',
    distance: 0.1,
    hours: 'Open until 10PM',
  ),
  Restaurant(
    name: 'Ali Baba Mediterranean',
    price: r'$',
    distance: 0.4,
    hours: 'Open until 6PM',
  ),
  Restaurant(
    name: 'Rosas Pizza',
    price: r'$',
    distance: 0.3,
    hours: 'Open until 10PM',
  ),
  Restaurant(
    name: 'DTown Pizzeria',
    price: r'$$',
    distance: 0.5,
    hours: 'Open until 9PM',
  ),
  Restaurant(
    name: 'Waffle House',
    price: r'$',
    distance: 0.4,
    hours: 'Open 24 hours',
  ),
  Restaurant(
    name: 'Pho 24',
    price: r'$$',
    distance: 0.6,
    hours: 'Open until 10PM',
  ),
  Restaurant(
    name: 'Metro Cafe Diner',
    price: r'$',
    distance: 0.5,
    hours: 'Open 24 hours',
  ),
  Restaurant(
    name: 'The Halal Guys',
    price: r'$',
    distance: 0.6,
    hours: 'Open until 11PM',
  ),
  Restaurant(
    name: 'Dua Vietnamese',
    price: r'$$$',
    distance: 0.5,
    hours: 'Open until 9PM',
  ),
  Restaurant(
    name: 'NaanStop',
    price: r'$',
    distance: 0.7,
    hours: 'Open until 8PM',
  ),
  Restaurant(
    name: 'Tin Lizzys Cantina',
    price: r'$$$',
    distance: 0.6,
    hours: 'Open until 10PM',
  ),
  Restaurant(
    name: 'Broad Street Boardwalk',
    price: r'$',
    distance: 0.2,
    hours: 'Open until 8PM',
  ),
  Restaurant(
    name: 'Five Guys',
    price: r'$$$',
    distance: 0.5,
    hours: 'Open until 10PM',
  ),
];

final Map<String, List<SeedMenuItem>> seededRestaurantMenus = {
  'Krispy Krunchy Chicken': const [
    SeedMenuItem(name: 'Cajun Tenders (3pc)', price: 6.49, category: 'Entree'),
    SeedMenuItem(name: 'Fried Chicken (2pc)', price: 5.99, category: 'Entree'),
    SeedMenuItem(name: 'Honey Biscuit', price: 1.29, category: 'Side'),
    SeedMenuItem(name: 'Cajun Fries', price: 2.99, category: 'Side'),
  ],
  'Gotta Eat ATL': const [
    SeedMenuItem(name: 'Chicken Philly', price: 9.99, category: 'Entree'),
    SeedMenuItem(name: 'Wings (6pc)', price: 8.99, category: 'Entree'),
    SeedMenuItem(name: 'Loaded Fries', price: 5.49, category: 'Side'),
    SeedMenuItem(name: 'Lemonade', price: 2.49, category: 'Drink'),
  ],
  'Chick-fil-A': const [
    SeedMenuItem(name: 'Chicken Sandwich', price: 5.79, category: 'Entree'),
    SeedMenuItem(
      name: 'Spicy Deluxe Sandwich',
      price: 6.85,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Waffle Potato Fries', price: 3.19, category: 'Side'),
    SeedMenuItem(name: 'Nuggets (8ct)', price: 5.55, category: 'Entree'),
  ],
  'Panburys Double Crust Pies': const [
    SeedMenuItem(
      name: 'Chicken and Mushroom Pie',
      price: 7.99,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Steak and Ale Pie', price: 8.49, category: 'Entree'),
    SeedMenuItem(name: 'Spinach and Feta Pie', price: 7.49, category: 'Entree'),
    SeedMenuItem(name: 'Sausage Roll', price: 4.25, category: 'Side'),
  ],
  'Aviva by Kameel': const [
    SeedMenuItem(
      name: 'Chicken Shawarma Plate',
      price: 12.49,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Falafel Plate', price: 10.99, category: 'Entree'),
    SeedMenuItem(name: 'Hummus and Pita', price: 5.49, category: 'Side'),
    SeedMenuItem(name: 'Lentil Soup', price: 4.99, category: 'Side'),
  ],
  'Anatolia Cafe': const [
    SeedMenuItem(name: 'Lamb Gyro Wrap', price: 10.49, category: 'Entree'),
    SeedMenuItem(name: 'Chicken Kebab Plate', price: 12.99, category: 'Entree'),
    SeedMenuItem(name: 'Greek Salad', price: 7.49, category: 'Side'),
    SeedMenuItem(name: 'Baklava', price: 3.99, category: 'Dessert'),
  ],
  'Moes Southwest Grill': const [
    SeedMenuItem(name: 'Homewrecker Burrito', price: 10.29, category: 'Entree'),
    SeedMenuItem(name: 'Chicken Bowl', price: 9.79, category: 'Entree'),
    SeedMenuItem(name: 'Quesadilla', price: 8.99, category: 'Entree'),
    SeedMenuItem(name: 'Chips and Queso', price: 4.49, category: 'Side'),
  ],
  'Subway': const [
    SeedMenuItem(
      name: 'Turkey Cali Club (6")',
      price: 8.99,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Italian BMT (6")', price: 7.49, category: 'Entree'),
    SeedMenuItem(
      name: 'Meatball Marinara (6")',
      price: 6.99,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Cookies (2ct)', price: 1.99, category: 'Dessert'),
  ],
  'Ali Baba Mediterranean': const [
    SeedMenuItem(
      name: 'Chicken Shawarma Wrap',
      price: 9.49,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Falafel Wrap', price: 8.99, category: 'Entree'),
    SeedMenuItem(name: 'Hummus Plate', price: 5.99, category: 'Side'),
    SeedMenuItem(name: 'Rice Pilaf', price: 3.99, category: 'Side'),
  ],
  'Rosas Pizza': const [
    SeedMenuItem(name: 'Cheese Slice', price: 3.25, category: 'Entree'),
    SeedMenuItem(name: 'Pepperoni Slice', price: 3.75, category: 'Entree'),
    SeedMenuItem(name: 'Baked Ziti', price: 9.99, category: 'Entree'),
    SeedMenuItem(name: 'Garlic Knots', price: 4.49, category: 'Side'),
  ],
  'DTown Pizzeria': const [
    SeedMenuItem(
      name: 'Margherita Pizza (10")',
      price: 11.99,
      category: 'Entree',
    ),
    SeedMenuItem(
      name: 'Buffalo Chicken Pizza (10")',
      price: 13.49,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Caesar Salad', price: 6.99, category: 'Side'),
    SeedMenuItem(name: 'Mozzarella Sticks', price: 6.49, category: 'Side'),
  ],
  'Waffle House': const [
    SeedMenuItem(name: 'All-Star Special', price: 11.29, category: 'Entree'),
    SeedMenuItem(
      name: 'Texas Cheesesteak Melt',
      price: 8.49,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Hashbrowns', price: 3.29, category: 'Side'),
    SeedMenuItem(name: 'Pecan Waffle', price: 5.79, category: 'Entree'),
  ],
  'Pho 24': const [
    SeedMenuItem(name: 'Pho Tai', price: 12.49, category: 'Entree'),
    SeedMenuItem(name: 'Pho Ga', price: 11.99, category: 'Entree'),
    SeedMenuItem(name: 'Spring Rolls (2pc)', price: 5.49, category: 'Side'),
    SeedMenuItem(name: 'Banh Mi', price: 8.99, category: 'Entree'),
  ],
  'Metro Cafe Diner': const [
    SeedMenuItem(name: 'Chicken and Waffles', price: 13.99, category: 'Entree'),
    SeedMenuItem(name: 'Bacon Cheeseburger', price: 11.49, category: 'Entree'),
    SeedMenuItem(name: 'Fried Chicken Plate', price: 12.99, category: 'Entree'),
    SeedMenuItem(name: 'French Toast', price: 8.49, category: 'Entree'),
  ],
  'The Halal Guys': const [
    SeedMenuItem(name: 'Chicken Platter', price: 11.99, category: 'Entree'),
    SeedMenuItem(name: 'Gyro Platter', price: 12.49, category: 'Entree'),
    SeedMenuItem(name: 'Falafel Platter', price: 10.99, category: 'Entree'),
    SeedMenuItem(name: 'Hummus', price: 4.99, category: 'Side'),
  ],
  'Dua Vietnamese': const [
    SeedMenuItem(name: 'Shaken Beef', price: 16.99, category: 'Entree'),
    SeedMenuItem(
      name: 'Lemongrass Chicken Bowl',
      price: 13.49,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Pork Belly Bao', price: 8.99, category: 'Side'),
    SeedMenuItem(
      name: 'Vietnamese Iced Coffee',
      price: 4.75,
      category: 'Drink',
    ),
  ],
  'NaanStop': const [
    SeedMenuItem(name: 'Chicken Tikka Bowl', price: 10.99, category: 'Entree'),
    SeedMenuItem(name: 'Paneer Bowl', price: 10.49, category: 'Entree'),
    SeedMenuItem(name: 'Garlic Naan', price: 2.99, category: 'Side'),
    SeedMenuItem(name: 'Samosa', price: 4.49, category: 'Side'),
  ],
  'Tin Lizzys Cantina': const [
    SeedMenuItem(name: 'Taco Trio', price: 12.99, category: 'Entree'),
    SeedMenuItem(name: 'Queso and Chips', price: 7.49, category: 'Side'),
    SeedMenuItem(name: 'Buffalo Chicken Taco', price: 4.49, category: 'Entree'),
    SeedMenuItem(name: 'Street Corn', price: 5.29, category: 'Side'),
  ],
  'Broad Street Boardwalk': const [
    SeedMenuItem(name: 'Classic Burger', price: 9.99, category: 'Entree'),
    SeedMenuItem(name: 'Hot Dog Combo', price: 7.49, category: 'Entree'),
    SeedMenuItem(
      name: 'Chicken Tenders Basket',
      price: 9.49,
      category: 'Entree',
    ),
    SeedMenuItem(name: 'Funnel Cake Fries', price: 5.99, category: 'Dessert'),
  ],
  'Five Guys': const [
    SeedMenuItem(name: 'Little Cheeseburger', price: 8.69, category: 'Entree'),
    SeedMenuItem(name: 'Bacon Burger', price: 10.49, category: 'Entree'),
    SeedMenuItem(name: 'Cajun Fries', price: 4.99, category: 'Side'),
    SeedMenuItem(name: 'Milkshake', price: 6.29, category: 'Drink'),
  ],
};

List<SeedMenuItem> getSeededMenuForRestaurant(String restaurantName) {
  return seededRestaurantMenus[restaurantName] ?? const [];
}
