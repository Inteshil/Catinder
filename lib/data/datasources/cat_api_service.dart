import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:catinder/domain/entities/cat.dart';

class CatApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.thecatapi.com/v1',
    headers: {
      'x-api-key': 'live_JbuH8dvofieAnngzk6sej35EExSxX2WPkOt4oBwq0Qeo9IeKYHDsxJnoXaECdUXJ',
    },
  ));

  Future<Cat?> fetchRandomCat([String? breed]) async {
    try {
      print('Fetching random cat from API...');
      final response = await _dio.get(
        '/images/search',
        queryParameters: {
          'has_breeds': 1,
          'limit': 1,
          if (breed != null) 'breed_ids': breed,
        }
      );

      print('API response: ${response.data}');

      if (response.data.isNotEmpty) {
        final data = response.data[0];
        if (data['breeds'] == null || (data['breeds'] as List).isEmpty) {
          print('No breed information available, retrying...');
          return fetchRandomCat(breed);
        }
        
        final breedData = data['breeds'][0];
        final cat = Cat(
          id: data['id'],
          imageUrl: data['url'],
          breed: breedData['name'],
          description: breedData['temperament'],
          detailedDescription: '${breedData['description']} '
              'Life span: ${breedData['life_span']} years. '
              'Origin: ${breedData['origin']}',
          likedAt: null,
        );
        print('Created cat: ${cat.breed}');
        return cat;
      }
      print('No cat data received');
      return null;
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }
}