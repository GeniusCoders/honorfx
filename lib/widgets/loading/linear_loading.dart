import 'package:flutter/material.dart';
import 'package:honorfx/utils/colors.dart';

class LinearLoading extends StatelessWidget {
  final bool isOpacity;

  const LinearLoading({this.isOpacity = false, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: isOpacity ? Colors.white.withOpacity(.6) : Colors.transparent,
      height: MediaQuery.of(context).size.height,
      child: const Column(
        children: [
          SizedBox(
            height: 4.0,
            child: LinearProgressIndicator(backgroundColor: AppColors.black),
          ),
        ],
      ),
    );
  }
}
