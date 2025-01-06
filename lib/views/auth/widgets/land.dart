import 'package:flutter/material.dart';

class Land extends StatelessWidget {
  const Land({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // bottom: getProportionateScreenWidth(-65),
      left: 0,
      right: 0,
      child: Image.asset(
        "assets/images/land_tree_light.png",
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
