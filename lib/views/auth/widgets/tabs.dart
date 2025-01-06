import 'package:chatting/data_sources/app_colors.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
    required this.press,
  });

  final ValueChanged<int> press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width, // 80%
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTabController(
        length: 2,
        child: TabBar(
          indicator: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorColor: AppColors.light,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          labelColor: AppColors.dark,
          unselectedLabelColor: AppColors.light,
          onTap: press,
          tabs: const [
            Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("morning login"),
              ),
            ),
            Tab(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Night login"),
            ))
          ],
        ),
      ),
    );
  }
}
