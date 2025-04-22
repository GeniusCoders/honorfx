import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/tab_title.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/gradient_background.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _isAgreementChecked = false;

  String _selectedOption = 'Open'; // 'Open' or 'Closed'
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommanAppbar(),
              SizedBox(height: 20.h),
              const UserName(),
              SizedBox(height: 30.h),
              const TabTitle(title: 'Support Center'),

              SizedBox(height: 25.h),

              // Contact Options Row
              Row(
                children: [
                  // Chat with us
                  Expanded(
                    child: _buildContactOption(
                      icon: 'messages.svg',
                      title: 'Chat with us',
                      buttonText: 'Click here',
                      buttonColor: const Color(0xFFE95E30),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Mail us
                  Expanded(
                    child: _buildContactOption(
                      icon: 'sms_outline.svg',
                      title: 'Mail us',
                      buttonText: 'Click here',
                      buttonColor: const Color(0xFFA1CF48),
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Tabs for tickets
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 4.w,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.lightGrey,
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: 'Raise New Ticket'),
                  Tab(text: 'My Tickets'),
                ],
              ),

              SizedBox(height: 20.h),

              // Tab content
              SizedBox(
                height: 600.h,
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildRaiseTicketForm(), _buildMyTicketsTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required String icon,
    required String title,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/$icon', width: 26.w, height: 26.h),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: AppColors.lightGrey),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRaiseTicketForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category field
          _buildFormLabel('Category', isRequired: true),
          CommonDropdown(hintText: 'Select Category', onChanged: (value) {}),
          SizedBox(height: 16.h),

          // Title field
          _buildFormLabel('Title', isRequired: true),
          _buildTextField(hintText: 'Enter your name'),
          SizedBox(height: 16.h),

          // Priority field
          _buildFormLabel('Priority', isRequired: true),
          _buildTextField(hintText: 'Enter your name'),
          SizedBox(height: 16.h),

          // Query field
          _buildFormLabel('Your query', isRequired: true),
          _buildTextField(hintText: 'Enter your query', maxLines: 6),
          SizedBox(height: 20.h),

          // Upload document button
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/upload.svg'),
                  SizedBox(width: 8.w),
                  Text(
                    'Upload a document',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Submit button
          SubmitButton(),
        ],
      ),
    );
  }

  Widget _buildMyTicketsTab() {
    return Column(
      children: [
        // Open/Closed tickets toggle
        Row(
          children: [
            Expanded(child: _buildRadioOption('Open', 'Open Tickets')),
            Expanded(child: _buildRadioOption('Closed', 'Closed Tickets')),
            // Refresh button
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: SvgPicture.asset(
                'assets/icons/upload_one.svg',
                width: 32.w,
                height: 32.h,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Display tickets based on selected type
        if (_selectedOption == 'Open')
          Column(
            children: [
              _buildTicketCard(
                ticketId: '114464636',
                title: 'Technical Issue',
                enquiryType: 'Technical',
                status: 'Pending',
                showSolution: true,
              ),
            ],
          )
        else
          Column(
            children: [
              _buildTicketCard(
                ticketId: '114464636',
                title: 'Technical Issue',
                enquiryType: 'Technical',
                status: 'Solved',
                showSolution: false,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRadioOption(String value, String label) {
    final bool isSelected = _selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF9BC547) : Colors.grey,
                width: 2.w,
              ),
            ),
            child:
                isSelected
                    ? const Center(
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Color(0xFF9BC547),
                      ),
                    )
                    : null,
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard({
    required String ticketId,
    required String title,
    required String enquiryType,
    required String status,
    required bool showSolution,
  }) {
    Color statusColor;
    Color statusTextColor = Colors.white;

    switch (status) {
      case 'Pending':
        statusColor = const Color(0xFFE95E30);
        break;
      case 'Solved':
        statusColor = const Color(0xFF666666);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Top section with ticket info
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Ticket ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket ID:',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '#$ticketId',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title:',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Enquiry Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enquiry Type:',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        enquiryType,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Solution section (if applicable)
          if (showSolution)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solution',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(height: 120.h), // Space for solution content
                  // Reply button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SvgPicture.asset(
                            'assets/icons/messages.svg',
                            width: 20.w,
                            height: 20.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Dropdown indicator for Solved tickets
          if (!showSolution && status == 'Solved')
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 8.h),
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          if (isRequired)
            Text(
              '*',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CommanTexfield(hintText: hintText);
  }
}
