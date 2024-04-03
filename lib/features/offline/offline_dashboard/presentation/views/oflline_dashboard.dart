import 'dart:async';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/const/app_images_const.dart';
import 'package:ym_daa_toce/core/db_client.dart';
import 'package:ym_daa_toce/features/assign_class/presentation/controller/assign_class_controller.dart';
import 'package:ym_daa_toce/features/assign_class/presentation/views/attendance_screen.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/controllers/attendance_ranking_controller.dart';
import 'package:ym_daa_toce/features/report/report_controller.dart';
import 'package:ym_daa_toce/features/report/report_model.dart';
import 'package:ym_daa_toce/features/temps/presentation/previous_attendence_detail_screen.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../../../../utils/network_notifier/network_notifier_controller.dart';
import '../../../../assign_class/data/data_source/assign_class_data_source.dart';
import '../../../../assign_class/data/models/assign_class_model/assign_class_model.dart';
import '../../../../assign_class/data/models/top_three_attendance_model.dart';
import '../../../../assign_class/presentation/controller/top_three_attendance_controller.dart';

import '../../../../dashboard/data/models/attendace_report_model.dart';
import '../../../../dashboard/presentation/views/attendance_ranking_table.dart';
import '../../../../search_attendance/data/model/search_attendance_response_model.dart';
import '../../../../search_attendance/presentation/controllers/search_controller.dart';
import '../../../../search_attendance/presentation/views/search_attendance_screen.dart';
import '../../../offline_attendance/presentation/views/offline_attendance_screen.dart';

List<String> percentList = [">=90%", "<90%>75%", "<75"];

class Indicator {
  final String name;
  final Color color;

  Indicator({required this.name, required this.color});
}

List<Indicator> indicator = [
  // Indicator(name: "overall", color: AppColorConst.kappprimaryColorBlue),
  Indicator(name: "Male", color: Color(0xff2DA9D8)),
  Indicator(name: "Female", color: Color(0xffB73377)),
  Indicator(name: "Others", color: Colors.yellow)
  // {"name": "overall", "color": "blue"},
  // {"name": "Girls", "color": "blue"},
  // {"name": "Boys", "color": "blue"},
  // {"name": "Others", "color": "blue"}
];

class DataItem {
  int x;
  double y1;
  double y2;
  double y3;

  DataItem({
    required this.x,
    required this.y1,
    required this.y2,
    required this.y3,
  });
}

