import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/auths_vm/auth_viewmodel.dart';
import 'package:chatting/views/widgets/app_dialog.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  Future<void> handleLogin() async {
    if (controllerEmail.text.isEmpty || controllerPassword.text.isEmpty) {
      appDialog(
          context: context,
          title: "Oops!",
          content: "Email or Password cannot be empty",
          confirmText: "Try Again",
          onConfirm: () {
            Navigator.pop(context);
          });
      return;
    }
    await auth.signIn(controllerEmail.text, controllerPassword.text);

    appDialog(
        context: context,
        title: auth.status ? "Success" : "Oops!",
        content: auth.message,
        confirmText: auth.status ? "Proceed" : "Try Again",
        onConfirm: auth.status
            ? navigatorHome
            : () {
                Navigator.pop(context);
              });
  }

  // function handle navigator signup
  navigatorSignUp() => Navigator.popAndPushNamed(context, AppRouters.signup);

  // function handle navigator home
  navigatorHome() => Navigator.popAndPushNamed(context, AppRouters.home);

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
                    "Welcome to SayHi ...\nYour friends await you! ",
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
                      "Login",
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
                      onTap: handleLogin,
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
                            "Sign In",
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
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account?  ",
                              style: const TextStyle(color: AppColors.grey40),
                              children: [
                                TextSpan(
                                  text: "Create account now!",
                                  style: const TextStyle(
                                      color: AppColors.blue40,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = navigatorSignUp,
                                )
                              ]),
                        ),
                      ),
                    ),

                    Center(
                      child: TextButton.icon(
                          onPressed: navigatorSignUp,
                          icon: const Icon(
                            Icons.person_outline,
                            color: AppColors.blue40,
                          ),
                          label: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.blue40),
                          )),
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
