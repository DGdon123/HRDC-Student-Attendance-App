import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/views/dashboard.dart';
import 'package:ym_daa_toce/features/drawer/presentation/app_drawer.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';

class AssignClassScreen extends StatelessWidget {
  const AssignClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Assigned Classes"),
      ),
      backgroundColor: const Color(0xffF9F9FC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: ListView(
            shrinkWrap: true,
            children: const [
              // SizedBox(
              //   height: context.heightPct(0.1),
              // ),
              AssignedClassCard(
                className: "1",
                classType: "Regular",
              ),
              AssignedClassCard(
                className: "2",
                classType: "Regular",
              ),
              AssignedClassCard(
                className: "3",
                classType: "Substitute",
              )
            ].animate(interval: 0.250.seconds).slideX(),
          ),
        ),
      ),
    );
  }
}

class AssignedClassCard extends StatelessWidget {
  const AssignedClassCard(
      {super.key, required this.className, required this.classType});
  final String className;
  final String classType;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => normalNav(context, const Dashboard()),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        // width: 100,
        // height: 110,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(0, 1),
                color: CupertinoColors.lightBackgroundGray,
              )
            ],
            borderRadius: BorderRadius.circular(10),
            color: AppColorConst.kappWhiteColor),
        child: ListTile(
          trailing: Text(classType),
          leading: Icon(
            FontAwesomeIcons.graduationCap,
            size: 30,
            color: AppColorConst.kappsecondaryColorYellow,
          ),
          title: Text(
            "Class : ${className}",
            style: TextStyle(),
          ),
          subtitle: Text("Date : 2021/02/01"),
        ),
      ),
    );
  }
}
