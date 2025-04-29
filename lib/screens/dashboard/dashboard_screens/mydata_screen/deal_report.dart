import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/deal_report_response.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';

class DealReport extends StatefulWidget {
  const DealReport({super.key});

  @override
  State<DealReport> createState() => _DealReportState();
}

class _DealReportState extends State<DealReport> {
  String? _selectedMt5Account;
  List<AccountListingTypeData> _accounts = [];
  List<DealReportData> _deals = [];
  final dashboardController = Get.find<DashboardController>();
  // Pagination state
  int currentPage = 1;
  int itemsPerPage = 6;

  // Date range - for now fixed as mentioned in requirements
  String fromDate = '03/29/2025';
  String toDate = '04/28/2025';

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    _accounts = dashboardController.accounts;
    if (_accounts.isNotEmpty) {
      _selectedMt5Account = _accounts.first.mtUserid.toString();
      _fetchDealReport();
    }
  }

  void _fetchDealReport() {
    if (_selectedMt5Account != null) {
      context.read<DashboardCubit>().getDealReport(
        mt5id: _selectedMt5Account!,
        from: fromDate,
        to: toDate,
      );
    }
  }

  int get totalPages => (_deals.length / itemsPerPage).ceil();

  List<DealReportData> get displayedDeals {
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex =
        startIndex + itemsPerPage > _deals.length
            ? _deals.length
            : startIndex + itemsPerPage;

    if (_deals.isEmpty) return [];
    return _deals.sublist(startIndex, endIndex);
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  void _nextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DealReportLoaded) {
          setState(() {
            _deals = state.deals;
            currentPage = 1; // Reset to first page when new data is loaded
          });
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DashboardLoading,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account selection
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: CommonDropdown(
                    hintText: 'Select MT5 Account',
                    value: _selectedMt5Account,
                    onChanged: (value) {
                      setState(() {
                        _selectedMt5Account = value;
                        _fetchDealReport();
                      });
                    },
                    data: _accounts.map((e) => e.mtUserid.toString()).toList(),
                  ),
                ),

                // Date range display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 10.w,
                      ),
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
                            '$fromDate - $toDate',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Error message
                if (state is DealReportError)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),

                // Empty state
                if (_deals.isEmpty &&
                    state is! DashboardLoading &&
                    state is! DealReportError)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_outlined,
                            color: Colors.grey.shade400,
                            size: 40,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No deal history found',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Deal report cards
                if (_deals.isNotEmpty)
                  RefreshIndicator(
                    onRefresh: () async {
                      _fetchDealReport();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          // Deal cards
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: displayedDeals.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final deal = displayedDeals[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child:
                                    deal.action == 0 || deal.action == 1
                                        ? DealCard(deal: deal)
                                        : Container(),
                              );
                            },
                          ),

                          // Pagination
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Entries count
                                Text(
                                  'Showing ${(currentPage - 1) * itemsPerPage + 1} to ${(currentPage - 1) * itemsPerPage + displayedDeals.length} of ${_deals.length} entries',
                                  style: TextStyle(
                                    color: AppColors.lightGrey,
                                    fontSize: 12.sp,
                                  ),
                                ),

                                // Pagination controls
                                Row(
                                  children: [
                                    // Previous page button
                                    GestureDetector(
                                      onTap: _previousPage,
                                      child: Container(
                                        width: 24.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.chevron_left,
                                            size: 16.w,
                                            color: AppColors.lightGrey,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Page indicator
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      child: Text(
                                        '$currentPage of $totalPages',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // Next page button
                                    GestureDetector(
                                      onTap: _nextPage,
                                      child: Container(
                                        width: 24.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.chevron_right,
                                            size: 16.w,
                                            color: AppColors.lightGrey,
                                          ),
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
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DealCard extends StatelessWidget {
  final DealReportData deal;

  const DealCard({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Deal ID
              Text(
                '#${deal.deal ?? 0}',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10.w),
              // Deal type badge
              SizedBox(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(deal.action),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    deal.getDealType(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Symbol
              _buildTableCell("Symbol", deal.symbol ?? 'Unknown'),

              // Price
              _buildTableCell("Price", deal.formattedCurrentPrice),

              // Profit
              _buildTableCell("Profit", _formatProfit(deal.profit)),

              // Date & Time
              SizedBox(
                width: 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      deal.getFormattedTime(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Comment (if available)
              if (deal.comment != null && deal.comment!.isNotEmpty)
                _buildTableCell("Comment", deal.comment!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String label, String value) {
    return SizedBox(
      width: 90.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(0xFF8A8A8A),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color:
                  label == "Profit"
                      ? (value.contains("+") || value.contains("-")
                          ? (value.contains("+") || !value.contains("-")
                              ? Colors.green
                              : Colors.red)
                          : Colors.black)
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatProfit(double? profit) {
    if (profit == null) return '0.00';
    final sign = profit >= 0 ? '+' : '';
    return '$sign${profit.toStringAsFixed(2)}';
  }

  Color _getTypeColor(int? action) {
    switch (action) {
      case 0: // Buy
        return Colors.green;
      case 1: // Sell
        return Colors.red;
      case 2: // Balance
      case 3: // Credit
      case 6: // Bonus
        return Colors.blue;
      case 4: // Charge
      case 5: // Correction
      case 7: // Commission
      case 8: // Commission Daily
      case 9: // Commission Monthly
      case 17: // Tax
        return Colors.orange;
      case 13: // Buy Canceled
      case 14: // Sell Canceled
        return Colors.grey;
      case 12: // Interest
      case 15: // Dividend
      case 16: // Dividend Franked
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }
}
