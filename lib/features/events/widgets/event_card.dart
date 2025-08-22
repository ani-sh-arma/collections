import 'package:collections/features/import_export/cubit/import_export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../core/utils/gradient_generator.dart';
import '../../../core/constants/app_constants.dart';
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
      child: Card(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (event.locked)
                      Icon(
                        Icons.lock,
                        color: textColor.withAlpha(200),
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  DateFormat('MMM dd, yyyy').format(event.date),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor.withAlpha(225),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withAlpha(200),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppConstants.smallPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tap to view details',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor.withAlpha(175),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      'Hold for options',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor.withAlpha(175),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<EventsCubit>(),
          ),
          BlocProvider.value(
            value: context.read<ImportExportCubit>(),
          ),
        ],
        child: _EventActionMenu(event: event),
      ),
    );
  }
}

class _EventActionMenu extends StatelessWidget {
  final Event event;

  const _EventActionMenu({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.padding),
          Text(
            event.title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.padding),
          _ActionTile(
            icon: Icons.visibility,
            title: 'View Details',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(eventId: event.id),
                ),
              );
            },
          ),
          _ActionTile(
            icon: Icons.copy,
            title: 'Make a Copy',
            onTap: () {
              Navigator.of(context).pop();
              context.read<EventsCubit>().copyEvent(event.id);
            },
          ),
          _ActionTile(
            icon: event.locked ? Icons.lock_open : Icons.lock,
            title: event.locked ? 'Unlock' : 'Lock',
            onTap: () {
              Navigator.of(context).pop();
              context.read<EventsCubit>().toggleEventLock(event.id);
            },
          ),
          _ActionTile(
            icon: Icons.file_download,
            title: 'Export',
            onTap: () {
              Navigator.of(context).pop();
              context.read<ImportExportCubit>().exportSingleEvent(event.id);
            },
          ),
          _ActionTile(
            icon: Icons.edit,
            title: 'Rename',
            onTap: () {
              Navigator.of(context).pop();
              _showRenameDialog(context);
            },
          ),
          _ActionTile(
            icon: Icons.delete,
            title: 'Delete',
            textColor: Colors.red,
            onTap: () {
              Navigator.of(context).pop();
              _showDeleteConfirmation(context);
            },
          ),
          const SizedBox(height: AppConstants.padding),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: event.title);

    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<EventsCubit>(),
            child: AlertDialog(
              title: const Text('Rename Event'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: AppConstants.maxTitleLength,
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newTitle = controller.text.trim();
                    if (newTitle.isNotEmpty && newTitle != event.title) {
                      dialogContext.read<EventsCubit>().updateEvent(
                        event.copyWith(title: newTitle),
                      );
                    }
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Rename'),
                ),
              ],
            ),
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<EventsCubit>(),
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
                    dialogContext.read<EventsCubit>().deleteEvent(event.id);
                    Navigator.of(dialogContext).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
      ),
    );
  }
}
