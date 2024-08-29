import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpacalculator/splash_screen.dart';

import 'option.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Splas_screen(),
    );
  }
}
