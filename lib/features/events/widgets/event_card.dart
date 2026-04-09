import 'package:collections/features/import_export/cubit/import_export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../utils/gradient_generator.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';
import '../cubit/events_cubit.dart';
import '../../event_detail/pages/event_detail_page.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

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

    return GestureDetector(
      onTap: () => _navigateToEventDetail(context),
      onLongPress: () => _showActionMenu(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle overlay pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: CustomPaint(painter: _DotPatternPainter(textColor)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (event.locked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: textColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: textColor.withValues(alpha: 0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_rounded, color: textColor, size: 11),
                              const SizedBox(width: 4),
                              Text(
                                'LOCKED',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: textColor.withValues(alpha: 0.7),
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('EEE, MMM dd, yyyy').format(event.date),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.7),
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'TAP TO VIEW',
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HOLD FOR OPTIONS',
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEventDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailPage(eventId: event.id),
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<EventsCubit>()),
          BlocProvider.value(value: context.read<ImportExportCubit>()),
        ],
        child: _EventActionMenu(event: event, parentContext: context),
      ),
    );
  }
}

// ── Decorative dot pattern ─────────────────────────────────────────────────────

class _DotPatternPainter extends CustomPainter {
  final Color color;
  _DotPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Action menu ───────────────────────────────────────────────────────────────

class _EventActionMenu extends StatelessWidget {
  final Event event;
  final BuildContext parentContext;

  const _EventActionMenu({required this.event, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Event title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE, MMM dd, yyyy').format(event.date),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Divider(color: AppColors.border, height: 1),
          ),

          // Actions
          _ActionTile(
            icon: Icons.visibility_outlined,
            title: 'View Details',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(parentContext).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(eventId: event.id),
                ),
              );
            },
          ),
          _ActionTile(
            icon: Icons.copy_outlined,
            title: 'Make a Copy',
            onTap: () {
              Navigator.of(context).pop();
              context.read<EventsCubit>().copyEvent(event.id, withData: true);
            },
          ),
          _ActionTile(
            icon: Icons.copy_all_outlined,
            title: 'Make a Copy (Without Data)',
            onTap: () {
              Navigator.of(context).pop();
              context.read<EventsCubit>().copyEvent(event.id, withData: false);
            },
          ),
          _ActionTile(
            icon: event.locked ? Icons.lock_open_outlined : Icons.lock_outlined,
            title: event.locked ? 'Unlock Event' : 'Lock Event',
            onTap: () {
              Navigator.of(context).pop();
              context.read<EventsCubit>().toggleEventLock(event.id);
            },
          ),
          _ActionTile(
            icon: Icons.file_download_outlined,
            title: 'Export Event',
            onTap: () {
              Navigator.of(context).pop();
              context.read<ImportExportCubit>().exportSingleEvent(event.id);
            },
          ),
          _ActionTile(
            icon: Icons.edit_outlined,
            title: 'Edit Details',
            onTap: () async {
              final eventsCubit = parentContext.read<EventsCubit>();
              await _showEditDetailsDialog(context, eventsCubit);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          _ActionTile(
            icon: Icons.delete_outline_rounded,
            title: 'Delete Event',
            textColor: AppColors.rose,
            iconColor: AppColors.rose,
            onTap: () async {
              final eventsCubit = parentContext.read<EventsCubit>();
              await _showDeleteConfirmation(context, eventsCubit);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext menuContext,
    EventsCubit eventsCubit,
  ) async {
    await showDialog(
      context: menuContext,
      builder: (dialogContext) => BlocProvider.value(
        value: eventsCubit,
        child: AlertDialog(
          title: const Text('Delete Event'),
          content: const Text(AppConstants.deleteEventConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                eventsCubit.deleteEvent(event.id);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDetailsDialog(
    BuildContext menuContext,
    EventsCubit eventsCubit,
  ) async {
    final titleController = TextEditingController(text: event.title);
    final descriptionController = TextEditingController(text: event.description);
    DateTime tempSelectedDate = event.date;

    await showDialog(
      context: menuContext,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: eventsCubit,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Edit Event Details'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Event Title',
                          prefixIcon: Icon(Icons.event_outlined),
                        ),
                        maxLength: AppConstants.maxTitleLength,
                      ),
                      const SizedBox(height: AppConstants.padding),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Event Description',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: AppConstants.padding),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: tempSelectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != tempSelectedDate) {
                            setState(() => tempSelectedDate = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Event Date',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(
                            DateFormat('MMM dd, yyyy').format(tempSelectedDate),
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newTitle = titleController.text.trim();
                      final newDescription = descriptionController.text.trim();
                      if (newTitle.isNotEmpty &&
                          (newTitle != event.title ||
                              newDescription != event.description ||
                              tempSelectedDate != event.date)) {
                        eventsCubit.updateEvent(
                          event.copyWith(
                            title: newTitle,
                            description: newDescription,
                            date: tempSelectedDate,
                          ),
                        );
                      }
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

// ── Action tile ────────────────────────────────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.textSecondary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: iconColor ?? AppColors.textSecondary),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
