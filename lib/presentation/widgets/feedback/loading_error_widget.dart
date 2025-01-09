import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/actions/no_connection_widget.dart';
import 'package:flutter/material.dart';

class LoadingErrorWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final Widget child;

  const LoadingErrorWidget({
    super.key,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor)));
    }

    if (error != null) {
      if (error == 'no_connection') {
        return NoConnectionWidget(onRetry: onRetry);
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: AppColors.redColor,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              error!,
              style: const TextStyle(
                color: AppColors.redColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return child;
  }
}
