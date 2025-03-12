// lib/models/modir.dart
class Modir {
  final int id;
  final String title;
  final double latitude;
  final double longitude;

  Modir({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory Modir.fromJson(Map<String, dynamic> json) {
    return Modir(
      id: json['id'] as int,
      title: json['title'] as String,
      latitude: (json['mapy'] as num).toDouble(),  // num을 double로 변환
      longitude: (json['mapx'] as num).toDouble(), // num을 double로 변환
    );
  }
}