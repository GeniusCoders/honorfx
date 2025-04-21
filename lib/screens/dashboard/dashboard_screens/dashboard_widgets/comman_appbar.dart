import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommanAppbar extends StatelessWidget {
  const CommanAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Row(
          children: [
            Image.asset("assets/images/techysquad_logo.png", height: 32),
            Spacer(),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: SvgPicture.asset("assets/icons/notification-bing.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
