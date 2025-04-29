import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/models/dashboard/account_listing_type_model.dart';
import 'package:honorfx/models/dashboard/reports_model/add_deposit_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbars.dart';
import 'package:honorfx/widgets/textfields/amount_texfield.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:image_picker/image_picker.dart';

class DepositWidget extends StatefulWidget {
  const DepositWidget({super.key});

  @override
  State<DepositWidget> createState() => _DepositWidgetState();
}

class _DepositWidgetState extends State<DepositWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedFile;
  String? _selectedAccount;
  final ImagePicker _picker = ImagePicker();
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
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBars.errorSnackBar(title: 'Please upload a deposit receipt'),
        );
        return;
      }
      BlocProvider.of<DashboardCubit>(context).addDeposit(
        model: AddDepositModel(
          accountNumber: _selectedAccount!,
          amount: _amountController.text,
          filePath: _selectedFile,
          refranceNumber: _transactionIdController.text,
          note: _noteController.text,
        ),
      );
    }
  }

  _onSelectImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedFile = image.path;
        });
      } else {
        return;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is AddDepositSuccess) {
          _formKey.currentState!.reset();

          _selectedFile = null;
          _selectedAccount = null;
          _amountController.clear();
          _transactionIdController.clear();
          _noteController.clear();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBars.successSnackBar(title: state.message));
        }
        if (state is DashboardError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBars.errorSnackBar(title: state.message));
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DashboardLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  // Payment Methods
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance,
                                color: Colors.white,
                                size: 15.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Bank Transfer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greyBackground,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.money),
                              SizedBox(width: 10.w),
                              Text(
                                'Cash',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greyBackground,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/visa.png',
                                width: 30,
                                height: 16,
                              ),
                              SizedBox(width: 5.w),
                              Image.asset(
                                'assets/images/mastercard.png',
                                width: 30,
                                height: 16,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Bank Card',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Divider(height: 1.h, color: AppColors.grey),
                  SizedBox(height: 25.h),
                  // Bank Transfers Section
                  Center(
                    child: Text(
                      'Bank Transfers',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  // Form Fields
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            CommonDropdown(
                              hintText: 'Select Account',
                              value: _selectedAccount,
                              data:
                                  _accounts
                                      .map((e) => e.mtUserid.toString())
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedAccount = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Amount',
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
                            SizedBox(height: 10.h),
                            AmountTexfield(
                              hintText: 'Amount',
                              controller: _amountController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Transaction ID',
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
                            SizedBox(height: 10.h),
                            CommanTexfield(
                              hintText: 'Transaction ID',
                              controller: _transactionIdController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Note',
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
                            SizedBox(height: 10.h),
                            CommanTexfield(
                              hintText: 'Note',
                              controller: _noteController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Upload Deposit Receipt',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _onSelectImage,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/upload.svg',
                                width: 20.w,
                                height: 20.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Upload a document',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  SubmitButton(onPressed: _onSubmit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
