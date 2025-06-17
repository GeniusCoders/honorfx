import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/deposit_transactions.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/myfund_screen/myfund_widget/deposit_widget.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/myfund_screen/myfund_widget/internal_transfer_widget.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/myfund_screen/myfund_widget/withdraw_widget.dart';
import 'package:honorfx/utils/colors.dart';

class MyFundScreen extends StatefulWidget {
  const MyFundScreen({super.key});

  @override
  State<MyFundScreen> createState() => _MyFundScreenState();
}

class _MyFundScreenState extends State<MyFundScreen>
    with TickerProviderStateMixin {
  late TabController _topTabController;
  late TabController _bottomTabController;

  @override
  void initState() {
    super.initState();
    _topTabController = TabController(length: 2, vsync: this);
    _bottomTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _topTabController.dispose();
    _bottomTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommanAppbar(),
                SizedBox(height: 12.h),
                const UserName(),
                SizedBox(height: 16.h),
                const TabTitle(title: 'Deposit & Withdrawal'),
                SizedBox(height: 12.h),
              ],
            ),
          ),
          TabBar(
            controller: _topTabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3.h,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.primary,
            tabs: const [Tab(text: 'Deposit'), Tab(text: 'Withdrawal')],
          ),
          SizedBox(
            height: 560.h,
            child: TabBarView(
              controller: _topTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [const DepositWidget(), _buildWithdrawalTab()],
            ),
          ),
          TabBar(
            controller: _bottomTabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3.h,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.grey,
            labelColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Internal Transfer'),
              Tab(text: 'Recent Transactions'),
            ],
            dividerColor: Colors.transparent,
          ),
          SizedBox(
            height: 300.h,
            child: TabBarView(
              controller: _bottomTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const InternalTransferWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildRecentTransactionsTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalTab() {
    return const WithdrawWidget();
  }

  Widget _buildRecentTransactionsTab() {
    return DepositTransactions();
  }
}
