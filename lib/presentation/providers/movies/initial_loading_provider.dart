//Provider para verificar que estos provider tenga info (true/false):
// nowPlayingMoviesProvider
// popularMoviesProvider
// upcomingMoviesProvider
// topRatedMoviesProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty; //Si el provider esta vacío
  final step2 = ref.watch(popularMoviesProvider).isEmpty;
  final step3 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).isEmpty;

  if(step1 || step2 ||step3 ||step4) return true;

  return false;
});
