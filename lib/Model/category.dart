class  Category {
  final String category;
  final String id;

  const Category( {
    required this.category,
    required this.id,
  }  );

  static Category fromJson(json) => Category(
    category: json['category'],
    id: json['_id'],
  );
}