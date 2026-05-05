import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../data/zakat_certificate_pdf_builder.dart';
import '../models/zakat_certificate_args.dart';

class ZakatCertificateScreen extends StatelessWidget {
  const ZakatCertificateScreen({super.key, required this.args});

  final ZakatCertificateArgs args;

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final file = await ZakatCertificatePdfBuilder.writeTempPdf(args);
      await SharePlus.instance.share(
        ShareParams(
          text: 'Zakat Payment Certificate',
          files: [XFile(file.path)],
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/calculator'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 56,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Payment recorded',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Certificate ${args.certificateId}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(theme, 'Payer', args.payerFullName),
                      _line(theme, 'Amount (ETB)', MoneyFormatter.etb(args.amountEtb)),
                      if (args.amountIsMarketEstimate)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'ETB estimated at local market value.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      _line(theme, 'Method', args.paymentMethodLabel),
                      if (args.beneficiaryLabel != null &&
                          args.beneficiaryLabel!.trim().isNotEmpty)
                        _line(theme, 'Beneficiary', args.beneficiaryLabel!.trim()),
                      _line(
                        theme,
                        'Issued',
                        args.issuedAt.toLocal().toString().split('.').first,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => context.go('/calculator'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to calculator'),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () => _sharePdf(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Download / Share PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _line(ThemeData theme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              k,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(v, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
