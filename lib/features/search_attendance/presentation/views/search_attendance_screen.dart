import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/search_attendance/presentation/controllers/search_controller.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../../../const/app_colors_const.dart';
import '../../../../utils/custom_navigation/app_nav.dart';
import '../../../assign_class/data/models/assign_class_model/assign_class_model.dart';
import '../../data/model/search_attendance_response_model.dart';
import 'attendance_result_screen.dart';

class SearchAttendaneScreen extends ConsumerStatefulWidget {
  const SearchAttendaneScreen({super.key, required this.assignedClassModel});
  final AssignedClassModel assignedClassModel;

  @override
  ConsumerState<SearchAttendaneScreen> createState() =>
      _SearchAttendaneScreenState();
}

class _SearchAttendaneScreenState extends ConsumerState<SearchAttendaneScreen> {
  late TextEditingController dateTextEditingControllor;
  NepaliDateTime? searchQuery;
  late String query;
  @override
  void initState() {
    query = "";
    // final currentDate = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    dateTextEditingControllor = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    dateTextEditingControllor.dispose();
    super.dispose();
  }

  String _displayText(DateTime? date) {
    final devanagariDate = NepaliUnicode.convert(date.toString());
    log(devanagariDate);
    if (date == null) {
      date = "" as DateTime?;
    }
    if (devanagariDate != null) {
      return '${"Date".tr()}: ${devanagariDate.toString().split(' ')[0] ?? ""}';
    } else {
      return 'Choose The Date'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(searchAttendaceControllerProvider(SearchParam(
      widget.assignedClassModel.class_id.toString(),
      widget.assignedClassModel.section_id.toString(),
      query,
    )));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Previous Attendance'.tr(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.02)),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0, 1),
                      color: CupertinoColors.lightBackgroundGray,
                    )
                  ],
                ),
                child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      searchQuery = await picker.showAdaptiveDatePicker(
                          context: context,
                          initialDate: NepaliDateTime.now(),
                          firstDate: NepaliDateTime(2078),
                          lastDate: NepaliDateTime(2100));

                      dateTextEditingControllor.text =
                          _displayText(searchQuery);
                      final dateValue = searchQuery.toString().split(' ')[0];

                      if (searchQuery != null)
                        setState(() {
                          query = dateValue.toString();
                        });
                    },
                    style: TextStyle(
                        fontFamily: AppFont.kProductsanfont, fontSize: 12),
                    controller: dateTextEditingControllor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(
                            14,
                          )),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            dateTextEditingControllor.clear();
                            setState(() {
                              query = "";
                            });
                          },
                          icon: Icon(CupertinoIcons.clear)),
                      prefixIcon: IconButton(
                          onPressed: () async {
                            searchQuery = await picker.showAdaptiveDatePicker(
                                context: context,
                                initialDate: NepaliDateTime.now(),
                                firstDate: NepaliDateTime(2078),
                                lastDate: NepaliDateTime(2100));

                            dateTextEditingControllor.text =
                                _displayText(searchQuery);
                            final dateValue =
                                searchQuery.toString().split(' ')[0];

                            if (searchQuery != null)
                              setState(() {
                                query = dateValue.toString();
                              });
                            if (searchQuery == null) {
                              setState(() {
                                query = "";
                              });
                            }
                          },
                          icon: const Icon(FontAwesomeIcons.calendarDay)),
                      hintText: "Select Date".tr(),
                      border: InputBorder.none,
                      filled: true,
                      enabled: true,
                      fillColor: Colors.white,
                    )),
              ),
              SizedBox(
                height: context.heightPct(0.9),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TrendingCourses(
                    //   screenWidth: context.widthPct(1),
                    // ),
                    result.when(
                        data: (data) {
                          return data.data.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: context.heightPct(0.3)),
                                  child: Text("No Attendance Available".tr()),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 3),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: CupertinoColors
                                                      .lightBackgroundGray,
                                                  width: 1),
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  AppColorConst
                                                      .kappprimaryColorBlue, // Start color
                                                  const Color(
                                                      0xFFFFFFFF), // End color
                                                ],
                                                stops: [
                                                  0.825,
                                                  0.1
                                                ], // Adjust the stops to control the gradient distribution
                                              ),
                                              color: Color(0xff0068B8),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 22, 123, 198),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 7),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${NepaliDateFormat.MMMM().format(searchQuery!)}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  AppDimensions
                                                                      .fontMediumNormal,
                                                              color: AppColorConst
                                                                  .kappWhiteColor),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "${NepaliDateFormat.d().format(searchQuery!)}",
                                                          style: TextStyle(
                                                              fontSize: 21,
                                                              fontWeight:
                                                                  AppDimensions
                                                                      .fontBold,
                                                              color: AppColorConst
                                                                  .kappWhiteColor),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                            "${NepaliDateFormat.EEEE().format(searchQuery!)}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    AppDimensions
                                                                        .fontMediumNormal,
                                                                color: AppColorConst
                                                                    .kappWhiteColor))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 0.05.w),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${widget.assignedClassModel.class_name} ${widget.assignedClassModel.section}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${"Present".tr()} : ${data.count.present}  ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        AppFont
                                                                            .kProductsanfont,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          Text(
                                                            "${"Absent".tr()} : ${data.count.absent}",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily: AppFont
                                                                    .kProductsanfont,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4),
                                                  child: IconButton(
                                                      onPressed: () => normalNav(
                                                          context,
                                                          AttendanceResultScreen(
                                                              date: query,
                                                              assignedClassModel:
                                                                  widget
                                                                      .assignedClassModel,
                                                              searchResponseModel:
                                                                  data)),
                                                      icon: const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: AppColorConst
                                                            .kappprimaryColorBlue,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        },
                        error: (e, s) => Text("No attendace available".tr()),
                        loading: () => Center()),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
