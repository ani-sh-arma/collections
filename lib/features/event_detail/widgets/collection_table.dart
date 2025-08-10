import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/debouncer.dart';
import '../bloc/bloc.dart';
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
    if (oldWidget.cells != widget.cells) {
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

          _controllers[key] = TextEditingController(
            text: cell?.displayValue ?? '',
          );

          _debouncers[key] = Debouncer(delay: AppConstants.autosaveDelay);
        }
      }
    }
  }

  void _updateControllers() {
    for (final row in widget.rows) {
      for (final column in widget.columns) {
        if (column.type == ColumnType.text || column.type == ColumnType.number) {
          final key = '${row.id}_${column.id}';
          final cell = _getCell(row.id, column.id);

          if (_controllers.containsKey(key)) {
            final controller = _controllers[key]!;
            final newValue = cell?.displayValue ?? '';
            if (controller.text != newValue) {
              controller.text = newValue;
            }
          }
        }
      }
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

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 8,
            horizontalMargin: 8,
            headingRowHeight: 48,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 56,
            border: TableBorder.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          children: [
            Icon(
              Icons.table_chart,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.padding),
            Text(
              AppConstants.emptyTableMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return widget.columns.map((column) {
      return DataColumn(
        label: Expanded(
          child: _buildColumnHeader(column),
        ),
      );
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
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (!column.fixed && !widget.isLocked)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 16),
            onSelected: (value) => _handleColumnAction(column, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rename',
                child: Text('Rename'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAddColumnButton() {
    if (widget.isLocked) {
      return const Icon(
        Icons.add,
        color: Colors.grey,
        size: 20,
      );
    }

    return IconButton(
      onPressed: _showAddColumnDialog,
      icon: const Icon(Icons.add),
      tooltip: 'Add Column',
      iconSize: 20,
    );
  }

  List<DataRow> _buildRows() {
    final rows = <DataRow>[];

    for (int i = 0; i < widget.rows.length; i++) {
      final row = widget.rows[i];
      rows.add(_buildDataRow(row, i));
    }

    return rows;
  }

  DataRow _buildDataRow(EventRow row, int index) {
    return DataRow(
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
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTextCell(EventRow row, EventColumn column, Cell? cell) {
    if (widget.isLocked) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Text(cell?.textValue ?? ''),
      );
    }

    final key = '${row.id}_${column.id}';
    final controller = _controllers[key];

    if (controller == null) return const SizedBox.shrink();

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      onChanged: (value) {
        _debouncers[key]?.call(() {
          context.read<EventDetailBloc>().add(
            UpdateCellText(
              rowId: row.id,
              columnId: column.id,
              value: value,
            ),
          );
        });
      },
      onEditingComplete: () {
        // Immediate save on editing complete
        context.read<EventDetailBloc>().add(
          UpdateCellText(
            rowId: row.id,
            columnId: column.id,
            value: controller.text,
          ),
        );
      },
    );
  }

  Widget _buildNumberCell(EventRow row, EventColumn column, Cell? cell) {
    if (widget.isLocked) {
      return Container(
        alignment: Alignment.centerRight,
        child: Text(
          cell?.numberValue.toString() ?? '0',
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      );
    }

    final key = '${row.id}_${column.id}';
    final controller = _controllers[key];

    if (controller == null) return const SizedBox.shrink();

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      textAlign: TextAlign.right,
      style: const TextStyle(fontFamily: 'monospace'),
      onChanged: (value) {
        _debouncers[key]?.call(() {
          final numValue = double.tryParse(value) ?? 0.0;
          context.read<EventDetailBloc>().add(
            UpdateCellNumber(
              rowId: row.id,
              columnId: column.id,
              value: numValue,
            ),
          );
        });
      },
      onEditingComplete: () {
        final numValue = double.tryParse(controller.text) ?? 0.0;
        context.read<EventDetailBloc>().add(
          UpdateCellNumber(
            rowId: row.id,
            columnId: column.id,
            value: numValue,
          ),
        );
      },
    );
  }

  Widget _buildBooleanCell(EventRow row, EventColumn column, Cell? cell) {
    final isChecked = cell?.boolValue ?? false;

    return Checkbox(
      value: isChecked,
      onChanged: widget.isLocked ? null : (value) {
        context.read<EventDetailBloc>().add(
          UpdateCellBool(
            rowId: row.id,
            columnId: column.id,
            value: value ?? false,
          ),
        );
      },
    );
  }

  Widget _buildActionCell(EventRow row) {
    if (widget.isLocked) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, size: 16),
      onSelected: (value) => _handleRowAction(row, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete Row'),
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
    switch (action) {
      case 'delete':
        _showDeleteRowConfirmation(row);
        break;
    }
  }

  void _showAddColumnDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<EventDetailBloc>(),
        child: const AddColumnDialog(),
      ),
    );
  }

  void _showRenameColumnDialog(EventColumn column) {
    final controller = TextEditingController(text: column.label);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Column'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Column Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newLabel = controller.text.trim();
              if (newLabel.isNotEmpty && newLabel != column.label) {
                context.read<EventDetailBloc>().add(
                  UpdateColumn(column.copyWith(label: newLabel)),
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

  void _showDeleteColumnConfirmation(EventColumn column) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Column'),
        content: const Text(AppConstants.deleteColumnConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EventDetailBloc>().add(DeleteColumn(column.id));
              Navigator.of(context).pop();
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

  void _showDeleteRowConfirmation(EventRow row) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Row'),
        content: const Text(AppConstants.deleteRowConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EventDetailBloc>().add(DeleteRow(row.id));
              Navigator.of(context).pop();
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
