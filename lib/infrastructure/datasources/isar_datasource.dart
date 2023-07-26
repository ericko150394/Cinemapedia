import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';

class IsarDatasource extends LocalStorageDatasource{
  late Future<Isar> db;

  IsarDatasource(){
    db = openDB();
  }

  Future<Isar> openDB() async{
    if( Isar.instanceNames.isEmpty ){
      return await Isar.open([ MovieSchema ], inspector: true, directory: '');
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int id) {
    // TODO: implement isMovieFavorite
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    // TODO: implement loadMovies
    throw UnimplementedError();
  }

  @override
  Future<void> toogleFavorite(Movie movie) {
    // TODO: implement toogleFavorite
    throw UnimplementedError();
  }
  

}