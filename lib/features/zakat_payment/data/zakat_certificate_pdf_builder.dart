import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/common/utils/money_formatter.dart';
import '../presentation/models/zakat_certificate_args.dart';

/// Builds a simple official-style PDF and writes it to a temp file.
class ZakatCertificatePdfBuilder {
  ZakatCertificatePdfBuilder._();

  static Future<File> writeTempPdf(ZakatCertificateArgs args) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Zakat and Awqaf Commission',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Zakat Payment Certificate',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 16),
              _kv('Certificate No.', args.certificateId),
              _kv('Payer', args.payerFullName),
              _kv('Amount paid (ETB)', MoneyFormatter.etb(args.amountEtb)),
              if (args.amountIsMarketEstimate) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  'ETB amount estimated by payer at local and current market value.',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
              if (args.naturalUnitSummary != null &&
                  args.naturalUnitSummary!.trim().isNotEmpty) ...[
                pw.SizedBox(height: 8),
                _kv('Calculated overview (natural units)', args.naturalUnitSummary!.trim()),
              ],
              _kv('Payment method', args.paymentMethodLabel),
              if (args.beneficiaryLabel != null &&
                  args.beneficiaryLabel!.trim().isNotEmpty)
                _kv('Beneficiary / project', args.beneficiaryLabel!.trim()),
              _kv(
                'Issued',
                args.issuedAt.toLocal().toString().split('.').first,
              ),
              pw.Spacer(),
              pw.Text(
                'This document is issued for the payer’s records.',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final safeId = args.certificateId.replaceAll(RegExp(r'[^\w-]+'), '_');
    final file = File('${dir.path}/zakat_certificate_$safeId.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  static pw.Widget _kv(String k, String v) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              k,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(v)),
        ],
      ),
    );
  }
}
