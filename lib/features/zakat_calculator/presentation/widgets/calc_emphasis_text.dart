import 'package:flutter/material.dart';

/// Typography helpers for the Zakat calculator.
abstract final class CalcTextStyles {
  static TextStyle stepTitle(TextTheme theme) =>
      theme.titleMedium!.copyWith(fontWeight: FontWeight.w700);

  static TextStyle sectionTitle(TextTheme theme) =>
      theme.titleSmall!.copyWith(fontWeight: FontWeight.w700);

  static TextStyle crucialBanner(TextTheme theme) =>
      theme.titleSmall!.copyWith(fontWeight: FontWeight.w700);

  static TextStyle crucialLine(TextTheme theme) =>
      theme.bodyMedium!.copyWith(fontWeight: FontWeight.w700);

  static TextStyle crucialNote(TextTheme theme) =>
      theme.labelMedium!.copyWith(fontWeight: FontWeight.w700);
}

/// Renders calculator copy with bold emphasis on amounts, thresholds, and outputs.
class CalcEmphasisText extends StatelessWidget {
  const CalcEmphasisText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.emphasizeAll = false,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool emphasizeAll;

  static final List<RegExp> _valuePatterns = [
    RegExp(r'ETB -?[\d,]+\.\d{2}'),
    RegExp(r'\d[\d,]*(?:\.\d+)?\s*kg\b', caseSensitive: false),
    RegExp(r'\d[\d,]*(?:\.\d+)?%'),
    RegExp(r'\d[\d,]*(?:\.\d+)?\s*g(?=\s|×|/|\)|,|\.|$|\s*×)'),
    RegExp(r'>=?\s*\d+'),
    RegExp(r'\b(?:653|85|40|30|5|2\.5)\b'),
    RegExp(r'=\s*[^,\n]+'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = style ?? theme.textTheme.bodySmall;
    final boldStyle = baseStyle?.copyWith(fontWeight: FontWeight.w700);

    if (emphasizeAll) {
      return Text(
        text,
        textAlign: textAlign,
        style: boldStyle ?? baseStyle,
      );
    }

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: _buildSpans(text, boldStyle ?? baseStyle!),
      ),
      textAlign: textAlign,
    );
  }

  static List<TextSpan> _buildSpans(String text, TextStyle boldStyle) {
    final ranges = <({int start, int end})>[];

    for (final pattern in _valuePatterns) {
      for (final match in pattern.allMatches(text)) {
        ranges.add((start: match.start, end: match.end));
      }
    }

    if (ranges.isEmpty) {
      return [TextSpan(text: text)];
    }

    ranges.sort((a, b) => a.start.compareTo(b.start));
    final merged = <({int start, int end})>[];
    for (final range in ranges) {
      if (merged.isEmpty || range.start > merged.last.end) {
        merged.add(range);
      } else if (range.end > merged.last.end) {
        final last = merged.removeLast();
        merged.add((start: last.start, end: range.end));
      }
    }

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final range in merged) {
      if (cursor < range.start) {
        spans.add(TextSpan(text: text.substring(cursor, range.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(range.start, range.end),
          style: boldStyle,
        ),
      );
      cursor = range.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return spans;
  }
}
