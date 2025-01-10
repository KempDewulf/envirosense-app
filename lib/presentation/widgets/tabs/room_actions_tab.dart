import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/actions/custom_action_button.dart';
import 'package:envirosense/presentation/widgets/bottom_sheets/custom_bottom_sheet_actions.dart';
import 'package:envirosense/presentation/widgets/bottom_sheets/custom_bottom_sheet_header.dart';
import 'package:envirosense/presentation/widgets/core/custom_confirmation_dialog.dart';
import 'package:envirosense/presentation/widgets/core/custom_text_form_field.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:envirosense/services/room_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoomActionsTab extends StatefulWidget {
  String roomName;
  final String roomId;
  final RoomService roomService;
  final Function(String) onRoomRenamed;
  final Function() onRoomRemoved;

  RoomActionsTab({
    super.key,
    required this.roomName,
    required this.roomId,
    required this.roomService,
    required this.onRoomRenamed,
    required this.onRoomRemoved,
  });

  @override
  State<RoomActionsTab> createState() => _RoomActionsTabState();
}

class _RoomActionsTabState extends State<RoomActionsTab> {
  Future<void> _showRenameRoomDialog(BuildContext context) async {
    final TextEditingController inputController = TextEditingController(text: widget.roomName);

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
            const CustomBottomSheetHeader(title: 'Rename Room'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextFormField(
                controller: inputController,
                labelText: 'Room Name',
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
                  await _handleRoomRename(inputController.text);
                }
              },
              saveButtonText: 'Save',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRemoveRoomDialog(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => CustomConfirmationDialog(
        title: 'Remove Room',
        message: 'Are you sure you want to remove ',
        highlightedText: widget.roomName,
        onConfirm: () async {
          await _handleRoomRemoval();
        },
      ),
    );
  }

  Future<void> _handleRoomRename(String newRoomName) async {
    try {
      if (widget.roomId.isEmpty) {
        throw Exception('Room id not found');
      }

      await widget.roomService.renameRoom(widget.roomId, newRoomName);
      widget.onRoomRenamed(newRoomName);

      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Room renamed successfully',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Failed to rename room. Please try again later.',
      );
    }
  }

  Future<void> _handleRoomRemoval() async {
    try {
      await widget.roomService.deleteRoom(widget.roomId);

      if (!mounted) return;

      Navigator.pop(context, true);
      Navigator.pop(context, true);

      CustomSnackbar.showSnackBar(
        context,
        'Room removed successfully',
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        'Failed to remove room. Please try again later.',
      );
    }
  }

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
                label: 'Rename Room',
                onPressed: () => _showRenameRoomDialog(context),
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.delete_outline,
                label: 'Remove Room',
                onPressed: () => _showRemoveRoomDialog(context),
                color: AppColors.darkRedColor,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
