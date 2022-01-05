import 'package:flutter/material.dart';
import 'package:peliculas_flutter/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO Cambiar luego por una instancia de movie
    final String movie =
        ModalRoute.of(context)?.settings.arguments.toString() ?? 'no-movie';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _CustomAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const _PosterAndTitle(),
                const _Overview(),
                const _Overview(),
                const _Overview(),
                const CastingCards()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.all(0),
          centerTitle: true,
          title: Container(
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            color: Colors.black12,
            child: const Text(
              "movie.title",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            width: double.infinity,
          ),
          background: const FadeInImage(
            placeholder: AssetImage("assets/loading.gif"),
            image: NetworkImage("https://via.placeholder.com/500x300"),
            fit: BoxFit.cover,
          )),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const FadeInImage(
              placeholder: AssetImage("assets/no-image.jpg"),
              image: NetworkImage("https://via.placeholder.com/200x300"),
              height: 150,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "movie.title",
                style: textTheme.headline5,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                "originalTitle",
                style: textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_outline,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text("movie.voteAverage", style: textTheme.caption)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Text(
        'Sit aliquip amet velit commodo sit fugiat adipisicing aliquip fugiat dolor tempor nulla pariatur enim. Quis non et laboris pariatur culpa amet ut et adipisicing officia amet do quis enim. Non enim esse minim consequat fugiat do minim occaecat aliquip enim. Ex sint exercitation esse anim id sint laboris officia labore enim enim. Occaecat qui nisi ex sunt officia commodo cillum nisi ipsum cillum cupidatat. Officia dolor cupidatat ea ullamco excepteur esse eu aliquip ut ullamco irure dolore nulla laboris. Reprehenderit non dolore veniam amet.',
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
