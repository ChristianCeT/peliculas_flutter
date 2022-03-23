import 'package:flutter/material.dart';
import 'package:peliculas_flutter/models/models.dart';
import 'package:peliculas_flutter/provider/movies_provider.dart';
import 'package:provider/provider.dart';

class MoviesSearchDelegate extends SearchDelegate {
  @override
  //asd
  String get searchFieldLabel => "Buscar película";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = ""; //elimina la query(el texto)
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //regresa a la pantalla anterior
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("BuildResults");
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 140,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    //listen sirve para no redibujar el future
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvider.getSuggestionsByQuery(query);

    //Hay mas control con un StreamBuilder que un FutureBuilder
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();
        final movies = snapshot.data!;

        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => _MovieItem(
                  movie: movies[index],
                ));
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
