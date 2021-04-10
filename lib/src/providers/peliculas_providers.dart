import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'e5852a6e341582f4e2287188f16fb55e';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _page = 0;
  bool _cargando = false;

  List<Pelicula> _populares = [];

  final _streamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get tuberiaSink => _streamController.sink.add;

  Stream<List<Pelicula>> get tuberiaStream => _streamController.stream;

  void streamDispose() {
    _streamController.close();
  }

  Future<List<Pelicula>> respuesta(Uri url) async {
    Response resp = await get(url);
    dynamic decoded = json.decode(resp.body);
    Peliculas p = Peliculas.fromJsonList(decoded['results']);

    return p.pelis;
  }

  Future<List<Pelicula>> getNowMovies() async {
    Uri url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    return await respuesta(url);

    //print(decoded['results'][0].length);
    //print(p.pelis);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) {
      _cargando = true;
      return [];
    }

    _page++;

    Uri url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _page.toString(),
    });

    List<Pelicula> resp = await respuesta(url);

    _populares.addAll(resp);
    tuberiaSink(_populares);

    _cargando = false;
    return resp;
    //print(decoded['results'][0].length);
    //print(p.pelis);
  }

  Future<List<Actor>> getCast(String peliId) async {
    Uri url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});

    Response resp = await get(url);
    dynamic decoded = json.decode(resp.body);
    Cast ac = Cast.fromJsonList(decoded['cast']);
    return ac.actores;
  }

  Future<List<Pelicula>> busqueda(String query) async {
    Uri url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'language': _language,
      'query': query,
    });

    return await respuesta(url);

    //print(decoded['results'][0].length);
    //print(p.pelis);
  }
}
