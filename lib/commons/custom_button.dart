import 'package:flutter/material.dart';

import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton(
      {required this.label,
      super.key,
      this.bioMetricsOnpress,
      required this.onPressed,
      this.isLable = true,
      this.bottonBgColor = AppColorConst.kappprimaryColorBlue,
      this.lableColor = Colors.white});

  final String label;
  final void Function()? onPressed;
  final Color lableColor;
  final Color bottonBgColor;
  final bool isLable;
  final void Function()? bioMetricsOnpress;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: context.widthPct(1)),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(0, 45),
            shape: ContinuousRectangleBorder(
                side: const BorderSide(
                    width: 0.8, color: AppColorConst.kappprimaryColorBlue),
                borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            backgroundColor: bottonBgColor,
          ),
          onPressed: onPressed,
          child: isLable
              ? Text(
                  label,
                  style: TextStyle(
                      fontFamily: AppFont.kProductsanfont,
                      color: lableColor,
                      fontWeight: FontWeight.bold),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontFamily: AppFont.kProductsanfont,
                          color: lableColor,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: bioMetricsOnpress,
                        icon: const Icon(
                          Icons.fingerprint,
                          color: AppColorConst.kappprimaryColorBlue,
                        ))
                  ],
                )),
    );
  }
}
