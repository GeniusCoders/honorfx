import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' as getcontroller;
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/auth/auth_cubit.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';

// Data class for submenu items
class SubMenuItem {
  final String title;
  final VoidCallback onTap;

  SubMenuItem({required this.title, required this.onTap});
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            'assets/images/DP.png',
                            width: 42.w,
                            height: 42.h,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/setting.svg',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: IconButton(
                        onPressed: () {
                          Scaffold.of(context).closeDrawer();
                        },
                        icon: SvgPicture.asset('assets/icons/close-square.svg'),
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: 'assets/images/dashboard-v2.png',
                    title: 'Dashboard',
                    isSelected: dashboardController.selectedIndex == 0,
                    isPng: true,
                    onTap: () {
                      dashboardController.updateSelectedIndex(0);
                      Navigator.pop(context);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: 'assets/icons/regulations.svg',
                    title: 'Regulations',
                  ),
                  _buildMenuItem(
                    context,
                    icon: 'assets/icons/my_fund.svg',
                    title: 'My Fund',
                    isSelected: dashboardController.selectedIndex == 1,
                    onTap: () {
                      dashboardController.updateSelectedIndex(1);
                      Navigator.pop(context);
                    },
                  ),
                  _buildExpandableMenuItem(
                    context,
                    icon: 'assets/icons/ib_program.svg',
                    title: 'IB Programme',
                    hasNotification: true,
                    subMenuItems: [
                      SubMenuItem(
                        title: 'IB Dashboard',
                        onTap: () {
                          Navigator.pop(context);
                          getIt<AppRouter>().goToIbDashboard();
                        },
                      ),
                      SubMenuItem(
                        title: 'Withdraw Report',
                        onTap: () {
                          Navigator.pop(context);
                          getIt<AppRouter>().goToTeamWithdrawReport();
                        },
                      ),
                      SubMenuItem(
                        title: 'My Clients',
                        onTap: () {
                          Navigator.pop(context);
                          getIt<AppRouter>().goToMyClients();
                        },
                      ),
                    ],
                  ),
                  _buildMenuItem(
                    context,
                    icon: 'assets/icons/my_data.svg',
                    title: 'My Data',
                    isSelected: dashboardController.selectedIndex == 2,
                    onTap: () {
                      dashboardController.updateSelectedIndex(2);
                      Navigator.pop(context);
                    },
                  ),

                  _buildMenuItem(
                    context,
                    icon: 'assets/icons/my_wallet.svg',
                    title: 'My Wallet',
                    isSelected: dashboardController.selectedIndex == 3,
                    onTap: () {
                      dashboardController.updateSelectedIndex(3);
                      Navigator.pop(context);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: 'assets/icons/news.svg',
                    title: 'News',
                  ),
                  _buildMenuItem(
                    context,
                    icon: 'assets/icons/support.svg',
                    title: 'Support',
                    onTap: () {
                      getIt<AppRouter>().goToSupport();
                    },
                  ),
                ],
              ),

              // Account Manager Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/DP.png',
                              width: 36.w,
                              height: 36.h,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Assigned Manager',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Jignesh Patel',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greyBackground,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/sms.svg',
                                    width: 20.w,
                                    height: 20.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Get in touch',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Referral Link Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Copy your Referral Link!',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Click Here',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Logout Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: GestureDetector(
                  onTap: () {
                    getIt<AuthCubit>().logout();
                    getcontroller.Get.delete<DashboardController>();
                    getIt<AppRouter>().goToLogin();
                  },
                  child: IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/logout.svg',
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    bool isSelected = false,
    bool hasNotification = false,
    bool isPng = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: isSelected ? AppColors.greyBackground : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isPng ? Colors.transparent : AppColors.greyBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:
                isPng
                    ? Image.asset(icon)
                    : SvgPicture.asset(icon, width: 20.w, height: 20.h),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        trailing:
            hasNotification
                ? Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 16.w),
                )
                : isSelected
                ? Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                )
                : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    bool hasNotification = false,
    required List<SubMenuItem> subMenuItems,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            expansionTileTheme: const ExpansionTileThemeData(
              iconColor: AppColors.black,
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.zero,
              expandedAlignment: Alignment.centerLeft,
              collapsedIconColor: AppColors.black,
              iconColor: AppColors.black,
              title: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: SvgPicture.asset(icon, width: 20.w, height: 20.h),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 16.w),
              ),
              children:
                  subMenuItems.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Container(
                        margin: EdgeInsets.only(left: 0.w),
                        padding: EdgeInsets.only(left: 56.w),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(vertical: -3),
                          minLeadingWidth: 0,
                          minVerticalPadding: 0,
                          title: Text(
                            item.title,
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          onTap: item.onTap,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
