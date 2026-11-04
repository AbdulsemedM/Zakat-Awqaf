import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:qr_flutter/qr_flutter.dart';

/// PNG of a payment QR with black modules on an opaque white background,
/// for sharing and saving to the gallery. Gallery and chat apps show
/// transparent pixels as black, so the image must never be transparent.
///
/// Built from [payload] when there is one (pixel by pixel, so it does not
/// depend on how the GPU draws); else [imageBase64] (the server's PNG)
/// flattened onto white. Null when neither gives an image.
Future<Uint8List?> buildQrPng({String? payload, String? imageBase64}) async {
  if (payload != null && payload.isNotEmpty) {
    final png = await _pngFromPayload(payload);
    if (png != null) return png;
  }
  if (imageBase64 != null && imageBase64.isNotEmpty) {
    return _flattenOnWhite(imageBase64);
  }
  return null;
}

/// About 800 px wide, with the 4-module quiet zone bank apps need.
Future<Uint8List?> _pngFromPayload(String payload) async {
  final validation = QrValidator.validate(
    data: payload,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );
  final code = validation.qrCode;
  if (!validation.isValid || code == null) return null;
  final qr = QrImage(code);
  const quietZone = 4;
  final modules = qr.moduleCount;
  final scale = (800 / (modules + 2 * quietZone)).ceil();
  final side = (modules + 2 * quietZone) * scale;
  // White everywhere, then the dark modules.
  final pixels = Uint8List(side * side * 4)..fillRange(0, side * side * 4, 255);
  for (var row = 0; row < modules; row++) {
    for (var col = 0; col < modules; col++) {
      if (!qr.isDark(row, col)) continue;
      final top = (row + quietZone) * scale;
      final left = (col + quietZone) * scale;
      for (var y = top; y < top + scale; y++) {
        final start = (y * side + left) * 4;
        for (var i = start; i < start + scale * 4; i += 4) {
          pixels[i] = 0;
          pixels[i + 1] = 0;
          pixels[i + 2] = 0;
        }
      }
    }
  }
  return _encodePng(pixels, side, side);
}

Future<Uint8List?> _flattenOnWhite(String imageBase64) async {
  final Uint8List bytes;
  try {
    bytes = base64Decode(imageBase64);
  } on FormatException {
    return null;
  }
  final codec = await ui.instantiateImageCodec(bytes);
  final image = (await codec.getNextFrame()).image;
  final width = image.width;
  final height = image.height;
  final raw = await image.toByteData(
    format: ui.ImageByteFormat.rawStraightRgba,
  );
  image.dispose();
  if (raw == null) return null;
  final pixels = raw.buffer.asUint8List(raw.offsetInBytes, raw.lengthInBytes);
  for (var i = 0; i < pixels.length; i += 4) {
    final alpha = pixels[i + 3];
    if (alpha == 255) continue;
    for (var c = 0; c < 3; c++) {
      pixels[i + c] = (pixels[i + c] * alpha + 255 * (255 - alpha)) ~/ 255;
    }
    pixels[i + 3] = 255;
  }
  return _encodePng(pixels, width, height);
}

Future<Uint8List?> _encodePng(Uint8List rgba, int width, int height) async {
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    rgba,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  final image = await completer.future;
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return png?.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes);
}
