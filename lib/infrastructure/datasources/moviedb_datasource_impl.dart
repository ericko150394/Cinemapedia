import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

//Clase para implementaciones
class MovieDbDataSource extends MoviesDataSource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.movieDbKey,
        'language': 'es-MX'
      }));
  
  List<Movie> _jsonToMovies(Map<String, dynamic> json){
    final movieDBResponse = MovieDbResponse.fromJson(json); //Antes era: response.data
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'No-Poster') //Si la película no cuenta con un poster, no se mostrará 
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }
  
  /*LISTA DE PELICULAS*/
  //Opción 1 (Sin separar en un método la función del json)
  /* @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {

    final response = await dio.get('/movie/now_playing',
      queryParameters: {
        'page': page
      }
    );

    //El siguiente contenido puede ir en un método aaparte, pues se va a reutilizar:
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'No-Poster') //Si la película no cuenta con un poster, no se mostrará 
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  } */

  //Opción 2 (Separando en un método la función que se utilizara en todas los métodos para obtener pelis)
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing',
      queryParameters: {
        'page': page
      }
    );
    return _jsonToMovies(response.data); //Ahora esperamos la respuesta desde nuestro método
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular',
      queryParameters: {
        'page': page
      }
    );
    return _jsonToMovies(response.data); //Ahora esperamos la respuesta desde nuestro método
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) async {
    final reponse = await dio.get('/movie/top_rated',
      queryParameters: {
        'page': page
      }
    );
    return _jsonToMovies(reponse.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    final response = await dio.get('/movie/upcoming',
      queryParameters: {
        'page': page
      });
    return _jsonToMovies(response.data);
  }
  
  /*PELICULAS*/
  @override
  Future<Movie> getMovieById(String id) async{

    final response = await dio.get('/movie/$id');
    if(response.statusCode != 200) throw Exception('Movie with id $id not found');

    final movieDetails = MovieDetails.fromJson(response.data);
    final Movie movie =  MovieMapper.movieDetailsToEntity(movieDetails);

    return movie;
  }
  
  @override
  Future<List<Movie>> getSearchMovies(String search) async {
    if(search.isEmpty) return [];

    final response = await dio.get('/search/movie',
      queryParameters: {
        'query': search
      });
    return _jsonToMovies(response.data);
  }
}
