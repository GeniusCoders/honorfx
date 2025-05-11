import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:honorfx/controllers/dashboard_controller.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading.dart';
import 'package:honorfx/widgets/textfields/amount_texfield.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';

class IbWithdrawScreen extends StatefulWidget {
  const IbWithdrawScreen({Key? key}) : super(key: key);

  @override
  State<IbWithdrawScreen> createState() => _IbWithdrawScreenState();
}

class _IbWithdrawScreenState extends State<IbWithdrawScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();
  final _formKey = GlobalKey<FormState>();

  String _selectedWithdrawType = 'MT5';
  String _selectedWithdrawTo = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  final List<String> _withdrawTypes = ['MT5'];
  List<String> _mt5Accounts = []; // Example MT5 IDs

  @override
  void initState() {
    super.initState();
    _mt5Accounts =
        _dashboardController.accounts
            .map((e) => e.mtUserid.toString())
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'IB Withdraw'),
      body: BlocConsumer<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        listener: (context, state) {
          if (state is IbWithdrawSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            getIt<AppRouter>().goToDashboard();
          } else if (state is IbWithdrawSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildContent(),
              if (state is IbWithdrawSubmitting) const Loading(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWithdrawTypeSection(),
            SizedBox(height: 16.h),
            _buildWithdrawToSection(),
            SizedBox(height: 16.h),
            _buildAmountSection(),
            SizedBox(height: 16.h),
            _buildNoteSection(),
            SizedBox(height: 24.h),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Withdraw Type ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CommonDropdown(
          hintText: 'Select Withdraw Type',
          data: _withdrawTypes,
          onChanged: (value) {
            setState(() {
              _selectedWithdrawType = value ?? '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildWithdrawToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Withdraw To ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CommonDropdown(
          hintText: 'Select Withdraw To',
          data: _mt5Accounts,
          onChanged: (value) {
            setState(() {
              _selectedWithdrawTo = value ?? '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Amount ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        AmountTexfield(
          controller: _amountController,
          hintText: 'Enter amount',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Note ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CommanTexfield(controller: _noteController, hintText: 'Enter Note'),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SubmitButton(onPressed: _submitForm);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String paymentMethod = _selectedWithdrawType.toLowerCase();
      String withdrawTo = _selectedWithdrawTo;
      String amount = _amountController.text;
      String note = _noteController.text;

      // For MT5 selected, withdrawTo will be the MT5 account
      if (_selectedWithdrawType == 'MT5' ||
          _selectedWithdrawType == 'Sub Client MT5') {
        paymentMethod = 'mt5';
      }

      _ibDashboardCubit.submitIbWithdraw(
        paymentMethod,
        withdrawTo,
        amount,
        note,
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dashboardController.dispose();
    super.dispose();
  }
}
