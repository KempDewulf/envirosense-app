import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/device_list.dart';
import 'package:envirosense/presentation/widgets/enviro_score_card.dart';
import 'package:flutter/material.dart';
import '../controllers/RoomOverviewController.dart';

class RoomOverviewScreen extends StatefulWidget {
  final String roomName;

  const RoomOverviewScreen({super.key, required this.roomName});

  @override
  State<RoomOverviewScreen> createState() => _RoomOverviewScreenState();
}

class _RoomOverviewScreenState extends State<RoomOverviewScreen> with SingleTickerProviderStateMixin {
  late final RoomOverviewController _controller;
  late final TabController _tabController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = RoomOverviewController();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      await _controller.getRoomData(widget.roomName);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
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
        title: Text(widget.roomName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to room settings
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Devices'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
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
        _buildOverviewTab(),
        DevicesList(roomId: widget.roomName),
        _buildHistoryTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        EnviroScoreCard(
          score: _controller.getEnviroScore(),
          onInfoPressed: _showEnviroScoreInfo,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showTargetTemperatureSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.thermostat, color: AppColors.whiteColor),
              const SizedBox(width: 8),
              Text(
                'Set Target Temperature (${_controller.getTargetTemperature()}°C)',
                style: const TextStyle(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          child: DataDisplayBox(
            title: 'This Room',
            data: _controller.getRoomData(widget.roomName),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          child: DataDisplayBox(
            title: 'Outside',
            data: _controller.getOutsideData(),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return const Center(
      child: Text('Historical data coming soon'),
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
    double currentTemp = _controller.getTargetTemperature();
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
                      setState(() => currentTemp = (currentTemp - 0.5).clamp(16, 30));
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${currentTemp.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() => currentTemp = (currentTemp + 0.5).clamp(16, 30));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _controller.setTargetTemperature(currentTemp);
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

class DataDisplayBox extends StatelessWidget {
  final String title;
  final Map<String, Map<String, dynamic>>
      data; // Updated type to include status

  const DataDisplayBox({
    super.key,
    required this.title,
    required this.data,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return AppColors.greenColor;
      case 'bad':
        return AppColors.redColor;
      case 'medium':
        return AppColors.secondaryColor;
      default:
        return AppColors.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accentColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...data.entries.map((entry) => ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentColor,
                  ),
                ),
                trailing: Text(
                  entry.value['value'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(entry.value['status']),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
