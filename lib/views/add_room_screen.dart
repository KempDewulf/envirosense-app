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
        foregroundColor: AppColors.blackColor,
        title: const Text(
          'Add Room',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        // Removed the SAVE button from the AppBar
        actions: const [],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enter Room's Name Label
            const Text(
              "Enter Room's name",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.lightGrayColor, // Gray accent color
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Text Input Field
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                hintText: 'e.g., Living Room',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded border
                  borderSide: const BorderSide(
                      color: AppColors.accentColor), // Accent color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accentColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Update the form completeness
                });
              },
            ),
            const SizedBox(height: 24),
            // Select Room's Icon Label
            const Text(
              "Select Room's icon",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.lightGrayColor, // Gray accent color
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Icons Grid
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
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? AppColors.secondaryColor
                                : AppColors.accentColor,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // SAVE Button Positioned at the Bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormComplete ? _saveRoom : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormComplete
                      ? AppColors.secondaryColor
                      : AppColors.lightGrayColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}