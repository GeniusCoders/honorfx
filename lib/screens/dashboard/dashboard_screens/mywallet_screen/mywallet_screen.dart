import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/mt5_to_wallet.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/wallet_history.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/wallet_to_mt5.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String walletBalance = '\$0.00';
  String equityBalance = '\$0.00';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Fetch dashboard data when the screen loads
    _loadDashboardData();
  }

  void _loadDashboardData() {
    context.read<DashboardCubit>().getDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardDataLoaded) {
          setState(() {
            // Update the wallet balance from API
            walletBalance = '\$${state.dashboardData.walletBalance ?? '0.00'}';

            // Equity balance could come from the account details,
            // but for now we'll just keep the placeholder
            equityBalance = '\$1000.16';
          });
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DashboardLoading,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommanAppbar(),
                SizedBox(height: 20.h),
                const UserName(),
                SizedBox(height: 30.h),
                const TabTitle(title: 'My Wallet'),
                SizedBox(height: 20.h),

                // Balance Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Wallet Balance Card
                    Expanded(
                      child: _buildBalanceCard(
                        'Wallet Balance',
                        walletBalance,
                        'assets/icons/wallet.svg',
                        Colors.deepOrange,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Equity Balance Card
                    Expanded(
                      child: _buildBalanceCard(
                        'Equity Balance',
                        equityBalance,
                        'assets/icons/green_candle.svg',
                        Colors.green,
                      ),
                    ),
                  ],
                ),

                // Error message
                if (state is DashboardDataError)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),

                SizedBox(height: 30.h),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFEEEEEE),
                        width: 2.w,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorWeight: 3.w,
                    dividerColor: AppColors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Wallet to MT5'),
                      Tab(text: 'MT5 to Wallet'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // Tab Content
                SizedBox(
                  height: 500.h,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Wallet Transfer Tab
                      const WalletToMt5(),
                      const Mt5ToWallet(),

                      // History Tab
                      WalletHistory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(
    String title,
    String amount,
    String iconAsset,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          SvgPicture.asset(
            iconAsset,
            height: 24.h,
            width: 24.w,
            color: iconColor,
          ),
          SizedBox(height: 12.h),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          // Amount
          Text(
            amount,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
