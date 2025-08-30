class Movie {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final List<int> genreIds;
  final int? runtime;

  Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    this.genreIds = const [],
    this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] ?? 0,
        title: json['title'] ?? json['name'] ?? '',
        overview: json['overview'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        releaseDate: json['release_date'],
        genreIds: (json['genre_ids'] as List?)?.map((e) => e as int).toList() ?? const [],
        runtime: json['runtime'],
      );
}
