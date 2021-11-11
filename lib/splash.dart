import 'package:flutter/material.dart';
import 'package:liscacontatos/home_page.dart';
import 'package:splashscreen/splashscreen.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 14,
      navigateAfterSeconds: new homepage(),
      title: new Text('Lista de contatos'),
      image: new Image.asset('images/imagemagenda.png',
          width: 100.0, height: 100.0),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.black,
      loadingText: new Text('Aguarde...'),
    );
  }
}
