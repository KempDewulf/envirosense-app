import 'package:envirosense/presentation/controllers/AddDeviceController.dart';
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
  final AddDeviceController _controller = AddDeviceController();

  String? _deviceIdentifierCode;
  String? _selectedRoom;
  TextEditingController _searchController = TextEditingController();
  List<String> _rooms = [
    'Room 1',
    'Room 2',
    'Room 3',
    'Room 4'
  ]; // Replace with actual room names
  List<String> _filteredRooms = [];

  void setResult(String result) {
    setState(() => _deviceIdentifierCode = result);
  }

  @override
  void initState() {
    super.initState();
    _filteredRooms = _rooms;
    _searchController.addListener(_filterRooms);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterRooms() {
    setState(() {
      _filteredRooms = _rooms
          .where((room) =>
              room.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
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
            const SizedBox(height: 28.0),
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
                            'Now select a room to assign this device to:',
                            style: TextStyle(
                              fontSize: 18,
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
                              prefixIcon: Icon(Icons.search,
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
                                      ? AppColors.primaryColor.withOpacity(0.1) : AppColors.whiteColor,
                                  child: ListTile(
                                    title: Text(
                                      _filteredRooms[index],
                                      style: TextStyle(
                                        color: _selectedRoom ==
                                                _filteredRooms[index]
                                            ? AppColors.primaryColor
                                            : AppColors.blackColor,
                                      ),
                                    ),
                                    trailing:
                                        _selectedRoom == _filteredRooms[index]
                                            ? Icon(Icons.check,
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
                                  : () {
                                      // Handle device assignment to the selected room
                                    },
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
