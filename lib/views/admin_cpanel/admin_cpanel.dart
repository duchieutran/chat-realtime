import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/admin_service.dart';
import 'package:chatting/services/notification_service.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/profile_viewmodel.dart';
import 'package:chatting/views/admin_cpanel/admin_cpanel_user.dart';
import 'package:chatting/views/admin_cpanel/admin_notification.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCpanel extends StatefulWidget {
  const AdminCpanel({super.key});

  @override
  State<AdminCpanel> createState() => _AdminCpanelState();
}

class _AdminCpanelState extends State<AdminCpanel> {
  final TextEditingController notificationController = TextEditingController();
  final TextEditingController _notificationForUser = TextEditingController();

  final FocusNode focusNode = FocusNode();
  final NotificationService notificationService = NotificationService();
  bool isLoading = true;
  Set<String> selectedUserIds = {};
  late Users users;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    notificationController.dispose();
    _notificationForUser.dispose();
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
      body: Container(
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
                  Expanded(
                      child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
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
                            FutureBuilder<int>(
                              future: NotificationService().getNotificationCount(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _buildFeature(
                                    size: size,
                                    icon: Icons.notifications,
                                    title: "Notification",
                                    subTitle: "...",
                                    // Hiển thị dấu chấm lửng khi đang load
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AdminNotification()),
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return _buildFeature(
                                    size: size,
                                    icon: Icons.notifications,
                                    title: "Notification",
                                    subTitle: "Error",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AdminNotification()),
                                      );
                                    },
                                  );
                                } else {
                                  return _buildFeature(
                                    size: size,
                                    icon: Icons.notifications,
                                    title: "Notification",
                                    subTitle: snapshot.data.toString(),
                                    // Số lượng thông báo
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AdminNotification()),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
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
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Input notification ...",
                                    hintStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                                    filled: true,
                                    fillColor: Colors.white10,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (notificationController.text.isEmpty) {
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
                                    FocusScope.of(context).unfocus();

                                    notificationService.sendNotification(
                                        content: notificationController.text, adminUid: users.uid);
                                    appDialog(
                                      context: context,
                                      title: "Success",
                                      content: "Add notification success.",
                                      confirmText: "Okey !",
                                      onConfirm: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: size.width * 0.35,
                                  height: size.width * 0.09,
                                  decoration:
                                      BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
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
                        ),
                        SizedBox(height: size.height * 0.05),
                        Container(
                          width: size.width,
                          height: size.height * 0.5,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff313a66),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TextField nhập nội dung thông báo
                              TextField(
                                controller: _notificationForUser,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: "Input notification ...",
                                  hintStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
                                  filled: true,
                                  fillColor: Colors.white10,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                              SizedBox(height: 10),

                              // Nút Add Notification
                              ElevatedButton(
                                onPressed: _sendNotification,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  "Add Notification",
                                  style: TextStyle(
                                    color: AppColors.light,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              // Danh sách người dùng có thể chọn
                              Expanded(
                                child: FutureBuilder<List<Users>>(
                                  future: AdminService().getAllUsers(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                          child: Text("Lỗi khi lấy dữ liệu", style: TextStyle(color: Colors.white)));
                                    }
                                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return Center(
                                          child:
                                              Text("Không có người dùng nào", style: TextStyle(color: Colors.white)));
                                    }

                                    List<Users> users = snapshot.data!;
                                    return ListView.builder(
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        Users user = users[index];
                                        bool isSelected = selectedUserIds.contains(user.uid);

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedUserIds.remove(user.uid);
                                              } else {
                                                selectedUserIds.add(user.uid);
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 4),
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blueAccent.withOpacity(0.7) : Colors.white10,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                // Avatar
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundImage: NetworkImage(user.urlAvatar),
                                                ),
                                                SizedBox(width: 12),

                                                // Thông tin User
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        user.name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(user.username,
                                                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                                                    ],
                                                  ),
                                                ),

                                                // Dấu tích bên phải nếu được chọn
                                                if (isSelected)
                                                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
      ),
    );
  }

  void _sendNotification() {
    String message = _notificationForUser.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng nhập nội dung thông báo!")));
      return;
    }
    if (selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng chọn ít nhất một người dùng!")));
      return;
    }

    notificationService.sendNotification(content: message, adminUid: users.uid, receivers: selectedUserIds.toList());
    appDialog(
        context: context,
        title: "Success",
        content: "Send notification success !",
        confirmText: "Okey Admin",
        onConfirm: () {
          Navigator.pop(context);
          _notificationForUser.clear();
          selectedUserIds.clear();
        });
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
