/// Food item model representing items available in the Smart Canteen.
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isVeg;
  final String imageUrl;
  final double rating;
  final int prepTimeMinutes;
  final bool isAvailable;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isVeg = true,
    required this.imageUrl,
    this.rating = 4.5,
    this.prepTimeMinutes = 10,
    this.isAvailable = true,
  });

  /// Factory constructor to create a copy with modified fields if needed.
  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    bool? isVeg,
    String? imageUrl,
    double? rating,
    int? prepTimeMinutes,
    bool? isAvailable,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isVeg: isVeg ?? this.isVeg,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
