import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/utils/enums.dart';
import 'package:chatting/view_models/auths_vm/auth_viewmodel.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthViewmodel auth = AuthViewmodel();
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;

  @override
  void initState() {
    super.initState();
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
  }

  // function handle login
  Future<void> handleSignUp({required BuildContext context}) async {
    SignUpStatus status = await auth.signUp(
        email: controllerEmail.text, password: controllerPassword.text);
    String message;
    switch (status) {
      case SignUpStatus.success:
      // TODO : vào trang đăng kí
      case SignUpStatus.emailAlreadyExists:
        message = "This email is already registered.";
      case SignUpStatus.error:
        message = "An error occurred. Please try again.";
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // function handle navigator signup
  navigatorSignIn() => Navigator.pushNamed(context, AppRouters.login);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ảnh
              Image.asset(
                logo,
                width: 250,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    "Welcome to SayHi ...\nLet's get you started with an account!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.red30,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // khung đăng nhập
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.light,
                  border: Border.all(color: AppColors.light, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey90.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Login
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppColors.blue40,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // TextField email, password
                    TextFieldCustom(
                      controller: controllerEmail,
                      hintText: 'admin@admin.vn',
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextFieldCustom(
                      controller: controllerPassword,
                      hintText: '******',
                      obscureText: true,
                      inputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 30),
                    // Button
                    GestureDetector(
                      onTap: () {
                        // TODO : xu ly popup
                        appDialog(
                            context: context,
                            title: "Thong bao",
                            content: "hahahah");
                        // handleSignUp(context: context);
                      },
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppColors.blue40,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.light,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // chức năng khác (đăng kí, quên mật khẩu)
                    SizedBox(
                      width: size.width,
                      child: const Center(
                        child: Text(
                          "already have an account? sign in now!",
                          style: TextStyle(color: AppColors.grey40),
                        ),
                      ),
                    ),

                    Center(
                      child: ClipPath(
                        child: Container(
                            color: AppColors.light,
                            child: Center(
                              child: IconButton(
                                onPressed: navigatorSignIn,
                                icon: const Icon(
                                  Icons.email,
                                  color: AppColors.grey50,
                                  size: 30,
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
