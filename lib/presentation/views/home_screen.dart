// home_screen.dart

import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/RoomController.dart';
import 'package:envirosense/presentation/widgets/add_options_bottom_sheet.dart';
import 'package:envirosense/presentation/widgets/device_card.dart';
import 'package:envirosense/presentation/widgets/header.dart';
import 'package:envirosense/presentation/widgets/item_grid_page.dart';
import 'package:envirosense/presentation/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/presentation/controllers/DeviceController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  List<Room> _allRooms = [];
  List<Device> _allDevices = [];
  final RoomController _roomController = RoomController();
  final DeviceController _deviceController = DeviceController();


  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _fetchDevices();
  }

  Future<void> _fetchRooms() async {
    final rooms = await _roomController.fetchRooms();
    setState(() {
      _allRooms = rooms;
    });
  }

  Future<void> _fetchDevices() async {
    final devices = await _deviceController.fetchDevices();
    setState(() {
      _allDevices = devices;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Header(
            selectedTabIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          if (_selectedTabIndex == 0)
            Expanded(
              child: ItemGridPage<Room>(
                allItems: _allRooms,
                itemBuilder: (room) => RoomCard(room: room),
                getItemName: (room) => room.name,
                onAddPressed: () {
                  // Handle add room action
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AddOptionsBottomSheet(),
                  );
                },
              ),
            ),
          if (_selectedTabIndex == 1)
            Expanded(
              child: ItemGridPage<Device>(
                allItems: _allDevices,
                itemBuilder: (device) => DeviceCard(device: device),
                getItemName: (device) => device.name,
                onAddPressed: () {
                  // Handle add device action
                },
              ),
            ),
        ],
      ),
    );
  }
}
