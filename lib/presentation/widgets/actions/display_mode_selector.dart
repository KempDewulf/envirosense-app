import 'package:envirosense/core/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/core/enums/display_mode.dart';
import 'package:flutter/material.dart';

class DisplayModeSelector extends StatefulWidget {
  final DisplayMode selectedMode;
  final Function(DisplayMode) onModeSelected;
  final bool isLoading;
  final bool hasError;

  const DisplayModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  State<DisplayModeSelector> createState() => _DisplayModeSelectorState();
}

// ignore: must_be_immutable
class _DisplayModeSelectorState extends State<DisplayModeSelector> {
  final ScrollController _scrollController = ScrollController();
  List<Widget> displayModes = [];

  final List<DisplayMode> modeTypes = [
    DisplayMode.normal,
    DisplayMode.temperature,
    DisplayMode.humidity,
    DisplayMode.ppm,
  ];

  @override
  void initState() {
    super.initState();
    displayModes = _createDisplayModes();

    // Scroll to active card after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMode();
    });
  }

  List<Widget> _createDisplayModes() {
    final l10n = AppLocalizations.of(context)!;

    return [
      _buildModeCard(DisplayMode.normal, l10n.defaultView, Icons.dashboard_outlined),
      _buildModeCard(DisplayMode.temperature, l10n.temperature, Icons.thermostat_outlined),
      _buildModeCard(DisplayMode.humidity, l10n.humidity, Icons.water_drop_outlined),
      _buildModeCard(DisplayMode.ppm, l10n.co2Level, Icons.air_outlined),
    ];
  }

  void _scrollToSelectedMode() {
    final selectedIndex = modeTypes.indexOf(widget.selectedMode);
    if (selectedIndex != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        selectedIndex * 170.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              widget.hasError ? Icons.error_outline : Icons.screen_rotation,
              color: widget.hasError ? AppColors.redColor : AppColors.secondaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.displayModeLabel,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.hasError)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              l10n.displayModeFetchError,
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 18,
              ),
            ),
          )
        else if (widget.isLoading)
          Center(
            child: SizedBox(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentColor)),
                  SizedBox(height: 16),
                  Text(
                    l10n.loading,
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
          // Existing display mode selector UI
          SizedBox(
            height: 170,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: displayModes,
            ),
          ),
      ],
    );
  }

  Widget _buildModeCard(DisplayMode mode, String title, IconData icon) {
    final isSelected = widget.selectedMode == mode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          if(isSelected) return;
          widget.onModeSelected(mode);
        },
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryColor : AppColors.lightGrayColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.secondaryColor : AppColors.lightGrayColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected ? AppColors.whiteColor : AppColors.accentColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.whiteColor : AppColors.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(DisplayModeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMode != widget.selectedMode) {
      setState(() {
        displayModes = _createDisplayModes();
      });
    }
  }
}
