import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final peliProvider = new PeliculasProvider();
  final peliculas = [
    'SuperMan',
    'Batman',
    'IronMan',
    'Capitan America',
    'Hulk',
    'Pantera Negra',
  ];
  final peliculasRecientes = [
    'Pantera Negra',
    'IronMan',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Imagen a la izquierda del appbar
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // el builder o el que crea los resultados que se muestran

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando se escribe

    return FutureBuilder(
      future: peliProvider.busqueda(query),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: FadeInImage(
                      width: 50.0,
                      fit: BoxFit.contain,
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      image: NetworkImage(snapshot.data[i].getImage())),
                  title: Text(snapshot.data[i].title),
                  subtitle: Text(snapshot.data[i].originalTitle),
                  onTap: () {
                    snapshot.data[i].uniqueId = '';
                    close(context, null);
                    Navigator.pushNamed(context, 'detalle',
                        arguments: snapshot.data[i]);
                  },
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    /* final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    ); */
  }
}
