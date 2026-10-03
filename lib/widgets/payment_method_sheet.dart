import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../theme/app_theme.dart';

/// "Payment Method" modal (Fig. 9 in the original design):
/// Credit/Debit Card, GCash, GrabPay.
Future<PaymentMethod?> showPaymentMethodSheet(BuildContext context) {
  return showModalBottomSheet<PaymentMethod>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PaymentMethodSheet(),
  );
}

class _PaymentMethodSheet extends StatelessWidget {
  const _PaymentMethodSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT METHOD',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          _PaymentOption(
            icon: Icons.credit_card,
            iconColor: AppColors.navy,
            title: 'CREDIT/DEBIT CARD',
            subtitle: 'Pay with Mastercard, Visa, BDO',
            onTap: () => Navigator.of(context).pop(PaymentMethod.card),
          ),
          const SizedBox(height: 12),
          _PaymentOption(
            icon: Icons.account_balance_wallet,
            iconColor: AppColors.gcash,
            title: 'GCASH',
            subtitle: 'Pay using your GCash balance',
            onTap: () => Navigator.of(context).pop(PaymentMethod.gcash),
          ),
          const SizedBox(height: 12),
          _PaymentOption(
            icon: Icons.local_taxi,
            iconColor: AppColors.grabpay,
            title: 'GRABPAY',
            subtitle: 'Pay using your GrabPay wallet',
            onTap: () => Navigator.of(context).pop(PaymentMethod.grabpay),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
