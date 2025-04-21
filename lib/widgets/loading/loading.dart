import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/colors.dart';

import 'loading_widget/loading_widget.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      color: AppColors.black.withOpacity(.3),
      child: const Center(child: Loader()),
    );
  }
}

class LoadingFull extends StatelessWidget {
  const LoadingFull({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: const Center(child: Loader()),
      ),
    );
  }
}

class SmallLoading extends StatelessWidget {
  const SmallLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.h),
      child: const Center(child: Loader()),
    );
  }
}
