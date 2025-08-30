import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieverse/screens/home_screen.dart';

import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchResultsProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  final q = ref.watch(searchQueryProvider);
  if (q.isEmpty) return [];
  final api = ref.read(apiProvider);
  return api.search(q);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Timer? _debounce;

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).state = v.trim();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 14, 6),
          title: AnimatedTextKit(
              repeatForever: true,
              pause: Duration(microseconds: 500),
              animatedTexts: [
                TypewriterAnimatedText(
                  'Search🔍',
                  textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  speed: const Duration(milliseconds: 200),
                )
              ])),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by movie title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
              ),
              onChanged: _onChanged,
            ),
          ),
          Expanded(
            child: results.when(
              data: (movies) {
                if (movies.isEmpty) {
                  return const Center(child: Text('Start typing to search...'));
                }
                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 40,
                    childAspectRatio: .435,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (_, i) => MovieCard(
                    movie: movies[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              MovieDetailsScreen(movieId: movies[i].id)),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
