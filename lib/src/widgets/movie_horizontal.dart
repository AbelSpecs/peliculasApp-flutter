import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  List<Pelicula> peliculas = [];
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemBuilder: (context, i) {
          return _tarjeta(context, peliculas[i]);
        },
        itemCount: peliculas.length,
      ),
    );
  }

  /* List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getImage()),
                fit: BoxFit.cover,
                height: 160.0,
                width: 150.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              pelicula.title,
              style: Theme.of(context).textTheme.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }).toList();
  } */

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-tarjeta';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getImage()),
                fit: BoxFit.cover,
                height: 160.0,
                width: 150.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            pelicula.title,
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
