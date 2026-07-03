class PlaceModel {
  final String id;
  final String name;
  final String address;
  final String category;
  final String description;
  final String coverImage;
  final double latitude;
  final double longitude;
  final List<String> tags;
  final String createdBy;

  PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.description,
    required this.coverImage,
    required this.latitude,
    required this.longitude,
    required this.tags,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "address": address,
      "category": category,
      "description": description,
      "coverImage": coverImage,
      "latitude": latitude,
      "longitude": longitude,
      "tags": tags,
      "createdBy": createdBy,
    };
  }
}