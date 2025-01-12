import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/enums/limit_type.dart';
import 'package:envirosense/core/helpers/connectivity_helper.dart';
import 'package:envirosense/core/helpers/unit_helper.dart';
import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/room_air_quality.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/controllers/outside_air_data_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:envirosense/presentation/widgets/lists/device_list.dart';
import 'package:envirosense/presentation/widgets/feedback/loading_error_widget.dart';
import 'package:envirosense/presentation/widgets/core/custom_app_bar.dart';
import 'package:envirosense/presentation/widgets/room_overview_content.dart';
import 'package:envirosense/presentation/widgets/tabs/room_actions_tab.dart';
import 'package:envirosense/presentation/widgets/bottom_sheets/target_temperature_sheet.dart';
import 'package:envirosense/services/room_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoomOverviewScreen extends StatefulWidget {
  String roomName;
  final String roomId;

  RoomOverviewScreen({super.key, required this.roomName, required this.roomId});

  @override
  State<RoomOverviewScreen> createState() => _RoomOverviewScreenState();
}

class _RoomOverviewScreenState extends State<RoomOverviewScreen> with SingleTickerProviderStateMixin {
  late final RoomController _roomController = RoomController();
  late final DeviceController _deviceController = DeviceController();
  late final OutsideAirDataController _outsideAirController = OutsideAirDataController();
  late final TabController _tabController = TabController(length: _tabs.length, vsync: this);

  bool _isLoading = true;
  final Map<String, bool> _loadingLimits = {
    'temperature': false,
  };

  bool _showRoomData = true;
  bool _roomHasDeviceData = false;

  Room? _room;
  RoomAirQuality? _airQuality;
  AirData? _outsideAirData;
  double? _targetTemperature;
  String? _error;
  String city = 'Brugge'; //TODO: later in poc we would get city from user

  final List<Tab> _tabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'Devices'),
    Tab(text: 'Actions'),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLimits('temperature');
  }

  Future<void> _loadLimits(String limitType) async {
    if (!mounted) return;

    setState(() => _loadingLimits[limitType] = true);
    try {
      final limits = await _roomController.getRoomLimits(widget.roomId);
      if (!mounted) return;

      setState(() {
        if (limitType == 'temperature') {
          _targetTemperature = limits.temperature;
        }
        _loadingLimits[limitType] = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (limitType == 'temperature') {
          _targetTemperature = null;
        }
        _loadingLimits[limitType] = false;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);

      final hasConnection = await ConnectivityHelper.checkConnectivity(
        context,
        setError: (error) => setState(() => _error = error),
        setLoading: (loading) => setState(() => _isLoading = loading),
      );

      if (!hasConnection) return;

      final room = await _roomController.getRoom(widget.roomId);
      final roomAirQuality = await _roomController.getRoomAirQuality(widget.roomId);

      if (!mounted) return;

      final outsideAirData = await _outsideAirController.getOutsideAirData(city);
      setState(() {
        _room = room;
        _airQuality = roomAirQuality;
        _outsideAirData = outsideAirData;
        _roomHasDeviceData = isDeviceDataAvailable();
        _showRoomData = _roomHasDeviceData;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        if (!mounted) return;
        _error = 'no_connection';
        _isLoading = false;
      });
    }
  }

  Future<void> _reloadRoomData() async {
    try {
      final room = await _roomController.getRoom(widget.roomId);

      setState(() {
        _room = room;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  bool isDeviceDataAvailable() {
    return _airQuality?.enviroScore != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _room?.name ?? widget.roomName,
        tabController: _tabController,
        tabs: _tabs,
        onBackPressed: () => Navigator.pop(context, true),
      ),
      body: LoadingErrorWidget(
        isLoading: _isLoading,
        error: _error,
        onRetry: () async {
          setState(() => _loadingLimits['temperature'] = true);
          await _loadData();
          await _loadLimits('temperature');
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await _loadData();
                await _loadLimits('temperature');
              },
              color: AppColors.secondaryColor,
              child: _buildOverviewTab(),
            ),
            RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.secondaryColor,
              child: DevicesList(devices: _room?.devices ?? []),
            ),
            _buildActionsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    if (_outsideAirData == null) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor)));
    }

    return RoomOverviewContent(
      airQuality: _airQuality,
      roomHasDeviceData: _roomHasDeviceData,
      targetTemperature: _targetTemperature,
      showRoomData: _showRoomData,
      outsideAirData: _outsideAirData,
      onSetTemperature: () => _showTargetTemperatureSheet(context),
      onDataToggle: (value) => setState(() => _showRoomData = value),
      isLoadingTemperature: _loadingLimits['temperature']!,
    );
  }

  Widget _buildActionsTab() {
    return RoomActionsTab(
      roomName: _room?.name ?? widget.roomName,
      roomId: _room?.id ?? '',
      roomService: RoomService(_roomController),
      onRoomRenamed: (newName) {
        _reloadRoomData();
      },
      onRoomRemoved: () => Navigator.pop(context, true),
    );
  }

  void _showTargetTemperatureSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => TargetTemperatureSheet(
              currentTemperature: _targetTemperature,
              onTemperatureChanged: _handleTemperatureLimitChanged,
            ));
  }

  void _handleTemperatureLimitChanged(double newTemperature) async {
    try {
      final hasConnection = await ConnectivityHelper.checkConnectivity(
        context,
        setError: (error) => setState(() => _error = error),
        setLoading: (loading) => setState(() => _isLoading = loading),
      );

      if (!hasConnection) return;

      if (!mounted) return;

      final allDeviceIds = _room?.devices?.map((device) => device.id).toList();

      if (allDeviceIds == null) {
        CustomSnackbar.showSnackBar(context, 'No devices found in this room');
      }

      allDeviceIds?.forEach((deviceId) async {
        await _deviceController.updateDeviceLimit(deviceId, LimitType.temperature, newTemperature);
      });

      setState(() => _targetTemperature = newTemperature);

      if (mounted) {
        final formattedTemp = await UnitConverter.formatTemperature(newTemperature);

        CustomSnackbar.showSnackBar(context, 'Temperature limit updated to $formattedTemp');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showSnackBar(context, 'Failed to update temperature limit');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
