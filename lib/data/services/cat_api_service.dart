import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_model.dart';

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String _apiKey =
      'live_JbuH8dvofieAnngzk6sej35EExSxX2WPkOt4oBwq0Qeo9IeKYHDsxJnoXaECdUXJ';

  Future<CatModel> fetchRandomCat() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)[0];
      return CatModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load cat. Status code: ${response.statusCode}',
      );
    }
  }
}
