import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbars.dart';
import 'package:honorfx/widgets/textfields/amount_texfield.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';

class Mt5ToWallet extends StatefulWidget {
  const Mt5ToWallet({super.key});

  @override
  State<Mt5ToWallet> createState() => _Mt5ToWalletState();
}

class _Mt5ToWalletState extends State<Mt5ToWallet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedMt5Account;
  final _formKey = GlobalKey<FormState>();
  List<AccountListingTypeData> _accounts = [];
  final dashboardController = Get.find<DashboardController>();

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
    _accounts = dashboardController.accounts;
  }

  void _submitTransfer() {
    if (_selectedMt5Account == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBars.errorSnackBar(title: 'Please select a MT5 account'),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dashboardCubit = context.read<DashboardCubit>();

    dashboardCubit.mt5ToWallet(
      mt5id: _selectedMt5Account!,
      amount: _amountController.text,
      note: _noteController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is Mt5ToWalletSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form fields
          _amountController.clear();
          _noteController.clear();
        } else if (state is Mt5ToWalletError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is WalletTransferLoading,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // To MT5 account dropdown
                CommonDropdown(
                  hintText: 'Select MT5 Account',
                  value: _selectedMt5Account,
                  onChanged: (value) {
                    setState(() {
                      _selectedMt5Account = value;
                    });
                  },
                  data: _accounts.map((e) => e.mtUserid.toString()).toList(),
                ),

                SizedBox(height: 20.h),

                // Amount field
                AmountTexfield(
                  hintText: 'Amount',
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    try {
                      final amount = double.parse(value);
                      if (amount <= 0) {
                        return 'Amount must be greater than 0';
                      }
                    } catch (e) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                // Note field
                CommanTexfield(
                  hintText: 'Note',
                  controller: _noteController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a note';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 28.h),

                // Submit button
                SubmitButton(onPressed: _submitTransfer),
              ],
            ),
          ),
        );
      },
    );
  }
}
