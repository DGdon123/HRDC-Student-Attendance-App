import 'package:flutter/material.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

class SpaceH extends StatelessWidget {
  const SpaceH({super.key, required this.spaceH});
  final double spaceH;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.heightPct(spaceH),
    );
  }
}
