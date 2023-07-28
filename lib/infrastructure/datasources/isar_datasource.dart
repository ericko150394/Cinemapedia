import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource{
  late Future<Isar> db; //<-- Al no ser una tarea sincrona, se usa 'late' para esperar a que este lista

  IsarDatasource(){
    db = openDB();
  }

  //Abrir la BD de Isar
  Future<Isar> openDB() async{
    final dir = await getApplicationDocumentsDirectory();
    if( Isar.instanceNames.isEmpty ){
      return await Isar.open([ MovieSchema ], inspector: true, directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async { //Si en la BD una movie con ese id existe...
    final isar = await db; //<--- Esperamos a que la BD este lista

    final Movie? isFavoriteMovie = await isar.movies
      .filter() //Filtrar...
      .idEqualTo(movieId) //Id igual a...
      .findFirst(); //Encontrar el primero...

    return isFavoriteMovie != null; //Devolvemos booleano
  }

  @override
  Future<void> toogleFavorite(Movie movie) async {
    
    final isar = await db;

    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();

    if( favoriteMovie != null ){ //Si encontramos la movie, eliminamos de favorito....
      //Borrar
      isar.writeTxnSync(() => isar.movies.deleteSync( favoriteMovie.isarId! ));
      return;
    }

    //Si no encontramos la movie, insertamos en favorito....
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    
    final isar = await db;

    return isar.movies.where()
    .offset(offset)
    .limit(limit)
    .findAll(); //Encuentra todos...
  }

}