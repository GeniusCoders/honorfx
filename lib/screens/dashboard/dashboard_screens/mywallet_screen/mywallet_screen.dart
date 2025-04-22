import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _horizontalScrollController = ScrollController();
  static String _dateRange = 'Jan 02,23 - Feb 28,25';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

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
                  '\$1200.56',
                  'assets/icons/wallet.svg',
                  Colors.deepOrange,
                ),
              ),
              SizedBox(width: 12.w),
              // Equity Balance Card
              Expanded(
                child: _buildBalanceCard(
                  'Equity Balance',
                  '\$1000.16',
                  'assets/icons/green_candle.svg',
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFFEEEEEE), width: 2.w),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              indicatorWeight: 3.w,
              dividerColor: AppColors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [Tab(text: 'Wallet Transfer'), Tab(text: 'History')],
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
                _buildWalletTransferTab(),

                // History Tab
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildWalletTransferTab() {
    return Column(
      children: [
        // From wallet dropdown
        CommonDropdown(hintText: 'Select Wallet', onChanged: (value) {}),

        // Transfer direction icon
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/icons/arrange-circle.svg"),
        ),

        // To MT5 account dropdown
        CommonDropdown(hintText: 'Select MT5 Account', onChanged: (value) {}),

        SizedBox(height: 30.h),

        // Amount field
        _buildInputField(
          label: 'Amount*',
          hintText: 'Amount',
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: 20.h),

        // Note field
        _buildInputField(label: 'Note*', hintText: 'Note', maxLines: 3),

        SizedBox(height: 28.h),

        // Submit button
        SubmitButton(),
      ],
    );
  }

  Widget _buildHistoryTab() {
    // Sample transaction data
    final List<Map<String, dynamic>> transactions = [
      {
        'date': 'Jan 21 2025',
        'id': '#12345378',
        'method': 'MT5',
        'deposit': '74648845',
        'amount': '\$500.00',
      },
      {
        'date': 'Jan 10 2025',
        'id': '#2567888',
        'method': 'Wallet',
        'deposit': '74648845',
        'amount': '\$100.00',
      },
      {
        'date': 'Jan 05 2025',
        'id': '#2536378',
        'method': 'Wallet',
        'deposit': '74648845',
        'amount': '\$100.00',
      },
      {
        'date': 'Jan 01 2025',
        'id': '#12343678',
        'method': 'MT5',
        'deposit': '74648845',
        'amount': '\$500.00',
      },
      {
        'date': 'Dec 21 2024',
        'id': '#24345378',
        'method': 'Wallet',
        'deposit': '74648845',
        'amount': '\$500.00',
      },
      {
        'date': 'Nov 25 2024',
        'id': '#12457378',
        'method': 'MT5',
        'deposit': '74648845',
        'amount': '\$500.00',
      },
      {
        'date': 'Sep 19 2025',
        'id': '#11255378',
        'method': 'MT5',
        'deposit': '74648845',
        'amount': '\$500.00',
      },
    ];

    // Pagination state
    int currentPage = 1;
    int totalPages = (transactions.length / 4).ceil();
    int startIndex = (currentPage - 1) * 4;
    int endIndex =
        startIndex + 4 > transactions.length
            ? transactions.length
            : startIndex + 4;
    var displayedTransactions = transactions.sublist(startIndex, endIndex);

    // Define a minimum width for the table to ensure it's scrollable
    const double tableMinWidth = 600;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    _dateRange,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SvgPicture.asset(
                    'assets/icons/arrow-circle-down.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: SvgPicture.asset(
                'assets/icons/upload_one.svg',
                width: 32.w,
                height: 32.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: AppColors.grey),
          ),
          child: Column(
            children: [
              // Single scroll view for both header and content
              SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(minWidth: tableMinWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table header
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFEEEEEE),
                              width: 1.w,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 12.w,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120.w,
                              child: Text(
                                'ID',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                'Method',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                'To Deposit',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                              child: Text(
                                'Amount',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Table rows - only vertical scrolling here
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children:
                              displayedTransactions
                                  .map(
                                    (transaction) =>
                                        _buildTransactionRow(transaction),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pagination
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: const Color(0xFFEEEEEE), width: 1.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Entries count
                    Text(
                      'Showing 1 to ${endIndex - startIndex} of ${transactions.length} entries',
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 12.sp,
                      ),
                    ),

                    // Pagination controls
                    Row(
                      children: [
                        // Previous page button
                        Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.lightGrey),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.chevron_left,
                              size: 16.w,
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ),

                        // Page indicator
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            '1 of 2',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Next page button
                        Container(
                          width: 24.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.lightGrey),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.chevron_right,
                              size: 16.w,
                              color: AppColors.lightGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> transaction) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFEEEEEE), width: 1.w),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              transaction['date'],
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 120.w,
            child: Text(
              transaction['id'],
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              transaction['method'],
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 120.w,
            child: Text(
              transaction['deposit'],
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              transaction['amount'],
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: AppColors.grey),
            ),
            child: Row(
              children: [
                Text(
                  '$hintText*',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return CommanTexfield(hintText: hintText);
  }
}
