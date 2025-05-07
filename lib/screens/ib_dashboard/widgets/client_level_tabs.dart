import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/utils/colors.dart';

class ClientLevelTabs extends StatefulWidget {
  final int selectedLevel;
  final Function(int) onLevelSelected;
  final Map<String, String> summaryData;
  final bool isLoading;

  const ClientLevelTabs({
    Key? key,
    required this.selectedLevel,
    required this.onLevelSelected,
    required this.summaryData,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<ClientLevelTabs> createState() => _ClientLevelTabsState();
}

class _ClientLevelTabsState extends State<ClientLevelTabs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ClientLevelTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle selected level changes for scrolling
    if (widget.selectedLevel != oldWidget.selectedLevel) {
      // Scroll to make the selected tab visible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedTab();
      });
    }

    // Handle summary data changes - compare actual values
    bool summaryDataChanged = false;
    if (widget.summaryData.length != oldWidget.summaryData.length) {
      summaryDataChanged = true;
    } else {
      widget.summaryData.forEach((key, value) {
        if (oldWidget.summaryData[key] != value) {
          summaryDataChanged = true;
        }
      });
    }

    if (summaryDataChanged) {
      setState(() {
        // Force a rebuild when summary data changes
      });
    }
  }

  void _scrollToSelectedTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / 4; // Approximate width of a tab

    // Calculate the position to scroll to
    final scrollTo = (widget.selectedLevel - 1) * tabWidth;

    // Ensure we don't scroll past the content
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetScroll = scrollTo.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      targetScroll,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral Clients of IB :- ${widget.summaryData['ibName'] ?? ''}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 2.w),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: List.generate(7, (index) {
                final level = index + 1;
                return _buildLevelTab(level);
              }),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (!widget.isLoading) _buildSummaryCards(),
      ],
    );
  }

  Widget _buildLevelTab(int level) {
    final isSelected = widget.selectedLevel == level;

    return GestureDetector(
      onTap: () => widget.onLevelSelected(level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Client',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Level $level',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    // For logging/debugging
    debugPrint('Building summary cards with data: ${widget.summaryData}');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSummaryCard('Lot', widget.summaryData['totalLots'] ?? '0'),
          SizedBox(width: 16.w),
          _buildSummaryCard(
            'Commission',
            '\$${widget.summaryData['totalCommission'] ?? '0'}',
          ),
          SizedBox(width: 16.w),
          _buildSummaryCard(
            'Deposit',
            '\$${widget.summaryData['deposit'] ?? '0'}',
          ),
          SizedBox(width: 16.w),
          _buildSummaryCard(
            'Withdraw',
            '\$${widget.summaryData['withdraw'] ?? '0'}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value) {
    // Ensure value is a valid string
    String displayValue = value;
    try {
      // If value is numeric, format it
      if (double.tryParse(value) != null) {
        final numValue = double.parse(value);
        displayValue = numValue.toStringAsFixed(2);
      }
    } catch (e) {
      // If there's any error in parsing, use the original value
      displayValue = value;
    }

    return Container(
      width: MediaQuery.of(context).size.width / 4 - 12,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayValue,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
