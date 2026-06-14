import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/bank_details/bank_details_cubit.dart';
import 'package:honorfx/cubit/bank_details/bank_details_state.dart';
import 'package:honorfx/models/dashboard/bank_details_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/widgets/buttons/button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddBankDetailsScreen extends StatefulWidget {
  const AddBankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _ifscSwiftCodeController = TextEditingController();
  final _ibanNoController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAddressController = TextEditingController();

  String? _selectedCountry;
  String? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  // Sample countries list - in a real app, this would come from an API or constants
  final List<String> _countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Argentina',
    'Australia',
    'Austria',
    'Bangladesh',
    'Belgium',
    'Brazil',
    'Canada',
    'China',
    'Denmark',
    'Egypt',
    'France',
    'Germany',
    'India',
    'Indonesia',
    'Italy',
    'Japan',
    'Malaysia',
    'Netherlands',
    'Norway',
    'Pakistan',
    'Philippines',
    'Singapore',
    'Spain',
    'Sweden',
    'Switzerland',
    'Thailand',
    'Turkey',
    'United Kingdom',
    'United States',
  ];

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNoController.dispose();
    _ifscSwiftCodeController.dispose();
    _ibanNoController.dispose();
    _bankNameController.dispose();
    _bankAddressController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _selectedFile = file.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        buildSnackBar(message: 'Error selecting file', isError: true),
      );
    }
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_selectedCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(message: 'Please select a country', isError: true),
        );
        return;
      }

      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(message: 'Please select a file', isError: true),
        );
        return;
      }

      final model = AddBankDetailsModel(
        accountName: _accountNameController.text.trim(),
        accountNo: _accountNoController.text.trim(),
        ifscSwiftCode: _ifscSwiftCodeController.text.trim(),
        ibanNo:
            _ibanNoController.text.trim().isEmpty
                ? null
                : _ibanNoController.text.trim(),
        bankName: _bankNameController.text.trim(),
        bankAddress:
            _bankAddressController.text.trim().isEmpty
                ? null
                : _bankAddressController.text.trim(),
        country: _selectedCountry!,
        bookBankPath: _selectedFile,
      );

      context.read<BankDetailsCubit>().addBankDetails(model);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _accountNameController.clear();
    _accountNoController.clear();
    _ifscSwiftCodeController.clear();
    _ibanNoController.clear();
    _bankNameController.clear();
    _bankAddressController.clear();
    setState(() {
      _selectedCountry = null;
      _selectedFile = null;
    });
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
            // Navigate back to bank details screen after successful addition
            context.pop();
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
                child: _buildAddBankDetailsForm(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddBankDetailsForm() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Details Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please fill in all required fields to add your bank details',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24.h),

            // Account Name
            _buildFieldLabel('Account Name', isRequired: true),
            CommanTexfield(
              controller: _accountNameController,
              hintText: 'Enter account holder name',
            ),
            SizedBox(height: 16.h),

            // Account No
            _buildFieldLabel('Account No.', isRequired: true),
            CommanTexfield(
              controller: _accountNoController,
              hintText: 'Enter account number',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),

            // IFSC/Swift Code
            _buildFieldLabel('IFSC/Swift Code', isRequired: true),
            CommanTexfield(
              controller: _ifscSwiftCodeController,
              hintText: 'Enter ifsc/swift code',
            ),
            SizedBox(height: 16.h),

            // IBAN No
            _buildFieldLabel('IBAN No.'),
            CommanTexfield(
              controller: _ibanNoController,
              hintText: 'Enter iban number',
              validator: (value) => null,
            ),
            SizedBox(height: 16.h),

            // Bank Name
            _buildFieldLabel('Bank Name', isRequired: true),
            CommanTexfield(
              controller: _bankNameController,
              hintText: 'Enter bank name',
            ),
            SizedBox(height: 16.h),

            // Bank Address
            _buildFieldLabel('Bank address'),
            CommanTexfield(
              controller: _bankAddressController,
              hintText: 'Enter bank address',
              validator: (value) => null,
            ),
            SizedBox(height: 16.h),

            // Country
            _buildFieldLabel('Country', isRequired: true),
            CommonDropdown(
              hintText: 'Please Choose...',
              value: _selectedCountry,
              data: _countries,
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Book Bank
            _buildFieldLabel('Book Bank', isRequired: true),
            GestureDetector(
              onTap: _selectFile,
              child: Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFile != null ? 'File selected' : 'Choose file',
                        style: TextStyle(
                          color:
                              _selectedFile != null
                                  ? AppColors.black
                                  : Colors.grey.shade400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        _selectedFile != null ? 'Selected' : 'No file chosen',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Submit Button
            Button(
              title: 'Submit',
              onPressed: _submitForm,
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          children:
              isRequired
                  ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : null,
        ),
      ),
    );
  }
}
