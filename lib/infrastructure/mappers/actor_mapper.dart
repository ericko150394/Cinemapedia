import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  //(1) Crear un método estatico con la entidad (Actor) como el dato que deseamos devolver
  //(2) El método recibira un parametro (Cast) el cual viene del modelo de datos (credits_response.dart) de nuestro response
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null 
        ? 'https://image.tmdb.org/t/p/w500${ cast.profilePath }' 
        : 'https://www.pngitem.com/pimgs/m/287-2876223_no-profile-picture-available-hd-png-download.png',
        character: cast.character,
      );
}
