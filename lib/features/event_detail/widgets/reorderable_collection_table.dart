import 'package:collections/features/event_detail/widgets/add_column_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';
import '../../../utils/debouncer.dart';
import '../cubit/event_detail_cubit.dart';

class ReorderableCollectionTable extends StatefulWidget {
  final Event event;
  final List<EventColumn> columns;
  final List<EventRow> rows;
  final List<Cell> cells;
  final bool isLocked;

  const ReorderableCollectionTable({
    super.key,
    required this.event,
    required this.columns,
    required this.rows,
    required this.cells,
    required this.isLocked,
  });

  @override
  State<ReorderableCollectionTable> createState() =>
      _ReorderableCollectionTableState();
}

class _ReorderableCollectionTableState
    extends State<ReorderableCollectionTable> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, Debouncer> _debouncers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(ReorderableCollectionTable oldWidget) {
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
        if (column.type == ColumnType.text ||
            column.type == ColumnType.number) {
          final key = '${row.id}_${column.id}';
          final cell = _getCell(row.id, column.id);

          _controllers[key] = TextEditingController(
            text: cell?.displayValue ?? '',
          );

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
            _controllers[key] = TextEditingController(
              text: cell?.displayValue ?? '',
            );
            _debouncers[key] = Debouncer(delay: AppConstants.autosaveDelay);
          }
        }
      }
    }

    final staleKeys = _controllers.keys
        .where((key) => !validKeys.contains(key))
        .toList();
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
          child: Column(
            children: [
              _buildHeaderRow(),
              if (!widget.isLocked)
                _buildReorderableRows()
              else
                _buildStaticRows(),
            ],
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
            child: const Icon(Icons.table_chart_outlined, size: 30, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          const Text(
            AppConstants.emptyTableMessage,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: AppColors.bgElevated,
      child: Row(
        children: [
          // Drag handle space
          Container(
            width: 40,
            height: 44,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
          ),
          ...widget.columns.map((column) {
            return SizedBox(
              width: 120,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: _buildColumnHeader(column),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(EventColumn column) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (column.key == AppConstants.addColumnKey && !widget.isLocked)
            IconButton(
              onPressed: _showAddColumnDialog,
              icon: const Icon(Icons.add_rounded, color: AppColors.gold),
              iconSize: 18,
            )
          else ...[
            Expanded(
              child: Text(
                column.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.textSecondary,
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
                    child: Row(children: [
                      Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 10),
                      Text('Rename', style: TextStyle(color: AppColors.textPrimary)),
                    ]),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.rose),
                      SizedBox(width: 10),
                      Text('Delete', style: TextStyle(color: AppColors.rose)),
                    ]),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildReorderableRows() {
    final colCount = widget.columns.length;
    final tableWidth = 40.0 + colCount * 120.0;
    return SizedBox(
      width: tableWidth,
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.rows.length,
        onReorder: _onReorder,
        proxyDecorator: (child, index, animation) => Material(
          color: AppColors.bgElevated,
          elevation: 4,
          shadowColor: Colors.black54,
          child: child,
        ),
        itemBuilder: (context, index) {
          final row = widget.rows[index];
          return _buildReorderableRow(row, index, Key(row.id));
        },
      ),
    );
  }

  Widget _buildStaticRows() {
    return Column(
      children: widget.rows.asMap().entries.map((entry) {
        return _buildStaticRow(entry.value, entry.key);
      }).toList(),
    );
  }

  Widget _buildReorderableRow(EventRow row, int index, Key key) {
    final isOdd = index.isOdd;
    return Container(
      key: key,
      color: isOdd ? AppColors.bgDeep.withValues(alpha: 0.6) : null,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 52,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: const Icon(Icons.drag_handle_rounded, color: AppColors.textMuted, size: 18),
          ),
          ...widget.columns.map((column) {
            return SizedBox(
              width: 120,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: _buildCell(row, column, index),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStaticRow(EventRow row, int index) {
    final isOdd = index.isOdd;
    return Container(
      color: isOdd ? AppColors.bgDeep.withValues(alpha: 0.6) : null,
      child: Row(
        children: [
          const SizedBox(width: 40),
          ...widget.columns.map((column) {
            return SizedBox(
              width: 120,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border)),
                ),
                child: _buildCell(row, column, index),
              ),
            );
          }),
        ],
      ),
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
    return Center(
      child: Text(
        '${index + 1}',
        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted, fontSize: 13),
      ),
    );
  }

  Widget _buildTextCell(EventRow row, EventColumn column, Cell? cell) {
    if (widget.isLocked) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(cell?.textValue ?? '', style: const TextStyle(color: AppColors.textPrimary)),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
      return Align(
        alignment: Alignment.centerRight,
        child: Text(
          displayText,
          style: const TextStyle(fontFamily: 'monospace', color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
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
      style: const TextStyle(fontFamily: 'monospace', color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
    return Center(
      child: Checkbox(
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
      ),
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
          child: Row(children: [
            Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.rose),
            SizedBox(width: 10),
            Text('Delete Row', style: TextStyle(color: AppColors.rose)),
          ]),
        ),
      ],
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final reorderedRows = List<EventRow>.from(widget.rows);
    final item = reorderedRows.removeAt(oldIndex);
    reorderedRows.insert(newIndex, item);
    context.read<EventDetailCubit>().reorderRows(
      reorderedRows.map((row) => row.id).toList(),
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
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EventDetailCubit>(),
        child: const AddColumnDialog(),
      ),
    );
  }

  void _showRenameColumnDialog(EventColumn column) {
    final controller = TextEditingController(text: column.label);
    final cubit = context.read<EventDetailCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
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
                  cubit.updateColumn(column.copyWith(label: newLabel));
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
    final cubit = context.read<EventDetailCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
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
                cubit.deleteColumn(column.id);
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
    final cubit = context.read<EventDetailCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
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
                cubit.deleteRow(row.id);
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
