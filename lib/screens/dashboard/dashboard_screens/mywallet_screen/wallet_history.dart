import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/wallet_history_response.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:intl/intl.dart';

class WalletHistory extends StatefulWidget {
  const WalletHistory({super.key});

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  static const String _dateRange = 'Jan 02,23 - Feb 28,25';
  final ScrollController _horizontalScrollController = ScrollController();

  // Pagination state
  int currentPage = 1;
  int itemsPerPage = 4;
  double tableMinWidth = 600;
  List<WalletHistoryData> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadWalletHistory();
  }

  void _loadWalletHistory() {
    context.read<DashboardCubit>().getWalletHistory();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  int get totalPages => (transactions.length / itemsPerPage).ceil();

  List<WalletHistoryData> get displayedTransactions {
    final int startIndex = (currentPage - 1) * itemsPerPage;
    final int endIndex =
        startIndex + itemsPerPage > transactions.length
            ? transactions.length
            : startIndex + itemsPerPage;

    if (transactions.isEmpty) return [];
    return transactions.sublist(startIndex, endIndex);
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('MMM dd yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is WalletHistoryLoaded) {
          setState(() {
            transactions = state.transactions;
            currentPage = 1; // Reset to first page when new data is loaded
          });
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DashboardLoading,
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.symmetric(
              //         vertical: 10.h,
              //         horizontal: 10.w,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(7.r),
              //       ),
              //       child: Row(
              //         children: [
              //           Container(
              //             padding: EdgeInsets.all(8.w),
              //             decoration: BoxDecoration(
              //               color: const Color(0xFFEEEEEE),
              //               shape: BoxShape.circle,
              //             ),
              //             child: SvgPicture.asset(
              //               'assets/icons/calendar.svg',
              //               width: 20.w,
              //               height: 20.h,
              //             ),
              //           ),
              //           SizedBox(width: 15.w),
              //           Text(
              //             _dateRange,
              //             style: TextStyle(
              //               fontSize: 14.sp,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //           SizedBox(width: 10.w),
              //           SvgPicture.asset(
              //             'assets/icons/arrow-circle-down.svg',
              //             width: 20.w,
              //             height: 20.h,
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 15.w),
              //     Container(
              //       padding: EdgeInsets.all(10.w),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(7.r),
              //       ),
              //       child: SvgPicture.asset(
              //         'assets/icons/upload_one.svg',
              //         width: 32.w,
              //         height: 32.h,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 30.h),
              if (state is WalletHistoryError)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ),
              if (transactions.isEmpty &&
                  !(state is DashboardLoading) &&
                  !(state is WalletHistoryError))
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Text(
                    'No transaction history found',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                ),
              if (transactions.isNotEmpty)
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
                                        'To Account',
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
                                        'Note',
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

                              // Table rows
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children:
                                      displayedTransactions
                                          .map(
                                            (transaction) =>
                                                _buildTransactionRow(
                                                  transaction,
                                                ),
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
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 12.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xFFEEEEEE),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Entries count
                            Text(
                              'Showing ${(currentPage - 1) * itemsPerPage + 1} to ${(currentPage - 1) * itemsPerPage + displayedTransactions.length} of ${transactions.length} entries',
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionRow(WalletHistoryData transaction) {
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
              _formatDate(transaction.date),
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              transaction.method ?? '',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              transaction.todeposit ?? '',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              transaction.note ?? '',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              '\$${transaction.amount ?? '0.00'}',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
