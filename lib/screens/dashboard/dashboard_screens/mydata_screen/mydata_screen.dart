import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:techysquad/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:techysquad/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:techysquad/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:techysquad/screens/dashboard/dashboard_screens/home_screen/home_widgets/transactions.dart';
import 'package:techysquad/utils/colors.dart';

class MyDataScreen extends StatefulWidget {
  const MyDataScreen({super.key});

  @override
  State<MyDataScreen> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedOption = 'Deposit';
  String _dateRange = 'Jan 02,23 - Feb 28,25';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          const TabTitle(title: 'My Data'),
          SizedBox(height: 20.h),

          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 4.w,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.grey,
            tabs: const [
              Tab(text: 'History'),
              Tab(text: 'Deal Report'),
              Tab(text: 'Insights'),
            ],
          ),

          // TabBarView with fixed height
          SizedBox(
            height: 760.h,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // History Tab
                _buildHistoryTab(),
                // Deal Report Tab
                Center(
                  child: Text(
                    'Deal Report Content',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                ),
                // Insights Tab
                _buildInsightsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radio Button Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRadioOption('Deposit', 'Deposit'),
              SizedBox(width: 40.w),
              _buildRadioOption('Withdrawal', 'Withdrawal'),
            ],
          ),
          SizedBox(height: 30.h),

          // Date Range Picker
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
                        height: 20.w,
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
                      height: 20.w,
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
                  height: 32.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Transactions(),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Stats Cards Row 1
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  title: 'Biggest Profit',
                  value: '\$1200.56',
                  icon: 'assets/icons/green_candle.svg',
                  iconColor: const Color(0xFF9BC547),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatsCard(
                  title: 'Biggest Loss',
                  value: '\$300.10',
                  icon: 'assets/icons/red_candle.svg',
                  iconColor: const Color(0xFFE95E30),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Stats Cards Row 2
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  title: 'Total Deposit',
                  value: '\$5000.00',
                  icon: 'assets/icons/deposit_transaction.svg',
                  iconColor: const Color(0xFF9BC547),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatsCard(
                  title: 'Total Withdraw',
                  value: '\$3000.00',
                  icon: 'assets/icons/withdraw_transaction.svg',
                  iconColor: const Color(0xFFE95E30),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Stats Cards Row 3
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  title: 'Total Trades',
                  value: '12',
                  isIconVisible: false,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatsCard(
                  title: 'Total Volume\nin USD',
                  value: '\$8000.00',
                  isIconVisible: false,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Wins and Losses Chart
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: AppColors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wins and Losses',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      '\$4,000',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last 30 Days',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '+15%',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 150.h,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: ChartPainter(),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '1D',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Text(
                      '1W',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Text(
                      '1M',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Text(
                      '3M',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Text(
                      '1Y',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    String? icon,
    Color iconColor = Colors.grey,
    bool isIconVisible = true,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isIconVisible && icon != null)
            SvgPicture.asset(icon, width: 24.w, height: 24.w, color: iconColor),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String label) {
    final bool isSelected = _selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF9BC547) : Colors.grey,
                width: 2.w,
              ),
            ),
            child:
                isSelected
                    ? const Center(
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(0xFF9BC547),
                      ),
                    )
                    : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Chart Painter
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint =
        Paint()
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Paint fillPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 0;

    // Define the gradient colors
    final List<Color> gradientColors = [
      const Color(0xFFE95E30),
      const Color(0xFFF49D54),
      const Color(0xFFEACA65),
      const Color(0xFF9BC547),
    ];

    // Create path for the line
    final Path path = Path();

    // Sample points for the chart (normalized to 0-1 range)
    final List<Offset> points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.2),
      Offset(size.width, size.height * 0.3),
    ];

    // Move to the first point
    path.moveTo(points[0].dx, points[0].dy);

    // Create a smooth curve through the points
    for (int i = 0; i < points.length - 1; i++) {
      final double controlPointX = (points[i].dx + points[i + 1].dx) / 2;
      path.quadraticBezierTo(
        controlPointX,
        points[i].dy,
        controlPointX,
        (points[i].dy + points[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(
        controlPointX,
        points[i + 1].dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
    }

    // Create a gradient for the line
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    linePaint.shader = gradient.createShader(rect);

    // Draw the line
    canvas.drawPath(path, linePaint);

    // Create a path for the fill area below the line
    final Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Create a gradient for the fill
    final Gradient fillGradient = LinearGradient(
      colors: gradientColors.map((color) => color.withOpacity(0.2)).toList(),
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    fillPaint.shader = fillGradient.createShader(rect);

    // Draw the fill
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
