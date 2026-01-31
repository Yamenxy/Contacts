import 'package:flutter/material.dart';

class RouteLogo extends StatelessWidget {
  const RouteLogo({super.key, this.width = 110});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/Route.png', width: width, fit: BoxFit.contain);
  }
}
