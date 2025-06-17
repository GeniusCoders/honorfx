import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/snackbar/snackbars.dart';
import 'package:honorfx/widgets/textfields/amount_texfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CryptoDepositScreen extends StatefulWidget {
  const CryptoDepositScreen({super.key});

  @override
  State<CryptoDepositScreen> createState() => _CryptoDepositScreenState();
}

class _CryptoDepositScreenState extends State<CryptoDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedAccount;

  DashboardController dashboardController = Get.find<DashboardController>();
  List<AccountListingTypeData> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() {
    _accounts = dashboardController.accounts;
  }

  _onSubmit() {
    FocusScope.of(context).unfocus();

    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBars.errorSnackBar(title: 'Please select an account'),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<DashboardCubit>(context).cregisDeposit(
          amount: _amountController.text,
          mt5id: _selectedAccount == 'Wallet' ? 'wallet' : _selectedAccount!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is CryptoDepositSuccess) {
          context.pushNamed(
            'online-deposit-payment',
            queryParameters: {'data': state.url, 'title': "Crypto Deposit"},
          );
        } else if (state is CryptoDepositError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBars.errorSnackBar(title: state.message));
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Crypto Deposits',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                // Account Selection
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    CommonDropdown(
                      hintText: 'Select Account',
                      value: _selectedAccount,
                      data: [
                        'Wallet',
                        ..._accounts.map((e) => e.mtUserid.toString()).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAccount = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Amount Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Amount in USD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    AmountTexfield(
                      hintText: 'Enter Amount in USD',
                      controller: _amountController,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Submit Button
                SubmitButton(onPressed: _onSubmit),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
