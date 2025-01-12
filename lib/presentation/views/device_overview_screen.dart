import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/helpers/connectivity_helper.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/device_config.dart';
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

  DeviceOverviewScreen({super.key, required this.deviceName, required this.deviceId});

  @override
  State<DeviceOverviewScreen> createState() => _DeviceOverviewScreenState();
}

class _DeviceOverviewScreenState extends State<DeviceOverviewScreen> with SingleTickerProviderStateMixin {
  late final DeviceController _deviceController = DeviceController();
  late final DeviceService _deviceService = DeviceService(_deviceController);
  late final DeviceDataController _deviceDataController = DeviceDataController();
  late final RoomController _roomController = RoomController();
  late final TabController _tabController = TabController(length: 3, vsync: this);

  bool _isLoading = true;
  final Map<String, bool> _loadingConfig = {
    'ui-mode': false,
    'brightness': false,
  };

  String? _deviceName;
  Device? _device;
  DeviceConfig? _deviceConfig;
  List<DeviceData> _deviceData = [];
  String? _error;
  final String _buildingId =
      "gox5y6bsrg640qb11ak44dh0"; //hardcoded here, but later outside PoC we would retrieve this from user that is linked to what building

  List<Tab> _buildTabs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      Tab(text: l10n.deviceDataHistory),
      Tab(text: l10n.deviceControls),
      Tab(text: l10n.deviceActions),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    if (!mounted) return;

    setState(() {
      _loadingConfig['ui-mode'] = true;
      _loadingConfig['brightness'] = true;
    });

    try {
      final config = await _deviceController.getDeviceConfig(widget.deviceId);
      if (!mounted) return;

      setState(() {
        _deviceConfig = config;
        _loadingConfig['ui-mode'] = false;
        _loadingConfig['brightness'] = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _deviceConfig = null;
        _loadingConfig['ui-mode'] = false;
        _loadingConfig['brightness'] = false;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _deviceName = widget.deviceName;
      });

      final hasConnection = await ConnectivityHelper.checkConnectivity(
        context,
        setError: (error) => setState(() => _error = error),
        setLoading: (loading) => setState(() => _isLoading = loading),
      );

      if (!hasConnection) return;

      final device = await _deviceController.getDevice(widget.deviceId, _buildingId);
      final deviceData = await _deviceDataController.getDeviceDataByDeviceId(device.identifier);

      if (!mounted) return;

      setState(() {
        _device = device;
        _deviceData = deviceData;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'no_connection';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: CustomAppBar(
          title: _deviceName ?? _device?.identifier ?? l10n.unknownDevice,
          tabController: _tabController,
          tabs: _buildTabs(context),
          onBackPressed: () => Navigator.pop(context, true),
        ),
        body: LoadingErrorWidget(
          isLoading: _isLoading,
          error: _error,
          onRetry: () async {
            await _loadData();
            await _loadConfig();
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _loadingConfig['ui-mode'] = true;
                    _loadingConfig['brightness'] = true;
                  });
                  await _loadData();
                  await _loadConfig();
                },
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
      deviceConfig: _deviceConfig,
      loadingConfig: _loadingConfig,
    );
  }

  Widget _buildActionsTab() {
    final l10n = AppLocalizations.of(context)!;

    if (_device == null) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor)));
    }

    return DeviceActionsTab(
      deviceCustomName: _deviceName,
      deviceId: _device?.id,
      deviceIdentifier: _device?.identifier,
      buildingId: _buildingId,
      deviceService: _deviceService,
      roomController: _roomController,
      currentRoomId: _device?.room?.id,
      currentRoomName: _device?.room?.name ?? l10n.notAssignedToRoom,
      onDeviceRenamed: (newName) {
        setState(() {
          _deviceName = newName;
        });
      },
      onDeviceRemoved: () => Navigator.pop(context, true),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
