import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/gradient_generator.dart';

class EventInfoSection extends StatelessWidget {
  final Event event;

  const EventInfoSection({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = GradientGenerator.gradientFromHex(
      event.gradientColorA,
      event.gradientColorB,
    );
    
    final textColor = GradientGenerator.getTextColorForGradient(
      event.gradientColorA,
      event.gradientColorB,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (event.locked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.smallPadding,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                      border: Border.all(
                        color: textColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock,
                          color: textColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Locked',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: textColor.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  DateFormat('EEEE, MMM dd, yyyy').format(event.date),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description,
                    color: textColor.withValues(alpha: 0.8),
                    size: 16,
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor.withValues(alpha: 0.8),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (event.locked) ...[
              const SizedBox(height: AppConstants.padding),
              Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                  border: Border.all(
                    color: textColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: textColor.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: Text(
                        AppConstants.lockedMessage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
