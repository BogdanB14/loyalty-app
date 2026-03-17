import '../../domain/entities/venue_entity.dart';

class VenueModel extends VenueEntity {
  const VenueModel({
    required super.id,
    required super.name,
    required super.address,
    required super.city,
    required super.country,
    required super.type,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) => VenueModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String? ?? '',
        city: json['city'] as String? ?? '',
        country: json['country'] as String? ?? '',
        type: json['type'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'city': city,
        'country': country,
        'type': type,
      };
}
