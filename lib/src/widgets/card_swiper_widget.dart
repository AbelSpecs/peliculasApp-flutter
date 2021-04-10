import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    //Container tarjetaSw = Container();

    return Container(
        width: double.infinity,
        height: 300.0,
        //margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.only(top: 20.0),
        child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.5,
          itemHeight: _screenSize.height * 0.7,
          itemBuilder: (BuildContext context, int index) {
            peliculas[index].uniqueId = '${peliculas[index].id}-swiper';
            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'detalle',
                        arguments: peliculas[index]);
                  },
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(
                      peliculas[index].getImage(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: peliculas.length,
          // pagination: new SwiperPagination(),
          // control: new SwiperControl(),
        ));

    /* return GestureDetector(
      child: tarjetaSw,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: peliculas);
      },
    ); */
  }
}