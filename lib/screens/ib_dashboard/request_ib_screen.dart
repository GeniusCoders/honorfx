import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading.dart';
import 'package:honorfx/widgets/snackbar/snackbars.dart';

class RequestIbScreen extends StatefulWidget {
  const RequestIbScreen({Key? key}) : super(key: key);

  @override
  State<RequestIbScreen> createState() => _RequestIbScreenState();
}

class _RequestIbScreenState extends State<RequestIbScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Request for IB'),
      body: BlocConsumer<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        listener: (context, state) {
          if (state is IbRequestSubmitted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBars.successSnackBar(title: 'Success'));
            // Navigate back to dashboard
            getIt<AppRouter>().goToDashboard();
          } else if (state is IbRequestError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBars.errorSnackBar(title: 'Error'));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildContent(),
              if (state is IbRequestSubmitting) const Loading(),
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
            SizedBox(height: 16.h),
            _buildTermsAndConditions(),
            SizedBox(height: 24.h),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return InkWell(
      onTap: () {
        setState(() {
          _agreeToTerms = !_agreeToTerms;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border:
                  _agreeToTerms
                      ? null
                      : Border.all(color: AppColors.secondary, width: 2),
              color: _agreeToTerms ? AppColors.secondary : Colors.transparent,
            ),
            child:
                _agreeToTerms
                    ? Icon(Icons.check, size: 16.w, color: AppColors.white)
                    : null,
          ),
          SizedBox(width: 12.w),
          RichText(
            text: TextSpan(
              text: 'I agree with ',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 120.w,
        child: SubmitButton(onPressed: _submitRequest),
      ),
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      _ibDashboardCubit.requestIbStatus();
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBars.errorSnackBar(title: 'Error'));
    }
  }
}
