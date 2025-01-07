import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:flutter/material.dart';

class BrightnessControl extends StatefulWidget {
  final int value;
  final Function(int) onChanged;
  final bool isLoading;
  final bool hasError;

  const BrightnessControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  State<BrightnessControl> createState() => _BrightnessControlState();
}

class _BrightnessControlState extends State<BrightnessControl> {
  int _minimumAttempts = 0;
  DateTime? _lastAttemptTime;

  void _handleMinimumBrightnessAttempt() {
    final now = DateTime.now();
    if (_lastAttemptTime != null && now.difference(_lastAttemptTime!).inSeconds < 2) {
      _minimumAttempts++;
      if (_minimumAttempts >= 3) {
        CustomSnackbar.showSnackBar(
          context,
          'Minimum brightness is 20%',
        );
        _minimumAttempts = 0;
      }
    } else {
      _minimumAttempts = 1;
    }
    _lastAttemptTime = now;
  }

  @override
  Widget build(BuildContext context) {
    final int activeBars = (widget.value ~/ 20).clamp(1, 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              widget.hasError ? Icons.error_outline : Icons.brightness_6,
              color: widget.hasError ? AppColors.redColor : AppColors.secondaryColor,
            ),
            const SizedBox(width: 8),
            const Text(
              'Brightness',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (!widget.isLoading && !widget.hasError) ...[
              Text(
                '${widget.value}%',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
        const SizedBox(height: 16),
        if (widget.hasError)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Failed to fetch brightness level',
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 18,
              ),
            ),
          )
        else if (widget.isLoading)
          const Center(
            child: SizedBox(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor)),
                  SizedBox(height: 16),
                  Text(
                    'Loading',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (widget.value > 20) {
                    widget.onChanged(widget.value - 20);
                  } else {
                    _handleMinimumBrightnessAttempt();
                  }
                },
                icon: const Icon(Icons.remove_circle),
                color: AppColors.secondaryColor,
              ),
              Expanded(
                child: Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final newValue = ((index + 1) * 20);
                          widget.onChanged(newValue);
                        },
                        child: Container(
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: index < activeBars ? AppColors.secondaryColor : AppColors.lightGrayColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              IconButton(
                onPressed: widget.value < 100 ? () => widget.onChanged(widget.value + 20) : null,
                icon: const Icon(Icons.add_circle),
                color: AppColors.secondaryColor,
              ),
            ],
          ),
      ],
    );
  }
}
