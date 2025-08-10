import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../core/constants/app_constants.dart';
import '../cubit/cubit.dart';

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
              backgroundColor: Colors.red,
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
              _InfoRow(
                label: 'Export Version',
                value: preview['version']?.toString() ?? 'Unknown',
              ),
              _InfoRow(
                label: 'Exported At',
                value: _formatDate(preview['exportedAt']),
              ),
              _InfoRow(
                label: 'Total Events',
                value: preview['totalEvents']?.toString() ?? '0',
              ),
              _InfoRow(
                label: 'Total Rows',
                value: preview['totalRows']?.toString() ?? '0',
              ),
              _InfoRow(
                label: 'Total Cells',
                value: preview['totalCells']?.toString() ?? '0',
              ),
              const SizedBox(height: AppConstants.padding),
              const Text(
                'Events to Import:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (preview['eventTitles'] as List?)?.length ?? 0,
                    itemBuilder: (context, index) {
                      final titles = preview['eventTitles'] as List;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.smallPadding / 2,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.event,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: AppConstants.smallPadding),
                            Expanded(
                              child: Text(
                                titles[index]?.toString() ?? 'Untitled Event',
                                style: Theme.of(context).textTheme.bodyMedium,
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
              const SizedBox(height: AppConstants.padding),
              Container(
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: Text(
                        'Imported events will be assigned new IDs to avoid conflicts.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[700],
                        ),
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
                        child: CircularProgressIndicator(strokeWidth: 2),
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
        return DateFormat('MMM dd, yyyy HH:mm')
            .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
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

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
