import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/device_data.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/controllers/device_data_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/core/custom_app_bar.dart';
import 'package:envirosense/presentation/widgets/data/device_data_list.dart';
import 'package:envirosense/presentation/widgets/feedback/loading_error_widget.dart';
import 'package:envirosense/presentation/widgets/tabs/device_actions_tab.dart';
import 'package:envirosense/presentation/widgets/tabs/device_controls_tab.dart';
import 'package:envirosense/services/device_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeviceOverviewScreen extends StatefulWidget {
  String deviceName;
  final String deviceId;

  DeviceOverviewScreen(
      {super.key, required this.deviceName, required this.deviceId});

  @override
  State<DeviceOverviewScreen> createState() => _DeviceOverviewScreenState();
}

class _DeviceOverviewScreenState extends State<DeviceOverviewScreen>
    with SingleTickerProviderStateMixin {
  late final DeviceController _deviceController = DeviceController();
  late final DeviceService _deviceService = DeviceService(_deviceController);
  late final DeviceDataController _deviceDataController =
      DeviceDataController();
  late final RoomController _roomController = RoomController();
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);

  bool _isLoading = true;
  Device? _device;
  List<DeviceData> _deviceData = [];
  String? _error;
  final String _buildingId =
      "gox5y6bsrg640qb11ak44dh0"; //hardcoded here, but later outside PoC we would retrieve this from user that is linked to what building

  final List<Tab> _tabs = const [
    Tab(text: 'Data History'),
    Tab(text: 'Controls'),
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
      final device =
          await _deviceController.getDevice(widget.deviceId, _buildingId);
      final deviceData = await _deviceDataController
          .getDeviceDataByDeviceId(device.identifier);
      setState(() {
        _device = device;
        _deviceData = deviceData;
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
        appBar: CustomAppBar(
          title: widget.deviceName,
          tabController: _tabController,
          tabs: _tabs,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: LoadingErrorWidget(
          isLoading: _isLoading,
          error: _error,
          onRetry: _loadData,
          child: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: _loadData,
                color: AppColors.secondaryColor,
                child: _buildOverviewTab(),
              ),
              _buildControlsTab(),
              _buildActionsTab(),
            ],
          ),
        ));
  }

  Widget _buildOverviewTab() {
    return DeviceDataList(
      deviceData: _deviceData,
      onRefresh: _loadData,
    );
  }

  Widget _buildControlsTab() {
    return DeviceControlsTab(
      deviceId: widget.deviceId,
      deviceController: _deviceController,
    );
  }

  Widget _buildActionsTab() {
    if (_device == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return DeviceActionsTab(
      deviceCustomName: widget.deviceName,
      deviceId: _device?.id,
      deviceIdentifier: _device?.identifier,
      buildingId: _buildingId,
      deviceService: _deviceService,
      roomController: _roomController,
      currentRoomId: _device?.room?.id,
      currentRoomName: _device?.room?.name ?? 'Not assigned to a room',
      onDeviceRenamed: (newName) {
        setState(() {
          widget.deviceName = newName;
        });
      },
      onDeviceRemoved: () => Navigator.pop(context),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
