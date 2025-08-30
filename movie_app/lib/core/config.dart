import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  static const String apiBaseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String imageSizeW500 = 'w500';
}
