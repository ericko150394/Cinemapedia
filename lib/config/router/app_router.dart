import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(//<-- Ruta raiz
      path:'/home/:page', //<-- Solocitamos la página que deseamos ver al dar clic en el bottomNavigationBar
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
      },
      routes: [
        GoRoute(
          path:
              'movie/:id', //Definimos que en esta screen, siempre vamos a recibir id
          name: MovieScreen.name,
          builder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return MovieScreen(
              movieId: movieId,
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    )
  ],
);
