import 'package:adhkar_flutter/routes/routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.HOME_SCREEN);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset(
            'assets/images/partone.png',
          ),
          // Expanded(child: SizedBox.shrink()),
          Expanded(
            child: Image.asset(
              'assets/images/parttwo.png',
            ),
          ),
          Image.asset(
            'assets/images/partthree.png',
          ),
        ],
      ),
    );
  }
}
