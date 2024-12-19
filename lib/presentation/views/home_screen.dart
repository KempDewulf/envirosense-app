// home_screen.dart

import 'package:envirosense/domain/entities/device.dart';
import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/add_options_bottom_sheet.dart';
import 'package:envirosense/presentation/widgets/device_card.dart';
import 'package:envirosense/presentation/widgets/header.dart';
import 'package:envirosense/presentation/widgets/item_grid_page.dart';
import 'package:envirosense/presentation/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/presentation/controllers/device_controller.dart';

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

  String _buildingId = "gox5y6bsrg640qb11ak44dh0"; //hardcoded here, but later outside PoC we would retrieve this from user that is linked to what building

  @override
  void initState() {
    super.initState();
    _getRooms();
    _getDevices();
  }

  Future<void> _refreshData() async {
    // get both rooms and devices
    await Future.wait([
      _getRooms(),
      _getDevices(),
    ]);
  }

  Future<void> _getRooms() async {
    final rooms = await _roomController.getRooms();
    setState(() {
      _allRooms = rooms;
    });
  }

  Future<void> _getDevices() async {
    final devices = await _deviceController.getDevices(_buildingId);
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
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: ItemGridPage<Room>(
                  allItems: _allRooms,
                  itemBuilder: (room) => RoomCard(room: room),
                  getItemName: (room) => room.name,
                  onAddPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const AddOptionsBottomSheet(),
                    );
                  },
                ),
              ),
            ),
          if (_selectedTabIndex == 1)
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: ItemGridPage<Device>(
                  allItems: _allDevices,
                  itemBuilder: (device) => DeviceCard(device: device),
                  getItemName: (device) => device.identifier,
                  onAddPressed: () {
                    // Handle add device action
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
