import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows "Step X of 6: <label>" plus a thin progress bar.
/// Addresses the cognitive-accessibility finding in the project write-up:
/// first-time users can get overwhelmed by the multi-step booking flow
/// without a visible progress indicator (Nielsen Heuristic 1).
class StepProgressIndicator extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String label;

  const StepProgressIndicator({
    super.key,
    required this.step,
    required this.label,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step $step of $totalSteps: $label',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STEP $step OF $totalSteps  •  ${label.toUpperCase()}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: step / totalSteps,
                minHeight: 5,
                backgroundColor: AppColors.pillUnselected,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.navy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
