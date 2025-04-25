import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/models/dashboard/group_list_model.dart';
import 'package:honorfx/models/dashboard/leverage_list_model.dart';
import 'package:honorfx/router/app_router.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';
import 'package:honorfx/widgets/textfields/password_text_field.dart';

class OpenAccountScreen extends StatefulWidget {
  const OpenAccountScreen({Key? key}) : super(key: key);

  @override
  State<OpenAccountScreen> createState() => _OpenAccountScreenState();
}

class _OpenAccountScreenState extends State<OpenAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mainPasswordController = TextEditingController();
  final _investorPasswordController = TextEditingController();

  GroupData? _selectedGroup;
  LeverageData? _selectedLeverage;
  List<GroupData> _groups = [];
  List<LeverageData> _leverages = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _mainPasswordController.dispose();
    _investorPasswordController.dispose();
    super.dispose();
  }

  void _loadData() {
    final dashboardCubit = context.read<DashboardCubit>();
    dashboardCubit.getGroupList();
    dashboardCubit.getLeverageList();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(message: 'Please select a group', isError: true),
        );
        return;
      }

      if (_selectedLeverage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(message: 'Please select leverage', isError: true),
        );
        return;
      }

      final dashboardCubit = context.read<DashboardCubit>();
      dashboardCubit.openLiveAccount(
        group: _selectedGroup!.value,
        leverage: _selectedLeverage!.leverage.toString(),
        mainPassword: _mainPasswordController.text,
        investorPassword: _investorPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Open New Account'),
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state is GroupListLoaded) {
            setState(() {
              _groups = state.groups;
              if (_groups.isNotEmpty) {
                _selectedGroup = _groups.first;
              }
            });
          }

          if (state is LeverageListLoaded) {
            setState(() {
              _leverages = state.leverages;
              if (_leverages.isNotEmpty) {
                _selectedLeverage = _leverages.first;
              }
            });
          }

          if (state is OpenAccountSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(message: state.message, isError: false),
            );
            // Handle success, navigate back
            context.pop();
          }

          if (state is OpenAccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(message: state.message, isError: true),
            );
          }
        },
        builder: (context, state) {
          return LoadingOverlay(
            isLoading: state is DashboardLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Group',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildGroupDropdown(),
                    SizedBox(height: 16.h),
                    Text(
                      'Leverage',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildLeverageDropdown(),
                    SizedBox(height: 16.h),
                    Text(
                      'Main Password',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    PasswordTextField(
                      controller: _mainPasswordController,
                      hintText: 'Enter main password',
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Investor Password',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    PasswordTextField(
                      controller: _investorPasswordController,
                      hintText: 'Enter investor password',
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Text(
                          'Open Account',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GroupData>(
          isExpanded: true,
          value: _selectedGroup,
          icon: const Icon(Icons.keyboard_arrow_down),
          items:
              _groups.map((GroupData group) {
                return DropdownMenuItem<GroupData>(
                  value: group,
                  child: Text(group.name),
                );
              }).toList(),
          onChanged: (GroupData? value) {
            setState(() {
              _selectedGroup = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLeverageDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LeverageData>(
          isExpanded: true,
          value: _selectedLeverage,
          icon: const Icon(Icons.keyboard_arrow_down),
          items:
              _leverages.map((LeverageData leverage) {
                return DropdownMenuItem<LeverageData>(
                  value: leverage,
                  child: Text('1:${leverage.leverage}'),
                );
              }).toList(),
          onChanged: (LeverageData? value) {
            setState(() {
              _selectedLeverage = value;
            });
          },
        ),
      ),
    );
  }
}
