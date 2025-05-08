import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/models/ib_program/my_commission_response.dart';
import 'package:honorfx/utils/colors.dart';

class MyCommissionTable extends StatefulWidget {
  final List<MyCommissionItem> data;

  const MyCommissionTable({Key? key, required this.data}) : super(key: key);

  @override
  State<MyCommissionTable> createState() => _MyCommissionTableState();
}

class _MyCommissionTableState extends State<MyCommissionTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _paginationScrollController = ScrollController();
  int _currentPage = 1;
  final int _entriesPerPage = 10;
  List<MyCommissionItem> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
  }

  @override
  void didUpdateWidget(MyCommissionTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      setState(() {
        _filteredData = widget.data;
      });
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _paginationScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          SizedBox(height: 16.h),
          _buildTable(),
          SizedBox(height: 16.h),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'My Commission',
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  int get _totalPages {
    return (_filteredData.length / _entriesPerPage).ceil();
  }

  List<MyCommissionItem> get _paginatedData {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14.sp,
              ),
              dataTextStyle: TextStyle(color: Colors.black87, fontSize: 14.sp),
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('MT5 ID')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Order')),
                DataColumn(label: Text('Symbol')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Profit')),
                DataColumn(label: Text('Volume')),
                DataColumn(label: Text('My Commission')),
                DataColumn(label: Text('Type')),
              ],
              rows:
                  _paginatedData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isEvenRow = index % 2 == 0;

                    return DataRow(
                      color: MaterialStateProperty.all(
                        isEvenRow ? Colors.grey.shade50 : Colors.white,
                      ),
                      cells: [
                        DataCell(
                          Text(
                            ((_currentPage - 1) * _entriesPerPage + index + 1)
                                .toString(),
                          ),
                        ),
                        DataCell(Text(item.login)),
                        DataCell(Text(item.date)),
                        DataCell(Text(item.order)),
                        DataCell(Text(item.symbol)),
                        DataCell(Text(item.price)),
                        DataCell(Text(item.profit)),
                        DataCell(Text(item.volume)),
                        DataCell(Text(item.commission)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  item.type.toLowerCase() == 'buy'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.type,
                              style: TextStyle(
                                color:
                                    item.type.toLowerCase() == 'buy'
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Entries count display
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Showing ${_filteredData.isEmpty ? 0 : (_currentPage - 1) * _entriesPerPage + 1} to ${_currentPage * _entriesPerPage > _filteredData.length ? _filteredData.length : _currentPage * _entriesPerPage} of ${_filteredData.length} entries',
            style: const TextStyle(color: Colors.black87),
          ),
        ),

        SizedBox(height: 12.h),

        // Pagination controls
        SizedBox(
          height: 40.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _paginationScrollController,
            child: Row(
              children: [
                _buildPaginationButton('Previous', _currentPage > 1, () {
                  if (_currentPage > 1) {
                    setState(() {
                      _currentPage--;
                    });
                  }
                }),
                ...List.generate(_totalPages, (index) {
                  final pageNumber = index + 1;
                  final isActive = pageNumber == _currentPage;

                  return _buildPageButton(pageNumber.toString(), isActive, () {
                    setState(() {
                      _currentPage = pageNumber;
                    });
                  });
                }),
                _buildPaginationButton('Next', _currentPage < _totalPages, () {
                  if (_currentPage < _totalPages) {
                    setState(() {
                      _currentPage++;
                    });
                  }
                }),
              ],
            ),
          ),
        ),

        // Scrollbar for pagination
        SizedBox(
          height: 4.h,
          child: Scrollbar(
            controller: _paginationScrollController,
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(2),
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: Container(height: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationButton(
    String text,
    bool isEnabled,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: isEnabled ? AppColors.black : Colors.grey,
        disabledForegroundColor: Colors.grey.shade400,
      ),
      child: Text(text),
    );
  }

  Widget _buildPageButton(String text, bool isActive, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: !isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? AppColors.secondary : Colors.white,
          foregroundColor: isActive ? Colors.white : AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: isActive ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          minimumSize: Size(40.w, 40.h),
          padding: EdgeInsets.zero,
        ),
        child: Text(text),
      ),
    );
  }
}
