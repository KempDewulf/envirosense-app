import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/widgets/device_data_list.dart';
import 'package:flutter/material.dart';

class DeviceOverviewScreen extends StatefulWidget {
  final String deviceName;
  final String deviceId;

  const DeviceOverviewScreen(
      {super.key, required this.deviceName, required this.deviceId});

  @override
  State<DeviceOverviewScreen> createState() => _DeviceOverviewScreenState();
}

class _DeviceOverviewScreenState extends State<DeviceOverviewScreen>
    with SingleTickerProviderStateMixin {
  late final DeviceController _controller = DeviceController();
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);
  bool _isLoading = true;
  Device? _device;
  String? _error;

  final String _buildingId =
      "gox5y6bsrg640qb11ak44dh0"; //hardcoded here, but later outside PoC we would retrieve this from user that is linked to what building

  final List<Tab> _tabs = const [
    Tab(text: 'Data History'),
    Tab(text: 'Actions'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final device = await _controller.getDevice(widget.deviceId, _buildingId);

      setState(() {
        _device = device;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
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
        title: Text(
          widget.deviceName,
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
          child: DeviceDataList(deviceData: _device?.deviceData ?? []),
        ),
        RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.secondaryColor,
          child: _buildActionsTab(),
        ),
      ],
    );
  }

  Widget _buildActionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildActionButton(
                icon: Icons.edit,
                label: 'Rename Device',
                onPressed: () {},
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.swap_horiz,
                label: 'Change Room',
                onPressed: () {},
                color: AppColors.secondaryColor,
                isWarning: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Device',
                onPressed: () {},
                color: Colors.red,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isDestructive = false,
    bool isWarning = false,
    bool isNeutral = false,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isDestructive
            ? Colors.red.withOpacity(0.2)
            : isWarning
                ? Colors.orange.withOpacity(0.2)
                : isNeutral
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? Colors.red
                        : isWarning
                            ? Colors.orange
                            : Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDestructive
                      ? Colors.red
                      : isWarning
                          ? Colors.orange
                          : Colors.black54,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
