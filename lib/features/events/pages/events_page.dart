import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/constants/app_constants.dart';
import '../bloc/bloc.dart';
import '../widgets/event_card.dart';
import '../widgets/create_event_dialog.dart';
import '../../import_export/cubit/cubit.dart';
import '../../import_export/widgets/import_dialog.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventsBloc>(
          create: (context) => sl<EventsBloc>()..add(const LoadEvents()),
        ),
        BlocProvider<ImportExportCubit>(
          create: (context) => sl<ImportExportCubit>(),
        ),
      ],
      child: const EventsView(),
    );
  }
}

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // Import button
          IconButton(
            onPressed: () => _showImportDialog(context),
            icon: const Icon(Icons.file_upload),
            tooltip: 'Import Events',
          ),
          // More options menu
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'export_all',
                    child: ListTile(
                      leading: Icon(Icons.file_download),
                      title: Text('Export All Events'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'backup',
                    child: ListTile(
                      leading: Icon(Icons.backup),
                      title: Text('Create Backup'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EventsBloc, EventsState>(
            listener: (context, state) {
              if (state is EventsError) {
                log('Events Error: ${state.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is EventCreated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppConstants.saveSuccessMessage),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is EventDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppConstants.deleteSuccessMessage),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          BlocListener<ImportExportCubit, ImportExportState>(
            listener: (context, state) {
              if (state is ImportExportError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is ExportSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ImportSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                // Refresh events after import
                context.read<EventsBloc>().add(const RefreshEvents());
              } else if (state is ImportPreview) {
                _showImportPreviewDialog(context, state);
              }
            },
          ),
        ],
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventsLoaded) {
              if (state.events.isEmpty) {
                return const _EmptyEventsView();
              }
              return _EventsListView(events: state.events);
            } else if (state is EventsError) {
              return _ErrorView(
                message: state.message,
                onRetry:
                    () => context.read<EventsBloc>().add(const LoadEvents()),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateEventDialog(context),
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<EventsBloc>(),
            child: const CreateEventDialog(),
          ),
    );
  }

  void _showImportDialog(BuildContext context) {
    context.read<ImportExportCubit>().pickFileForImport();
  }

  void _showImportPreviewDialog(BuildContext context, ImportPreview state) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<ImportExportCubit>(),
            child: ImportDialog(
              exportData: state.exportData,
              preview: state.preview,
            ),
          ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    final importExportCubit = context.read<ImportExportCubit>();

    switch (action) {
      case 'export_all':
        importExportCubit.exportAllEvents();
        break;
      case 'backup':
        importExportCubit.createBackup();
        break;
      case 'settings':
        // TODO: Navigate to settings page
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings coming soon!')));
        break;
    }
  }
}

class _EventsListView extends StatelessWidget {
  final List<dynamic> events; // Using dynamic to avoid import issues for now

  const _EventsListView({required this.events});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<EventsBloc>().add(const RefreshEvents());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.padding),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.padding),
            child: EventCard(event: events[index]),
          );
        },
      ),
    );
  }
}

class _EmptyEventsView extends StatelessWidget {
  const _EmptyEventsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
          const SizedBox(height: AppConstants.padding),
          Text(
            AppConstants.noEventsMessage,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          Builder(
            builder:
                (context) => ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (dialogContext) => BlocProvider.value(
                            value: context.read<EventsBloc>(),
                            child: const CreateEventDialog(),
                          ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Your First Event'),
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: AppConstants.padding),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.red[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
