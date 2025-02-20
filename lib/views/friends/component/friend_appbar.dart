import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:flutter/material.dart';

class FriendAppbar extends StatefulWidget {
  const FriendAppbar({super.key, required this.size});

  final Size size;

  @override
  State<FriendAppbar> createState() => _FriendAppbarState();
}

class _FriendAppbarState extends State<FriendAppbar> {
  bool isSearch = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.035),
      width: size.width,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        color: AppColors.blue10.withOpacity(0.3),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey40,
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(0, 0), // Bóng đều ở cả 4 cạnh
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.dark,
                size: size.height * 0.03,
              ),
            ),
            isSearch
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1, color: AppColors.grey60),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                // suffix: GestureDetector(
                                //   onTap: () {},
                                //   child: const Icon(
                                //     Icons.search_outlined,
                                //     color: AppColors.grey60,
                                //   ),
                                // ),
                                suffixIcon: const Icon(Icons.search_outlined),
                                hintStyle:
                                    const TextStyle(color: AppColors.grey60),
                                fillColor: AppColors.light,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: AppColors.grey60),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: AppColors.grey60),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      const BorderSide(color: AppColors.grey60),
                                ),
                              ),
                              cursorColor: AppColors.dark,
                              style: const TextStyle(color: AppColors.dark),
                            ),
                          ),
                          // const Icon(
                          //   Icons.search_outlined,
                          // )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              width: size.width * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tim kiem
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearch = !isSearch;
                      });
                    },
                    child: Icon(
                      isSearch ? Icons.close : Icons.search_outlined,
                      color: AppColors.dark,
                      size: size.height * 0.03,
                    ),
                  ),
                  // thong bao
                  Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppColors.dark,
                        size: size.height * 0.03,
                      ),
                      Positioned(
                        top: size.height * 0.004,
                        right: size.height * 0.004,
                        child: Container(
                          width: size.height * 0.01,
                          height: size.height * 0.01,
                          decoration: BoxDecoration(
                            color: AppColors.red50,
                            borderRadius:
                                BorderRadius.circular(size.height * 0.01),
                          ),
                        ),
                      )
                    ],
                  ),
                  //logo
                  Container(
                    height: size.height * 0.04,
                    width: size.height * 0.04,
                    decoration: BoxDecoration(
                      image:
                          const DecorationImage(image: AssetImage(gifBatman)),
                      color: AppColors.blue10,
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.height * 0.04),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
