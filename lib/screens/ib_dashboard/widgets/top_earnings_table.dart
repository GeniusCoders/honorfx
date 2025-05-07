import 'package:flutter/material.dart';
import 'package:honorfx/models/ib_program/top_earning_response.dart';
import 'package:honorfx/utils/colors.dart';

class TopEarningsTable extends StatefulWidget {
  final List<TopEarningData> data;

  const TopEarningsTable({Key? key, required this.data}) : super(key: key);

  @override
  State<TopEarningsTable> createState() => _TopEarningsTableState();
}

class _TopEarningsTableState extends State<TopEarningsTable> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), const SizedBox(height: 16), _buildTable()],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Top 5 Earnings of Sub IBs',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTable() {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Adjust the table width based on screen size
    final double totalTableWidth = screenWidth; // Accounting for padding

    // Adjust column widths for better responsiveness
    final double idWidth = totalTableWidth * 0.1;
    final double nameWidth = totalTableWidth * 0.2;
    final double emailWidth = totalTableWidth * 0.3;
    final double lotsWidth = totalTableWidth * 0.2;
    final double commissionWidth = totalTableWidth * 0.35;

    return Container(
      width: screenWidth, // Account for container padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: SizedBox(
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: idWidth,
                      child: const Text(
                        'ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: nameWidth,
                      child: const Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: emailWidth,
                      child: const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: lotsWidth,
                      child: const Text(
                        'Total Lots',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: commissionWidth,
                      child: const Text(
                        'Commission Earned',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Table rows
              ...List.generate(
                widget.data.length,
                (index) => _buildTableRow(
                  index,
                  idWidth: idWidth,
                  nameWidth: nameWidth,
                  emailWidth: emailWidth,
                  lotsWidth: lotsWidth,
                  commissionWidth: commissionWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(
    int index, {
    required double idWidth,
    required double nameWidth,
    required double emailWidth,
    required double lotsWidth,
    required double commissionWidth,
  }) {
    final rowData = widget.data[index];
    final isEvenRow = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isEvenRow ? Colors.grey.shade100 : Colors.white,
      ),
      child: Row(
        children: [
          SizedBox(
            width: idWidth,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: nameWidth,
            child: Text(
              rowData.name,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: emailWidth,
            child: Text(
              rowData.email,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          SizedBox(
            width: lotsWidth,
            child: Text(
              rowData.totalLots,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: commissionWidth,
            child: Text(
              '\$${rowData.totalComm}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
