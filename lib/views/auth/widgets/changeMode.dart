import 'package:chatting/data_sources/app_colors.dart';
import 'package:flutter/material.dart';

class IconChangeMode extends StatefulWidget {
  final ValueChanged<bool> onPressed;
  const IconChangeMode({super.key, required this.onPressed});

  @override
  State<IconChangeMode> createState() => _IconChangeModeState();
}

class _IconChangeModeState extends State<IconChangeMode> {
  late bool light;

  @override
  void initState() {
    light = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: IconButton(
          onPressed: () {
            setState(() {
              light = !light;
              widget.onPressed.call(light);
            });
          },
          icon: Icon(
            light ? Icons.dark_mode : Icons.light_mode,
            size: 30,
            color: light ? AppColors.violet60 : AppColors.brandOrange40,
          )),
    );
  }
}
