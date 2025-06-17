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

class WalletToMt5 extends StatefulWidget {
  final Function(String)? onAccountSelected;

  const WalletToMt5({super.key, this.onAccountSelected});

  @override
  State<WalletToMt5> createState() => _WalletToMt5State();
}

class _WalletToMt5State extends State<WalletToMt5> {
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
    FocusScope.of(context).unfocus();

    if (_selectedMt5Account == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBars.errorSnackBar(title: 'Please select a valid account'),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dashboardCubit = context.read<DashboardCubit>();

    dashboardCubit.walletToMt5(
      mt5id: _selectedMt5Account!,
      amount: _amountController.text,
      note: _noteController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is WalletToMt5Success) {
          context.read<DashboardCubit>().getDashboardData();
          context.read<DashboardCubit>().getAccounts(
            isAccountDetailsFetched: false,
          );

          // Clear form and reset validation state
          _formKey.currentState?.reset();
          _amountController.clear();
          _noteController.clear();
          _selectedMt5Account = null;

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is WalletToMt5Error) {
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

                    // Notify parent when account is selected
                    if (value != null && widget.onAccountSelected != null) {
                      widget.onAccountSelected!(value);
                    }
                  },
                  data: _accounts.map((e) => e.mtUserid.toString()).toList(),
                ),

                SizedBox(height: 20.h),

                // Amount field
                AmountTexfield(
                  hintText: 'Amount',
                  controller: _amountController,
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
