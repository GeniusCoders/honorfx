import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const CircularProgressIndicator()
        : CupertinoActivityIndicator(
            radius: 16.sp,
          );
  }
}
