import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/presentation/qr_png.dart';

Future<(ByteData, int)> _decode(Uint8List png) async {
  final codec = await ui.instantiateImageCodec(png);
  final image = (await codec.getNextFrame()).image;
  final raw = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  return (raw!, image.width);
}

int _pixel(ByteData raw, int width, int x, int y) =>
    raw.getUint32((y * width + x) * 4);

void main() {
  const white = 0xFFFFFFFF;
  const black = 0x000000FF;

  testWidgets('payload: opaque white quiet zone, black finder', (tester) async {
    await tester.runAsync(() async {
      final png = await buildQrPng(
        payload:
            '00020101021226360014ET.GOV.NBE.ETHQR0110ZAKAT12345'
            '5204000053032305406100.005802ET5915MEJLIS ZAKAT6304A1B2',
      );
      expect(png, isNotNull);
      final (raw, width) = await _decode(png!);
      expect(width, greaterThanOrEqualTo(700));
      expect(_pixel(raw, width, 0, 0), white);
      expect(_pixel(raw, width, width - 1, width - 1), white);
      var allOpaque = true;
      for (var i = 3; i < raw.lengthInBytes; i += 4) {
        if (raw.getUint8(i) != 255) allOpaque = false;
      }
      expect(allOpaque, isTrue);
      // Centre of the top-left finder's 3x3 dot is black.
      var foundBlack = false;
      for (var x = 0; x < width ~/ 4 && !foundBlack; x++) {
        if (_pixel(raw, width, x, x) == black) foundBlack = true;
      }
      expect(foundBlack, isTrue);
    });
  });

  testWidgets('transparent server PNG is flattened onto white', (tester) async {
    await tester.runAsync(() async {
      // 2x1 PNG: one transparent pixel, one opaque black pixel.
      final pixels = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 255]);
      final buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
      final descriptor = ui.ImageDescriptor.raw(
        buffer,
        width: 2,
        height: 1,
        pixelFormat: ui.PixelFormat.rgba8888,
      );
      final image =
          (await (await descriptor.instantiateCodec()).getNextFrame()).image;
      final source = await image.toByteData(format: ui.ImageByteFormat.png);
      final png = await buildQrPng(
        imageBase64: base64Encode(source!.buffer.asUint8List()),
      );
      final (raw, width) = await _decode(png!);
      expect(_pixel(raw, width, 0, 0), white);
      expect(_pixel(raw, width, 1, 0), black);
    });
  });
}
