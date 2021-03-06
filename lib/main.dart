import 'package:adhkar_flutter/routes/routes.dart';
import 'package:adhkar_flutter/routes/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AnnotatedRegion<SystemUiOverlayStyle>(
    child: MyApp(),
    //
    value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.SPLASH_SCREEN,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          fontFamily: 'NotoKufiArabic',
        ),
      ),
    );
  }
}
