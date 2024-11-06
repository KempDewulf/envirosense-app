// home_screen.dart

import 'package:flutter/material.dart';
import 'package:envirosense/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _rooms = [
    {'icon': Icons.chair, 'name': '3.108', 'devices': 1},
    {'icon': Icons.meeting_room, 'name': '3.109', 'devices': 2},
    {'icon': Icons.computer, 'name': '3.110', 'devices': 3},
    {'icon': Icons.laptop, 'name': '3.111', 'devices': 4},
    {'icon': Icons.tv, 'name': '3.112', 'devices': 0},
    {'icon': Icons.headphones, 'name': '3.113', 'devices': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          _buildHeader(),
          if (_selectedTabIndex == 0) _buildRoomsPage(),
          if (_selectedTabIndex == 1) _buildDevicesPage(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Howest University',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.accentColor,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                'Campus Brugge Station - Building A',
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTabButton('ROOMS', 0),
              const SizedBox(width: 32),
              _buildTabButton('DEVICES', 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 6,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondaryColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsPage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
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
                itemCount: _rooms.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  if (index < _rooms.length) {
                    var room = _rooms[index];
                    return _buildRoomCard(room);
                  } else {
                    return _buildAddRoomCard();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              room['icon'],
              color: AppColors.secondaryColor,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              room['name'],
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'x${room['devices']} device(s)',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRoomCard() {
    return GestureDetector(
      onTap: () {
        // Handle add room
      },
      child: Card(
        color: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 48,
              ),
              SizedBox(height: 8),
              Text(
                'Add a room',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
