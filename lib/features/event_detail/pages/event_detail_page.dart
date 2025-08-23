import 'package:collections/features/import_export/cubit/import_export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/constants/app_constants.dart';
import '../cubit/event_detail_state.dart';
import '../cubit/event_detail_cubit.dart';
import '../widgets/event_info_section.dart';
import '../widgets/collection_table.dart';
import '../widgets/reorderable_collection_table.dart';
import '../widgets/totals_table.dart';
import '../widgets/add_row_dialog.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventDetailCubit>(
          create: (context) => sl<EventDetailCubit>()..loadEventDetail(eventId),
        ),
        BlocProvider<ImportExportCubit>(
          create: (context) => sl<ImportExportCubit>(),
        ),
      ],
      child: EventDetailView(eventId: eventId),
    );
  }
}

class EventDetailView extends StatefulWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  bool _isReorderMode = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailCubit, EventDetailState>(
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
      child: BlocBuilder<EventDetailCubit, EventDetailState>(
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
          IconButton(
            onPressed: () {
              context.read<EventDetailCubit>().toggleEventLock();
            },
            icon: Icon(state.isLocked ? Icons.lock : Icons.lock_open),
            tooltip:
                state.isLocked
                    ? AppConstants.unlockTooltip
                    : AppConstants.lockTooltip,
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
                  // Collection Table Title with Reorder Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Collection Data',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!state.isLocked)
                        Row(
                          children: [
                            Text(
                              'Reorder Mode',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: _isReorderMode,
                              onChanged: (value) {
                                setState(() {
                                  _isReorderMode = value;
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.padding),

                  // Collection Table (switches between normal and reorderable)
                  _isReorderMode && !state.isLocked
                      ? ReorderableCollectionTable(
                        event: state.event,
                        columns: state.sortedColumns,
                        rows: state.sortedRows,
                        cells: state.cells,
                        isLocked: state.isLocked,
                      )
                      : CollectionTable(
                        event: state.event,
                        columns: state.sortedColumns,
                        rows: state.sortedRows,
                        cells: state.cells,
                        isLocked: state.isLocked,
                      ),

                  Divider(),

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
                context.read<EventDetailCubit>().loadEventDetail(
                  widget.eventId,
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<EventDetailCubit>(),
            child: const AddRowDialog(),
          ),
    );
  }
}
