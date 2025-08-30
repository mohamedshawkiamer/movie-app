# MovieVerse (Flutter)

A clean starter to meet the *Movie App Requirements* (Trending, Now Playing, Top Rated, Upcoming, Details with cast/crew & trailer, and Search with live suggestions).

## Setup

1. Create a TMDB account and generate an API key (bearer token).
2. Run the app with your key:

```bash
flutter pub get
flutter run --dart-define=TMDB_API_KEY=YOUR_TMDB_V4_READ_TOKEN
```

> The app expects a **v4** bearer token in `TMDB_API_KEY` for Authorization headers.

## Build

```bash
flutter build apk --dart-define=TMDB_API_KEY=YOUR_TMDB_V4_READ_TOKEN
```

## Notes

- Images use: `https://image.tmdb.org/t/p/w500/{image_path}`.
- Home shows sections: Trending, Now Playing, Top Rated, Upcoming.
- Details screen shows: poster/backdrop, title, release date, rating, overview, genres, runtime, cast & crew (names), and an embedded YouTube trailer when available.
- Search provides live suggestions with debounced requests.
