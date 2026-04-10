import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';
import '../../../utils/debouncer.dart';
import '../cubit/event_detail_cubit.dart';
import 'add_column_dialog.dart';

class CollectionTable extends StatefulWidget {
  final Event event;
  final List<EventColumn> columns;
  final List<EventRow> rows;
  final List<Cell> cells;
  final bool isLocked;

  const CollectionTable({
    super.key,
    required this.event,
    required this.columns,
    required this.rows,
    required this.cells,
    required this.isLocked,
  });

  @override
  State<CollectionTable> createState() => _CollectionTableState();
}

class _CollectionTableState extends State<CollectionTable> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, Debouncer> _debouncers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(CollectionTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cells != widget.cells ||
        oldWidget.rows != widget.rows ||
        oldWidget.columns != widget.columns) {
      _updateControllers();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final debouncer in _debouncers.values) {
      debouncer.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    _controllers.clear();
    _debouncers.clear();

    for (final row in widget.rows) {
      for (final column in widget.columns) {
        if (column.type == ColumnType.text || column.type == ColumnType.number) {
          final key = '${row.id}_${column.id}';
          final cell = _getCell(row.id, column.id);
          _controllers[key] = TextEditingController(text: cell?.displayValue ?? '');
          _debouncers[key] = Debouncer(delay: AppConstants.autosaveDelay);
        }
      }
    }
  }

  void _updateControllers() {
    final validKeys = <String>{};

    for (final row in widget.rows) {
      for (final column in widget.columns) {
        if (column.type == ColumnType.text || column.type == ColumnType.number) {
          final key = '${row.id}_${column.id}';
          validKeys.add(key);

          if (!_controllers.containsKey(key)) {
            final cell = _getCell(row.id, column.id);
            _controllers[key] = TextEditingController(text: cell?.displayValue ?? '');
            _debouncers[key] = Debouncer(delay: AppConstants.autosaveDelay);
          }
        }
      }
    }

    final staleKeys = _controllers.keys.where((key) => !validKeys.contains(key)).toList();
    for (final key in staleKeys) {
      _controllers.remove(key)?.dispose();
      _debouncers.remove(key)?.dispose();
    }
  }

  Cell? _getCell(String rowId, String columnId) {
    try {
      return widget.cells.firstWhere(
        (cell) => cell.rowId == rowId && cell.columnId == columnId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.columns.isEmpty || widget.rows.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 8,
            horizontalMargin: 12,
            headingRowHeight: 44,
            dataRowMinHeight: 52,
            dataRowMaxHeight: 52,
            headingRowColor: WidgetStateProperty.all(AppColors.bgElevated),
            border: TableBorder(
              horizontalInside: BorderSide(color: AppColors.border, width: 1),
              verticalInside: BorderSide(color: AppColors.border, width: 1),
            ),
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.table_chart_outlined,
              size: 30,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppConstants.emptyTableMessage,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return widget.columns.map((column) {
      return DataColumn(label: Expanded(child: _buildColumnHeader(column)));
    }).toList();
  }

  Widget _buildColumnHeader(EventColumn column) {
    if (column.key == AppConstants.addColumnKey) {
      return _buildAddColumnButton();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            column.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (!column.fixed && !widget.isLocked)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 14, color: AppColors.textMuted),
            onSelected: (value) => _handleColumnAction(column, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rename',
                child: _MenuRow(icon: Icons.edit_outlined, label: 'Rename'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: _MenuRow(icon: Icons.delete_outline_rounded, label: 'Delete', isDestructive: true),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAddColumnButton() {
    if (widget.isLocked) {
      return const Icon(Icons.add_rounded, color: AppColors.textMuted, size: 18);
    }
    return IconButton(
      onPressed: _showAddColumnDialog,
      icon: const Icon(Icons.add_rounded, color: AppColors.gold),
      tooltip: 'Add Column',
      iconSize: 18,
    );
  }

  List<DataRow> _buildRows() {
    final rows = <DataRow>[];
    for (int i = 0; i < widget.rows.length; i++) {
      rows.add(_buildDataRow(widget.rows[i], i));
    }
    return rows;
  }

  DataRow _buildDataRow(EventRow row, int index) {
    return DataRow(
      color: WidgetStateProperty.resolveWith((states) {
        return index.isOdd ? AppColors.bgDeep.withValues(alpha: 0.5) : null;
      }),
      cells: widget.columns.map((column) {
        return DataCell(_buildCell(row, column, index));
      }).toList(),
    );
  }

  Widget _buildCell(EventRow row, EventColumn column, int rowIndex) {
    final cell = _getCell(row.id, column.id);
    switch (column.type) {
      case ColumnType.serial:
        return _buildSerialCell(rowIndex);
      case ColumnType.text:
        return _buildTextCell(row, column, cell);
      case ColumnType.number:
        return _buildNumberCell(row, column, cell);
      case ColumnType.boolean:
        return _buildBooleanCell(row, column, cell);
      case ColumnType.action:
        return _buildActionCell(row);
    }
  }

  Widget _buildSerialCell(int index) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${index + 1}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTextCell(EventRow row, EventColumn column, Cell? cell) {
    if (widget.isLocked) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          cell?.textValue ?? '',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        ),
      );
    }

    final key = '${row.id}_${column.id}';
    final controller = _controllers[key];
    if (controller == null) return const SizedBox.shrink();

    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      onChanged: (value) {
        _debouncers[key]?.call(() {
          context.read<EventDetailCubit>().updateCellText(
            rowId: row.id,
            columnId: column.id,
            value: value,
          );
        });
      },
      onEditingComplete: () {
        context.read<EventDetailCubit>().updateCellText(
          rowId: row.id,
          columnId: column.id,
          value: controller.text,
        );
      },
    );
  }

  Widget _buildNumberCell(EventRow row, EventColumn column, Cell? cell) {
    if (widget.isLocked) {
      final num = cell?.valueNumber;
      final displayText = num != null
          ? (num == num.truncateToDouble() ? num.toInt().toString() : num.toString())
          : '';
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          displayText,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final key = '${row.id}_${column.id}';
    final controller = _controllers[key];
    if (controller == null) return const SizedBox.shrink();

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      style: const TextStyle(
        fontFamily: 'monospace',
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      textAlign: TextAlign.right,
      onChanged: (value) {
        // Immediately update in-memory state so totals reflect every keystroke.
        final numValue = double.tryParse(value) ?? 0.0;
        context.read<EventDetailCubit>().previewCellNumber(
          rowId: row.id,
          columnId: column.id,
          value: numValue,
        );
        // Debounced DB write via updateCellNumber.
        _debouncers[key]?.call(() {
          context.read<EventDetailCubit>().updateCellNumber(
            rowId: row.id,
            columnId: column.id,
            value: numValue,
          );
        });
      },
      onEditingComplete: () {
        final numValue = double.tryParse(controller.text) ?? 0.0;
        context.read<EventDetailCubit>().updateCellNumber(
          rowId: row.id,
          columnId: column.id,
          value: numValue,
        );
      },
    );
  }

  Widget _buildBooleanCell(EventRow row, EventColumn column, Cell? cell) {
    final isChecked = cell?.boolValue ?? false;
    return Checkbox(
      value: isChecked,
      onChanged: widget.isLocked
          ? null
          : (value) {
              // Immediate in-memory preview so totals update instantly.
              context.read<EventDetailCubit>().previewCellBool(
                rowId: row.id,
                columnId: column.id,
                value: value ?? false,
              );
              context.read<EventDetailCubit>().updateCellBool(
                rowId: row.id,
                columnId: column.id,
                value: value ?? false,
              );
            },
    );
  }

  Widget _buildActionCell(EventRow row) {
    if (widget.isLocked) return const SizedBox.shrink();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz_rounded, size: 16, color: AppColors.textMuted),
      onSelected: (value) => _handleRowAction(row, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: _MenuRow(icon: Icons.delete_outline_rounded, label: 'Delete Row', isDestructive: true),
        ),
      ],
    );
  }

  void _handleColumnAction(EventColumn column, String action) {
    switch (action) {
      case 'rename':
        _showRenameColumnDialog(column);
        break;
      case 'delete':
        _showDeleteColumnConfirmation(column);
        break;
    }
  }

  void _handleRowAction(EventRow row, String action) {
    if (action == 'delete') _showDeleteRowConfirmation(row);
  }

  void _showAddColumnDialog() {
    final eventDetailCubit = context.read<EventDetailCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: eventDetailCubit,
        child: const AddColumnDialog(),
      ),
    );
  }

  void _showRenameColumnDialog(EventColumn column) {
    final controller = TextEditingController(text: column.label);
    final eventDetailCubit = context.read<EventDetailCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: eventDetailCubit,
        child: AlertDialog(
          title: const Text('Rename Column'),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Column Name',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newLabel = controller.text.trim();
                if (newLabel.isNotEmpty && newLabel != column.label) {
                  eventDetailCubit.updateColumn(column.copyWith(label: newLabel));
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

  void _showDeleteColumnConfirmation(EventColumn column) {
    final eventDetailCubit = context.read<EventDetailCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: eventDetailCubit,
        child: AlertDialog(
          title: const Text('Delete Column'),
          content: const Text(AppConstants.deleteColumnConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                eventDetailCubit.deleteColumn(column.id);
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

  void _showDeleteRowConfirmation(EventRow row) {
    final eventDetailCubit = context.read<EventDetailCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: eventDetailCubit,
        child: AlertDialog(
          title: const Text('Delete Row'),
          content: const Text(AppConstants.deleteRowConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                eventDetailCubit.deleteRow(row.id);
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
}

// ── Small helper for popup menu items ─────────────────────────────────────────

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _MenuRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.rose : AppColors.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}
