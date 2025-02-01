import 'package:flutter/material.dart';
import 'package:chatting/utils/app_colors.dart';

class FriendRequestDialog extends StatefulWidget {
  final String url;
  final String name;
  final String email;
  final bool statusAdd;
  final VoidCallback onAddFriend;

  const FriendRequestDialog({
    super.key,
    required this.url,
    required this.name,
    required this.email,
    required this.statusAdd,
    required this.onAddFriend,
  });

  @override
  State<FriendRequestDialog> createState() => _FriendRequestDialogState();
}

class _FriendRequestDialogState extends State<FriendRequestDialog> {
  bool isAdded = false;

  @override
  void initState() {
    super.initState();
    isAdded = widget.statusAdd;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: Stack(
        children: [
          Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.1,
            decoration: const BoxDecoration(
              color: AppColors.blue30,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.network(
                    widget.url,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.name,
                  style: const TextStyle(color: AppColors.grey70, fontSize: 20, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.email,
                  style: const TextStyle(
                      color: AppColors.grey50, fontSize: 16, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                const Text(
                  "\"Gặp nhau là chữ duyên lành,\nKết tình bạn mới, chân thành sẻ chia.\"",
                  style: TextStyle(
                    color: AppColors.blue60,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: isAdded
                          ? null
                          : () {
                              setState(() {
                                isAdded = true;
                              });
                              widget.onAddFriend();
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: isAdded ? AppColors.grey30 : AppColors.green60,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isAdded ? "Pending" : "Add Friend",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.light,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.red50,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.light,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
