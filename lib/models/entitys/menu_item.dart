import 'package:chatting/models/entitys/tab_item.dart';
import 'package:flutter/material.dart';

class MenuItemModel {
  MenuItemModel({
    this.id,
    this.title = "",
    required this.riveIcon,
  });

  UniqueKey? id = UniqueKey();
  String title;
  TabItem riveIcon;

  static List<MenuItemModel> menuItems = [
    MenuItemModel(
      title: "Trang Chủ",
      riveIcon: TabItem(stateMachine: "HOME_interactivity", artboard: "HOME"),
    ),
    MenuItemModel(
      title: "Tìm Kiếm",
      riveIcon:
          TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"),
    ),
    MenuItemModel(
      title: "Yêu Thích",
      riveIcon:
          TabItem(stateMachine: "STAR_Interactivity", artboard: "LIKE/STAR"),
    ),
    MenuItemModel(
      title: "Trợ Giúp",
      riveIcon: TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"),
    ),
  ];

  static List<MenuItemModel> menuItems2 = [
    MenuItemModel(
      title: "Lịch Sử",
      riveIcon: TabItem(stateMachine: "TIMER_Interactivity", artboard: "TIMER"),
    ),
    MenuItemModel(
      title: "Đăng Xuất",
      riveIcon: TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
    ),
  ];

  static List<MenuItemModel> menuItems3 = [
    MenuItemModel(
      title: "Dark Mode",
      riveIcon:
          TabItem(stateMachine: "SETTINGS_Interactivity", artboard: "SETTINGS"),
    ),
  ];
}