class OfflineDashboard extends ConsumerStatefulWidget {
  const OfflineDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<OfflineDashboard> {
  final List<DataItem> _myData = List.generate(
      3,
      (index) => DataItem(
            x: 1,
            y1: Random().nextInt(20) + Random().nextDouble(),
            y2: Random().nextInt(20) + Random().nextDouble(),
            y3: Random().nextInt(20) + Random().nextDouble(),
          ));
  PageController controller = PageController();

  Future<String> checkOfflineAttendance() async {
    String result = await DbClient().getData(dbKey: "offline-attendance");
    return result;
  }

  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = false;
  AssignedClassModel? assignedData;
  bool showOffline = false;
  bool clearCard = false;
  Count? hello;
  TopThreeAttendanceModel? date;
  AssignedClassModel? show;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  Locale _currentLocale = const Locale('en', 'US'); // Default to English
  bool _isLoading = false;
  @override
  void initState() {
    clearCard = false;

    // checkOfflineAttendance();
    // checkForInternet();
    showOffline = false;
    super.initState();
    _checkConnectivity();
    _connectivitySubscription =
        _connectivityService.onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
    _isLoading = true;

    // Simulating a delay of 5 seconds before showing the text
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnection();
    setState(() {
      _isConnected = isConnected;
    });
  }

  String formatNepaliTime(DateTime dateTime) {
    final nepaliDateTime = dateTime.toNepaliDateTime();
    final formattedTime = NepaliDateFormat('hh:mm:ss a').format(nepaliDateTime);
    final nepaliFormattedTime = NepaliUnicode.convert(formattedTime);

    return nepaliFormattedTime;
  }

  int? class4;
  String? section4;
  @override
  Widget build(BuildContext context) {
    final originalDate = NepaliDateTime.now();
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date2 = dateFormat.format(currentDate);
    // print(originalDate.toString());
    final monthFormatter = NepaliDateFormat.yMMMM().format(
        originalDate); // Format for month abbreviationfinal nepaliDate = dateFormat.toNepaliDateTime();
    var year = "";
    var month = "";
    var day = "";
    final dayFormatter =
        NepaliDateFormat.d().format(originalDate); // Format for day
    final weekdayFormatter = NepaliDateFormat.E().format(originalDate); //
    log(originalDate.day);
    // final formattedDate = DateFormat('hh:mm:ss a').format(originalDate);
    final assingedClass = ref.watch(assignedClassControllerProvider);
    final dataProvider = ref.watch(assignedClassDataSourceProvider);
    assingedClass.when(
      data: (value) {
        class4 = value.class_id;
        section4 = value.section_id;
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => Center(),
    );
    return Scaffold(
        // backgroundColor: AppColorConst.kappWhiteColor,

        body: class4 != null && section4 != null
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    assingedClass.when(
                        data: (value) {
                          show = value;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100.w,
                                height: 27.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      AppImagesConst.kSchoolImage,
                                    ),
                                    fit: BoxFit.fill,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.55),
                                      BlendMode.srcATop,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: AppDimensions.paddingLARGE),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 14.h,
                                          child: AnalogClock(
                                            dateTime: DateTime.now(),
                                            isKeepTime: true,
                                            dialColor: Colors.white,
                                            dialBorderColor: Colors.black,
                                            dialBorderWidthFactor: 0.08,
                                            markingColor: Colors.black,
                                            markingRadiusFactor: 1.0,
                                            markingWidthFactor: 1.0,
                                            hourNumberColor: Colors.black,
                                            hourNumbers: const [
                                              '',
                                              '',
                                              '3',
                                              '',
                                              '',
                                              '6',
                                              '',
                                              '',
                                              '9',
                                              '',
                                              '',
                                              '12'
                                            ],
                                            hourNumberSizeFactor: 1.0,
                                            hourNumberRadiusFactor: 1.0,
                                            hourHandColor: Colors.black,
                                            hourHandWidthFactor: 1.0,
                                            hourHandLengthFactor: 1.0,
                                            minuteHandColor: Colors.black,
                                            minuteHandWidthFactor: 1.0,
                                            minuteHandLengthFactor: 1.0,
                                            secondHandColor: Colors.black,
                                            secondHandWidthFactor: 1.0,
                                            secondHandLengthFactor: 1.0,
                                            centerPointColor: Colors.black,
                                            centerPointWidthFactor: 1.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppDimensions.paddingDEFAULT,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${dayFormatter} ${monthFormatter},",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize:
                                                          AppDimensions.body_20,
                                                      color: AppColorConst
                                                          .kappWhiteColor,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontFamily: AppFont
                                                          .nProductsanfont,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.8),
                                                ),
                                                Text(
                                                  " ${weekdayFormatter}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize:
                                                          AppDimensions.body_16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: AppColorConst
                                                          .kappWhiteColor,
                                                      fontFamily: AppFont
                                                          .kProductsanfont,
                                                      fontWeight: AppDimensions
                                                          .fontMedium,
                                                      letterSpacing: 0.9),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: AppDimensions
                                                  .paddingEXTRASMALL,
                                            ),
                                            StreamBuilder<int>(
                                              stream: Stream.periodic(
                                                  Duration(seconds: 1),
                                                  (count) => count),
                                              builder: (context, snapshot) {
                                                final currentTime =
                                                    DateTime.now();
                                                final formattedDate =
                                                    _currentLocale.languageCode ==
                                                            'ne'
                                                        ? formatNepaliTime(
                                                            currentTime)
                                                        : DateFormat(
                                                                'hh:mm:ss a')
                                                            .format(
                                                                currentTime);

                                                return Text(
                                                  "$formattedDate",
                                                  style: TextStyle(
                                                      fontSize:
                                                          AppDimensions.body_20,
                                                      letterSpacing: 1.1,
                                                      fontFamily: AppFont
                                                          .nProductsanfont,
                                                      color: Colors.white,
                                                      fontWeight: AppDimensions
                                                          .fontMedium),
                                                  //   ),
                                                  // ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: AppDimensions.paddingSMALL,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: context.widthPct(0.02),
                                            vertical: context.heightPct(0.012)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: ContinuousRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.8,
                                                    color: AppColorConst
                                                        .kappprimaryColorBlue),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: AppColorConst
                                                .kappprimaryColorBlue,
                                            elevation: 0,
                                            fixedSize:
                                                Size(context.widthPct(1), 45),
                                          ),
                                          onPressed: () async {
                                            ref.invalidate(
                                                studentReasonListProvider);
                                            ref.invalidate(
                                                absentReasonMissingStudentsProvider);

                                            Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        OfflineAttendanceScreen()));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 2.w,
                                                    ),
                                                    Text(
                                                      "Take Attendance".tr(),
                                                      style: TextStyle(
                                                          color: AppColorConst
                                                              .kappWhiteColor,
                                                          fontSize:
                                                              AppDimensions
                                                                  .body_16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                color: AppColorConst
                                                    .kappWhiteColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Last 3 Days Attendance'.tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                                // fontFamily: "Gil",
                                              ),
                                        ),
                                        InkWell(
                                            onTap: () => normalNav(
                                                context,
                                                SearchAttendaneScreen(
                                                  assignedClassModel: value,
                                                )),
                                            child: Text("View All".tr()))
                                      ],
                                    ),
                                    SizedBox(
                                      height: AppDimensions.paddingDEFAULT,
                                    ),
                                    ref
                                        .watch(
                                            searchAttendaceControllerProvider(
                                                SearchParam(
                                                    value.class_id.toString(),
                                                    value.section_id.toString(),
                                                    "${year}-${month}-${day}")))
                                        .when(
                                            data: (data) {
                                              hello = data.count;
                                              return Container();
                                            },
                                            error: (err, s) => Center(
                                                  child: Text(err.toString()),
                                                ),
                                            loading: () => Center()),
                                    ref
                                        .watch(
                                          topThreeAttendanceControllerProvider(
                                            TopThreeParams(
                                              classNum:
                                                  value.class_id.toString(),
                                              sectionNum:
                                                  value.section_id.toString(),
                                            ),
                                          ),
                                        )
                                        .maybeWhen(
                                            orElse: () => Center(),
                                            data: (data) {
                                              if (data.isEmpty) {
                                                return Container();
                                              }
                                              return Column(
                                                children: [
                                                  CarouselSlider(
                                                    carouselController:
                                                        _controller,
                                                    options: CarouselOptions(
                                                      autoPlayInterval:
                                                          Duration(seconds: 5),
                                                      autoPlay: true,
                                                      autoPlayCurve:
                                                          Curves.fastOutSlowIn,
                                                      enlargeCenterPage: true,
                                                      aspectRatio: 2.0,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _current = index;
                                                        });
                                                      },
                                                    ),
                                                    items: data.map((e) {
                                                      date = e;
                                                      return TodayCardOne(
                                                        hello: hello,
                                                        assign: value,
                                                        section: value.section,
                                                        onPressed: () =>
                                                            normalNav(
                                                          context,
                                                          PreviousAttendeneDetailScreen(
                                                            classid:
                                                                value.class_id,
                                                            sectionid:
                                                                int.parse(value
                                                                    .section_id),
                                                            sectionName:
                                                                value.section,
                                                            className: value
                                                                .class_name,
                                                            classNum: value
                                                                .class_id
                                                                .toString(),
                                                            date: e
                                                                .attendanceDateAd,
                                                            sectionNum: value
                                                                .section_id
                                                                .toString(),
                                                            teacherName: value
                                                                .teacher_name,
                                                          ),
                                                        ),
                                                        classNum: value.class_id
                                                            .toString(),
                                                        date:
                                                            e.attendanceDateAd,
                                                        teacherName:
                                                            value.teacher_name,
                                                        className:
                                                            value.class_name,
                                                      );
                                                    }).toList(),
                                                  ),
                                                  SizedBox(
                                                    height: AppDimensions
                                                        .paddingDEFAULT,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: data
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                      return GestureDetector(
                                                        onTap: () => _controller
                                                            .animateToPage(
                                                                entry.key),
                                                        child: Container(
                                                          width: 7.0,
                                                          height: 10.0,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      4.0),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: (Theme.of(context)
                                                                              .brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? Colors
                                                                          .white
                                                                      : AppColorConst
                                                                          .kappprimaryColorBlue)
                                                                  .withOpacity(
                                                                      _current ==
                                                                              entry.key
                                                                          ? 0.9
                                                                          : 0.4)),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              );
                                            }),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        error: (error, stack) => Text(error.toString()),
                        loading: () => Center()),
                    assingedClass.when(
                      data: (assigned) => ref
                          .watch(attendanceRankingControllerProvider(
                              AttendanceRankParams(
                                  classId: assigned.class_id,
                                  teacherId: int.parse(assigned.section_id))))
                          .when(
                              data: (rank) => Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Highest Attendance Ranking".tr(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColorConst
                                                .kappprimaryColorBlue),
                                      ),
                                      SizedBox(
                                        height: 18.0,
                                      ),
                                      if (rank.isEmpty)
                                        Center(
                                            child: Text(
                                                "No data available.".tr())),
                                      if (rank.isNotEmpty)
                                        AttendanceRankingTable(
                                          rankings: rank,
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                              error: (err, s) => Text(err.toString()),
                              loading: () => Center(
                                      child: CardPageSkeleton(
                                    totalLines: 5,
                                  ))),
                      error: (err, str) => Center(
                        child: Text(err.toString()),
                      ),
                      loading: () => Center(
                          child: CardPageSkeleton(
                        totalLines: 5,
                      )),
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final reportState = ref.watch(reportControllerProvider);
                        if (reportState.hasValue) {
                          final data = reportState.value!;

                          final allZeros = [
                            data.females,
                            data.males,
                          ].every((list) => list.every((e) => e == "0"));

                          print('Data Females: ${data.females}');
                          print('Data Males: ${data.males}');
                          print('All Zeros: $allZeros');

                          if (allZeros) {
                            return SizedBox(
                              height: 200,
                            ); // Don't execute if all values are zero
                          } else {
                            // Build your widget using the data
                            return Column(
                              children: [
                                SizedBox(
                                  height: context.heightPct(0.01),
                                ),
                                Center(
                                    child: Text(
                                  "Attendance Reports".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color:
                                          AppColorConst.kappprimaryColorBlue),
                                )),
                                SizedBox(
                                  height: context.heightPct(0.04),
                                ),
                                Center(
                                    child: Text(
                                  "Students Regularity in Pie Chart".tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                )),
                                ref.watch(reportControllerProvider).when(
                                      data: (data) {
                                        double maleValue = ((data.males
                                                    .map((e) => int.parse(e))
                                                    .fold(
                                                        0,
                                                        (previousValue, element) =>
                                                            previousValue +
                                                            element) /
                                                (data.males.map((e) => int.parse(e)).fold(0, (previousValue, element) => previousValue + element) +
                                                    data.females
                                                        .map(
                                                            (e) => int.parse(e))
                                                        .fold(
                                                            0,
                                                            (previousValue,
                                                                    element) =>
                                                                previousValue +
                                                                element) +
                                                    data.others.map((e) => int.parse(e)).fold(
                                                        0,
                                                        (previousValue, element) =>
                                                            previousValue + element))) *
                                            100);
                                        double femaleValue = ((data.females
                                                    .map((e) => int.parse(e))
                                                    .fold(
                                                        0,
                                                        (previousValue, element) =>
                                                            previousValue +
                                                            element) /
                                                (data.males.map((e) => int.parse(e)).fold(0, (previousValue, element) => previousValue + element) +
                                                    data.females
                                                        .map(
                                                            (e) => int.parse(e))
                                                        .fold(
                                                            0,
                                                            (previousValue,
                                                                    element) =>
                                                                previousValue +
                                                                element) +
                                                    data.others.map((e) => int.parse(e)).fold(
                                                        0,
                                                        (previousValue, element) =>
                                                            previousValue + element))) *
                                            100);
                                        double othersValue = ((data.others
                                                    .map((e) => int.parse(e))
                                                    .fold(
                                                        0,
                                                        (previousValue, element) =>
                                                            previousValue +
                                                            element) /
                                                (data.males.map((e) => int.parse(e)).fold(0, (previousValue, element) => previousValue + element) +
                                                    data.females
                                                        .map(
                                                            (e) => int.parse(e))
                                                        .fold(
                                                            0,
                                                            (previousValue,
                                                                    element) =>
                                                                previousValue +
                                                                element) +
                                                    data.others.map((e) => int.parse(e)).fold(
                                                        0,
                                                        (previousValue, element) =>
                                                            previousValue + element))) *
                                            100);
                                        List<PieChartSectionData>
                                            _createSections() {
                                          final sections =
                                              <PieChartSectionData>[];

                                          sections.add(
                                            PieChartSectionData(
                                              color: Color(0xff2DA9D8),
                                              value: maleValue,
                                              title:
                                                  '${maleValue.toStringAsFixed(2)}%',
                                              titleStyle: TextStyle(
                                                  color: Colors.white),
                                              showTitle: true,
                                            ),
                                          );

                                          sections.add(
                                            PieChartSectionData(
                                              color: Color(0xffB73377),
                                              value: femaleValue,
                                              title:
                                                  '${femaleValue.toStringAsFixed(2)}%',
                                              titleStyle: TextStyle(
                                                  color: Colors.white),
                                              showTitle: true,
                                            ),
                                          );

                                          sections.add(
                                            PieChartSectionData(
                                              color: Colors.yellow,
                                              value: othersValue,
                                              title:
                                                  '${othersValue.toStringAsFixed(2)}%',
                                              titleStyle: TextStyle(
                                                  color: Colors.white),
                                              showTitle: true,
                                            ),
                                          );

                                          return sections;
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 20),
                                          child: Card(
                                            color: Colors.white,
                                            elevation: 2.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                SizedBox(
                                                  height: 200,
                                                  child: PieChart(
                                                    PieChartData(
                                                        sections:
                                                            _createSections()),
                                                    swapAnimationCurve:
                                                        Curves.elasticInOut,
                                                    swapAnimationDuration:
                                                        Duration(seconds: 60),
                                                  ),
                                                ).animate().rotate(
                                                    duration:
                                                        Duration(seconds: 8)),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      error: (err, s) => Center(
                                        child: Text("Error loading data".tr()),
                                      ),
                                      loading: () => Center(
                                          child: CardPageSkeleton(
                                        totalLines: 5,
                                      )),
                                    ),
                              ],
                            );
                          }
                        } else if (reportState is Error) {
                          return Center(
                            child: Text(
                                "Error loading data"), // Display error message
                          );
                        } else {
                          return SizedBox(); // Handle other states if needed
                        }
                      },
                    ),
                    SizedBox(
                      height: AppDimensions.paddingDEFAULT,
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final reportState = ref.watch(reportControllerProvider);
                        if (reportState.hasValue) {
                          final data = reportState.value!;

                          final allZeros = [
                            data.females,
                            data.males,
                          ].every((list) => list.every((e) => e == "0"));

                          print('Data Females: ${data.females}');
                          print('Data Males: ${data.males}');
                          print('All Zeros: $allZeros');

                          if (allZeros) {
                            return SizedBox(
                              height: 200,
                            ); // Don't execute if all values are zero
                          } else {
                            // Build your widget using the data
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 3.h,
                                  width: 10.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color(0xff2DA9D8),
                                  ),
                                ),
                                SizedBox(width: AppDimensions.paddingSMALL),
                                Text("Boys".tr()),
                                SizedBox(width: AppDimensions.paddingDEFAULT),
                                Container(
                                  height: 3.h,
                                  width: 10.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color(0xffB73377),
                                  ),
                                ),
                                SizedBox(width: AppDimensions.paddingSMALL),
                                Text("Girls".tr()),
                                SizedBox(width: AppDimensions.paddingDEFAULT),
                                Container(
                                  height: 3.h,
                                  width: 10.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Colors.yellow,
                                  ),
                                ),
                                SizedBox(width: AppDimensions.paddingSMALL),
                                Text("Others".tr()),
                              ],
                            );
                          }
                        } else if (reportState is Error) {
                          return Center(
                            child: Text(
                                "Error loading data"), // Display error message
                          );
                        } else {
                          return SizedBox(); // Handle other states if needed
                        }
                      },
                    ),
                    SizedBox(
                      height: AppDimensions.paddingDEFAULT,
                    ),
                    SizedBox(
                      height: AppDimensions.paddingEXTRALARGE,
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final reportState = ref.watch(reportControllerProvider);
                        if (reportState.hasValue) {
                          final data = reportState.value!;
                      
                          final allZeros = [
                            data.females,
                            data.males,
                          ].every((list) => list.every((e) => e == "0"));

                          print('Data Females: ${data.females}');
                          print('Data Males: ${data.males}');
                          print('All Zeros: $allZeros');

                          if (allZeros) {
                            return SizedBox(
                              height: 200,
                            ); // Don't execute if all values are zero
                          } else {
                            // Build your widget using the data
                            return Column(
                              children: [
                                Center(
                                    child: Text(
                                  "Students Regularity in Bar Graph".tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                )),
                                SizedBox(
                                  height: context.heightPct(0.04),
                                ),
                                ref.watch(reportControllerProvider).when(
                                      data: (data) {
                                        List<DataItem> _myData = [];

                                        for (int i = 0;
                                            i < data.labels.length;
                                            i++) {
                                          double y1 =
                                              double.parse(data.males[i]);
                                          double y2 =
                                              double.parse(data.females[i]);
                                          double y3 =
                                              double.parse(data.others[i]);

                                          _myData.add(DataItem(
                                            x: i,
                                            y1: y1,
                                            y2: y2,
                                            y3: y3,
                                          ));
                                        }

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: SizedBox(
                                                height: context.heightPct(0.25),
                                                width: context.widthPct(0.94),
                                                child: BarChart(
                                                  BarChartData(
                                                    titlesData: FlTitlesData(
                                                      leftTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          reservedSize: 35,
                                                          interval: 5,
                                                          showTitles: true,
                                                        ),
                                                      ),
                                                      topTitles: AxisTitles(),
                                                      rightTitles: AxisTitles(),
                                                      bottomTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          showTitles: true,
                                                          getTitlesWidget:
                                                              (value, _) =>
                                                                  getTitles(
                                                                      value,
                                                                      data),
                                                        ),
                                                      ),
                                                    ),
                                                    gridData:
                                                        FlGridData(show: true),
                                                    borderData: FlBorderData(
                                                      border: Border.symmetric(
                                                        vertical: BorderSide(
                                                            width: 1),
                                                      ),
                                                    ),
                                                    barGroups:
                                                        _myData.map((dataItem) {
                                                      return BarChartGroupData(
                                                        x: dataItem.x,
                                                        barRods: [
                                                          BarChartRodData(
                                                            color: Color(
                                                                0xff2DA9D8),
                                                            toY: dataItem.y1,
                                                          ),
                                                          BarChartRodData(
                                                            color: Color(
                                                                0xffB73377),
                                                            toY: dataItem.y2,
                                                          ),
                                                          BarChartRodData(
                                                            color:
                                                                Colors.yellow,
                                                            toY: dataItem.y3,
                                                          ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                  swapAnimationDuration:
                                                      Duration(
                                                          milliseconds: 500),
                                                  swapAnimationCurve:
                                                      Curves.easeInOut,
                                                ),
                                              ).animate().scaleY(
                                                  duration:
                                                      Duration(seconds: 8))),
                                        );
                                      },
                                      error: (err, s) => Text(err.toString()),
                                      loading: () => Center(
                                          child: CardPageSkeleton(
                                        totalLines: 5,
                                      )),
                                    ),
                              ],
                            );
                          }
                        } else if (reportState is Error) {
                          return Center(
                            child: Text(
                                "Error loading data"), // Display error message
                          );
                        } else {
                          return SizedBox(); // Handle other states if needed
                        }
                      },
                    ),
                    SizedBox(
                      height: AppDimensions.paddingDEFAULT,
                    ),
                  ],
                ),
              )
            : Center(
                child: _isLoading
                    ? CardPageSkeleton(
                        totalLines: 5,
                      )
                    : Center(
                        child: Container(
                          width: 350,
                          child: Text(
                            "Sorry, You have not been assigned to any classes or section !!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFont.kProductsanfont,
                              fontSize: AppDimensions.body_18,
                              fontWeight: AppDimensions.fontMediumNormal,
                            ),
                          ),
                        ),
                      ),
              ));
  }

  Widget getTitles(double value, ReportModel data) {
    if (value >= 0 && value <= data.labels.length) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(color: Colors.black, width: 7.6.w, height: 0.1.h),
            Container(
              margin: const EdgeInsets.only(top: 6.5),
              child: Transform.rotate(
                angle: 51,
                child: Text(
                  data.labels[value.toInt()],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }
}

class TodayCardOne extends ConsumerWidget {
  const TodayCardOne(
      {super.key,
      required this.assign,
      required this.onPressed,
      required this.classNum,
      required this.date,
      required this.teacherName,
      required this.className,
      required this.section,
      required this.hello});
  final Function()? onPressed;
  final AssignedClassModel? assign;
  final String date;
  final String classNum;
  final String teacherName;

  final String className;
  final String section;
  final Count? hello;
  @override
  Widget build(BuildContext context, ref) {
    Count? fix;
    final originalDate = DateTime.parse(date);
    final nepaliDate = originalDate.toNepaliDateTime();

    final year = NepaliDateFormat.y().format(nepaliDate);
    final month = NepaliDateFormat.M().format(nepaliDate);
    final day = NepaliDateFormat.d().format(nepaliDate);
    final formattedDate =
        DateFormat.MMM("en_US").add_d().add_E().format(originalDate);
    final parts = formattedDate.split(' ');

    final dayOfWeek = parts[2];
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 27),
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFFFFFFFF), // Start color
              AppColorConst.kappprimaryColorBlue, // End color
            ],
            stops: [
              0.32,
              0.1
            ], // Adjust the stops to control the gradient distribution
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              offset: const Offset(0, 0),
              blurRadius: 4.0,
              spreadRadius: 2.0, // Adjust the spreadRadius value as desired
            ),
            //BoxShadow
            //BoxShadow
          ],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ref
                .watch(searchAttendaceControllerProvider(SearchParam(
                    assign!.class_id.toString(),
                    assign!.section_id.toString(),
                    "${year}-${month}-${day}")))
                .when(
                    data: (data) {
                      fix = data.count;
                      return Container();
                    },
                    error: (err, s) => Center(
                          child: Text(err.toString()),
                        ),
                    loading: () => Center()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NepaliDateFormat.MMMM().format(
                    nepaliDate,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: AppDimensions.fontMediumNormal,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  NepaliDateFormat.d().format(nepaliDate),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: AppDimensions.fontBold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  NepaliDateFormat.E().format(nepaliDate),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            SizedBox(width: context.widthPct(0.07)),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${className} ${section}",
                      style: TextStyle(
                          // fontFamily: "Gil",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    // const SizedBox(
                    //   height: 4,
                    // ),
                    // Text(
                    //   "${"Section".tr()} : ${section}",
                    //   style: TextStyle(
                    //       // fontFamily: "Gil",
                    //       fontWeight: FontWeight.bold,
                    //       color: CupertinoColors.systemGrey,
                    //       fontSize: 16),
                    // ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text(
                          "${"Present".tr()} : ${fix?.present ?? 0}",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: AppFont.kProductsanfont,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "${"Absent".tr()} : ${fix?.absent ?? 0} ",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: AppFont.kProductsanfont,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              width: AppDimensions.paddingDEFAULT,
            ),
            Container(
              width: 1,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
            ),
            IconButton(
                onPressed: onPressed,
                color: Colors.white,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )),
          ],
        ),
      ),
    );
  }
}
