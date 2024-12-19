import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../core/constants/colors.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RoomController _roomController = RoomController();
  final DeviceController _deviceController = DeviceController();

  String? _deviceIdentifierCode;
  Room? _selectedRoom;
  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];

  bool _isSaving = false;

  bool get _isFormComplete {
    return _deviceIdentifierCode != null && _selectedRoom != null;
  }

  void setResult(String result) {
    setState(() => _deviceIdentifierCode = result);
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
      setState(() {
        _rooms = rooms;
        _filteredRooms = rooms;
      });
    } catch (e) {
      print('Failed to fetch rooms: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load rooms')),
      );
    }
  }

  Future<void> _addDeviceToRoom() async {
    if (!_isFormComplete || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _deviceController.addDevice(_selectedRoom?.id, _deviceIdentifierCode);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device assigned successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print('Failed to assign device: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign device: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
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
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: _deviceIdentifierCode == null ? 28.0 : 12.0),
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
                          child: QrCodeScanner(setResult: setResult),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select a room:',
                            style: TextStyle(
                              fontSize: 26,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search rooms',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.accentColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.accentColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.accentColor),
                              ),
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.accentColor),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredRooms.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: _selectedRoom == _filteredRooms[index]
                                      ? AppColors.primaryColor.withOpacity(0.1)
                                      : AppColors.whiteColor,
                                  child: ListTile(
                                    title: Text(
                                      _filteredRooms[index].name,
                                      style: TextStyle(
                                        color: _selectedRoom?.id ==
                                                _filteredRooms[index].id
                                            ? AppColors.primaryColor
                                            : AppColors.blackColor,
                                      ),
                                    ),
                                    trailing: _selectedRoom?.id ==
                                            _filteredRooms[index].id
                                        ? const Icon(Icons.check,
                                            color: AppColors.primaryColor)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedRoom = _filteredRooms[index];
                                      });
                                    },
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
                                foregroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _selectedRoom == null
                                  ? null
                                  : _addDeviceToRoom,
                              child: const Text('Assign Device'),
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
