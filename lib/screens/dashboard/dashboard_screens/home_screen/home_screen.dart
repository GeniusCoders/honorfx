import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/account_balance.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/account_balance_details.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/account_list.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/open_account_button.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/open_position.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/transactions.dart';
import 'package:honorfx/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommanAppbar(),
          SizedBox(height: 20.h),
          const UserName(),
          SizedBox(height: 30.h),
          TabTitle(title: 'My Accounts'),
          SizedBox(height: 20.h),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.r)),
            child: Row(
              children: [AccountBalance(), Spacer(), OpenAccountButton()],
            ),
          ),
          SizedBox(height: 30.h),
          Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/trade-button.svg",
                          height: 52.h,
                        ),
                        SizedBox(width: 4.w),
                        Image.asset(
                          "assets/images/deposit-button.png",
                          height: 52.h,
                        ),
                        SizedBox(width: 4.w),
                        SvgPicture.asset(
                          "assets/icons/withdraw-button.svg",
                          height: 52.h,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: SvgPicture.asset(
                      "assets/images/left-shape.svg",
                      height: 57.h,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: SvgPicture.asset(
                      "assets/images/right-shape.svg",
                      height: 57.h,
                    ),
                  ),
                ],
              ),
              Container(
                height: 160.h,
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14.r),
                    bottomRight: Radius.circular(14.r),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFDFDFDF), width: 0.8),

                    left: BorderSide(color: Color(0xFFDFDFDF), width: 0.8),

                    right: BorderSide(color: Color(0xFFDFDFDF), width: 0.8),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "MCN",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        VerticalDivider(
                          color: Color(0xFFDFDFDF),
                          thickness: 0.8,
                        ),
                        Text(
                          "ECN",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        VerticalDivider(
                          color: Color(0xFFDFDFDF),
                          thickness: 0.8,
                        ),
                        Text(
                          "REAL",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "\$1000",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30.sp,
                      ),
                    ),
                    AccountBalanceDetails(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          AccountList(),
          SizedBox(height: 20.h),
          Container(
            height: 400.h,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    dividerColor: AppColors.primary,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                      color: AppColors.black,
                    ),
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),

                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: "Open Positions"),
                      Tab(text: "Transactions"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [OpenPosition(), Transactions()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
