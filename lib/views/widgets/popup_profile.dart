import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showPopUpProfile(
    {required BuildContext context,
    required String name,
    required String email,
    required String urlAvatar,
    required String uid}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: AppColors.translate,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                const Image(image: AssetImage(backgroundProfile)),
                const Positioned(
                    right: 30,
                    bottom: 20,
                    child: Image(image: AssetImage(vectorProfile))),
                Positioned(
                  top: 70,
                  left: 30,
                  child: Row(
                    children: [
                      // ảnh đại diện
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(width: 2, color: AppColors.light),
                            image: DecorationImage(
                                image: NetworkImage(urlAvatar))),
                      ),
                      const SizedBox(width: 15),
                      // tên + email
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                color: AppColors.light,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                                color: AppColors.light,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Image(
                        image: AssetImage(iconClose),
                        height: 20,
                      ),
                    ))
              ],
            ),
            Stack(
              children: [
                const Image(image: AssetImage(spline)),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: AppColors.violet80.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Text(
                            "UID : $uid",
                            style: const TextStyle(
                                color: AppColors.light,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 30),
                          CopyButton(textToCopy: uid)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

class CopyButton extends StatefulWidget {
  final String textToCopy;

  const CopyButton({super.key, required this.textToCopy});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isCopied = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void _copyToClipboard() async {
    // _controller.forward(); // Bắt đầu xoay
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      isCopied = true; // Đổi thành dấu tích
    });

    await Future.delayed(
        const Duration(seconds: 2)); // Giữ trạng thái trong 2 giây

    setState(() {
      isCopied = false; // Trở lại trạng thái ban đầu
    });

    // _controller.reset(); // Dừng xoay
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copyToClipboard,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isCopied
            ? const Icon(Icons.check_circle,
                color: Colors.green, key: ValueKey(1))
            : RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                child: const Icon(Icons.copy,
                    color: Colors.white, key: ValueKey(2)),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
