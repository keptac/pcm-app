// import 'package:flutter/material.dart';
// import 'package:zeucpcm/model/delegate_info.dart';
// import 'package:zeucpcm/model/user_info.dart';
// import 'package:zeucpcm/model/user_role.dart';
// import 'package:zeucpcm/services/api.dart';
// import 'package:zeucpcm/styles/app_colors.dart';
// import 'package:zeucpcm/styles/app_styletext.dart';
// import 'package:zeucpcm/utils/constants/size_constants.dart';
// import 'package:zeucpcm/widgets/customDialogs/verification_dialog.dart';
// import 'package:zeucpcm/widgets/custom_button.dart';
// import 'package:get/get.dart';
// import 'package:zeucpcm/widgets/k_inputfield.dart';

// class CreateUserDialog extends StatelessWidget {
//   final double height;
//   final double width;

//   const CreateUserDialog({Key? key, required this.height, required this.width})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController firstnameController = TextEditingController();
//     final TextEditingController lastnameController = TextEditingController();
//     final TextEditingController companynameController = TextEditingController();
//     final TextEditingController emailController = TextEditingController();

//     String firstname = firstnameController.text.trim();
//     String lastname = lastnameController.text.trim();
//     String companyname = companynameController.text.trim();
//     String email = emailController.text.trim();

//     Future<void> verifiedDialog(
//         double height, double width, UserInfo user) async {
//       await Get.dialog(
//           VerificationDialog(height: height, width: width, user: user),
//           barrierDismissible: false);
//     }

//     void createUser(BuildContext context) {
//       var updatedDelegate = DelegateInfo(
//           id: 93343,
//           fname: firstname,
//           lname: lastname,
//           username: companyname,
//           email: email,
//           image: 'image',
//           checkinStatus: 1);

//       print(updatedDelegate.toString);

//       var value = UserInfo(
//         id: updatedDelegate.id,
//         fname: updatedDelegate.fname,
//         lname: updatedDelegate.lname,
//         username: updatedDelegate.username,
//         email: updatedDelegate.email,
//         image: updatedDelegate.image,
//         checkinStatus: updatedDelegate.checkinStatus,
//         roleId: 1,
//         userRole: UserRole(
//             id: 1,
//             name: "Delegate",
//             slug: "Our highly esteemed delegate",
//             status: 1),
//       );

//       verifiedDialog(500, 500, value);
//       Api().insertDelegate(updatedDelegate);
//     }

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 0,
//       backgroundColor: AppColors.dialogBoxColor,
//       child: SizedBox(
//         height: height * 0.70,
//         width: width * 0.42,
//         child: Column(
//           children: [
//             const SizedBox(height: 50),
//             KInputField(
//                 width: width * 0.25,
//                 hintText: "First Name",
//                 prefixIcon: const SizedBox(),
//                 suffixIcon: const SizedBox(),
//                 textInputType: TextInputType.text,
//                 controller: firstnameController,
//                 hintTextStyle: AppStyleText.infoDetailM16S5,
//                 textStyle: AppStyleText.infoDetailM16P5,
//                 suffixText: ''),
//             const SizedBox(height: 22),
//             Obx(() => KInputField(
//                 width: width * 0.25,
//                 hintText: "Surname",
//                 prefixIcon: const SizedBox(),
//                 suffixIcon: const SizedBox(),
//                 textInputType: TextInputType.text,
//                 controller: lastnameController,
//                 hintTextStyle: AppStyleText.infoDetailM16S5,
//                 textStyle: AppStyleText.infoDetailM16P5,
//                 suffixText: '')),
//             const SizedBox(height: 22),
//             Obx(() => KInputField(
//                 width: width * 0.25,
//                 hintText: "Email Address",
//                 prefixIcon: const SizedBox(),
//                 suffixIcon: const SizedBox(),
//                 textInputType: TextInputType.text,
//                 controller: emailController,
//                 hintTextStyle: AppStyleText.infoDetailM16S5,
//                 textStyle: AppStyleText.infoDetailM16P5,
//                 suffixText: '')),
//             const SizedBox(height: 22),
//             Obx(() => KInputField(
//                 width: width * 0.25,
//                 hintText: "Company",
//                 prefixIcon: const SizedBox(),
//                 suffixIcon: const SizedBox(),
//                 textInputType: TextInputType.text,
//                 controller: companynameController,
//                 hintTextStyle: AppStyleText.infoDetailM16S5,
//                 textStyle: AppStyleText.infoDetailM16P5,
//                 suffixText: '')),
//             const SizedBox(height: 50),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 CustomRaisedBtn(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     borderRadius: Sizes.dimen_18,
//                     width: width * 0.15,
//                     height: Sizes.dimen_56,
//                     child: const Text(
//                       'Cancel',
//                       style: AppStyleText.buttonSM20W5,
//                     ),
//                     color: AppColors.butttoColor),
//                 CustomRaisedBtn(
//                     onPressed: () {
//                       createUser(context);
//                       Get.back();
//                     },
//                     borderRadius: Sizes.dimen_18,
//                     width: width * 0.15,
//                     height: Sizes.dimen_56,
//                     child: const Text(
//                       'Add',
//                       style: AppStyleText.buttonSM20W5,
//                     ),
//                     color: AppColors.butttoColor),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
