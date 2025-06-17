import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/mt5_to_wallet.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/wallet_history.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/mywallet_screen/wallet_to_mt5.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String walletBalance = '\$0.00';
  String equityBalance = '\$0.00';
  final dashboardController = Get.find<DashboardController>();
  Worker? _accountSelectionWorker;
  Worker? _navigationWorker;
  int? _initialAccountIndex;
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initialAccountIndex = dashboardController.selectedAccountIndex.value;
    _loadDashboardData();
    _setupAccountSelectionListener();
  }

  void _loadDashboardData() {
    context.read<DashboardCubit>().getDashboardData();
  }

  void _setupAccountSelectionListener() {
    _accountSelectionWorker = ever(dashboardController.selectedAccountIndex, (
      _,
    ) {
      _updateEquityBalance();
    });
  }

  void _resetAccountSelection() {
    if (_initialAccountIndex != null) {
      dashboardController.selectedAccountIndex.value = _initialAccountIndex!;
    }

    if (mounted && !_isDisposing) {
      setState(() {
        equityBalance = '\$0.00';
      });
    }
  }

  void _updateEquityBalance() {
    if (!mounted || _isDisposing) return;

    if (dashboardController.accounts.isNotEmpty) {
      final selectedIndex = dashboardController.selectedAccountIndex.value;
      if (selectedIndex >= 0 &&
          selectedIndex < dashboardController.accounts.length) {
        final selectedAccount = dashboardController.accounts[selectedIndex];
        setState(() {
          equityBalance = '\$${selectedAccount.balance ?? '0.00'}';
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupNavigationListener();
  }

  void _setupNavigationListener() {
    _navigationWorker?.dispose();
    _navigationWorker = ever(dashboardController.selectedIndex, (int index) {
      if (index != 3 && mounted && !_isDisposing) {
        _resetAccountSelection();
      }
    });
  }

  @override
  void dispose() {
    _isDisposing = true;
    _tabController.dispose();
    _accountSelectionWorker?.dispose();
    _navigationWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardDataLoaded && mounted && !_isDisposing) {
          setState(() {
            walletBalance = '\$${state.dashboardData.walletBalance ?? '0.00'}';
            _updateEquityBalance();
          });
        }
        if (state is AccountsLoaded) {
          dashboardController.accounts.value = state.accounts;
          _updateEquityBalance();
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DashboardLoading,
          child: SingleChildScrollView(
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildBalanceCard(
                        'Wallet Balance',
                        walletBalance,
                        'assets/icons/wallet.svg',
                        Colors.deepOrange,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildBalanceCard(
                        'Equity Balance',
                        equityBalance,
                        'assets/icons/green_candle.svg',
                        Colors.green,
                      ),
                    ),
                  ],
                ),

                if (state is DashboardDataError)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),

                SizedBox(height: 30.h),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),

                  indicatorWeight: 3.w,
                  dividerColor: AppColors.grey,
                  labelColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Wallet to MT5'),
                    Tab(text: 'MT5 to Wallet'),
                    Tab(text: 'History'),
                  ],
                ),
                SizedBox(height: 30.h),

                SizedBox(
                  height: 500.h,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      WalletToMt5(onAccountSelected: _onAccountSelected),
                      Mt5ToWallet(onAccountSelected: _onAccountSelected),
                      WalletHistory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onAccountSelected(String accountId) {
    if (!mounted || _isDisposing) return;

    final index = dashboardController.accounts.indexWhere(
      (account) => account.mtUserid.toString() == accountId,
    );

    if (index != -1) {
      dashboardController.selectedAccountIndex.value = index;
    }
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
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            height: 24.h,
            width: 24.w,
            color: iconColor,
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
