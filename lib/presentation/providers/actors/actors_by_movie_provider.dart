import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider
final actorByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {

  final actorRepository =  ref.watch(actorsRepositoryProvider);

  return ActorsByMovieNotifier(getActors: actorRepository.getActorsByMovie);
});

/* Id - Listado
  {
    '1234152': <Actor>[],
    '5474757': <Actor>[],
    '6879766': <Actor>[],
    '2344235': <Actor>[],
  }
 */

typedef GetActorsCallBack = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier <Map<String, List<Actor>>>{
  ActorsByMovieNotifier({required this.getActors}) : super({});

  final GetActorsCallBack getActors;

  Future <void> loadActors(String movieId) async {
    if(state[movieId] != null ) return;
    
    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors };
  }
}