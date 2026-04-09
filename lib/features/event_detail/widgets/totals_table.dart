import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/models.dart';
import '../../../constants/colors.dart';

class TotalsTable extends StatelessWidget {
  final EventTotals? totals;

  const TotalsTable({super.key, this.totals});

  @override
  Widget build(BuildContext context) {
    final t = totals ?? EventTotals.empty('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Three summary cards ──────────────────────────────────────────────
        Row(
          children: [
            // Online
            Expanded(
              child: _SummaryCard(
                label: 'ONLINE',
                amount: t.onlineTotal,
                icon: Icons.wifi_rounded,
                accentColor: AppColors.sky,
                dimColor: AppColors.skyDim,
              ),
            ),
            const SizedBox(width: 10),
            // Offline
            Expanded(
              child: _SummaryCard(
                label: 'OFFLINE',
                amount: t.offlineTotal,
                icon: Icons.money_rounded,
                accentColor: AppColors.emerald,
                dimColor: AppColors.emeraldDim,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ── Grand total card ─────────────────────────────────────────────────
        _GrandTotalCard(amount: t.grandTotal),

        // ── Last updated ─────────────────────────────────────────────────────
        if (totals != null && totals!.eventId.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                'Updated ${DateFormat('MMM dd, HH:mm').format(totals!.updatedAt)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color accentColor;
  final Color dimColor;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.accentColor,
    required this.dimColor,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: dimColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formatter.format(amount),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  final double amount;

  const _GrandTotalCard({required this.amount});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1900), Color(0xFF1A1200)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.gold,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GRAND TOTAL',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatter.format(amount),
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
