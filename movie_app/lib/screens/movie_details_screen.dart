import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieverse/screens/home_screen.dart';

import '../core/config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final movieRawProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, id) async {
  return ref.read(apiProvider).rawMovieDetails(id);
});

class MovieDetailsScreen extends ConsumerStatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  YoutubePlayerController? _yt;

  @override
  void dispose() {
    _yt?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(movieRawProvider(widget.movieId));
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
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 138, 14, 6),
            title: AnimatedTextKit(
                repeatForever: true,
                pause: Duration(microseconds: 500),
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Details🎬',
                    textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    speed: const Duration(milliseconds: 200),
                  )
                ])),
        body: async.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (data) {
              final title = data['title'] ?? '';
              final overview = data['overview'] ?? '';
              final backdrop = data['backdrop_path'];
              final releaseDate = data['release_date'] ?? '';
              final runtime = data['runtime']?.toString() ?? '';
              final vote = (data['vote_average'] ?? 0).toString();
              final genres =
                  (data['genres'] as List?)?.map((e) => e['name']).join(', ') ??
                      '';

              // YouTube trailer
              final videos = (data['videos']?['results'] as List?) ?? [];
              final trailer = videos.cast<Map<String, dynamic>>().firstWhere(
                    (v) => (v['site'] == 'YouTube') && (v['type'] == 'Trailer'),
                    orElse: () => {},
                  );
              final ytKey = trailer['key'] as String?;
              if (ytKey != null && _yt == null) {
                _yt = YoutubePlayerController(
                  initialVideoId: ytKey,
                  flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (backdrop != null)
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.network(
                            '${AppConfig.imageBaseUrl}${AppConfig.imageSizeW500}$backdrop',
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(.5),
                                  const Color.fromARGB(0, 0, 0, 0),
                                  const Color.fromARGB(0, 0, 0, 0),
                                  const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.7),
                                ],
                                stops: const [0.0, 0.3, 0.9, 1.0],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Release: $releaseDate • Rating: $vote⭐ • Runtime: $runtime min',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                if (genres.isNotEmpty)
                                  Text(
                                    'Genres: $genres',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    // باقي التفاصيل (Overview + Trailer)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            overview,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          if (_yt != null) ...[
                            Text(
                              'Trailer',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: YoutubePlayer(
                                controller: _yt!,
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
