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
import 'package:honorfx/screens/dashboard/dashboard_screens/myfund_screen/crypto_deposit_screen.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbars.dart';
import 'package:honorfx/widgets/textfields/amount_texfield.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

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

  // Tab management
  int _selectedPaymentMethod = 0; // 0: Bank Transfer, 1: Cash, 2: Crypto

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
          accountNumber:
              _selectedAccount == 'Wallet' ? 'wallet' : _selectedAccount!,
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
                        // Bank Transfer
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = 0;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _selectedPaymentMethod == 0
                                      ? AppColors.primary
                                      : AppColors.greyBackground,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  color:
                                      _selectedPaymentMethod == 0
                                          ? Colors.white
                                          : Colors.black,
                                  size: 15.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Bank Transfer',
                                  style: TextStyle(
                                    color:
                                        _selectedPaymentMethod == 0
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Cash
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       _selectedPaymentMethod = 1;
                        //     });
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       vertical: 10.h,
                        //       horizontal: 10.w,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color:
                        //           _selectedPaymentMethod == 1
                        //               ? AppColors.primary
                        //               : AppColors.secondaryBackground,
                        //       borderRadius: BorderRadius.circular(7),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Icon(
                        //           Icons.money,
                        //           color:
                        //               _selectedPaymentMethod == 1
                        //                   ? Colors.white
                        //                   : Colors.black,
                        //         ),
                        //         SizedBox(width: 10.w),
                        //         Text(
                        //           'Cash',
                        //           style: TextStyle(
                        //             color:
                        //                 _selectedPaymentMethod == 1
                        //                     ? Colors.white
                        //                     : Colors.black,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 12.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 10.w),
                        // Crypto
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = 2;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _selectedPaymentMethod == 2
                                      ? AppColors.primary
                                      : AppColors.greyBackground,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.currency_bitcoin,
                                  color:
                                      _selectedPaymentMethod == 2
                                          ? Colors.white
                                          : Colors.black,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Crypto',
                                  style: TextStyle(
                                    color:
                                        _selectedPaymentMethod == 2
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Divider(height: 1.h, color: AppColors.grey),
                  SizedBox(height: 25.h),

                  _buildSelectedPaymentMethodForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedPaymentMethodForm() {
    switch (_selectedPaymentMethod) {
      case 0:
        return _buildBankTransferForm();
      case 1:
        return _buildCashForm();
      case 2:
        return const CryptoDepositScreen();
      default:
        return _buildBankTransferForm();
    }
  }

  Widget _buildBankTransferForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bank Transfers Section
        Center(
          child: Text(
            'Bank Transfers',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
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
                  SizedBox(
                    width: 150.w,
                    child: CommonDropdown(
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
                  CommanTexfield(hintText: 'Note', controller: _noteController),
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
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
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
    );
  }

  Widget _buildCashForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cash Deposit Section
        Center(
          child: Text(
            'Cash Deposit',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 25.h),
        // Information Message
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Cash Deposit Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                'For cash deposits, please visit our office location:',
                style: TextStyle(fontSize: 12.sp, color: Colors.blue.shade700),
              ),
              SizedBox(height: 8.h),
              Text(
                'HonorFX Office\nAddress: [Office Address]\nWorking Hours: 9:00 AM - 6:00 PM (Mon-Fri)',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Please bring a valid ID and mention your account details to our staff.',
                style: TextStyle(fontSize: 12.sp, color: Colors.blue.shade700),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBars.successSnackBar(
                  title: 'Contact our support team for cash deposit assistance',
                ),
              );
            },
            icon: Icon(Icons.phone, color: Colors.white),
            label: Text(
              'Contact Support',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }
}
