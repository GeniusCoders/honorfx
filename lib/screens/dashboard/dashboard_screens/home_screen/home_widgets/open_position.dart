import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/reports_cubit/reports_cubit.dart';
import 'package:honorfx/models/dashboard/open_positions_model.dart';
import 'package:honorfx/utils/colors.dart';

class OpenPosition extends StatefulWidget {
  const OpenPosition({super.key});

  @override
  State<OpenPosition> createState() => _OpenPositionState();
}

class _OpenPositionState extends State<OpenPosition> {
  @override
  void initState() {
    super.initState();
    // Fetch open positions data
    context.read<ReportsCubit>().getOpenPositions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReportsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.secondary, size: 40),
                SizedBox(height: 16),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<ReportsCubit>().getOpenPositions(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is OpenPositionsReportLoaded) {
          if (state.data.isEmpty) {
            return Center(
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
                    'No open positions found',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final position = state.data[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PositionCard(position: position),
                );
              },
            ),
          );
        }

        // Default state - loading
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class PositionCard extends StatelessWidget {
  final OpenPositionData position;

  const PositionCard({super.key, required this.position});

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
              // Currency pair
              SizedBox(
                width: 88.w,
                child: Text(
                  position.symbol ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Buy/Sell Badge
              SizedBox(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: position.isBuy ? AppColors.primary : AppColors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    position.actionType,
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

              // Profit/Loss
              _buildTableCell("Profit / Loss", position.formattedProfit),

              // Buy Price
              _buildTableCell("Open Price", position.formattedOpenPrice),

              // Current Price
              _buildTableCell("Current Price", position.formattedCurrentPrice),

              // Volume
              _buildTableCell("Volume", position.formattedVolume),

              // Date & Time
              SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.dateString,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      position.timeString,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Close Button
              SizedBox(
                width: 70.w,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(60, 30),
                  ),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
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
                  label == "Profit / Loss"
                      ? (value.contains("+")
                          ? Colors.green
                          : value.contains("-")
                          ? Colors.red
                          : Colors.black)
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
