import 'package:flutter/material.dart';
// import 'package:suivi_stage2/pages/home.dart';
// import 'package:suivi_stage2/pages/profile.dart';
// import 'pages/ListStage.dart';
// import 'pages/Missions.dart';
// import 'pages/Objectifs.dart'; 
// import 'pages/Realisations.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // routes: {
      //   '/page2': (context) => ListStage(),
      //   '/page3': (context) => Missions(),
      //   '/page4': (context) => Objectifs(),
      //   '/page5': (context) => Realisations(),
      // },
    );
  }
}