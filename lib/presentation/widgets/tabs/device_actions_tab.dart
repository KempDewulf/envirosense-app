import 'package:envirosense/presentation/controllers/room_controller.dart';
import 'package:envirosense/presentation/widgets/actions/custom_action_button.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_actions.dart';
import 'package:envirosense/presentation/widgets/dialogs/custom_bottom_sheet_header.dart';
import 'package:envirosense/presentation/widgets/core/custom_confirmation_dialog.dart';
import 'package:envirosense/presentation/widgets/core/custom_text_form_field.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../services/device_service.dart';

// ignore: must_be_immutable
class DeviceActionsTab extends StatefulWidget {
  String? deviceCustomName;
  String? deviceIdentifier;
  final String? deviceId;
  final String buildingId;
  final DeviceService deviceService;
  final RoomController roomController;
  final Function(String) onDeviceRenamed;
  final Function() onDeviceRemoved;
  final String? currentRoomId;
  final String? currentRoomName;

  DeviceActionsTab(
      {super.key,
      required this.deviceCustomName,
      this.deviceIdentifier,
      this.deviceId,
      required this.buildingId,
      required this.deviceService,
      required this.roomController,
      required this.onDeviceRenamed,
      required this.onDeviceRemoved,
      this.currentRoomId,
      this.currentRoomName});

  @override
  State<DeviceActionsTab> createState() => _DeviceActionsTabState();
}

class _DeviceActionsTabState extends State<DeviceActionsTab> {
  String? _selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomActionButton(
                icon: Icons.edit,
                label: 'Rename Device',
                onPressed: _showRenameDeviceDialog,
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.swap_horiz,
                label: 'Change Room',
                onPressed: _showChangeRoomDialog,
                color: AppColors.secondaryColor,
                isWarning: true,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Device',
                onPressed: _showRemoveDeviceDialog,
                color: AppColors.redColor,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showRenameDeviceDialog() async {
    final TextEditingController inputController = TextEditingController(text: widget.deviceCustomName);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomBottomSheetHeader(title: 'Rename Device'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextFormField(
                controller: inputController,
                labelText: 'Device Name',
                floatingLabelCustomStyle: const TextStyle(
                  color: AppColors.secondaryColor,
                ),
                textStyle: const TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Divider(color: AppColors.accentColor.withOpacity(0.2)),
            CustomBottomSheetActions(
              onCancel: () => Navigator.pop(context),
              onSave: () async {
                if (inputController.text.isNotEmpty) {
                  await _handleDeviceRename(inputController.text);
                }
              },
              saveButtonText: 'Save',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeviceRename(String newName) async {
    try {
      final deviceIdentifier = widget.deviceIdentifier!;

      await widget.deviceService.renameDevice(deviceIdentifier, newName);

      if (!mounted) return;
      setState(() {
        widget.deviceCustomName = newName;
      });

      widget.onDeviceRenamed(newName);

      Navigator.pop(context);
      CustomSnackbar.showSnackBar(
        context,
        'Device renamed successfully',
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Failed to rename device. Please try again later.',
      );
    }
  }

  Future<void> _showChangeRoomDialog() async {
    setState(() {
      _selectedRoomId = widget.currentRoomId;
    });

    final rooms = await widget.roomController.getRooms();

    if (!mounted) return;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Room',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.currentRoomName ?? "Unknown room",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: AppColors.secondaryColor,
                      value: _selectedRoomId,
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomId = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.secondaryColor,
                        size: 30,
                      ),
                      selectedItemBuilder: (context) => [
                        ...rooms.map((room) => DropdownMenuItem(
                              value: room.id,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                                ),
                                child: Text(
                                  room.name,
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                            )),
                      ],
                      items: [
                        ...rooms.map((room) => DropdownMenuItem(
                              value: room.id,
                              child: Row(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      return Text(
                                        room.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 16,
                                          fontWeight: room.id == _selectedRoomId ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      );
                                    },
                                  ),
                                  if (room.id == widget.currentRoomId) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Current room',
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            )),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Select New Room',
                        labelStyle: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondaryColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.accentColor.withOpacity(0.2)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.secondaryColor),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.secondaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: _selectedRoomId == widget.currentRoomId
                              ? null
                              : () async {
                                  await handleRoomChange();
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleRoomChange() async {
    if (_selectedRoomId == null || _selectedRoomId == widget.currentRoomId) {
      return;
    }

    try {
      final currentRoomId = widget.currentRoomId;

      await widget.deviceService.changeDeviceRoom(
        deviceId: widget.deviceId!,
        deviceIdentifier: widget.deviceIdentifier!,
        currentRoomId: currentRoomId,
        newRoomId: _selectedRoomId!,
        removeDeviceFromRoom: widget.roomController.removeDeviceFromRoom,
        addDeviceToRoom: widget.roomController.addDeviceToRoom,
      );

      if (!mounted) return;
      Navigator.pop(context);
      CustomSnackbar.showSnackBar(
        context,
        'Room changed successfully',
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Failed to change room. Please try again later.',
      );
    }
  }

  Future<void> _showRemoveDeviceDialog() async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => CustomConfirmationDialog(
        title: 'Remove Device',
        message: 'Are you sure you want to remove ',
        highlightedText: widget.deviceCustomName ?? widget.deviceIdentifier!,
        onConfirm: () async {
          await _handleDeviceRemoval();
        },
      ),
    );
  }

  Future<void> _handleDeviceRemoval() async {
    try {
      await widget.deviceService.deleteDevice(widget.deviceId!, widget.buildingId);

      if (!mounted) return;
      Navigator.pop(context, true);
      Navigator.pop(context, true);

      CustomSnackbar.showSnackBar(
        context,
        'Device removed successfully',
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Failed to remove device. Please try again later.',
      );
    }
  }
}
