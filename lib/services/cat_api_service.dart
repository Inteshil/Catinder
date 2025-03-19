import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/cat.dart';

class CatApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.thecatapi.com/v1',
    headers: {
      'x-api-key':
          'live_JbuH8dvofieAnngzk6sej35EExSxX2WPkOt4oBwq0Qeo9IeKYHDsxJnoXaECdUXJ',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<Cat?> getRandomCatByBreed(String breedId) async {
    try {
      _dio.interceptors.add(InterceptorsWrapper(
        onError: (DioException error, handler) async {
          debugPrint('Error type: ${error.type}');
          if (error.type == DioExceptionType.badResponse) {
            debugPrint('Response status: ${error.response?.statusCode}');
            debugPrint('Response headers: ${error.response?.headers}');
          }
          return handler.next(error);
        },
      ));

      final response = await _dio.get(
        '/images/search',
        queryParameters: {
          'breed_ids': breedId,
          'limit': 1,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
        ),
      );

      if (response.data != null && response.data.isNotEmpty) {
        final catData = response.data[0];
        if (catData['breeds'] == null || catData['breeds'].isEmpty) {
          debugPrint('No breed information found for cat');
          return null;
        }

        final breed = catData['breeds'][0];

        return Cat(
          imageUrl: catData['url'],
          breed: breed['name'],
          description: breed['temperament'],
          detailedDescription: '''
${breed['name']}

Temperament:
• ${breed['temperament'].split(', ').join('\n• ')}

Description:
• ${breed['description']}
• Life Span: ${breed['life_span']} years
• ${breed['origin']} origin
''',
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching cat: $e');
      if (e is DioException) {
        debugPrint('DioError type: ${e.type}');
        debugPrint('DioError message: ${e.message}');
        debugPrint('DioError response: ${e.response}');
      }
      return null;
    }
  }

  static const Map<String, String> breedIds = {
    'Британская короткошерстная': 'bsho',
    'Мейн-кун': 'mcoo',
    'Сиамская': 'siam',
  };
}
