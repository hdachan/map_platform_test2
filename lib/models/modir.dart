class Modir {
  final int id;
  final String title;
  final double latitude;
  final double longitude;
  final String type;
  final String address;
  final String roadAddress;
  final String trial;
  final String description;

  Modir({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.address,
    required this.roadAddress,
    required this.trial,
    required this.description,
  });

  factory Modir.fromJson(Map<String, dynamic> json) {
    return Modir(
      id: json['id'] as int,
      title: json['title'] as String,
      latitude: (json['mapy'] as num).toDouble(),
      longitude: (json['mapx'] as num).toDouble(),
      type: json['type'] as String,
      address: json['address'] as String,
      roadAddress: json['roadAddress'] as String,
      trial: json['trial'] as String,
      description: json['description'] as String,
    );
  }
}
