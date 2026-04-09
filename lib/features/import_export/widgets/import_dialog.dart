import 'package:collections/features/import_export/cubit/import_export_cubit.dart';
import 'package:collections/features/import_export/cubit/import_export_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';

class ImportDialog extends StatelessWidget {
  final ExportData exportData;
  final Map<String, dynamic> preview;

  const ImportDialog({
    super.key,
    required this.exportData,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImportExportCubit, ImportExportState>(
      listener: (context, state) {
        if (state is ImportSuccess) {
          Navigator.of(context).pop();
        } else if (state is ImportExportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.bgCard,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Import Preview'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats grid
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bgDeep,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: 'Export Version', value: preview['version']?.toString() ?? 'Unknown'),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Exported At', value: _formatDate(preview['exportedAt'])),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Total Events', value: preview['totalEvents']?.toString() ?? '0'),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Total Rows', value: preview['totalRows']?.toString() ?? '0'),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Total Cells', value: preview['totalCells']?.toString() ?? '0'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'EVENTS TO IMPORT',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 160),
                  decoration: BoxDecoration(
                    color: AppColors.bgDeep,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: (preview['eventTitles'] as List?)?.length ?? 0,
                    itemBuilder: (context, index) {
                      final titles = preview['eventTitles'] as List;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                titles[index]?.toString() ?? 'Untitled Event',
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: AppColors.skyDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.sky.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.sky, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Imported events will be assigned new IDs to avoid conflicts.',
                        style: TextStyle(fontSize: 12, color: AppColors.sky.withValues(alpha: 0.9)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ImportExportCubit>().cancelImport();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          BlocBuilder<ImportExportCubit, ImportExportState>(
            builder: (context, state) {
              final isImporting = state is ImportExportLoading;
              return ElevatedButton(
                onPressed: isImporting
                    ? null
                    : () => context.read<ImportExportCubit>().confirmImport(exportData),
                child: isImporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onGold),
                      )
                    : const Text('Import'),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp is DateTime) {
        return DateFormat('MMM dd, yyyy HH:mm').format(timestamp);
      } else if (timestamp is int) {
        return DateFormat('MMM dd, yyyy HH:mm').format(
          DateTime.fromMillisecondsSinceEpoch(timestamp),
        );
      }
      return 'Unknown';
    } catch (e) {
      return 'Invalid Date';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
