import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../causes/presentation/screens/causes_screen.dart';
import '../../data/models/zakat_payment_models.dart';
import '../../data/repository/zakat_payment_repository.dart';

/// The official zakat certificate (`GET /certificates/{id}`), with the
/// server's PDF (QR code included) to download and share.
class ZakatCertificateScreen extends StatefulWidget {
  const ZakatCertificateScreen({super.key, required this.certificateId});

  final String certificateId;

  @override
  State<ZakatCertificateScreen> createState() => _ZakatCertificateScreenState();
}

class _ZakatCertificateScreenState extends State<ZakatCertificateScreen> {
  final _repository = getIt<ZakatPaymentRepository>();
  ZakatCertificate? _certificate;
  ApiException? _error;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final certificate = await _repository.fetchCertificate(
        widget.certificateId,
      );
      if (mounted) setState(() => _certificate = certificate);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _sharePdf() async {
    final l10n = context.l10n;
    setState(() => _sharing = true);
    try {
      final bytes = await _repository.downloadCertificatePdf(
        widget.certificateId,
      );
      final dir = await getTemporaryDirectory();
      final safeName = widget.certificateId.replaceAll(
        RegExp(r'[^A-Za-z0-9_-]'),
        '_',
      );
      final file = File(p.join(dir.path, 'zakat-certificate-$safeName.pdf'));
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          text: l10n.certTitle,
          files: [XFile(file.path, mimeType: 'application/pdf')],
        ),
      );
    } on ApiException {
      _showSnack(l10n.certPdfError);
    } on FileSystemException {
      _showSnack(l10n.certPdfError);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final certificate = _certificate;
    final error = _error;
    final Widget body;
    if (certificate != null) {
      body = _CertificateDetails(certificate: certificate);
    } else if (error != null) {
      body = CausesMessage(
        icon: error.isNotFound
            ? Icons.search_off_rounded
            : Icons.cloud_off_outlined,
        message: error.isNotFound ? l10n.certNotFound : l10n.certLoadError,
        onRetry: error.isNotFound ? null : _load,
      );
    } else {
      body = const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZakatPageHeader(
              title: l10n.certTitle,
              subtitle: l10n.certNumber(widget.certificateId),
              leadingIcon: Icons.workspace_premium_outlined,
              onBack: () => context.canPop() ? context.pop() : context.go('/'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: body,
            ),
          ],
        ),
      ),
      bottomNavigationBar: certificate == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: _sharing
                    ? const SizedBox(
                        height: 56,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : GoldActionButton(
                        label: l10n.certSharePdf,
                        icon: Icons.download_outlined,
                        onPressed: _sharePdf,
                      ),
              ),
            ),
    );
  }
}

class _CertificateDetails extends StatelessWidget {
  const _CertificateDetails({required this.certificate});

  final ZakatCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat.yMMMd(
      context.contentLocale.toString(),
    ).add_jm();
    String? date(DateTime? value) =>
        value == null ? null : dateFormat.format(value.toLocal());
    final rows = <(String, String?)>[
      (l10n.certPayer, certificate.payerFullName),
      (l10n.certType, zakatTypeLabel(l10n, certificate.zakatType)),
      (l10n.certCause, certificate.causeTitle),
      (l10n.certNaturalUnits, certificate.naturalUnitSummary),
      (l10n.certMethod, certificate.methodLabel),
      (l10n.certReference, certificate.providerReference),
      (l10n.certPaidAt, date(certificate.paidAt)),
      (l10n.certIssuedAt, date(certificate.issuedAt)),
      (l10n.certHijriDate, certificate.hijriDate),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (certificate.issuerName != null) ...[
                Text(
                  certificate.issuerName!,
                  style: AppTypography.body(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                MoneyFormatter.etb(certificate.amountEtb),
                style: AppTypography.body(
                  fontSize: 28,
                  color: AppColors.goldDeep,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Divider(height: 24),
              for (final (label, value) in rows)
                if (value != null && value.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            label,
                            style: AppTypography.body(
                              fontSize: 13,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            value,
                            style: AppTypography.body(
                              fontSize: 14,
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              if (certificate.signatoryName != null) ...[
                const Divider(height: 24),
                Text(
                  [
                    certificate.signatoryName,
                    certificate.signatoryTitle,
                  ].whereType<String>().join(' · '),
                  style: AppTypography.body(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.certVerifyHint,
          textAlign: TextAlign.center,
          style: AppTypography.body(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Localized `zakatType`; the raw value for one the app does not know.
String? zakatTypeLabel(AppLocalizations l10n, String? zakatType) =>
    switch (zakatType) {
      null => null,
      'wealth' => l10n.zakatTypeWealth,
      'livestock' => l10n.zakatTypeLivestock,
      'crops' => l10n.zakatTypeCrops,
      'general' => l10n.zakatTypeGeneral,
      'fitr' => l10n.zakatAlFitr,
      _ => zakatType,
    };
