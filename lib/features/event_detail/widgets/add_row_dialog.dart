import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/colors.dart';
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
  bool _pendingSave = false;

  @override
  void dispose() {
    _positionController.dispose();
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
                  'WHERE TO ADD',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: AppColors.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                _RowOption(
                  title: 'Add at the end',
                  subtitle: 'Append to the bottom of the table',
                  icon: Icons.vertical_align_bottom_rounded,
                  value: true,
                  groupValue: _addAtEnd,
                  onChanged: (v) => setState(() => _addAtEnd = v!),
                ),
                const SizedBox(height: 8),
                _RowOption(
                  title: 'Insert at position',
                  subtitle: 'Insert at a specific row number',
                  icon: Icons.format_list_numbered_rounded,
                  value: false,
                  groupValue: _addAtEnd,
                  onChanged: (v) => setState(() => _addAtEnd = v!),
                ),

                if (!_addAtEnd) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _positionController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Row Position *',
                      hintText: 'e.g., 1, 2, 3...',
                      prefixIcon: Icon(Icons.format_list_numbered_rounded),
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
                  const SizedBox(height: 10),
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
                            'Rows at this position and below will be moved down.',
                            style: TextStyle(fontSize: 12, color: AppColors.sky.withValues(alpha: 0.9)),
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
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onGold,
                        ),
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
    setState(() => _pendingSave = true);
    if (_addAtEnd) {
      context.read<EventDetailCubit>().addRow();
    } else {
      if (_formKey.currentState?.validate() ?? false) {
        final position = int.parse(_positionController.text);
        context.read<EventDetailCubit>().insertRowAtPosition(position);
      } else {
        setState(() => _pendingSave = false);
      }
    }
  }
}

class _RowOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool?> onChanged;

  const _RowOption({
    required this.title,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold.withValues(alpha: 0.1) : AppColors.bgDeep,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.gold.withValues(alpha: 0.4) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
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
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
