import 'package:flutter/material.dart';

import 'package:login/src/routes/routes.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User form - Darwin Jimenez',

      initialRoute: '/',
      routes: getApplicationsRoutes(),
    );
  }
}
