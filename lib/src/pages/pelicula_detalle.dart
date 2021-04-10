import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pelicula peli = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _customAppbar(peli),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          SizedBox(height: 10.0),
          _posterTitulo(context, peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _descripcion(peli),
          _crearCasting(peli),
        ]))
      ],
    ));
  }

  Widget _customAppbar(Pelicula peli) {
    return SliverAppBar(
        elevation: 2.0,
        backgroundColor: Colors.indigo,
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            peli.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          background: FadeInImage(
            placeholder: AssetImage('assets/img/loading.gif'),
            image: NetworkImage(peli.getBackground()),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 500),
          ),
        ));
  }

  Widget _posterTitulo(BuildContext context, Pelicula peli) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: peli.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage(peli.getImage()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  peli.title,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(peli.originalTitle,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    SizedBox(width: 5.0),
                    Text(peli.voteAverage.toString()),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula peli) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(peli.overview, textAlign: TextAlign.justify),
    );
  }

  Widget _crearCasting(Pelicula peli) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
        future: peliProvider.getCast(peli.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return _crearActoresP(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _crearActoresP(List data) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(
            viewportFraction: 0.3,
            initialPage: 1,
          ),
          itemCount: data.length,
          itemBuilder: (context, i) {
            return _actorCard(data[i]);
          }),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      //margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
