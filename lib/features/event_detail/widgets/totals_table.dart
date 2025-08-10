import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../core/constants/app_constants.dart';

class TotalsTable extends StatelessWidget {
  final EventTotals? totals;

  const TotalsTable({super.key, this.totals});

  @override
  Widget build(BuildContext context) {
    final effectiveTotals = totals ?? EventTotals.empty('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.smallPadding),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              children: [
                // Header row
                TableRow(
                  children: [
                    _buildHeaderCell('No.'),
                    _buildHeaderCell('Source'),
                    _buildHeaderCell('Amount'),
                  ],
                ),
                // Online row
                TableRow(
                  children: [
                    _buildDataCell('1'),
                    _buildDataCell(AppConstants.onlineTotalLabel),
                    _buildAmountCell(effectiveTotals.onlineTotal),
                  ],
                ),
                // Offline row
                TableRow(
                  children: [
                    _buildDataCell('2'),
                    _buildDataCell(AppConstants.offlineTotalLabel),
                    _buildAmountCell(effectiveTotals.offlineTotal),
                  ],
                ),
                // Total row
                TableRow(
                  children: [
                    _buildDataCell('3', isBold: true),
                    _buildDataCell(AppConstants.grandTotalLabel, isBold: true),
                    _buildAmountCell(effectiveTotals.grandTotal, isBold: true),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),

        _buildLastUpdated(effectiveTotals),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAmountCell(double amount, {bool isBold = false}) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        formatter.format(amount),
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
          fontFamily: 'monospace',
          color: isBold ? Colors.blue.shade700 : null,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildLastUpdated(EventTotals totals) {
    if (totals.eventId.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(Icons.update, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          'Last updated: ${DateFormat('MMM dd, HH:mm').format(totals.updatedAt)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
