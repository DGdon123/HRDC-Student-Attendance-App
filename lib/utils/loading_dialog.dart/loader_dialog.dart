import 'package:flutter/material.dart';
import 'package:ym_daa_toce/const/app_const.dart';

showLoaderDialog(BuildContext context) async {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 7), child: Text(AppConst.loading)),
      ],
    ),
  );
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
