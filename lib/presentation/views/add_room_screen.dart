import 'package:envirosense/core/helpers/icon_helper.dart';
import 'package:envirosense/core/helpers/string_helper.dart';
import 'package:envirosense/domain/entities/roomtype.dart';
import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/controllers/room_type_controller.dart';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'package:envirosense/services/logging_service.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final RoomController _roomController = RoomController();
  final RoomTypeController _roomTypesController = RoomTypeController();
  final TextEditingController _roomNameController = TextEditingController();

  final String _buildingId = "gox5y6bsrg640qb11ak44dh0";
  List<RoomType>? _roomTypes; // Store room types in state
  RoomType? _selectedRoomType;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoomTypes();
  }

  Future<void> _loadRoomTypes() async {
    try {
      final roomTypes = await _roomTypesController.getRoomTypes(_buildingId);
      if (mounted) {
        setState(() {
          _roomTypes = roomTypes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      LoggingService.logError('Error loading room types', e);
    }
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  bool get _isFormComplete {
    return _roomNameController.text.isNotEmpty && _selectedRoomType != null;
  }

  Future<void> _saveRoom() async {
    if (!_isFormComplete || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _roomController.addRoom(
          _roomNameController.text, _buildingId, _selectedRoomType?.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Room added successfully. Drag down to refresh.')),
        );

        Navigator.pop(context, true);
      }
    } catch (e, stackTrace) {
      LoggingService.logError('Exception caught: $e', e, stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add room')),
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Room's name",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.lightGrayColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                hintText: 'e.g., Living Room',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accentColor),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Room's icon",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.lightGrayColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _roomTypes?.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final roomType = _roomTypes![index];
                  final isSelected = _selectedRoomType == roomType;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRoomType = roomType;
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
                            getIconData(roomType.icon),
                            color: isSelected
                                ? Colors.white
                                : AppColors.accentColor,
                            size: 35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          capitalizeWords(roomType.icon),
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
                      ],
                    ),
                  );
                },
              ),
            ),
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
                child: _isSaving
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                      )
                    : const Text(
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
