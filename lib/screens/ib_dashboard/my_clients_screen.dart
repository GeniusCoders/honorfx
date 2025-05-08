import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_cubit.dart';
import 'package:honorfx/cubit/ib_dashboard/ib_dashboard_state.dart';
import 'package:honorfx/injection.dart';
import 'package:honorfx/models/ib_program/my_clients_response.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/client_level_tabs.dart';
import 'package:honorfx/screens/ib_dashboard/widgets/client_table.dart';
import 'package:honorfx/widgets/custom_app_bar.dart';

class MyClientsScreen extends StatefulWidget {
  const MyClientsScreen({Key? key}) : super(key: key);

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {
  final IbDashboardCubit _ibDashboardCubit = getIt<IbDashboardCubit>();
  int _selectedLevel = 1;

  // Store client data for each level
  List<ClientData>? _level1Clients;
  List<ClientData>? _level2Clients;
  List<ClientData>? _level3Clients;
  List<ClientData>? _level4Clients;
  List<ClientData>? _level5Clients;
  List<ClientData>? _level6Clients;
  List<ClientData>? _level7Clients;

  // Summary data for display in tabs
  Map<String, String> _summaryData = {
    'ibName': '',
    'totalLots': '0',
    'totalCommission': '0',
    'deposit': '0',
    'withdraw': '0',
  };

  @override
  void initState() {
    super.initState();
    _loadClientsByLevel(_selectedLevel);
  }

  void _loadClientsByLevel(int level) {
    switch (level) {
      case 1:
        _ibDashboardCubit.getMyClientsLevel1();
        break;
      case 2:
        _ibDashboardCubit.getMyClientsLevel2();
        break;
      case 3:
        _ibDashboardCubit.getMyClientsLevel3();
        break;
      case 4:
        _ibDashboardCubit.getMyClientsLevel4();
        break;
      case 5:
        _ibDashboardCubit.getMyClientsLevel5();
        break;
      case 6:
        _ibDashboardCubit.getMyClientsLevel6();
        break;
      case 7:
        _ibDashboardCubit.getMyClientsLevel7();
        break;
    }
  }

  void _onLevelSelected(int level) {
    setState(() {
      _selectedLevel = level;
    });

    // Check if we already have data for this level
    final clientsForLevel = _getClientsForLevel(level);
    if (clientsForLevel == null) {
      _loadClientsByLevel(level);
    } else {
      // Update summary data for the selected level even if we already have the data
      _updateSummaryData(clientsForLevel);
    }
  }

  List<ClientData>? _getClientsForLevel(int level) {
    switch (level) {
      case 1:
        return _level1Clients;
      case 2:
        return _level2Clients;
      case 3:
        return _level3Clients;
      case 4:
        return _level4Clients;
      case 5:
        return _level5Clients;
      case 6:
        return _level6Clients;
      case 7:
        return _level7Clients;
      default:
        return null;
    }
  }

  // Helper method to ensure summary data is synchronized with current level
  void _ensureSummaryDataSync() {
    final clientsForLevel = _getClientsForLevel(_selectedLevel);
    if (clientsForLevel != null) {
      _updateSummaryData(clientsForLevel);
    }
  }

  void _updateSummaryData(List<ClientData> clients) {
    // Calculate totals
    double totalLots = 0;
    double totalCommission = 0;
    String ibName = '';

    if (clients.isNotEmpty) {
      for (var client in clients) {
        totalLots += double.tryParse(client.totalLots) ?? 0;
        totalCommission += double.tryParse(client.totalComm) ?? 0;
      }

      // Only use the ibName if we have clients
      ibName = clients.first.ibName;
    }

    setState(() {
      _summaryData = {
        'ibName': ibName,
        'totalLots': totalLots.toStringAsFixed(2),
        'totalCommission': totalCommission.toStringAsFixed(2),
        'deposit': '0', // This would need to come from another API
        'withdraw': '0', // This would need to come from another API
      };
    });

    debugPrint("Updated summary data for level $_selectedLevel: $_summaryData");
  }

  @override
  Widget build(BuildContext context) {
    // Always ensure summary data is in sync with the current level
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureSummaryDataSync();
    });

    return Scaffold(
      appBar: CustomAppBar(title: 'My Clients'),
      body: BlocConsumer<IbDashboardCubit, IbDashboardState>(
        bloc: _ibDashboardCubit,
        listener: (context, state) {
          if (state is MyClientsLevel1Loaded) {
            setState(() {
              _level1Clients = state.data;
            });
            if (_selectedLevel == 1) {
              _updateSummaryData(state.data);
            }
          } else if (state is MyClientsLevel2Loaded) {
            setState(() {
              _level2Clients = state.data;
            });
            if (_selectedLevel == 2) {
              _updateSummaryData(state.data);
            }
          } else if (state is MyClientsLevel3Loaded) {
            setState(() {
              _level3Clients = state.data;
            });
            if (_selectedLevel == 3) {
              _updateSummaryData(state.data);
            }
          } else if (state is MyClientsLevel4Loaded) {
            setState(() {
              _level4Clients = state.data;
            });
            if (_selectedLevel == 4) {
              _updateSummaryData(state.data);
            }
          } else if (state is MyClientsLevel5Loaded) {
            setState(() {
              _level5Clients = state.data;
            });
            if (_selectedLevel == 5) {
              _updateSummaryData(state.data);
            }
          } else if (state is MyClientsLevel6Loaded) {
            setState(() {
              _level6Clients = state.data;
            });
            if (_selectedLevel == 6) {
              _updateSummaryData(state.data);
            }
          } else if (state is MyClientsLevel7Loaded) {
            setState(() {
              _level7Clients = state.data;
            });
            if (_selectedLevel == 7) {
              _updateSummaryData(state.data);
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is MyClientsLoading;
          final hasError = state is MyClientsError;
          final errorMessage =
              hasError ? (state as MyClientsError).message : '';

          final currentLevelClients = _getClientsForLevel(_selectedLevel);

          return RefreshIndicator(
            onRefresh: () async {
              _loadClientsByLevel(_selectedLevel);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClientLevelTabs(
                    selectedLevel: _selectedLevel,
                    onLevelSelected: _onLevelSelected,
                    summaryData: _summaryData,
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 24.h),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (hasError)
                    Center(child: Text(errorMessage))
                  else if (currentLevelClients != null)
                    currentLevelClients.isEmpty
                        ? const Center(
                          child: Text(
                            'No clients found for this level',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                        : ClientTable(data: currentLevelClients)
                  else
                    const Center(
                      child: Text(
                        'Select a level to view clients',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
