import 'package:chatting/services/admin_service.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/views/admin_cpanel/admin_cpanel_user.dart';
import 'package:flutter/material.dart';

class AdminCpanel extends StatefulWidget {
  const AdminCpanel({super.key});

  @override
  State<AdminCpanel> createState() => _AdminCpanelState();
}

class _AdminCpanelState extends State<AdminCpanel> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xff44518a),
        ),
        child: Column(
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
                    backgroundImage: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/instagram-3d6bf.appspot.com/o/profiles%2F6vpqc9YvLscnIXlLfPDBwvWp9Kt2.jpg?alt=media&token=95f0efde-f4f3-455f-9fb5-b9dd03963b4e'),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
            // info
            Container(
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
                    "Tran Duc hieu",
                    style: TextStyle(
                      color: AppColors.light,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "tranduchieu222004@gmail.com",
                    style: TextStyle(
                      color: AppColors.light,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            // TODO:  feature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FutureBuilder<int>(
                  future: AdminService().getUserCount(),
                  // Gọi hàm lấy số lượng người dùng
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
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminCpanelUser(),
                                  ));
                            },
                    );
                  },
                ),
                _buildFeature(
                    size: size,
                    icon: Icons.message,
                    title: "Feedback",
                    subTitle: "100",
                    onTap: () {}),
                _buildFeature(
                    size: size,
                    icon: Icons.report,
                    title: "Report",
                    subTitle: "100",
                    onTap: () {}),
              ],
            ),
          ],
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
        decoration: BoxDecoration(
            color: Color(0xff313a66), borderRadius: BorderRadius.circular(15)),
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
              style: TextStyle(
                  color: Color(0xff737ead),
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(
              subTitle,
              style: TextStyle(
                  color: AppColors.light,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
