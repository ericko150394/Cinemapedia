import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _HomeView()),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading =  ref.watch(initialLoadingProvider);
    if(initialLoading) return const FullScreenLoader();

    final moviesSlideShow = ref.watch(moviesSlideshowProvider); //Slideshow
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider); //En cines
    final popularPlayingMovies = ref.watch(popularMoviesProvider); //Popular
    final upcomingPlayingMovies = ref.watch(upcomingMoviesProvider); //Proximas
    final topRatedPlayingMovies = ref.watch(topRatedMoviesProvider); //Mejor calificadas

    return CustomScrollView(
      slivers: [ //Un sliver es un 'wdiget' que trabaja directamente con el scroll de la pantalla
        const SliverAppBar(
          floating: true, //Permite que aparezca el appbar apenas tenga espacio
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [

          /* const CustomAppBar(), //<--- Este appBar ahora pasa a la posición del SliverAppBar

          Expanded( //De acuerdo al parent(Column) expandira en todo lo posible dando un ancho y alto fijos
          child: ListView.builder(
            itemCount: nowPlayingMovies.length,
            itemBuilder: (context, index) {
              final movie = nowPlayingMovies[index];
              return ListTile(
                title: Text(movie.title),
              );
            },
          ),
        ), */

                MoviesSlideShow(movies: moviesSlideShow),
                
                MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle: 'Martes 04',
                    loadNextPage: () => ref
                        .read(nowPlayingMoviesProvider.notifier)
                        .loadNextPage()),

                MovieHorizontalListview(
                    movies: upcomingPlayingMovies,
                    title: 'Próximamente',
                    subTitle: 'En este mes',
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage()),

                MovieHorizontalListview(
                    movies: popularPlayingMovies,
                    title: 'Populares',
                    //subTitle: 'Martes 04',
                    loadNextPage: () => ref
                        .read(popularMoviesProvider.notifier)
                        .loadNextPage()),

                MovieHorizontalListview(
                    movies: topRatedPlayingMovies,
                    title: 'Mejor Calificadas',
                    subTitle: 'Desde siempre',
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage()),

                const SizedBox(height: 10),
              ],
            );
          }, childCount: 1),
        ) //Delegate (Función para crear slivers dentro del list)
      ],
    );

    /* Column(
      children: [
        const CustomAppBar(),

        /* Expanded( //De acuerdo al parent(Column) expandira en todo lo posible dando un ancho y alto fijos
          child: ListView.builder(
            itemCount: nowPlayingMovies.length,
            itemBuilder: (context, index) {
              final movie = nowPlayingMovies[index];
              return ListTile(
                title: Text(movie.title),
              );
            },
          ),
        ), */

        MoviesSlideShow(movies: moviesSlideShow),

        MovieHorizontalListview(
          movies: nowPlayingMovies,
          title: 'En cines',
          subTitle: 'Martes 04',
          loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
        )
      ],
    ); */
  }
}
