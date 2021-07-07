import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class Utils {
  static Future capture(GlobalKey key) async {
    if (key == null) return null;

    // Tìm object theo key.
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();

    // Capture object dưới dạng hình ảnh.
    final image = await boundary.toImage(pixelRatio: 3);

    // Chuyển đối tượng hình ảnh đó sang ByteData theo format của png.
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // Chuyển ByteData sang Uint8List.
    final pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }
}