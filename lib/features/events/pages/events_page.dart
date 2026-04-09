import 'dart:developer';
import 'package:collections/features/events/cubit/events_state.dart';
import 'package:collections/features/import_export/cubit/import_export_cubit.dart';
import 'package:collections/features/import_export/cubit/import_export_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';
import '../cubit/events_cubit.dart';
import '../widgets/event_card.dart';
import '../widgets/create_event_dialog.dart';
import '../../import_export/widgets/import_dialog.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventsCubit>(
          create: (context) => sl<EventsCubit>()..loadEvents(),
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
      backgroundColor: AppColors.bgDeep,
      appBar: _buildAppBar(context),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EventsCubit, EventsState>(
            listener: (context, state) {
              if (state is EventsError) {
                log('Events Error: ${state.message}');
                _showSnackBar(context, state.message, isError: true);
              } else if (state is EventCreated) {
                _showSnackBar(context, AppConstants.saveSuccessMessage);
              } else if (state is EventDeleted) {
                _showSnackBar(context, AppConstants.deleteSuccessMessage);
              }
            },
          ),
          BlocListener<ImportExportCubit, ImportExportState>(
            listener: (context, state) {
              if (state is ImportExportError) {
                _showSnackBar(context, state.message, isError: true);
              } else if (state is ExportSuccess) {
                _showSnackBar(context, '${state.filePath} ${state.message}');
              } else if (state is ImportSuccess) {
                _showSnackBar(context, state.message);
                context.read<EventsCubit>().refreshEvents();
              } else if (state is ImportPreview) {
                _showImportPreviewDialog(context, state);
              }
            },
          ),
        ],
        child: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const _LoadingView();
            } else if (state is EventsLoaded) {
              if (state.events.isEmpty) {
                return const _EmptyEventsView();
              }
              return _EventsListView(events: state.events);
            } else if (state is EventsError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<EventsCubit>().loadEvents(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgDeep,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.onGold,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            AppConstants.appName,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        // Import button
        _AppBarIconButton(
          icon: Icons.file_download_outlined,
          tooltip: 'Import Events',
          onPressed: () => _showImportDialog(context),
        ),
        const SizedBox(width: 4),
        // More options menu
        _buildMoreMenu(context),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, value),
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.more_horiz_rounded, size: 18, color: AppColors.textPrimary),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'export_all',
          child: _MenuItemContent(
            icon: Icons.file_upload_outlined,
            label: 'Export All Events',
          ),
        ),
        const PopupMenuItem(
          value: 'backup',
          child: _MenuItemContent(
            icon: Icons.backup_outlined,
            label: 'Create Backup',
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: _MenuItemContent(
            icon: Icons.settings_outlined,
            label: 'Settings',
          ),
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => showCreateEventDialog(context),
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.onGold,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'New Event',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _showImportDialog(BuildContext context) {
    context.read<ImportExportCubit>().pickFileForImport();
  }

  void _showImportPreviewDialog(BuildContext context, ImportPreview state) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings coming soon!')),
        );
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: isError ? AppColors.rose : AppColors.emerald,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.bgCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }
}

void showCreateEventDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<EventsCubit>(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: const CreateEventDialog(),
            ),
          );
        },
      ),
    ),
  );
}

// ─── List view ───────────────────────────────────────────────────────────────

class _EventsListView extends StatelessWidget {
  final List<dynamic> events;
  const _EventsListView({required this.events});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.gold,
      backgroundColor: AppColors.bgCard,
      onRefresh: () async => context.read<EventsCubit>().refreshEvents(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: EventCard(event: events[index]),
                ),
                childCount: events.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyEventsView extends StatelessWidget {
  const _EmptyEventsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: const Icon(
                Icons.event_note_outlined,
                size: 44,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Events Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create your first collection event to start tracking contributions.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Builder(
              builder: (context) => ElevatedButton.icon(
                onPressed: () => showCreateEventDialog(context),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Create First Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Loading view ─────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.gold),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
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
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  const _AppBarIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _MenuItemContent extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MenuItemContent({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      ],
    );
  }
}
