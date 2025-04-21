import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/home_screen/home_screen.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mydata_screen/mydata_screen.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/myfund_screen/myfund_screen.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/mywallet_screen.dart';
import 'package:honorfx/widgets/app_drawer.dart';
import 'package:honorfx/widgets/gradient_background.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyFundScreen(),
    const MyDataScreen(),
    const MyWalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        drawer: const AppDrawer(),
        body: SafeArea(child: _screens[_selectedIndex]),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
          ),
          margin: EdgeInsets.all(20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, 'assets/images/dashboard.png', 'Dashboard'),
              _buildNavItem(1, 'assets/images/myfund.png', 'My Fund'),
              _buildNavItem(2, 'assets/images/mydata.png', 'My Data'),
              _buildNavItem(3, 'assets/images/mywallet.png', 'My Wallet'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C2C2C) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 40.w, height: 40.w),
            if (isSelected)
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 10.h, 15.w, 10.h),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
