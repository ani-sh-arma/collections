import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/models.dart';
import '../bloc/bloc.dart';
import '../widgets/event_info_section.dart';
import '../widgets/collection_table.dart';
import '../widgets/totals_table.dart';
import '../widgets/add_row_dialog.dart';
import '../../import_export/cubit/cubit.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventDetailBloc>(
          create:
              (context) => sl<EventDetailBloc>()..add(LoadEventDetail(eventId)),
        ),
        BlocProvider<ImportExportCubit>(
          create: (context) => sl<ImportExportCubit>(),
        ),
      ],
      child: EventDetailView(eventId: eventId),
    );
  }
}

class EventDetailView extends StatelessWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailBloc, EventDetailState>(
      listener: (context, state) {
        if (state is EventDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is EventDetailOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: BlocBuilder<EventDetailBloc, EventDetailState>(
        builder: (context, state) {
          if (state is EventDetailLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('Loading...')),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is EventDetailLoaded) {
            return _buildLoadedView(context, state);
          } else if (state is EventDetailError) {
            return _buildErrorView(context, state);
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Event Details')),
            body: const Center(child: Text('Unknown state')),
          );
        },
      ),
    );
  }

  Widget _buildLoadedView(BuildContext context, EventDetailLoaded state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.event.title),
        actions: [
          // Lock/Unlock toggle
          IconButton(
            onPressed: () {
              context.read<EventDetailBloc>().add(const ToggleEventLock());
            },
            icon: Icon(state.isLocked ? Icons.lock : Icons.lock_open),
            tooltip:
                state.isLocked
                    ? AppConstants.unlockTooltip
                    : AppConstants.lockTooltip,
          ),
          // More actions menu
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value, state),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'export',
                    child: ListTile(
                      leading: Icon(Icons.file_download),
                      title: Text('Export'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'copy',
                    child: ListTile(
                      leading: Icon(Icons.copy),
                      title: Text('Make a Copy'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'rename',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Rename'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Event Info Section
          EventInfoSection(event: state.event),

          // Collection Table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collection Table Title
                  Text(
                    'Collection Data',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.padding),

                  // Collection Table
                  CollectionTable(
                    event: state.event,
                    columns: state.sortedColumns,
                    rows: state.sortedRows,
                    cells: state.cells,
                    isLocked: state.isLocked,
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  // Totals Table
                  TotalsTable(totals: state.totals),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          state.isLocked
              ? null
              : FloatingActionButton(
                onPressed: () => _showAddRowDialog(context),
                tooltip: 'Insert Row',
                child: const Icon(Icons.add),
              ),
    );
  }

  Widget _buildErrorView(BuildContext context, EventDetailError state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppConstants.padding),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ElevatedButton(
              onPressed: () {
                context.read<EventDetailBloc>().add(LoadEventDetail(eventId));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    EventDetailLoaded state,
  ) {
    switch (action) {
      case 'export':
        context.read<ImportExportCubit>().exportSingleEvent(state.event.id);
        break;
      case 'copy':
        // Navigate back and trigger copy in events bloc
        Navigator.of(context).pop();
        // You might want to pass this action back to the events page
        break;
      case 'rename':
        _showRenameDialog(context, state.event);
        break;
      case 'delete':
        _showDeleteConfirmation(context, state.event);
        break;
    }
  }

  void _showAddRowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<EventDetailBloc>(),
            child: const AddRowDialog(),
          ),
    );
  }

  void _showRenameDialog(BuildContext context, Event event) {
    final controller = TextEditingController(text: event.title);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newTitle = controller.text.trim();
                  if (newTitle.isNotEmpty && newTitle != event.title) {
                    context.read<EventDetailBloc>().add(
                      UpdateEventInfo(event.copyWith(title: newTitle)),
                    );
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Rename'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Event'),
            content: const Text(AppConstants.deleteEventConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to events page
                  // The events page should handle the deletion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
