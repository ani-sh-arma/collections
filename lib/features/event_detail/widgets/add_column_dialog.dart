import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../../core/constants/app_constants.dart';
import '../bloc/bloc.dart';

class AddColumnDialog extends StatefulWidget {
  const AddColumnDialog({super.key});

  @override
  State<AddColumnDialog> createState() => _AddColumnDialogState();
}

class _AddColumnDialogState extends State<AddColumnDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  ColumnType _selectedType = ColumnType.text;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailBloc, EventDetailState>(
      listener: (context, state) {
        if (state is EventDetailLoaded) {
          Navigator.of(context).pop();
        } else if (state is EventDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Add New Column'),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column name input
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                    labelText: 'Column Name *',
                    hintText: 'Enter column name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a column name';
                    }
                    if (value.trim().length > 50) {
                      return 'Column name must be 50 characters or less';
                    }
                    return null;
                  },
                  autofocus: true,
                ),

                const SizedBox(height: AppConstants.padding),

                // Column type selection
                const Text(
                  'Column Type:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: AppConstants.smallPadding),

                // Text type
                RadioListTile<ColumnType>(
                  title: const Text('Text'),
                  subtitle: const Text('For names, descriptions, etc.'),
                  value: ColumnType.text,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value ?? ColumnType.text;
                    });
                  },
                ),

                // Number type
                RadioListTile<ColumnType>(
                  title: const Text('Number'),
                  subtitle: const Text('For amounts, quantities, etc.'),
                  value: ColumnType.number,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value ?? ColumnType.text;
                    });
                  },
                ),

                // Boolean type
                RadioListTile<ColumnType>(
                  title: const Text('Checkbox'),
                  subtitle: const Text('For yes/no, true/false values'),
                  value: ColumnType.boolean,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value ?? ColumnType.text;
                    });
                  },
                ),

                const SizedBox(height: AppConstants.padding),

                // Info note
                Container(
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallPadding,
                    ),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: Text(
                          'The new column will be added before the "+" column.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<EventDetailBloc, EventDetailState>(
            builder: (context, state) {
              final isLoading = state is EventDetailSaving;

              return ElevatedButton(
                onPressed: isLoading ? null : _addColumn,
                child:
                    isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Add Column'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addColumn() {
    if (_formKey.currentState?.validate() ?? false) {
      final label = _labelController.text.trim();
      context.read<EventDetailBloc>().add(
        AddColumn(label: label, type: _selectedType),
      );
    }
  }
}
