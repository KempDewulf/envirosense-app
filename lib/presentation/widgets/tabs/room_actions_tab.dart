import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/actions/custom_action_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
            CustomBottomSheetHeader(title: l10n.renameRoom),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextFormField(
                controller: inputController,
                labelText: l10n.roomNameLabel,
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
              saveButtonText: l10n.save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRemoveRoomDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => CustomConfirmationDialog(
        title: l10n.removeRoom,
        message: l10n.removeDeviceConfirm,
        highlightedText: widget.roomName,
        onConfirm: () async {
          await _handleRoomRemoval();
        },
      ),
    );
  }

  Future<void> _handleRoomRename(String newRoomName) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      if (widget.roomId.isEmpty) {
        throw Exception(l10n.roomIdNotFound);
      }

      await widget.roomService.renameRoom(widget.roomId, newRoomName);
      widget.onRoomRenamed(newRoomName);

      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        l10n.renameRoomSuccess,
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        l10n.renameRoomError,
      );
    }
  }

  Future<void> _handleRoomRemoval() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await widget.roomService.deleteRoom(widget.roomId);

      if (!mounted) return;

      Navigator.pop(context, true);
      Navigator.pop(context, true);

      CustomSnackbar.showSnackBar(
        context,
        l10n.removeRoomSuccess,
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showSnackBar(
        context,
        l10n.removeRoomError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                label: l10n.renameRoom,
                onPressed: () => _showRenameRoomDialog(context),
                color: AppColors.accentColor,
                isNeutral: true,
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                icon: Icons.delete_outline,
                label: l10n.removeRoom,
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
