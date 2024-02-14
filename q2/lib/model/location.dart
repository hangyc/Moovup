
class Location {
  Location(this.latitude, this.longitude);

  final double? latitude;
  final double? longitude;

  Location.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'latitude': latitude, 'longitude': longitude};
}
