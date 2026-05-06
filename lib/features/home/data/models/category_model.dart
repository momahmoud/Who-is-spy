class CategoryModel {
  final String id;
  final String image;
  final String title;
  final int price;
  final bool isLocked;
  /// Expiry timestamp (milliseconds since epoch) for rented categories; null if free or locked.
  final int? rentalExpiryMillis;

  const CategoryModel({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.isLocked,
    this.rentalExpiryMillis,
  });
}
