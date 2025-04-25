import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';
import 'package:honorfx/widgets/textfields/amount_texfield.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';

class WithdrawWidget extends StatefulWidget {
  const WithdrawWidget({super.key});

  @override
  State<WithdrawWidget> createState() => _WithdrawWidgetState();
}

class _WithdrawWidgetState extends State<WithdrawWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedAccount;
  List<AccountListingTypeData> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _loadAccounts() {
    final dashboardCubit = context.read<DashboardCubit>();
    if (dashboardCubit.state is! AccountsLoaded &&
        dashboardCubit.state is! AccountDetailsLoaded) {
      dashboardCubit.getAccounts();
    } else {
      _setupAccounts(dashboardCubit.state);
    }
  }

  void _setupAccounts(DashboardState state) {
    if (state is AccountsLoaded) {
      setState(() {
        _accounts = state.accounts;
        if (_accounts.isNotEmpty) {
          _selectedAccount = _accounts.first.mtUserid.toString();
        }
      });
    } else if (state is AccountDetailsLoaded) {
      setState(() {
        _accounts = state.accounts;
        if (_accounts.isNotEmpty) {
          _selectedAccount = _accounts.first.mtUserid.toString();
        }
      });
    }
  }

  void _submitWithdrawal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = _amountController.text.trim();

    // Call the withdraw method
    final dashboardCubit = context.read<DashboardCubit>();
    dashboardCubit.withdraw(
      mt5id: _selectedAccount!,
      withdrawTo: 'cash',
      amount: amount,
      note: _noteController.text.trim(),
      paymentMethod: 'cash',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is AccountsLoaded || state is AccountDetailsLoaded) {
          _setupAccounts(state);
        }

        if (state is WithdrawSuccess) {
          _amountController.clear();
          _noteController.clear();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(buildSnackBar(message: state.message, isError: false));
        }

        if (state is WithdrawError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(buildSnackBar(message: state.message, isError: true));
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DashboardLoading,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.money, color: AppColors.white, size: 15.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'Cash',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Account Selection
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommonDropdown(
                    hintText: 'Select Account',
                    value: _selectedAccount,
                    data: _accounts.map((e) => e.mtUserid.toString()).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAccount = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Amount
                  Text(
                    'Amount*',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AmountTexfield(
                    hintText: 'Enter amount',
                    controller: _amountController,
                  ),
                  SizedBox(height: 16.h),

                  // Note
                  Text(
                    'Note*',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CommanTexfield(
                    hintText: 'Enter note',
                    controller: _noteController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Note is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Submit Button
                  Center(child: SubmitButton(onPressed: _submitWithdrawal)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
