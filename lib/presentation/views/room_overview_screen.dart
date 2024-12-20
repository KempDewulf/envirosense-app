import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/air_quality.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/outside_air_data_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/data_display_box.dart';
import 'package:envirosense/presentation/widgets/device_list.dart';
import 'package:envirosense/presentation/widgets/enviro_score_card.dart';
import 'package:flutter/material.dart';

class RoomOverviewScreen extends StatefulWidget {
  final String roomName;
  final String roomId;

  const RoomOverviewScreen(
      {super.key, required this.roomName, required this.roomId});

  @override
  State<RoomOverviewScreen> createState() => _RoomOverviewScreenState();
}

class _RoomOverviewScreenState extends State<RoomOverviewScreen> with SingleTickerProviderStateMixin {
  late final RoomController _controller = RoomController();
  late final OutsideAirDataController _outsideAirController = OutsideAirDataController();
  late final TabController _tabController = TabController(length: _tabs.length, vsync: this);

  bool _isLoading = true;
  bool _showRoomData = true;
  bool _roomHasDeviceData = false;
  double _targetTemperature = 22.0; // hardcoded for now

  Room? _room;
  AirQuality? _airQuality;
  AirData? _outsideAirData;
  String? _error;
  String city = 'Brugge'; //TODO: get city from user

  final List<Tab> _tabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'Devices'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final room = await _controller.getRoom(widget.roomId);
      final airQuality = await _controller.getAirQuality(widget.roomId);
      final outsideAirData = await _outsideAirController.getOutsideAirData(city);
      setState(() {
        _room = room;
        _airQuality = airQuality;
        _outsideAirData = outsideAirData;
        _isLoading = false;
        _roomHasDeviceData = isDeviceDataAvailable();
        _showRoomData = _roomHasDeviceData;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  bool isDeviceDataAvailable() {
    return _airQuality?.enviroScore != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded),
          iconSize: 35,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _room?.name ?? widget.roomName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.whiteColor),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: AppColors.secondaryColor,
          indicatorColor: AppColors.secondaryColor,
          unselectedLabelColor: AppColors.whiteColor,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.secondaryColor,
          child: _buildOverviewTab(),
        ),
        RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.secondaryColor,
          child: DevicesList(devices: _room?.devices ?? []),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EnviroScoreCard(
          score: _airQuality?.enviroScore ?? 0,
          onInfoPressed: _showEnviroScoreInfo,
          isDeviceDataAvailable: _roomHasDeviceData,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _showTargetTemperatureSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.thermostat, color: AppColors.secondaryColor),
              const SizedBox(width: 8),
              Text(
                'Set Target Temperature ($_targetTemperature°C)',
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Toggle buttons
              Container(
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _roomHasDeviceData
                            ? () => setState(() => _showRoomData = true)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _showRoomData && _roomHasDeviceData
                                ? AppColors.secondaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Room Data',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _showRoomData && _roomHasDeviceData
                                  ? Colors.white
                                  : AppColors.secondaryColor.withOpacity(
                                      _roomHasDeviceData ? 1.0 : 0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showRoomData = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_showRoomData
                                ? AppColors.secondaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'Outside Data',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_showRoomData
                                  ? Colors.white
                                  : AppColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              DataDisplayBox(
                key: ValueKey(_showRoomData),
                title:
                    _showRoomData ? 'Room Environment' : 'Outside Environment',
                data: _showRoomData && _roomHasDeviceData
                    ? _airQuality!.airData
                    : _outsideAirData!,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _showEnviroScoreInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About EnviroScore'),
        content: const Text(
          'EnviroScore is a measure of environmental quality based on various factors including air quality, temperature, and humidity levels in your space.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showTargetTemperatureSheet(BuildContext context) {
    double currentTargetTemp = _targetTemperature;
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Set Target Temperature',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() => currentTargetTemp =
                          (currentTargetTemp - 0.5).clamp(16, 30));
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${currentTargetTemp.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() => currentTargetTemp =
                          (currentTargetTemp + 0.5).clamp(16, 30));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _targetTemperature = currentTargetTemp;
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
