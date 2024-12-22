import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/core/helpers/device_storage_helper.dart';
import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/custom_text_form_field.dart';
import 'package:envirosense/presentation/widgets/device_data_list.dart';
import 'package:flutter/material.dart';

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
  late final RoomController _roomController = RoomController();
  late final DeviceStorageHelper _deviceStorageHelper = DeviceStorageHelper();
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);
  bool _isLoading = true;
  Device? _device;
  String? _error;
  String? _selectedRoomId;

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
      final device =
          await _deviceController.getDevice(widget.deviceId, _buildingId);

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
                onPressed: _showRenameDeviceDialog,
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.swap_horiz,
                label: 'Change Room',
                onPressed: _showChangeRoomDialog,
                color: AppColors.secondaryColor,
                isWarning: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Device',
                onPressed: _showRemoveDeviceDialog,
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
            ? Colors.red.withOpacity(0.4)
            : isWarning
                ? Colors.orange.withOpacity(0.4)
                : isNeutral
                    ? Colors.grey.withOpacity(0.4)
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

  Future<void> _showRenameDeviceDialog() async {
    final TextEditingController inputController =
        TextEditingController(text: widget.deviceName);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
                'Rename Device',
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
                labelText: 'Device Name',
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
                            final deviceIdentifier = _device?.identifier;

                            if (deviceIdentifier == null) {
                              throw Exception('Device identifier not found');
                            }

                            await _deviceStorageHelper.setDeviceName(
                                deviceIdentifier, inputController.text);

                            setState(() {
                              widget.deviceName = inputController.text;
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

  Future<void> _showChangeRoomDialog() async {
    setState(() {
      _selectedRoomId = _device?.room?.id;
    });

    final rooms = await _roomController.getRooms();

    if (!mounted) return;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Room',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _device?.room?.name ?? "Unknown Room",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select New Room',
                        labelStyle: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.secondaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.secondaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.secondaryColor, width: 2),
                        ),
                      ),
                      dropdownColor: AppColors.secondaryColor,
                      value: _selectedRoomId,
                      selectedItemBuilder: (context) => [
                        ...rooms.map((room) => DropdownMenuItem(
                              value: room.id,
                              child: Text(
                                room.name,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            )),
                      ],
                      items: [
                        ...rooms.map((room) => DropdownMenuItem(
                              value: room.id,
                              child: Row(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      return Text(
                                        room.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: room.id == _selectedRoomId
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      );
                                    },
                                  ),
                                  if (room.id == _device?.room?.id) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Current room',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomId = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.secondaryColor,
                        size: 30,
                      ),
                    ),
                  ],
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
                            side: const BorderSide(
                                color: AppColors.secondaryColor),
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
                          onPressed: _selectedRoomId == _device?.room?.id
                              ? null
                              : () async {
                                  await handleRoomChange();
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
      ),
    );
  }

  Future<void> handleRoomChange() async {
    if (_selectedRoomId == null || _selectedRoomId == _device?.room?.id) {
      return;
    }

    try {
      final currentRoomId = _device?.room?.id;

      if (currentRoomId == null) return;

      await _roomController.removeDeviceFromRoom(currentRoomId, _device?.id);
      await _roomController.addDeviceToRoom(_selectedRoomId, _device?.id);

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room changed successfully')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change room: $_error')),
      );
    }
  }

  Future<void> _handleDeviceRemoval() async {
    if (_device?.id == null) return;

    try {
      final deviceId = _device?.id;

      if (deviceId == null) {
        throw Exception('Device identifier not found');
      }

      await _deviceController.deleteDevice(deviceId, _buildingId);

      Navigator.pop(context);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device removed successfully')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove device: $_error')),
      );
    }
  }

  Future<void> _showRemoveDeviceDialog() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
                'Remove Device',
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
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Are you sure you want to remove '),
                    TextSpan(
                      text: widget.deviceName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const TextSpan(text: ' from this room?'),
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
                          await _handleDeviceRemoval();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
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
}
