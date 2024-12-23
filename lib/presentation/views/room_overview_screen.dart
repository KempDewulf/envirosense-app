import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/domain/entities/air_data.dart';
import 'package:envirosense/domain/entities/room_air_quality.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/outside_air_data_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/custom_text_form_field.dart';
import 'package:envirosense/presentation/widgets/data_display_box.dart';
import 'package:envirosense/presentation/widgets/device_list.dart';
import 'package:envirosense/presentation/widgets/enviro_score_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoomOverviewScreen extends StatefulWidget {
  String roomName;
  final String roomId;

  RoomOverviewScreen({super.key, required this.roomName, required this.roomId});

  @override
  State<RoomOverviewScreen> createState() => _RoomOverviewScreenState();
}

class _RoomOverviewScreenState extends State<RoomOverviewScreen>
    with SingleTickerProviderStateMixin {
  late final RoomController _roomController = RoomController();
  late final OutsideAirDataController _outsideAirController =
      OutsideAirDataController();
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);

  bool _isLoading = true;
  bool _showRoomData = true;
  bool _roomHasDeviceData = false;
  double _targetTemperature = 22.0; // hardcoded for now

  Room? _room;
  RoomAirQuality? _airQuality;
  AirData? _outsideAirData;
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
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final room = await _roomController.getRoom(widget.roomId);
      final airQuality = await _roomController.getRoomAirQuality(widget.roomId);
      final outsideAirData =
          await _outsideAirController.getOutsideAirData(city);
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
        _buildActionsTab(),
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
          type: 'Room',
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
                                  ? AppColors.whiteColor
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
                                  ? AppColors.whiteColor
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
                    ? _airQuality?.airData ?? AirData(temperature: 0, humidity: 0, gasPpm: 0)
                    : _outsideAirData!,
              )
            ],
          ),
        ),
      ],
    );
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
            color: AppColors.blackColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isDestructive
            ? AppColors.redColor.withOpacity(0.4)
            : isWarning
                ? AppColors.secondaryColor.withOpacity(0.4)
                : isNeutral
                    ? AppColors.accentColor.withOpacity(0.4)
                    : AppColors.whiteColor,
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
                        ? AppColors.redColor
                        : isWarning
                            ? AppColors.secondaryColor
                            : AppColors.blackColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDestructive
                      ? AppColors.redColor
                      : isWarning
                          ? AppColors.secondaryColor
                          : AppColors.blackColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
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
                label: 'Rename Room',
                onPressed: _showRenameRoomDialog,
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Room',
                onPressed: _showRemoveRoomDialog,
                color: AppColors.redColor,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showRenameRoomDialog() async {
    final TextEditingController inputController =
        TextEditingController(text: widget.roomName);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Rename Room',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextFormField(
                controller: inputController,
                labelText: 'Room Name',
                floatingLabelCustomStyle: const TextStyle(
                  color: AppColors.secondaryColor,
                ),
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Divider(color: AppColors.accentColor.withOpacity(0.2)),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side:
                              const BorderSide(color: AppColors.secondaryColor),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          if (inputController.text.isNotEmpty) {
                            final roomName = _room?.name;

                            if (roomName == null) {
                              throw Exception('Room name not found');
                            }

                            await _handleRoomRename(inputController.text);

                            setState(() {
                              widget.roomName = inputController.text;
                            });

                            Navigator.pop(context);
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRemoveRoomDialog() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Remove Room',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.blackColor,
                  ),
                  children: [
                    const TextSpan(text: 'Are you sure you want to remove '),
                    TextSpan(
                      text: widget.roomName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const TextSpan(text: ' from this building?'),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.accentColor.withOpacity(0.2)),
            // Action buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side:
                              const BorderSide(color: AppColors.secondaryColor),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await _handleRoomRemoval();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRoomRename(String newRoomName) async {
    if (_room?.id == null) return;

    try {
      final roomId = _room?.id;

      if (roomId == null) {
        throw Exception('Room id not found');
      }

      await _roomController.updateRoom(roomId, newRoomName);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room renamed successfully')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to rename (update) room: $_error')),
      );
    }
  }

  Future<void> _handleRoomRemoval() async {
    if (_room?.id == null) return;

    try {
      final roomId = _room?.id;

      if (roomId == null) {
        throw Exception('Room id not found');
      }

      await _roomController.deleteRoom(roomId);

      Navigator.pop(context);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room removed successfully')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove room: $_error')),
      );
    }
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
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Target Temperature',
                        style: TextStyle(
                          color: AppColors.accentColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            iconSize: 28,
                            color: AppColors.secondaryColor,
                            onPressed: () {
                              setState(() => currentTargetTemp =
                                  (currentTargetTemp - 0.5).clamp(16, 30));
                            },
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${currentTargetTemp.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 28,
                            color: AppColors.secondaryColor,
                            onPressed: () {
                              setState(() => currentTargetTemp =
                                  (currentTargetTemp + 0.5).clamp(16, 30));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 180,
                        child: FilledButton(
                          onPressed: () {
                            _targetTemperature = currentTargetTemp;
                            Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )),
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
