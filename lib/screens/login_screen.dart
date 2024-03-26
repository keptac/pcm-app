import 'package:flutter/material.dart';
import 'package:zeucpcm/controllers/login_controller.dart';
import 'package:zeucpcm/styles/app_colors.dart';
import 'package:zeucpcm/styles/app_styletext.dart';
import 'package:zeucpcm/utils/constants/size_constants.dart';
import 'package:zeucpcm/widgets/custom_button.dart';
import 'package:zeucpcm/widgets/k_inputfield.dart';
import 'package:get/get.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final loginController = Get.put(LogInController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 70, 21, 99).withOpacity(0.6),
                    const Color.fromARGB(255, 4, 42, 111).withOpacity(0.7),
                    Colors.red.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.20,
                      width: width * 0.20,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const Text(
                      'Zimbabwe East Union Conference',
                      style: AppStyleText.buttonSM20W5,
                    ),
                    const Text(
                      'Public Campus Ministry',
                      style: AppStyleText.largeTitleM18W,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Sizes.dimen_40, bottom: Sizes.dimen_42),
                      child: Column(
                        children: [
                          KInputField(
                              width: width * 0.70,
                              hintText: "User Name",
                              prefixIcon: const Icon(Icons.person),
                              suffixIcon: const SizedBox(),
                              textInputType: TextInputType.text,
                              controller: loginController.usernameControlleer,
                              hintTextStyle: AppStyleText.infoDetailM16S5,
                              textStyle: AppStyleText.infoDetailM16P5,
                              suffixText: ''),
                          const SizedBox(height: 20),
                          Obx(() => KInputField(
                              width: width * 0.70,
                              hintText: "Password",
                              obscureText: loginController.obsecureText.value,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  loginController.obsecureText.value
                                      ? loginController.setObsecureText(false)
                                      : loginController.setObsecureText(true);
                                },
                                child: Icon(
                                  loginController.obsecureText.value
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined,
                                  size: Sizes.dimen_24,
                                ),
                              ),
                              textInputType: TextInputType.text,
                              controller: loginController.passwordController,
                              hintTextStyle: AppStyleText.infoDetailM16S5,
                              textStyle: AppStyleText.infoDetailM16P5,
                              suffixText: '')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Sizes.dimen_42, bottom: Sizes.dimen_22),
                      child: CustomRaisedBtn(
                          onPressed: () {
                            sigIn(context);
                          },
                          borderRadius: 50,
                          width: width * 0.40,
                          height: Sizes.dimen_56,
                          child: const Text(
                            'Sign In',
                            style: AppStyleText.buttonSM20W5,
                          ),
                          color: Color.fromARGB(255, 113, 18, 18)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void sigIn(BuildContext context) {
    if (loginController.username == "" || loginController.password == "") {
      Get.snackbar('Error', "Password or Email is missing",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(191, 50, 56, 223),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          colorText: Colors.white,
          maxWidth: MediaQuery.of(context).size.width * 0.8);
    } else {
      loginController.login(context);
    }
  }
}
