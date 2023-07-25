import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment{
  static String movieDbKey = dotenv.env['THE_MOVIE_DB_KEY'] ?? 'No existe un API key';
}