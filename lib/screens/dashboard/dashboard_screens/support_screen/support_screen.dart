import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:honorfx/cubit/dashboard/dashboard_cubit.dart';
import 'package:honorfx/cubit/dashboard/dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/common_dropdown.dart';
import 'package:honorfx/utils/constant/strings.dart';
import 'package:honorfx/utils/submit_button.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';
import 'package:honorfx/widgets/gradient_background.dart';
import 'package:honorfx/widgets/textfields/comman_texfield.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  String _selectedOption = 'Open'; // 'Open' or 'Closed'

  // Form controllers
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  // Form values
  String? _selectedCategory;
  String? _selectedPriority;

  late DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dashboardCubit = getIt<DashboardCubit>();
    // Load tickets when screen initializes
    _dashboardCubit.getMyTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardCubit,
      child: BlocListener<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state is CreateTicketSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Clear form after successful submission
            _clearForm();
          } else if (state is CreateTicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MyTicketsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AddCommentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AddCommentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(title: 'Support Center'),

            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          buttonColor: AppColors.primary,
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
                          buttonColor: AppColors.secondary,
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
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final isLoading = state is CreateTicketLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category field
              _buildFormLabel('Category', isRequired: true),
              CommonDropdown(
                hintText: 'Select Category',
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                data: Constant.ticketCategory,
              ),
              SizedBox(height: 16.h),

              // Title field
              _buildFormLabel('Title', isRequired: true),
              CommanTexfield(
                hintText: 'Enter ticket title',
                controller: _titleController,
              ),
              SizedBox(height: 16.h),

              // Priority field
              _buildFormLabel('Priority', isRequired: true),
              CommonDropdown(
                hintText: 'Select Priority',
                value: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                data: Constant.ticketPriority,
              ),
              SizedBox(height: 16.h),

              // Query field
              _buildFormLabel('Describe your problem', isRequired: true),
              CommanTexfield(
                hintText: 'Enter your query',
                controller: _messageController,
              ),
              SizedBox(height: 20.h),

              SizedBox(height: 24.h),

              // Submit button
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SubmitButton(onPressed: _submitTicket),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyTicketsTab() {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Column(
          children: [
            // Open/Closed tickets toggle
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(child: _buildRadioOption('Open', 'Open Tickets')),
                Expanded(child: _buildRadioOption('Closed', 'Closed Tickets')),
              ],
            ),

            SizedBox(height: 20.h),

            // Display tickets based on state and selected type
            Expanded(child: _buildTicketsContent(state)),
          ],
        );
      },
    );
  }

  Widget _buildTicketsContent(DashboardState state) {
    if (state is MyTicketsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is MyTicketsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading tickets',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              state.message,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => _dashboardCubit.getMyTickets(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is MyTicketsLoaded) {
      final filteredTickets =
          state.tickets.where((ticket) {
            if (_selectedOption == 'Open') {
              return ticket.status?.toLowerCase() == 'open' ||
                  ticket.status?.toLowerCase() == 'pending';
            } else {
              return ticket.status?.toLowerCase() == 'closed' ||
                  ticket.status?.toLowerCase() == 'solved';
            }
          }).toList();

      if (filteredTickets.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey),
              SizedBox(height: 16.h),
              Text(
                'No ${_selectedOption.toLowerCase()} tickets found',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your ${_selectedOption.toLowerCase()} tickets will appear here',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: filteredTickets.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final ticket = filteredTickets[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTicketCard(
              ticketId: ticket.ticketId ?? '',
              title: ticket.title ?? '',
              enquiryType: ticket.category ?? '',
              status: ticket.status ?? '',
              priority: ticket.priority ?? '',
              message: ticket.message ?? '',
              showSolution:
                  ticket.status?.toLowerCase() == 'open' ||
                  ticket.status?.toLowerCase() == 'pending',
            ),
          );
        },
      );
    }

    // Default state - show empty state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            'No tickets found',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your tickets will appear here',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
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
                color: isSelected ? AppColors.primary : Colors.grey,
                width: 2.w,
              ),
            ),
            child:
                isSelected
                    ? const Center(
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: AppColors.primary,
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
    String? priority,
    String? message,
  }) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ticket ID
                Column(
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

                // Title
                Flexible(
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

                // Category
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category:',
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

                // Priority
                if (priority != null)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Priority:',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(priority!),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            priority!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                    'Message',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 8.h),
                  if (message != null && message!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(message!, style: TextStyle(fontSize: 14.sp)),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          'No message available',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ),
                    ),
                  SizedBox(height: 16.h),
                  // Reply button
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: GestureDetector(
                  //     onTap: () => _showReplyDialog(ticketId),
                  //     child: Container(
                  //       padding: EdgeInsets.symmetric(
                  //         horizontal: 24.w,
                  //         vertical: 10.h,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: Colors.black,
                  //         borderRadius: BorderRadius.circular(8.r),
                  //       ),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(
                  //             'Reply',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 14.sp,
                  //             ),
                  //           ),
                  //           SizedBox(width: 8.w),
                  //           SvgPicture.asset(
                  //             'assets/icons/messages.svg',
                  //             width: 20.w,
                  //             height: 20.h,
                  //             colorFilter: const ColorFilter.mode(
                  //               Colors.white,
                  //               BlendMode.srcIn,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
              ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  void _submitTicket() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a category'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedPriority == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a priority'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _dashboardCubit.createTicket(
        title: _titleController.text.trim(),
        category: _selectedCategory!,
        priority: _selectedPriority!,
        message: _messageController.text.trim(),
      );
    }
  }

  void _clearForm() {
    _titleController.clear();
    _messageController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedPriority = null;
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showReplyDialog(String ticketId) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: _dashboardCubit,
          child: BlocListener<DashboardCubit, DashboardState>(
            listener: (context, state) {
              if (state is AddCommentSuccess) {
                Navigator.of(context).pop();
                replyController.dispose();
              }
            },
            child: AlertDialog(
              title: Text(
                'Reply to Ticket',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ticket ID: #$ticketId',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Your Reply',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: replyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter your reply...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.r),
                        borderSide: BorderSide(color: AppColors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.r),
                        borderSide: BorderSide(color: AppColors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.r),
                        borderSide: BorderSide(color: AppColors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    replyController.dispose();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                ),
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    final isLoading = state is AddCommentLoading;

                    return ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                final comment = replyController.text.trim();
                                if (comment.isNotEmpty) {
                                  _dashboardCubit.addComment(
                                    ticketId: ticketId,
                                    comment: comment,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a reply'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:
                          isLoading
                              ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                'Send Reply',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
