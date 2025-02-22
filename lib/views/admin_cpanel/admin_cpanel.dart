import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/admin_service.dart';
import 'package:chatting/services/notification_service.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/profile_viewmodel.dart';
import 'package:chatting/views/admin_cpanel/admin_cpanel_user.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:chatting/views/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCpanel extends StatefulWidget {
  const AdminCpanel({super.key});

  @override
  State<AdminCpanel> createState() => _AdminCpanelState();
}

class _AdminCpanelState extends State<AdminCpanel> {
  final TextEditingController notificationController = TextEditingController();

  final FocusNode focusNode = FocusNode();
  final NotificationService notificationService = NotificationService();
  bool isLoading = true;
  late Users users;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    notificationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final friendViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    Users? user = await friendViewModel.getUserProfile();
    (user != null) ? users = user : users = Users();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xff44518a),
          ),
          child: isLoading
              ? Center(
                  child: Image(image: AssetImage(gifBatman)),
                )
              : Column(
                  children: [
                    // app bar
                    SizedBox(height: size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios, color: AppColors.grey30)),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            color: AppColors.light,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.1,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(users.urlAvatar),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    // info
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: size.width * 0.09),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        width: size.width,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Color(0xff596def),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              users.name,
                              style: TextStyle(
                                color: AppColors.light,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              users.email,
                              style: TextStyle(
                                color: AppColors.light,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FutureBuilder<int>(
                          future: AdminService().getUserCount(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _buildFeature(
                                size: size,
                                icon: Icons.person_outline,
                                title: "User",
                                subTitle: "...",
                                onTap: () {},
                              );
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return _buildFeature(
                                size: size,
                                icon: Icons.person_outline,
                                title: "User",
                                subTitle: "0",
                                onTap: () {},
                              );
                            }
                            return _buildFeature(
                              size: size,
                              icon: Icons.person_outline,
                              title: "User",
                              subTitle: "${snapshot.data}",
                              onTap: snapshot.data == 0
                                  ? () {}
                                  : () {
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => AdminCpanelUser()));
                                    },
                            );
                          },
                        ),
                        _buildFeature(
                            size: size, icon: Icons.message, title: "Feedback", subTitle: "100", onTap: () {}),
                        _buildFeature(size: size, icon: Icons.report, title: "Report", subTitle: "100", onTap: () {}),
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      width: size.width,
                      height: size.height * 0.18,
                      decoration: BoxDecoration(
                        color: Color(0xff313a66),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // header
                          Text(
                            "Notification",
                            style: TextStyle(
                              color: AppColors.light,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          // input
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: TextField(
                              controller: notificationController,
                              focusNode: focusNode,
                              style: TextStyle(
                                color: AppColors.light,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                hintText: "Input notification ...",
                                hintStyle: TextStyle(
                                  color: AppColors.grey40,
                                  fontSize: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.blue50),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.green50),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (notificationController.text.isEmpty) {
                                // Bỏ focus trước khi mở dialog
                                FocusScope.of(context).unfocus();

                                appDialog(
                                  context: context,
                                  title: "Error",
                                  content: "Notification cannot be empty.",
                                  confirmText: "Try again !",
                                  onConfirm: () {
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                // Bỏ focus trước khi hiển thị loading
                                FocusScope.of(context).unfocus();

                                appLoading(context: context, gif: gifBatman);
                                notificationService.sendNotification(
                                    content: notificationController.text, adminUid: users.uid);
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              width: size.width * 0.35,
                              height: size.width * 0.09,
                              decoration:
                                  BoxDecoration(color: AppColors.blue50, borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "Add Notification",
                                  style: TextStyle(
                                    color: AppColors.light,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required Size size,
    required IconData icon,
    required String title,
    required String subTitle,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        width: size.width * 0.29,
        height: size.width * 0.25,
        decoration: BoxDecoration(color: Color(0xff313a66), borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Color(0xff737ead)),
                Icon(Icons.more_vert_outlined, color: Color(0xff737ead))
              ],
            ),
            Text(
              title,
              style: TextStyle(color: Color(0xff737ead), fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              subTitle,
              style: TextStyle(color: AppColors.light, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
