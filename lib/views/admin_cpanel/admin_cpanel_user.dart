import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/admin_service.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:flutter/material.dart';

class AdminCpanelUser extends StatefulWidget {
  const AdminCpanelUser({super.key});

  @override
  State<AdminCpanelUser> createState() => _AdminCpanelUserState();
}

class _AdminCpanelUserState extends State<AdminCpanelUser> {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: AppColors.grey30)),
                Text(
                  "User Management",
                  style: TextStyle(
                    color: AppColors.light,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Icon(Icons.verified_user, color: AppColors.green50),
              ],
            ),
            // list friend
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: size.width,
                decoration:
                    BoxDecoration(color: Color(0xff596def).withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
                child: FutureBuilder<List<Users>>(
                  future: AdminService().getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Image(image: AssetImage(gifBatman)));
                    }
                    if (snapshot.hasError) {
                      return Text(
                        "Lỗi khi lấy dữ liệu",
                        style: TextStyle(color: AppColors.light),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("Không có người dùng nào", style: TextStyle(color: AppColors.light));
                    }

                    List<Users> users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return _buildCardUser(size: size, user: users[index]);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardUser({required Size size, required Users user}) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(8),
          width: size.width,
          height: size.height * 0.1,
          decoration: BoxDecoration(color: Color(0xff44518a), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // avatar
              CircleAvatar(
                backgroundImage: NetworkImage(user.urlAvatar),
              ),
              SizedBox(width: 10),
              // ten + email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "name : ${user.name}",
                      style: TextStyle(
                        color: AppColors.light,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      "gmail: ${user.email}",
                      style: TextStyle(
                        color: AppColors.light,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      "UID : ${user.uid} ",
                      style: TextStyle(
                          color: AppColors.light,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: false,
                    // Không cho phép nhấn ra ngoài để đóng
                    enableDrag: false,
                    // Không kéo xuống để đóng
                    isScrollControlled: true,
                    // Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      bool isAdmin = user.role; // Lấy giá trị role từ user

                      return Container(
                        width: double.infinity, // Full width
                        padding: EdgeInsets.all(20), // Padding tổng thể
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Update Admin Role",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),

                            // Nút cập nhật và hủy
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      AdminService().updateUserRole(user.uid, !isAdmin).then((_) {
                                        setState(() {
                                          user.role = !isAdmin;
                                        });
                                        if (mounted) {
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isAdmin ? Colors.red : Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12), // Bo góc
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Text(
                                      isAdmin ? "Remove Admin" : "Grant Admin",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),

                                // Nút Cancel
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.grey.shade400),
                                      // Viền
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12), // Bo góc
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.more_vert, color: AppColors.grey30),
              ),
            ],
          ),
        ),
        user.role
            ? Positioned(
                top: 0,
                left: 15,
                child: Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
