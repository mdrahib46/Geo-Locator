import 'package:flutter/material.dart';

import 'home_page.dart';


class GeoLocatorApp extends StatelessWidget {
  const GeoLocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
