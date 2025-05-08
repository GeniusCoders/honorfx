import 'package:flutter/material.dart';
import 'package:honorfx/models/ib_program/ib_withdraw_list_response.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:intl/intl.dart';

class WithdrawReportTable extends StatefulWidget {
  final List<IbWithdrawItem> data;

  const WithdrawReportTable({Key? key, required this.data}) : super(key: key);

  @override
  State<WithdrawReportTable> createState() => _WithdrawReportTableState();
}

class _WithdrawReportTableState extends State<WithdrawReportTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  int _entriesPerPage = 10;
  int _currentPage = 1;
  List<IbWithdrawItem> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
  }

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
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildTable(),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      ' Withdraw Report',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  int get _totalPages {
    return (_filteredData.length / _entriesPerPage).ceil();
  }

  List<IbWithdrawItem> get _paginatedData {
    final startIndex = (_currentPage - 1) * _entriesPerPage;
    final endIndex =
        startIndex + _entriesPerPage > _filteredData.length
            ? _filteredData.length
            : startIndex + _entriesPerPage;
    if (startIndex >= _filteredData.length) {
      return [];
    }
    return _filteredData.sublist(startIndex, endIndex);
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalScrollController,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14,
              ),
              dataTextStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
              columns: const [
                DataColumn(label: Text('ID')),

                DataColumn(label: Text('MT5 ID')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Withdraw To')),
                DataColumn(label: Text('Payment Method')),
                DataColumn(label: Text('Note')),
                DataColumn(label: Text('Comment')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Date')),
              ],
              rows: List.generate(_paginatedData.length, (index) {
                final item = _paginatedData[index];
                final DateTime parsedDate = DateFormat(
                  'yyyy-MM-dd HH:mm:ss',
                ).parse(item.date);
                final String formattedDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(parsedDate);
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        (index + 1 + (_currentPage - 1) * _entriesPerPage)
                            .toString(),
                      ),
                    ),

                    DataCell(Text(item.withdrawTo)),
                    DataCell(
                      Text(
                        item.amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    DataCell(Text(item.withdrawTo)),
                    DataCell(Text(item.paymentMethod)),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Text(item.note, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Text(
                          item.comment,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              item.status == 'Approved'
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            color:
                                item.status == 'Approved'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(formattedDate)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final showingStart =
        _filteredData.isEmpty ? 0 : (_currentPage - 1) * _entriesPerPage + 1;
    final showingEnd =
        _filteredData.isEmpty ? 0 : showingStart + _paginatedData.length - 1;

    return Row(
      children: [
        Text(
          'Showing $showingStart to $showingEnd of ${_filteredData.length} entries',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const Spacer(),
        TextButton(
          onPressed:
              _currentPage > 1
                  ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                  : null,
          style: TextButton.styleFrom(
            backgroundColor:
                _currentPage > 1
                    ? AppColors.secondary.withOpacity(0.1)
                    : Colors.grey.shade200,
          ),
          child: Text(
            'Previous',
            style: TextStyle(
              color: _currentPage > 1 ? AppColors.secondary : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            _currentPage.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed:
              _currentPage < _totalPages
                  ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                  : null,
          style: TextButton.styleFrom(
            backgroundColor:
                _currentPage < _totalPages
                    ? AppColors.secondary.withOpacity(0.1)
                    : Colors.grey.shade200,
          ),
          child: Text(
            'Next',
            style: TextStyle(
              color:
                  _currentPage < _totalPages
                      ? AppColors.secondary
                      : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
