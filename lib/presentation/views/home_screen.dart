// home_screen.dart

import 'package:envirosense/domain/entities/room.dart';
import 'package:envirosense/presentation/controllers/RoomController.dart';
import 'package:envirosense/presentation/widgets/add_options_bottom_sheet.dart';
import 'package:envirosense/presentation/widgets/add_room_card.dart';
import 'package:envirosense/presentation/widgets/header.dart';
import 'package:envirosense/presentation/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:envirosense/core/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];
  final RoomController _roomController = RoomController();

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _searchController.addListener(_filterRooms);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRooms);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRooms() async {
    final rooms = await _roomController.fetchRooms();
    setState(() {
      _allRooms = rooms;
      _filteredRooms = rooms;
    });
  }

  void _filterRooms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRooms = _allRooms.where((room) {
        final roomName = room.name.toLowerCase();
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
                    return AddRoomCard(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const AddOptionsBottomSheet(),
                        );
                      },
                    );
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
