import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieMasonry extends StatefulWidget {
  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  //TODO: InfiniteScroll 
  //Paso 1) Definir un controller y asociarlo al controller del Masonry:
  final scrollController = ScrollController();
  
  //TODO: initState
  //Paso 2) InitState (Crear Listener)
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      //4) Condicinar que contenemos con la siguiente página (loadNextPage)
      if(widget.loadNextPage == null ) return;

      //5) Definir la posición del scroll
      if(scrollController.position.pixels +100 >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }
    });
  }

  //TODO: Dispose
  //Paso 3) Dispose para hacer la limpieza al crear el listener
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3, //Columnas
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 40),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }

          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
