import 'package:collections/features/import_export/cubit/import_export_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../constants/colors.dart';
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
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.rose, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppColors.bgCard,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        } else if (state is EventDetailSaveFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.gold, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppColors.bgCard,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        } else if (state is EventDetailOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: AppColors.emerald, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: AppColors.bgCard,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: BlocBuilder<EventDetailCubit, EventDetailState>(
        buildWhen: (previous, current) {
          if (current is EventDetailSaving) return false;
          // Save-failure and operation-success are surfaced via the listener as
          // transient SnackBars; the BlocBuilder must not rebuild for them so
          // the table remains visible and the optimistic state is preserved.
          if (current is EventDetailSaveFailed) return false;
          if (previous is EventDetailLoaded && current is EventDetailLoading) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is EventDetailLoading) {
            return const Scaffold(
              backgroundColor: AppColors.bgDeep,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            );
          } else if (state is EventDetailLoaded) {
            return _buildLoadedView(context, state);
          } else if (state is EventDetailError) {
            return _buildErrorView(context, state);
          }
          return const Scaffold(
            backgroundColor: AppColors.bgDeep,
            body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
          );
        },
      ),
    );
  }

  Widget _buildLoadedView(BuildContext context, EventDetailLoaded state) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          // Gradient event header
          EventInfoSection(event: state.event),

          // Content
          Expanded(
            child: RefreshIndicator(
              color: AppColors.gold,
              backgroundColor: AppColors.bgCard,
              onRefresh: () =>
                  context.read<EventDetailCubit>().refreshEventDetail(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section header: Collection Data ──────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'COLLECTION DATA',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${state.sortedRows.length} ${state.sortedRows.length == 1 ? 'entry' : 'entries'}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Lock / unlock toggle — always visible so users can toggle
                      // editing from the detail body without hunting in the header.
                      GestureDetector(
                        onTap: () =>
                            context.read<EventDetailCubit>().toggleEventLock(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: state.isLocked
                                ? AppColors.gold.withValues(alpha: 0.15)
                                : AppColors.bgElevated,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: state.isLocked
                                  ? AppColors.gold.withValues(alpha: 0.4)
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.isLocked
                                    ? Icons.lock_rounded
                                    : Icons.lock_open_rounded,
                                size: 14,
                                color: state.isLocked
                                    ? AppColors.gold
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                state.isLocked ? 'Locked' : 'Unlocked',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: state.isLocked
                                      ? AppColors.gold
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Reorder toggle (only when unlocked)
                      if (!state.isLocked) ...[
                        const SizedBox(width: 8),
                        const Text(
                          'Reorder',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Switch(
                          value: _isReorderMode,
                          onChanged: (value) {
                            setState(() => _isReorderMode = value);
                          },
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Data table ───────────────────────────────────────────
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

                  const SizedBox(height: 28),

                  // ── Section header: Summary ──────────────────────────────
                  const Text(
                    'COLLECTION SUMMARY',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Totals table ─────────────────────────────────────────
                  TotalsTable(totals: state.totals),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
      floatingActionButton: state.isLocked
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showAddRowDialog(context),
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.onGold,
              elevation: 4,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Add Row',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
    );
  }

  Widget _buildErrorView(BuildContext context, EventDetailError state) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.roseDim,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.rose),
              ),
              const SizedBox(height: 20),
              Text(
                state.message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<EventDetailCubit>().loadEventDetail(widget.eventId);
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddRowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EventDetailCubit>(),
        child: const AddRowDialog(),
      ),
    );
  }
}
