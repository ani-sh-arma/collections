import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/models.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';
import '../cubit/event_detail_state.dart';
import '../cubit/event_detail_cubit.dart';

class AddColumnDialog extends StatefulWidget {
  const AddColumnDialog({super.key});

  @override
  State<AddColumnDialog> createState() => _AddColumnDialogState();
}

class _AddColumnDialogState extends State<AddColumnDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  ColumnType _selectedType = ColumnType.text;
  bool _pendingSave = false;

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailCubit, EventDetailState>(
      listener: (context, state) {
        if (_pendingSave && state is EventDetailLoaded) {
          Navigator.of(context).pop();
        } else if (state is EventDetailError) {
          _pendingSave = false;
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
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Column Name *',
                    hintText: 'Enter column name',
                    prefixIcon: Icon(Icons.label_outline_rounded),
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
                  'COLUMN TYPE',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),

                _TypeOption(
                  label: 'Text',
                  subtitle: 'Names, descriptions, etc.',
                  icon: Icons.text_fields_rounded,
                  value: ColumnType.text,
                  groupValue: _selectedType,
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),
                _TypeOption(
                  label: 'Number',
                  subtitle: 'Amounts, quantities, etc.',
                  icon: Icons.tag_rounded,
                  value: ColumnType.number,
                  groupValue: _selectedType,
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),
                _TypeOption(
                  label: 'Checkbox',
                  subtitle: 'Yes/No, True/False values',
                  icon: Icons.check_box_outlined,
                  value: ColumnType.boolean,
                  groupValue: _selectedType,
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),

                const SizedBox(height: AppConstants.padding),

                // Info note
                Container(
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  decoration: BoxDecoration(
                    color: AppColors.skyDim,
                    borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    border: Border.all(color: AppColors.sky.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.sky, size: 14),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: Text(
                          'The new column will be added before the "+" column.',
                          style: TextStyle(fontSize: 12, color: AppColors.sky.withValues(alpha: 0.9)),
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
          BlocBuilder<EventDetailCubit, EventDetailState>(
            builder: (context, state) {
              final isLoading = state is EventDetailSaving;
              return ElevatedButton(
                onPressed: isLoading ? null : _addColumn,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF150900)),
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
      setState(() => _pendingSave = true);
      context.read<EventDetailCubit>().addColumn(
        label: _labelController.text.trim(),
        type: _selectedType,
      );
    }
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final ColumnType value;
  final ColumnType groupValue;
  final ValueChanged<ColumnType?> onChanged;

  const _TypeOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withValues(alpha: 0.1)
              : AppColors.bgDeep,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.gold.withValues(alpha: 0.4) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Radio<ColumnType>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: isSelected ? AppColors.gold : AppColors.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

