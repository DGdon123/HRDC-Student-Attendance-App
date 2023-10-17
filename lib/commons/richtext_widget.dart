import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget(
      {super.key,
      required this.onTap,
      required this.firstText,
      required this.secondText});
  final Function()? onTap;
  final String firstText;
  final String secondText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "$firstText ",
                style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontFamily: AppFont.kProductsanfont)),
            TextSpan(
                text: secondText,
                style: const TextStyle(
                    color: AppColorConst.kappprimaryColorBlue,
                    fontFamily: AppFont.kProductsanfont),
                recognizer: TapGestureRecognizer()..onTap = onTap),
            const TextSpan(),
          ],
        ),
      ),
    );
  }
}
