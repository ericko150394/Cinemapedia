import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

//Definimos un tipo de función especifica:
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  //NOTA: Debounce, es una método/técnica utilizado para evitar que una función sea llamada con demasiada frecuencia.
  //Por ejemplo los llamados a un API:

  //¿Como usar un Debounce? Usaremos Streambuilder en lugar de FutureBuilder y crearemos un controlador para este:
  StreamController<List<Movie>> debouncedMovies = StreamController
      .broadcast(); //Al usar broadcast, indica un uso de multiples listeners y no solo uno.
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer?
      _debounceTimer; //<-- Determina el tiempo de espera, luego de que el usuario hay terminado de escribir

  SearchMoviDelegate(
      {required this.searchMovies,
      required this.initialMovies}); //El searchDelegate va a recibir una función especifica que ayudara en la búsqueda

  //Método utilizado en 'buildLeading' cuando cierre el 'delegate' y destruye el controller y que no quede en memoria:
  void clearStreams() {
    debouncedMovies.close();
  }

  //Función utilizada con Debounced, para que el StreamController, emita un nuevo valor a buscar:
  //La función ya esta programada para solo hacer 'una' petición al momento terminar cambios de valor por 500ms
  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    //Si el timer tiene un valor y esta activo, limpio mi timer
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      /* if (query.isEmpty) {//Si query está vacío... ¡No realizamos una petición!
        debouncedMovies.add([]); //Y al streamController del debounced se le agregara una lista vacía
        return;
      } */

      //Si ya tenemos un valor... ¡Realizamos la búsqueda!
      final movies = await searchMovies(query);

      initialMovies = movies; //Para evitar la doble busqueda de datos entre buildResults() y buildSuggestions(), damos un valor de inicio
      //a initialMovies, asignando el valor de movies y en el initialValue de los métodos, declarar initialMovies como su valor
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    //Dentro del BuildActions, creamos una condición/animacion con ayuda de un StreamBuilder, para que muestre
    //un icono o una animación dependiendo de su el usuario escribe en el teclado o no.
    //El isLoadingStream debe habilitarse en la función onQueryChanged -> isLoadingStream = true/false

    return [
      //Lista de widgets
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false)
              {
                return SpinPerfect(
                  animate: query.isNotEmpty,
                  duration: const Duration(seconds: 10),
                  spins: 10,
                  infinite: true,
                  child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                );
              }
            return FadeIn(
                  animate:
                      query.isNotEmpty, //Bool: Si el query no esta vacío... (2)
                  duration: const Duration(milliseconds: 300),
                  child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.clear),
                  ),
                );
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          //close() es un método propio de SearchDelegate:
          close(context,
              null); //<- result, es lo que deseamos devolver al cerrar el Search Delegate
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Opcion (1): Sin usar Debounce
    /* return FutureBuilder(
      future: searchMovie(query), //<-- La función que enviamos como párametro (Se ejecuta)
      builder: (context, snapshot) {
        
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieSearchItem(
              movie: movies[index],
               onMovieSelected: close,)
            );
      },
    ); */

    //Opción (2): Usando Debounce
    _onQueryChanged(
        query); //<-- Este método sera llamado constante, siempre que teclee algo, se va a emitir
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    //El streamBuilder, se separo en un método aparte, que estaba dentro de buildSuggestions y buildResults
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieSearchItem(
                  movie: movies[index],
                  onMovieSelected: (context, movie) {
                    clearStreams();
                    close(context, movie);
                  },
                ) //
            );
      },
    );
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieSearchItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            /* Image */
            SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                )),

            const SizedBox(width: 10),

            //Descripción
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half,
                        color: Colors.yellow.shade800,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
