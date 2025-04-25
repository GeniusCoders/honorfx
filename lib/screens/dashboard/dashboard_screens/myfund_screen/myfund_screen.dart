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
          // Fixed height header section
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
          // Top Tab Bar (Deposit/Withdrawal)
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1.h),
              ),
            ),
            child: TabBar(
              controller: _topTabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3.h,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [Tab(text: 'Deposit'), Tab(text: 'Withdrawal')],
            ),
          ),
          // First TabBarView with fixed height
          SizedBox(
            height: 560.h,
            child: TabBarView(
              controller: _topTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Deposit Tab
                const DepositWidget(),
                // Withdrawal Tab
                _buildWithdrawalTab(),
              ],
            ),
          ),
          // Bottom Tab Bar (Internal Transfer/Recent Transactions)
          TabBar(
            controller: _bottomTabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3.h,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Internal Transfer'),
              Tab(text: 'Recent Transactions'),
            ],
            dividerColor: Colors.transparent,
          ),
          // Second TabBarView with fixed height
          SizedBox(
            height: 300.h,
            child: TabBarView(
              controller: _bottomTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Internal Transfer Tab
                const InternalTransferWidget(),
                // Recent Transactions Tab
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
