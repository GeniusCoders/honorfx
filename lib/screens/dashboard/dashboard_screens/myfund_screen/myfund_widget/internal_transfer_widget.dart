import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';

class InternalTransferWidget extends StatefulWidget {
  const InternalTransferWidget({super.key});

  @override
  State<InternalTransferWidget> createState() => _InternalTransferWidgetState();
}

class _InternalTransferWidgetState extends State<InternalTransferWidget> {
  final _amountController = TextEditingController();
  String? _fromAccount;
  String? _toAccount;
  List<AccountListingTypeData> _accounts = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  void dispose() {
    _amountController.dispose();
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
          _fromAccount = _accounts.first.mtUserid.toString();
          // Default to second account if available, otherwise use the first
          _toAccount =
              _accounts.length > 1
                  ? _accounts[1].mtUserid.toString()
                  : _accounts.first.mtUserid.toString();
        }
      });
    } else if (state is AccountDetailsLoaded) {
      setState(() {
        _accounts = state.accounts;
        if (_accounts.isNotEmpty) {
          _fromAccount = _accounts.first.mtUserid.toString();
          // Default to second account if available, otherwise use the first
          _toAccount =
              _accounts.length > 1
                  ? _accounts[1].mtUserid.toString()
                  : _accounts.first.mtUserid.toString();
        }
      });
    }
  }

  void _submitTransfer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_fromAccount == _toAccount) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(
          message: 'From and To accounts must be different',
          isError: true,
        ),
      );
      return;
    }

    final amount = _amountController.text.trim();

    // Check if amount is a valid number
    if (double.tryParse(amount) == null || double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(message: 'Please enter a valid amount', isError: true),
      );
      return;
    }

    // Call the internal transfer method
    final dashboardCubit = context.read<DashboardCubit>();
    dashboardCubit.internalTransfer(
      fromAccount: _fromAccount!,
      toAccount: _toAccount!,
      amount: amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is AccountsLoaded || state is AccountDetailsLoaded) {
          _setupAccounts(state);
        }

        if (state is InternalTransferSuccess) {
          _amountController.clear();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(buildSnackBar(message: state.message, isError: false));
        }

        if (state is InternalTransferError) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                // Internal Transfer Form
                Row(
                  children: [
                    Expanded(
                      child: CommonDropdown(
                        hintText: 'From Account',
                        value: _fromAccount,
                        onChanged: (value) {
                          setState(() {
                            _fromAccount = value;
                          });
                        },
                        data:
                            _accounts
                                .map((e) => e.mtUserid.toString())
                                .toList(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CommonDropdown(
                        hintText: 'To Account',
                        value: _toAccount,
                        data:
                            _accounts
                                .map((e) => e.mtUserid.toString())
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _toAccount = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CommanTexfield(
                        hintText: 'Amount',
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SubmitButton(onPressed: _submitTransfer),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
