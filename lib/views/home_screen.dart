// home_screen.dart

import 'package:envirosense/widgets/add_room_card.dart';
import 'package:envirosense/widgets/bottom_nav_bar.dart';
import 'package:envirosense/widgets/header.dart';
import 'package:envirosense/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredRooms = [];

  final List<Map<String, dynamic>> _rooms = [
    {'icon': Icons.chair, 'name': '3.108', 'devices': 1},
    {'icon': Icons.meeting_room, 'name': '3.109', 'devices': 2},
    {'icon': Icons.computer, 'name': '3.110', 'devices': 3},
    {'icon': Icons.laptop, 'name': '3.111', 'devices': 4},
    {'icon': Icons.tv, 'name': '3.112', 'devices': 0},
    {'icon': Icons.headphones, 'name': '3.113', 'devices': 2},
  ];

  @override
  void initState() {
    super.initState();
    _filteredRooms = _rooms;
    _searchController.addListener(_filterRooms);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRooms);
    _searchController.dispose();
    super.dispose();
  }

  void _filterRooms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRooms = _rooms.where((room) {
        final roomName = room['name'].toLowerCase();
        return roomName.contains(query);
      }).toList();
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
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Header(
            selectedTabIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          if (_selectedTabIndex == 0) _buildRoomsPage(),
          if (_selectedTabIndex == 1) _buildDevicesPage(),
        ],
      ),
    );
  }

  Widget _buildRoomsPage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search a room',
                prefixIcon: const Icon(Icons.search),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: AppColors.secondaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _filteredRooms.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  if (index < _filteredRooms.length) {
                    var room = _filteredRooms[index];
                    return RoomCard(room: room);
                  } else {
                    return const AddRoomCard();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesPage() {
    // Build your devices page here
    return const Expanded(
      child: Center(
        child: Text(
          'Devices Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
