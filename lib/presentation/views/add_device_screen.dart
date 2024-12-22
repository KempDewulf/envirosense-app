import 'package:envirosense/core/helpers/icon_helper.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/custom_text_form_field.dart';
import 'package:envirosense/presentation/widgets/qr_code_scanner.dart';
import 'package:envirosense/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../core/constants/colors.dart';
import 'package:envirosense/services/logging_service.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _deviceNameController = TextEditingController();
  final RoomController _roomController = RoomController();
  final DeviceController _deviceController = DeviceController();
  final DatabaseService _databaseService = DatabaseService();

  String? _deviceIdentifierCode;
  Room? _selectedRoom;
  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];
  bool _isSaving = false;

  bool get _isFormComplete {
    return _deviceIdentifierCode != null &&
        _selectedRoom != null &&
        _deviceNameController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _getRooms();
    _searchController.addListener(_filterRooms);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  void _filterRooms() {
    setState(() {
      _filteredRooms = _rooms
          .where((room) => room.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _getRooms() async {
    try {
      final rooms = await _roomController.getRooms();
      if (mounted) {
        setState(() {
          _rooms = rooms;
          _filteredRooms = rooms;
        });
      }
    } catch (e) {
      LoggingService.logError('Failed to fetch rooms: $e', e);
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Failed to load rooms')),
        );
      }
    }
  }

  Future<void> _addDeviceToRoom() async {
    if (!_isFormComplete || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _deviceController.addDevice(
          _selectedRoom?.id, _deviceIdentifierCode);
      await _databaseService.setDeviceName(_deviceIdentifierCode!, _deviceNameController.text);

      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Device assigned successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      LoggingService.logError('Failed to assign device: $e', e);
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Failed to assign device: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded),
          iconSize: 35,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: const Text(
          'Add Device',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_deviceIdentifierCode == null)
              const Text(
                'Scan the QR Code on the device.\nYour device will connect automatically.',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.accentColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: _deviceIdentifierCode == null ? 28.0 : 6.0),
            Expanded(
              child: Center(
                child: _deviceIdentifierCode == null
                    ? DottedBorder(
                        color: AppColors.secondaryColor,
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        dashPattern: const [6, 3],
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: QrCodeScanner(setResult: (result) {
                            if (mounted) {
                              setState(() => _deviceIdentifierCode = result);
                            }
                          }),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter device name',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: _deviceNameController,
                            labelText: 'Enter a name for this device',
                            floatingLabelBehaviour: FloatingLabelBehavior.never,
                            onChanged: (value) => setState(() {}),
                            labelColor: AppColors.accentColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            borderColor: AppColors.accentColor,
                            floatingLabelCustomStyle: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            textStyle: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Select a room',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: _searchController,
                            labelText: 'Search rooms',
                            floatingLabelBehaviour: FloatingLabelBehavior.never,
                            labelColor: AppColors.accentColor,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            borderColor: AppColors.accentColor,
                            floatingLabelCustomStyle: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            textStyle: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: GridView.builder(
                              itemCount: _filteredRooms.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 25,
                                crossAxisSpacing: 15,
                                childAspectRatio: 1 / 1.15,
                              ),
                              itemBuilder: (context, index) {
                                final room = _filteredRooms[index];
                                final isSelected = _selectedRoom == room;

                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _selectedRoom = room;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.secondaryColor
                                              : AppColors.lightGrayColor,
                                          shape: BoxShape.circle,
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors
                                                        .secondaryColor
                                                        .withOpacity(0.6),
                                                    spreadRadius: 2,
                                                    blurRadius: 6,
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Icon(
                                          getIconData(room.roomType.icon),
                                          color: isSelected
                                              ? AppColors.whiteColor
                                              : AppColors.accentColor,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Tooltip(
                                        message: room.name,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          room.name,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isSelected
                                                ? AppColors.secondaryColor
                                                : AppColors.accentColor,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormComplete
                                    ? AppColors.secondaryColor
                                    : AppColors.lightGrayColor,
                                foregroundColor: AppColors.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                disabledBackgroundColor:
                                    AppColors.lightGrayColor,
                                disabledForegroundColor: AppColors.accentColor,
                              ),
                              onPressed:
                                  !_isFormComplete ? null : _addDeviceToRoom,
                              child: Text(
                                'Assign Device',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isFormComplete
                                      ? AppColors.whiteColor
                                      : AppColors.accentColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
