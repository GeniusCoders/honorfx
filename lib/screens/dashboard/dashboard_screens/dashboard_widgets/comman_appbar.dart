import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommanAppbar extends StatelessWidget {
  const CommanAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          children: [
            SvgPicture.asset("assets/images/honorfx_logo.svg", height: 32),
            Spacer(),
            // GestureDetector(
            //   onTap: () {
            //     Fluttertoast.showToast(msg: "Coming Soon");
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Color(0xFFF4F4F4),
            //       borderRadius: BorderRadius.all(Radius.circular(16)),
            //     ),
            //     child: SvgPicture.asset("assets/icons/notification-bing.svg"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
