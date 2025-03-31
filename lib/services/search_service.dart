// lib/services/search_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../config/naverapi_config.dart'; // NaverApiConfig를 가져오기 위해

class SearchService {
  Future<List<Map<String, dynamic>>> fetchSearchResults(String query) async {
    final url = Uri.parse('${NaverApiConfig.baseUrl}?query=$query&display=10&start=1&sort=sim');

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Naver-Client-Id': NaverApiConfig.clientId,
          'X-Naver-Client-Secret': NaverApiConfig.clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        return items.map((item) {
          final title = item['title'];
          final document = html_parser.parse(title);
          final cleanTitle = document.body?.text ?? '';
          final latitude = _parseCoordinate(item['mapy'] ?? '', isLatitude: true);
          final longitude = _parseCoordinate(item['mapx'] ?? '', isLatitude: false);

          return {
            'title': cleanTitle,
            'latitude': latitude,
            'longitude': longitude,
          };
        }).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  String _parseCoordinate(String coordinate, {required bool isLatitude}) {
    if (coordinate.isEmpty) return '0.0';
    final integerLength = isLatitude ? 2 : 3;
    final integerPart = coordinate.substring(0, integerLength);
    final decimalPart = coordinate.substring(integerLength);
    return '$integerPart.$decimalPart';
  }
}