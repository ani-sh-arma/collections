import 'package:collections/features/event_detail/cubit/event_detail_cubit.dart';
import 'package:collections/features/event_detail/cubit/event_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../constants/app_constants.dart';
import '../../../utils/gradient_generator.dart';

class EventInfoSection extends StatelessWidget {
  final Event event;

  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Subscribe directly to the cubit so the lock button always reflects the
    // latest state, even if the parent BlocBuilder skipped a rebuild.
    return BlocSelector<EventDetailCubit, EventDetailState, Event?>(
      selector: (state) => state is EventDetailLoaded ? state.event : null,
      builder: (context, liveEvent) {
        final displayEvent = liveEvent ?? event;
        return _buildContent(context, displayEvent);
      },
    );
  }

  Widget _buildContent(BuildContext context, Event displayEvent) {
    final gradient = GradientGenerator.gradientFromHex(
      displayEvent.gradientColorA,
      displayEvent.gradientColorB,
    );

    final textColor = GradientGenerator.getTextColorForGradient(
      displayEvent.gradientColorA,
      displayEvent.gradientColorB,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          // Background dot pattern for texture
          Positioned.fill(
            child: CustomPaint(
              painter: _SubtleGridPainter(textColor),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Navigation row ──────────────────────────────────────
                  Row(
                    children: [
                      _NavButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        color: textColor,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          displayEvent.title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Lock / unlock button
                      _LockButton(event: displayEvent, textColor: textColor),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Date ────────────────────────────────────────────────
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: textColor.withValues(alpha: 0.7),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEEE, MMM dd, yyyy').format(displayEvent.date),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // ── Description ──────────────────────────────────────────
                  if (displayEvent.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.notes_rounded,
                          color: textColor.withValues(alpha: 0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            displayEvent.description,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.75),
                              fontSize: 12,
                              height: 1.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ── Locked message ───────────────────────────────────────
                  if (displayEvent.locked) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: textColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: textColor.withValues(alpha: 0.8),
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppConstants.lockedMessage,
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.8),
                                fontSize: 12,
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
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _LockButton extends StatelessWidget {
  final Event event;
  final Color textColor;

  const _LockButton({required this.event, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<EventDetailCubit>().toggleEventLock(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              event.locked ? Icons.lock_rounded : Icons.lock_open_rounded,
              color: textColor,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              event.locked ? 'Locked' : 'Unlocked',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubtleGridPainter extends CustomPainter {
  final Color color;
  _SubtleGridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    const r = 1.2;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SubtleGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
