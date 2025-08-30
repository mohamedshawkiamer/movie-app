import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';
import '../models/movie.dart';
import '../models/genre.dart';

class TmdbApi {
  final http.Client _client;
  TmdbApi({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'accept': 'application/json',
        'Authorization': 'Bearer ${AppConfig.tmdbApiKey}',
      };

  Uri _uri(String path, [Map<String, String>? query]) {
    final q = {'language': 'en-US', ...?query};
    return Uri.parse('${AppConfig.apiBaseUrl}$path').replace(queryParameters: q);
  }

  Future<List<Movie>> fetchList(String path, {Map<String, String>? query}) async {
    final res = await _client.get(_uri(path, query), headers: _headers);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}: ${res.body}');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();
    return results.map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Movie>> trendingDay() => fetchList('/trending/movie/day');
  Future<List<Movie>> nowPlaying() => fetchList('/movie/now_playing');
  Future<List<Movie>> topRated() => fetchList('/movie/top_rated');
  Future<List<Movie>> upcoming() => fetchList('/movie/upcoming');

  Future<Movie> movieDetails(int id) async {
    final res = await _client.get(_uri('/movie/$id', {'append_to_response': 'videos,credits'}), headers: _headers);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}: ${res.body}');
    final data = json.decode(res.body) as Map<String, dynamic>;
    return Movie.fromJson(data);
  }

  Future<Map<String, dynamic>> rawMovieDetails(int id) async {
    final res = await _client.get(_uri('/movie/$id', {'append_to_response': 'videos,credits'}), headers: _headers);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}: ${res.body}');
    return json.decode(res.body) as Map<String, dynamic>;
  }

  Future<List<Genre>> genres() async {
    final res = await _client.get(_uri('/genre/movie/list'), headers: _headers);
    if (res.statusCode != 200) throw Exception('TMDB error ${res.statusCode}: ${res.body}');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final results = (data['genres'] as List).cast<Map<String, dynamic>>();
    return results.map((e) => Genre.fromJson(e)).toList();
  }

  Future<List<Movie>> search(String query) => fetchList('/search/movie', query: {'query': query});
}
