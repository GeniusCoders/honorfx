import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/models/ib_program/my_clients_response.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:intl/intl.dart';

class ClientTable extends StatefulWidget {
  final List<ClientData> data;

  const ClientTable({Key? key, required this.data}) : super(key: key);

  @override
  State<ClientTable> createState() => _ClientTableState();
}

class _ClientTableState extends State<ClientTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  int _entriesPerPage = 10;
  int _currentPage = 1;
  String _searchQuery = '';
  List<ClientData> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
  }

  @override
  void didUpdateWidget(ClientTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _filterData();
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _filterData() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredData = widget.data;
        _currentPage = 1;
      });
    } else {
      setState(() {
        _filteredData =
            widget.data.where((item) {
              final searchLower = _searchQuery.toLowerCase();
              return item.name.toLowerCase().contains(searchLower) ||
                  item.email.toLowerCase().contains(searchLower) ||
                  item.phone.toLowerCase().contains(searchLower) ||
                  item.mt5id.toLowerCase().contains(searchLower);
            }).toList();
        _currentPage = 1;
      });
    }
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
          _buildSearchAndPageSize(),
          SizedBox(height: 16.h),
          _buildTable(),
          SizedBox(height: 16.h),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildSearchAndPageSize() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16.w,
      runSpacing: 16.h,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Show '),
            DropdownButton<int>(
              value: _entriesPerPage,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _entriesPerPage = newValue;
                    _currentPage = 1;
                  });
                }
              },
              items:
                  [10, 25, 50, 100].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
              underline: Container(height: 1.h, color: Colors.grey.shade300),
            ),
            Text(' entries'),
          ],
        ),
        Container(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search:',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterData();
            },
          ),
        ),
      ],
    );
  }

  int get _totalPages {
    return (_filteredData.length / _entriesPerPage).ceil();
  }

  List<ClientData> get _paginatedData {
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
    final screenWidth = MediaQuery.of(context).size.width;

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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: screenWidth - 64, // Account for container padding
              ),
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: MaterialStateProperty.all(
                  Colors.grey.shade100,
                ),
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
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('MT5 ID')),
                  DataColumn(label: Text('Total Lots')),
                  DataColumn(label: Text('Total Commission')),
                  DataColumn(label: Text('IB Name')),
                  DataColumn(label: Text('Registration Date')),
                ],
                rows: List.generate(_paginatedData.length, (index) {
                  final item = _paginatedData[index];
                  try {
                    final DateTime parsedDate = DateFormat(
                      'yyyy-MM-dd',
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
                        DataCell(
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.2,
                            ),
                            child: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.25,
                            ),
                            child: Text(
                              item.mt5id,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(item.totalLots)),
                        DataCell(
                          Text(
                            '\$${item.totalComm}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.2,
                            ),
                            child: Text(
                              item.ibName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(formattedDate)),
                      ],
                    );
                  } catch (e) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            (index + 1 + (_currentPage - 1) * _entriesPerPage)
                                .toString(),
                          ),
                        ),
                        DataCell(
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.2,
                            ),
                            child: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.25,
                            ),
                            child: Text(
                              item.mt5id,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(item.totalLots)),
                        DataCell(
                          Text(
                            '\$${item.totalComm}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.2,
                            ),
                            child: Text(
                              item.ibName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(item.date)),
                      ],
                    );
                  }
                }),
              ),
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

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Text(
          'Showing $showingStart to $showingEnd of ${_filteredData.length} entries',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
        ),
      ],
    );
  }
}
