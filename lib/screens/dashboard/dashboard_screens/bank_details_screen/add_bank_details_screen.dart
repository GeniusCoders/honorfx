import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/bank_details/bank_details_cubit.dart';
import 'package:honorfx/cubit/bank_details/bank_details_state.dart';
import 'package:honorfx/models/dashboard/bank_details_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/buttons/button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';
import 'package:honorfx/widgets/textfields/custom_textfield.dart';

class AddBankDetailsScreen extends StatefulWidget {
  const AddBankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _ifscSwiftCodeController = TextEditingController();
  final _ibanNoController = TextEditingController();
  final _countryController = TextEditingController();
  final _bankAddressController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNoController.dispose();
    _ifscSwiftCodeController.dispose();
    _ibanNoController.dispose();
    _countryController.dispose();
    _bankAddressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bankDetails = AddBankDetailsModel(
        bankName: _bankNameController.text,
        accountName: _accountNameController.text,
        accountNo: _accountNoController.text,
        ifscSwiftCode: _ifscSwiftCodeController.text,
        ibanNo:
            _ibanNoController.text.isNotEmpty ? _ibanNoController.text : null,
        country: _countryController.text,
        bankAddress:
            _bankAddressController.text.isNotEmpty
                ? _bankAddressController.text
                : null,
      );

      context.read<BankDetailsCubit>().addBankDetails(bankDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Add Bank Details'),
      body: BlocListener<BankDetailsCubit, BankDetailsState>(
        listener: (context, state) {
          if (state is BankDetailsAddSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(buildSnackBar(message: state.message));
            Navigator.pop(context);
          } else if (state is BankDetailsAddError) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(message: state.message, isError: true),
            );
          }
        },
        child: BlocBuilder<BankDetailsCubit, BankDetailsState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is BankDetailsLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Bank Details',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: _bankNameController,
                        label: 'Bank Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bank name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _accountNameController,
                        label: 'Account Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _accountNoController,
                        label: 'Account Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _ifscSwiftCodeController,
                        label: 'IFSC/SWIFT Code',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter IFSC/SWIFT code';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _ibanNoController,
                        label: 'IBAN Number (Optional)',
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _countryController,
                        label: 'Country',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter country';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _bankAddressController,
                        label: 'Bank Address (Optional)',
                        maxLines: 3,
                      ),
                      SizedBox(height: 32.h),
                      Button(
                        title: 'Add Bank Details',
                        onPressed: _submitForm,
                        backgroundColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
