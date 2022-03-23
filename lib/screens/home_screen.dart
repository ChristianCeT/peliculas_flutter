import 'package:flutter/material.dart';
import 'package:peliculas_flutter/provider/movies_provider.dart';
import 'package:peliculas_flutter/search/search_delegate.dart';
import 'package:peliculas_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Va al arbol de widgets y busca moviesprovider si no, la crea
    //Redibuja cuando haya una modificacion en el provider el listen
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Peliculas en cines"),
          elevation: 0,
          actions: [
            IconButton(
              //es un metodo global
              //El delegate es una clase o un widget que requiere ciertas condiciones
              onPressed: () => showSearch(
                  context: context, delegate: MoviesSearchDelegate()),
              icon: const Icon(Icons.search_outlined),
            ),
          ],
        ),
        //SingleChildScrollView permite hacer scroll
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Tarjetas principales
              CardSwiper(
                movies: moviesProvider.onDisplayMovies,
              ),

              //Slider de películas
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: "Peliculas populares",
                onNextPage: () => {
                  moviesProvider.getPopularMovies(),
                },
              ),
            ],
          ),
        ));
  }
}
