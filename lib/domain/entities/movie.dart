
import 'package:isar/isar.dart'; //2) Importamos isar

part 'movie.g.dart'; //'movie' es el nombre del 'archivo'.dart donde se implamenta isar (ES NORMAL SI MARCA ERROR)

//5) Correr el comando 'flutter pub run build_runner build' en consola:
//Este comando va a verificar los archivos decorados con @collection y generara el archivo

@collection //Implementamos el funcionamiento Isar (BD): 1) Agregamos la anotación collection
class Movie {
  Id? isarId; //3) Agradimos el campo id para Isar (puede ser opcional ?)

  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount
  });
}