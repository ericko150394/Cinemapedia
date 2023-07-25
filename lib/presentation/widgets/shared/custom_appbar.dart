import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                Icons.movie_outlined,
                color: colors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                'Cinemapedia',
                style: titleStyle,
              ),
              const Spacer(),
              IconButton(
                  /* onPressed: () {
                    final movieRepository =  ref.read(movieRepositoryProvider);

                    //Opcion (1): Sin recuperar el id de la pelicula para ir a otra pantalla:
                    // showSearch<Movie?>( //Al método podemos indicador el tipo de dato <Int/double> opcional '?' con el que puede trabajar
                    //   context: context,
                    //   delegate: SearchMoviDelegate(
                    //     searchMovie: movieRepository.getSearchMovies), //Enviamos la función solicitada por searchDelegate
                    // );
                  }, */
                  
                  onPressed: () {
                    //Opcion 1 Mantener estado del query: 
                    //final movieRepository =  ref.read(movieRepositoryProvider);
                    //Mantener el estado del query de busqueda, usando un stateprovider:
                    //final searchQuery = ref.read(searchQueryProvider); //<-- Esta valor se asigna al método showSearch en la propiedad 'query

                    //Opcion (2):
                    final searchedMovies = ref.read(searchedMoviesProvider); //Apuntando a mi nuevo provider con la lista de búsqueda previa
                    final searchQuery = ref.read(searchQueryProvider);


                    showSearch<Movie?>( //Al método podemos indicador el tipo de dato <Int/double> opcional '?' con el que puede trabajar
                      query: searchQuery,
                      context: context,
                      delegate: SearchMoviDelegate( //Modificamos la instancia para recibir 2 parametros, e initialMovies es una lista de peliculas por 
                        initialMovies: searchedMovies, //<- Opcion 2: Agregar un parametro para tener un valor inicial
                        searchMovies: 
                        
                        //Opción 1: Manteniendo el estado del query
                        /* (query){ //<-- Función anónima: (parameter) => o (parameter) { }
                          ref.read(searchQueryProvider.notifier).update((state) => query);
                          return movieRepository.getSearchMovies(query);
                        } */

                        //Opción 2: Manteniendo el estado del query + lista de busqueda
                        ref.read(searchedMoviesProvider.notifier).searchMovieByQuery

                        ), //Enviamos la función solicitada por searchDelegate
                    ).then((movie) {
                      if(movie ==null) return;
                      context.push('/movie/${movie.id}');
                    });

                    //NOTA: Don't use 'BuildContext's across async gaps:
                    //Hacer esto entre espacios asincronos de un método, lleva el riesgo de un cambio en el contexto
                    //Es mejor llamar al valor del context cuando se llame a la función showSearch():
                    /* if(movie != null){
                      context.push('movie/${movie.id}'); 
                    } */
                    //Mejor hacer el llamado del context en el método .then() de la función showSearch()
                    //Y recomiendo el async/await del métdoo onPressed
                    
                  }, 
                  icon: const Icon(Icons.search))
            ],
          ),
        ),
      ),
    );
  }
}
