import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../cubit/event_detail_state.dart';
import '../cubit/event_detail_cubit.dart';

class AddRowDialog extends StatefulWidget {
  const AddRowDialog({super.key});

  @override
  State<AddRowDialog> createState() => _AddRowDialogState();
}

class _AddRowDialogState extends State<AddRowDialog> {
  final _formKey = GlobalKey<FormState>();
  final _positionController = TextEditingController();
  bool _addAtEnd = true;

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailCubit, EventDetailState>(
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
        title: const Text('Add New Row'),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose where to add the new row:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppConstants.padding),

                // Add at end option
                RadioListTile<bool>(
                  title: const Text('Add at the end'),
                  subtitle: const Text('Append to the bottom of the table'),
                  value: true,
                  groupValue: _addAtEnd,
                  onChanged: (value) {
                    setState(() {
                      _addAtEnd = value ?? true;
                    });
                  },
                ),

                // Insert at position option
                RadioListTile<bool>(
                  title: const Text('Insert at specific position'),
                  subtitle: const Text('Insert at a specific row number'),
                  value: false,
                  groupValue: _addAtEnd,
                  onChanged: (value) {
                    setState(() {
                      _addAtEnd = value ?? true;
                    });
                  },
                ),

                // Position input (only shown when inserting at position)
                if (!_addAtEnd) ...[
                  const SizedBox(height: AppConstants.padding),
                  TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(
                      labelText: 'Row Position *',
                      hintText: 'Enter row number (e.g., 1, 2, 3...)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.format_list_numbered),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a row position';
                      }
                      final position = int.tryParse(value);
                      if (position == null || position < 1) {
                        return 'Please enter a valid position (1 or greater)';
                      }
                      return null;
                    },
                    autofocus: true,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
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
                            'Existing rows at this position and below will be moved down.',
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<EventDetailCubit, EventDetailState>(
            builder: (context, state) {
              final isLoading = state is EventDetailSaving;

              return ElevatedButton(
                onPressed: isLoading ? null : _addRow,
                child:
                    isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Add Row'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addRow() {
    if (_addAtEnd) {
      // Add at the end
      context.read<EventDetailCubit>().addRow();
    } else {
      // Insert at specific position
      if (_formKey.currentState?.validate() ?? false) {
        final position = int.parse(_positionController.text);
        context.read<EventDetailCubit>().insertRowAtPosition(position);
      }
    }
  }
}
