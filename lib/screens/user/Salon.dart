class Salon{
  final String name, description;
  final List<String> images;
  final bool isFavourate, isPopular;
  final double rating;

  Salon( {
    required this.name,
    required this.description,
    required this.images,
    this.rating = 0.0,
    // this.isFavourate ;
     this.isFavourate = false,
     this.isPopular = false,
  } );


  static Salon fromJson(json) => Salon(
    name: json['username'],
    description: json['email'],
    images: json['image'],
  );
}

// List<Salon> salon = [
//   Salon(
//       name:"Rob Roy  ",
//       description: " Hair stylish salon",
//       images: [
//         "assets/images/robroy.jpg",
//
//       ],
//      isFavourate: true,
//     isPopular: true,
//   ),
//
//   Salon(
//     name:"VA Makeup Salon",
//     description: " Makeup salon",
//     images: [
//       "assets/images/va.png",
//
//     ],
//     isPopular: true,
//   ),
//
//   Salon(
//     name:"VA Makeup Salon",
//     description: " Makeup salon",
//     images: [
//       "assets/images/va.png",
//     ],
//     isPopular: true,
//   ),
//
//
// ];