import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage,
  });

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() { 
      if(widget.loadNextPage == null) return;

      if((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent)
      //print('Load next Movies');

      widget.loadNextPage!();

    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(
              title: widget.title,
              subTitle: widget.subTitle,
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({this.title, this.subTitle});

  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subTitle!),
            )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null){
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  return GestureDetector(onTap: ()=> context.push('/home/0/movie/${movie.id}'), child: FadeIn(child: child));
                },
              ),
            ),
          ),
          const SizedBox(height: 5,),
          
          /*Titulo*/
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyles.titleSmall,
            ),
          ),

          /*Raiting*/
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                const SizedBox(width: 3,),
                Text('${movie.voteAverage}', style: textStyles.bodyMedium?.copyWith(
                  color: Colors.yellow.shade800
                ),),
                Spacer(),
                Text(HumanFormats.number(movie.popularity), style: textStyles.bodySmall,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
