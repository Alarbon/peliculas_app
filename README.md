# Películas · Flutter web

App de películas hecha con Flutter que consulta la API de TMDB: cartelera, próximos estrenos, mejor valoradas, populares, búsqueda, reparto, fichas de actores, tráileres y favoritos guardados en Firebase Realtime Database.

**Estado:** proyecto de formación (2024). [Ver demo](https://alarbon-films.vercel.app)

## Tecnologías

Flutter y Dart · paquete `http` · API de TMDB · Firebase Realtime Database (REST)

## Ejecución

Necesitas una clave propia de la API de TMDB (gratuita en themoviedb.org). No la escribas en el código.

```bash
flutter pub get
flutter run -d chrome --dart-define=TMDB_API_KEY=tu_clave
flutter build web --dart-define=TMDB_API_KEY=tu_clave
```

En una app web la clave acaba en el JavaScript que descarga el navegador. Usa una clave dedicada solo a esta demo.

## Licencia

Pendiente de decidir.
