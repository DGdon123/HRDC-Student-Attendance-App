import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ym_daa_toce/commons/custom_form.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/presentation/views/login_screen.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

class ClassActivitiesScreen extends ConsumerStatefulWidget {
  const ClassActivitiesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ClassActivitiesScreen> {
  bool _isExpanded = false;
  String _selectedClassActivity = "अन्य";
  TextEditingController genderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> tableHeader = [
      "S.N",
      "Date".tr(),
      "Class Activities".tr(),
    ];
    final List<String> reactionList = [
      "अन्य",
      "परिक्षा संचालान दिन",
      "अन्य कृयाकलाप भएकाे दिन",
      "परीक्षा समाप्त हुने दिन",
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Activities".tr()),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(0.015),
              vertical: context.heightPct(0.01)),
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9.0, right: 9.0, top: 8),
                  child: ExpansionTileCard(
                      paddingCurve: Curves.easeInCirc,
                      baseColor: AppColorConst.kappprimaryColorBlue,
                      expandedColor: AppColorConst.kappprimaryColorBlue,
                      title: Center(
                        child: Text(
                          "Add Class Activities".tr(),
                          style: TextStyle(
                            fontFamily: 'Pop',
                            fontSize: AppDimensions.body_14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isExpanded = expanded;
                        });
                      },
                      trailing: _isExpanded
                          ? Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColorConst
                                  .kappWhiteColor, // Change the color of the arrow when expanded
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColorConst
                                  .kappWhiteColor, // Change the color of the arrow when collapsed
                            ),
                      children: [
                        SizedBox(
                          height: AppDimensions.paddingDEFAULT,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                              ),
                              child: Text(
                                "Class Activity : ",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: AppColorConst.kappWhiteColor),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 30, top: 12),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: AppColorConst.kappWhiteColor,
                                      borderRadius: BorderRadius.circular(10)
                                      // labelStyle:
                                      //     const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                      // label: Text(
                                      //   lable,
                                      // ),
                                      ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedClassActivity,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedClassActivity = newValue!;
                                      });
                                    },
                                    items: reactionList.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(item),
                                        ),
                                      );
                                    }).toList(),
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                          color: AppColorConst.kappWhiteColor,
                                          width: 0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                          color: AppColorConst.kappWhiteColor,
                                          width: 0,
                                        ),
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                          color: AppColorConst.kappWhiteColor,
                                          width: 0,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                          color: AppColorConst.kappWhiteColor,
                                          width: 0,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: BorderSide(
                                          color: AppColorConst.kappWhiteColor,
                                          width: 0,
                                        ),
                                      ),
                                      // Remove underline
                                      // Set underline to an empty Container
                                    ),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return reactionList
                                          .map<Widget>((String item) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(item),
                                        );
                                      }).toList();
                                    },
                                    dropdownColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: ContinuousRectangleBorder(
                                    side: const BorderSide(
                                        width: 0.8,
                                        color: AppColorConst.kappWhiteColor),
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: AppColorConst.kappWhiteColor,
                                elevation: 0,
                                fixedSize: Size(context.widthPct(1), 45),
                              ),
                              onPressed: () {},
                              child: Text(
                                AppConst.kSubmit,
                                style: TextStyle(
                                    color: AppColorConst.kappprimaryColorBlue),
                              )),
                        )
                      ]),
                ),
                SizedBox(
                  height: AppDimensions.paddingDEFAULT,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...tableHeader.map((e) => Container(
                          decoration: const BoxDecoration(border: Border()),
                          child: Text(
                            e,
                            style: TextStyle(
                                color: AppColorConst.kappprimaryColorBlue,
                                fontWeight: AppDimensions.fontMedium),
                          )))
                    ],
                  ),
                ),
                Container(
                  color: AppColorConst.kappWhiteColor,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "2080-06-17",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "परीक्षा शुरु हुने दिन",
                        style: TextStyle(fontSize: 12),
                      ),
                      // Text(e.date),
                    ],
                  ),
                ),
                Container(
                  color: AppColorConst.kappWhiteColor,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "2",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "2080-06-18",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "परीक्षा समाप्त हुने दिन",
                        style: TextStyle(fontSize: 12),
                      ),
                      // Text(e.date),
                    ],
                  ),
                ),
                Container(
                  color: AppColorConst.kappWhiteColor,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "2",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "2080-06-19",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "अन्य कृयाकलाप भएकाे दिन",
                        style: TextStyle(fontSize: 12),
                      ),
                      // Text(e.date),
                    ],
                  ),
                ),
              ]))),
    );
  }
}
