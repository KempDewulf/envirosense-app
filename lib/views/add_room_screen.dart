// lib/views/add_room_screen.dart

import 'package:flutter/material.dart';
import '../colors/colors.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController _roomNameController = TextEditingController();
  String? _selectedRoomType;

  // List of available room types with corresponding icons
  final List<Map<String, dynamic>> _roomTypes = [
    {'name': 'Cafeteria', 'icon': Icons.coffee},
    {'name': 'Bedroom', 'icon': Icons.bed},
    {'name': 'Bathroom', 'icon': Icons.bathtub},
    {'name': 'Office', 'icon': Icons.work},
    {'name': 'TV Room', 'icon': Icons.tv},
    {'name': 'Classroom', 'icon': Icons.class_},
    {'name': 'Garage', 'icon': Icons.garage},
    {'name': 'Toilet', 'icon': Icons.family_restroom},
    {'name': 'Kid Room', 'icon': Icons.child_friendly},
  ];

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  bool get _isFormComplete {
    return _roomNameController.text.isNotEmpty && _selectedRoomType != null;
  }

  void _saveRoom() {
    // Implement the save logic here
    Navigator.pop(context);
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
          'Add Room',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isFormComplete ? _saveRoom : null,
            child: Text(
              'SAVE',
              style: TextStyle(
                color: _isFormComplete
                    ? AppColors.secondaryColor
                    : const Color.fromARGB(110, 139, 139, 139),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Room's name",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                hintText: 'e.g., Living Room',
                hintStyle: const TextStyle(
                  color: AppColors.accentColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.lightGrayColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Update the form completeness
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Room's icon",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _roomTypes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                ),
                itemBuilder: (context, index) {
                  String roomName = _roomTypes[index]['name'];
                  IconData iconData = _roomTypes[index]['icon'];
                  bool isSelected = _selectedRoomType == roomName;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRoomType = roomName;
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
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.6),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            iconData,
                            color: isSelected
                                ? Colors.white
                                : AppColors.accentColor,
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          roomName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
