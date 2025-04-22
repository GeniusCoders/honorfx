import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when the screen is opened
    _loadDashboardData();
  }

  void _loadDashboardData() {
    // Load accounts data
    context.read<DashboardCubit>().getAccounts();

    // Add other dashboard data loading here
    // context.read<DashboardCubit>().getOpenPositions();
    // context.read<DashboardCubit>().getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadDashboardData();
      },
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.r),
                  ),
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
                              SizedBox(width: 4.w),
                              SvgPicture.asset(
                                "assets/icons/trade-button.svg",
                                height: 46.h,
                              ),
                              SizedBox(width: 4.w),
                              Image.asset(
                                "assets/images/deposit-button.png",
                                height: 46.h,
                              ),
                              SizedBox(width: 4.w),
                              SvgPicture.asset(
                                "assets/icons/withdraw-button.svg",
                                height: 46.h,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: SvgPicture.asset(
                            "assets/images/left-shape.svg",
                            height: 50.h,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: SvgPicture.asset(
                            "assets/images/right-shape.svg",
                            height: 50.h,
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
                          bottom: BorderSide(
                            color: Color(0xFFDFDFDF),
                            width: 0.8,
                          ),
                          left: BorderSide(
                            color: Color(0xFFDFDFDF),
                            width: 0.8,
                          ),
                          right: BorderSide(
                            color: Color(0xFFDFDFDF),
                            width: 0.8,
                          ),
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
                            state is AccountDetailsLoaded
                                ? "${state.accountDetails.currency ?? '\$'}${state.accountDetails.balance ?? '0.00'}"
                                : state is AccountsLoaded &&
                                    state.accounts.isNotEmpty &&
                                    state.selectedAccountIndex != null
                                ? "\$${state.accounts[state.selectedAccountIndex!].balance ?? '0.00'}"
                                : "\$0.00",
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
                SizedBox(
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
        },
      ),
    );
  }
}
