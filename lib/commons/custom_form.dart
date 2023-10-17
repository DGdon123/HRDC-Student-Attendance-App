import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';

class CustomAppForm extends StatelessWidget {
  const CustomAppForm(
      {super.key,
      required this.textEditingController,
      this.textInputAction = TextInputAction.next,
      required this.lable,
      this.validator,
      this.onTap,
      this.maxLines = 1,
      this.isPrefixIconrequired = false,
      this.istextCapitilization = false,
      this.inputMaxLenght = 10,
      this.obscureText = false,
      required this.readOnly,
      this.ismaxLength = false,
      this.keyboardType = TextInputType.emailAddress,
      this.sufixWidget,
      this.prefixIcon});

  final String lable;
  final bool isPrefixIconrequired;
  final Widget? sufixWidget;
  final IconData? prefixIcon;
  final TextEditingController textEditingController;
  final bool obscureText;
  final bool istextCapitilization;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool ismaxLength;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final int inputMaxLenght;
  final bool readOnly;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        keyboardType: keyboardType,
        maxLength: ismaxLength ? inputMaxLenght : null,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        textCapitalization: istextCapitilization
            ? TextCapitalization.words
            : TextCapitalization.none,
        validator: validator,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w100,
            fontFamily: AppFont.kProductsanfont),
        textInputAction: textInputAction,
        decoration: InputDecoration(
            counterText: "",
            suffixIcon: sufixWidget,
            prefixIcon: isPrefixIconrequired ? Icon(prefixIcon) : null,
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 0, color: CupertinoColors.lightBackgroundGray),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 0, color: CupertinoColors.lightBackgroundGray),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 0, color: CupertinoColors.lightBackgroundGray),
                borderRadius: BorderRadius.circular(10)),
            border: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            hintText: lable
            // labelStyle:
            //     const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            // label: Text(
            //   lable,
            // ),
            ),
      ),
    );
  }
}
