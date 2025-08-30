import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/tmdb_api.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

final apiProvider = Provider<TmdbApi>((ref) => TmdbApi());

final trendingProvider =
    FutureProvider<List<Movie>>((ref) => ref.read(apiProvider).trendingDay());
final nowPlayingProvider =
    FutureProvider<List<Movie>>((ref) => ref.read(apiProvider).nowPlaying());
final topRatedProvider =
    FutureProvider<List<Movie>>((ref) => ref.read(apiProvider).topRated());
final upcomingProvider =
    FutureProvider<List<Movie>>((ref) => ref.read(apiProvider).upcoming());

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
            const Color.fromARGB(0, 0, 0, 0),
            const Color.fromARGB(0, 0, 0, 0),
            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
          ],
          stops: const [0.0, 0.1, 0.6, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 14, 6),
          title: AnimatedTextKit(
              repeatForever: true,
              pause: Duration(microseconds: 500),
              animatedTexts: [
                TypewriterAnimatedText(
                  'MovieCorn🍿',
                  textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  speed: const Duration(milliseconds: 200),
                )
              ]),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).pushNamed('/search'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(title: 'Trending', provider: trendingProvider),
              _Section(title: 'Now Playing', provider: nowPlayingProvider),
              _Section(title: 'Top Rated', provider: topRatedProvider),
              _Section(title: 'Upcoming', provider: upcomingProvider),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends ConsumerWidget {
  final String title;
  final FutureProvider<List<Movie>> provider;

  const _Section({required this.title, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        SizedBox(
          height: 230,
          child: async.when(
            data: (movies) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => MovieCard(
                movie: movies[i],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) =>
                          MovieDetailsScreen(movieId: movies[i].id)),
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: movies.length,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Error: $e'),
            ),
          ),
        ),
      ],
    );
  }
}
