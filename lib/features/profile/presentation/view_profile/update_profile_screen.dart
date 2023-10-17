import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ym_daa_toce/commons/custom_button.dart';
import 'package:ym_daa_toce/commons/custom_form.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/profile/presentation/view_profile/profile_screen.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/form_validation/form_validation_extension.dart';
import 'package:ym_daa_toce/utils/keyboard_dismiss/keyboard_dimiss_extension.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController phoneController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  File? image;
  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
      );
      if (image == null) {
        return;
      } else {
        final imageTempo = File(image.path);
        if (kDebugMode) print(imageTempo);

        if (mounted) {
          setState(() {
            this.image = imageTempo;
          });
        }
      }
    } on PlatformException {
      if (kDebugMode) print("Failed to pick image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConst.kappBarUpdateProfile),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(0.02),
                vertical: context.heightPct(0.010)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: context.heightPct(0.0),
                      bottom: context.heightPct(0.03)),
                  width: context.widthPct(1),
                  height: context.heightPct(0.1),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(1.0, -9),
                          spreadRadius: 4,
                          color: CupertinoColors.lightBackgroundGray,
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                      color: CupertinoColors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            image != null
                                ? CircleAvatar(
                                    maxRadius: 38,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        FileImage(File(image!.path)),
                                  )
                                : CircleAvatar(
                                    maxRadius: context.widthPct(0.07),
                                  ),
                            SizedBox(
                              width: context.widthPct(0.09),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor:
                                        AppColorConst.kappprimaryColorBlue,
                                    shape: const RoundedRectangleBorder()),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoActionSheet(
                                          title: Text(
                                            AppConst.kchooseYouImage,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFont.kProductsanfont),
                                          ),
                                          // message: const Text('Message'),
                                          actions: <CupertinoActionSheetAction>[
                                            CupertinoActionSheetAction(
                                              child: Text(
                                                AppConst.kgallery,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    // fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        AppFont.kProductsanfont,
                                                    color:
                                                        CupertinoColors.black),
                                              ),
                                              onPressed: () async {
                                                await pickImage(
                                                    ImageSource.gallery);
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                            CupertinoActionSheetAction(
                                              child: Text(
                                                AppConst.kcamera,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    // fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        AppFont.kProductsanfont,
                                                    color:
                                                        CupertinoColors.black),
                                              ),
                                              onPressed: () async {
                                                await pickImage(
                                                    ImageSource.camera);
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                          ],
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                            child: const Text(
                                              AppConst.kcancel,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  // fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      AppFont.kProductsanfont,
                                                  color: CupertinoColors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      });

                                  // showModalBottomSheet(
                                  //     shape: const RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.vertical(
                                  //         top: Radius.circular(25.0),
                                  //       ),
                                  //     ),
                                  //     // elevation: 0,
                                  //     // barrierColor: Colors.black.withOpacity(0.9),
                                  //     // backgroundColor: Colors.transparent,
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return Text("data");
                                  //     });
                                },
                                child: const Text("Upload Profile"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                //firstName
                Text(AppConst.kFirstName),
                CustomAppForm(readOnly: false,
                  textEditingController: firstNameController,
                  lable: AppConst.kFirstName,
                  validator: (input) => input!.isFirtNameValid(input),
                ),
                //lastName
                Text(AppConst.kLastName),
                CustomAppForm(readOnly: false,
                  textEditingController: lastNameController,
                  lable: AppConst.kLastName,
                  validator: (input) => input!.isLastNameValid(input),
                ),
                //Phone
                Text(AppConst.kContact),
                CustomAppForm(readOnly: false,
                  textEditingController: phoneController,
                  lable: AppConst.kContact,
                  validator: (input) => input!.isPhoneValidate(input),
                ),
                Text(AppConst.kAddress),
                CustomAppForm(readOnly: false,
                  textEditingController: addressController,
                  lable: AppConst.kAddress,
                  validator: (input) => input!.isFirtNameValid(input),
                ),
                CustomAppButton(
                  label: AppConst.kUpdate,
                  onPressed: () => normalNav(context, const ProfileScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
