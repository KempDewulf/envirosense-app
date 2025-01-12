import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/actions/pagination_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:envirosense/presentation/widgets/actions/pagination_indicator.dart';
import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PaginationButton(
                onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
                isNext: false,
                text: l10n.previous,
              ),
            ),
            Expanded(
              child: Center(
                child: PageIndicator(
                  currentPage: currentPage,
                  totalPages: totalPages,
                ),
              ),
            ),
            Expanded(
              child: PaginationButton(
                onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
                isNext: true,
                text: l10n.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
