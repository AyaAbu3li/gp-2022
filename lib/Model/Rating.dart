class  Rating {
  final double rating;
  final String id;

  const Rating( {
    required this.rating,
    required this.id,
  }  );

  static Rating fromJson(json) => Rating(
    rating: json['rating'],
    id: json['_id'],
  );
}