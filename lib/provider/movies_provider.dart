import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_flutter/helpers/debouncer.dart';
import 'package:peliculas_flutter/models/models.dart';
import 'package:peliculas_flutter/models/search_movie_response.dart';

//Para que funcione un provider se debe extender de ChangeNotifier

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = "api.themoviedb.org";
  final String _apiKey = "4190aa8f5d7f2ebf6913f0bec0bf28e3";
  final String _language = "es-ES";

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  //todo los stream se debe de cerrar
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  //constructor
  MoviesProvider() {
    // ignore: avoid_print
    print("MoviesProvider inicializado");

    //Metodo que se esta llamando
    getOnDisplayMovies();
    getPopularMovies();
  }
//forma de hacer opcional un parametro en dart [int page = 1 valor defecto]
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      //parametros de la peticion
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  //metodo
  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    //Compatibilidad con un listado de movies
    onDisplayMovies = nowPlayingResponse.results;

    //Le dice a todos los listener, sucedio un cambio y se redibuja
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    //Compatibilidad con un listado de movies
    //Toma las peliculas actuales y concatenar los resultados
    popularMovies = [...popularMovies, ...popularResponse.results];

    //Le dice a todos los listener, sucedio un cambio y se redibuja
    notifyListeners();
  }

//Future listado de cast
  Future<List<Cast>> getMovieCast(int movieId) async {
    //Se pone el simbolo de admiracion por que se que tengo el valor
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    print("Pidiendo info al servidor de los actores");

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, "3/search/movie", {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //se llama a la data
      final results = await searchMovies(value);
      
      //seteas la data
      _suggestionStreamController.add(results);
    };

    //sirve para iniciar la peticion con la query
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });
    
    //termina la petición del timer
    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
