import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/bank_details/bank_details_cubit.dart';
import 'package:honorfx/cubit/bank_details/bank_details_state.dart';
import 'package:honorfx/models/dashboard/bank_details_model.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/buttons/button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/loading/loading.dart';
import 'package:honorfx/widgets/loading/loading_overlay.dart';
import 'package:honorfx/widgets/snackbar/snackbar.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/router/app_router.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load bank details list when screen initializes
    context.read<BankDetailsCubit>().getBankDetailsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Bank Details'),
      bottomNavigationBar: Button(
        title: 'Add New Bank Details',
        onPressed: () {
          getIt<AppRouter>().goToAddBankDetails();
        },
        backgroundColor: AppColors.primary,
      ),
      body: BlocListener<BankDetailsCubit, BankDetailsState>(
        listener: (context, state) {
          if (state is BankDetailsListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(message: state.message, isError: true),
            );
          }
        },
        child: BlocBuilder<BankDetailsCubit, BankDetailsState>(
          builder: (context, state) {
            // Navigate to add bank details screen if list is empty
            if (state is BankDetailsListLoaded &&
                state.bankDetailsList.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getIt<AppRouter>().goToAddBankDetails();
              });
            }

            if (state is BankDetailsLoading) {
              return Center(child: SmallLoading());
            }

            if (state is BankDetailsListLoaded) {
              return _buildBankDetailsList(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBankDetailsList(BankDetailsListLoaded state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bank Details List',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${state.bankDetailsList.length} Records',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Bank Details Cards
          _buildBankDetailsCards(state.bankDetailsList),
        ],
      ),
    );
  }

  Widget _buildBankDetailsCards(List<BankDetailsData> bankDetailsList) {
    if (bankDetailsList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bankDetailsList.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final bankDetail = bankDetailsList[index];
        return _buildBankDetailCard(bankDetail);
      },
    );
  }

  Widget _buildBankDetailCard(BankDetailsData bankDetail) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bankDetail.bankName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'ID: ${bankDetail.id ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      bankDetail.status == 'Approved'
                          ? Colors.green.withOpacity(0.1)
                          : bankDetail.status == 'Pending'
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  bankDetail.status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        bankDetail.status == 'Approved'
                            ? Colors.green
                            : bankDetail.status == 'Pending'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Bank Details
          _buildDetailRow('Account Name', bankDetail.accountName),
          _buildDetailRow('Account No', bankDetail.accountNo),
          _buildDetailRow('IFSC/SWIFT Code', bankDetail.ifscSwiftCode),
          if (bankDetail.ibanNo != null)
            _buildDetailRow('IBAN No', bankDetail.ibanNo!),
          _buildDetailRow('Country', bankDetail.country),
          if (bankDetail.bankAddress != null)
            _buildDetailRow('Bank Address', bankDetail.bankAddress!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 48.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Bank Details Added',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your bank details to receive withdrawals',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
