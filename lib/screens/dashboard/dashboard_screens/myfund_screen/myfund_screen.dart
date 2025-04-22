import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_widgets/transactions.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';

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
              indicatorColor: const Color(0xFF9BC547),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildDepositTab(),
                ),
                // Withdrawal Tab
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildWithdrawalTab(),
                ),
              ],
            ),
          ),
          // Bottom Tab Bar (Internal Transfer/Recent Transactions)
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1.h),
                bottom: BorderSide(color: Colors.grey.shade200, width: 1.h),
              ),
            ),
            child: TabBar(
              controller: _bottomTabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3.h,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Internal Transfer'),
                Tab(text: 'Recent Transactions'),
              ],
              dividerColor: Colors.transparent,
            ),
          ),
          // Second TabBarView with fixed height
          SizedBox(
            height: 300.h,
            child: TabBarView(
              controller: _bottomTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Internal Transfer Tab
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildInternalTransferTab(),
                ),
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

  Widget _buildDepositTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        // Payment Methods
        SizedBox(
          height: 40.h,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 15.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Bank Transfer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.money),
                    SizedBox(width: 10.w),
                    Text(
                      'Cash',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/visa.png',
                      width: 30,
                      height: 16,
                    ),
                    SizedBox(width: 5.w),
                    Image.asset(
                      'assets/images/mastercard.png',
                      width: 30,
                      height: 16,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Bank Card',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25.h),
        Divider(height: 1.h, color: AppColors.grey),
        SizedBox(height: 25.h),
        // Bank Transfers Section
        Center(
          child: Text(
            'Bank Transfers',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 25.h),
        // Form Fields
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Select Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CommanTexfield(hintText: 'Select Account'),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CommanTexfield(hintText: 'Amount'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Transaction ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CommanTexfield(hintText: 'Transaction ID'),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Note',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),

                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CommanTexfield(hintText: 'Note'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Upload Deposit Receipt',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/upload.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Upload a document',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        SubmitButton(),
      ],
    );
  }

  Widget _buildWithdrawalTab() {
    return Center(
      child: Text(
        'Withdrawal Feature Coming Soon',
        style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildInternalTransferTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        // Internal Transfer Form
        Row(
          children: [
            Expanded(
              child: CommonDropdown(
                hintText: 'From Account',
                onChanged: (value) {},
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CommonDropdown(
                hintText: 'To Account',
                onChanged: (value) {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: CommanTexfield(hintText: 'Amount')),
            SizedBox(width: 10.w),
            SubmitButton(),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRecentTransactionsTab() {
    return Transactions();
  }
}
