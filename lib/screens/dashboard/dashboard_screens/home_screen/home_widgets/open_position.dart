import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techysquad/utils/colors.dart';

class OpenPosition extends StatelessWidget {
  const OpenPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: demoPositions.length,
        itemBuilder: (context, index) {
          final position = demoPositions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PositionCard(position: position),
          );
        },
      ),
    );
  }
}

class PositionCard extends StatelessWidget {
  final PositionData position;

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
                  position.currencyPair,
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
                    position.isBuy ? "Buy" : "Sell",
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
              _buildTableCell("Profit / Loss", position.profitLoss),

              // Buy Price
              _buildTableCell("Buy Price", position.buyPrice),

              // Current Price
              _buildTableCell("Current Price", position.currentPrice),

              // Volume
              _buildTableCell("Volume", position.volume),

              // Date & Time
              SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.date,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF8A8A8A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      position.time,
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
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for position data
class PositionData {
  final String currencyPair;
  final bool isBuy;
  final String profitLoss;
  final String buyPrice;
  final String currentPrice;
  final String volume;
  final String date;
  final String time;

  PositionData({
    required this.currencyPair,
    required this.isBuy,
    required this.profitLoss,
    required this.buyPrice,
    required this.currentPrice,
    required this.volume,
    required this.date,
    required this.time,
  });
}

// Sample data
final List<PositionData> demoPositions = [
  PositionData(
    currencyPair: "USD/EUR",
    isBuy: false,
    profitLoss: "\$20",
    buyPrice: "2066",
    currentPrice: "2066",
    volume: "1.5 Lot",
    date: "02/01/2025",
    time: "14:32",
  ),
  PositionData(
    currencyPair: "XAU/USD",
    isBuy: true,
    profitLoss: "\$20",
    buyPrice: "2066",
    currentPrice: "2066",
    volume: "1.5 Lot",
    date: "02/01/2025",
    time: "14:32",
  ),
  PositionData(
    currencyPair: "USD/EUR",
    isBuy: false,
    profitLoss: "\$20",
    buyPrice: "2066",
    currentPrice: "2066",
    volume: "1.5 Lot",
    date: "02/01/2025",
    time: "14:32",
  ),
  PositionData(
    currencyPair: "XAU/USD",
    isBuy: true,
    profitLoss: "\$20",
    buyPrice: "2066",
    currentPrice: "2066",
    volume: "1.5 Lot",
    date: "02/01/2025",
    time: "14:32",
  ),
];
