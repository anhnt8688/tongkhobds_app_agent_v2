import 'dart:io';

import 'package:image/image.dart' as img;

/// Crop arguments passed to [cropByPercentEntry] across an isolate boundary.
class CropArgs {
  const CropArgs({
    required this.inPath,
    required this.outPath,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.quality = 88,
  });

  final String inPath;
  final String outPath;
  final double left;
  final double top;
  final double width;
  final double height;
  final int quality;
}

/// Crop a JPEG to the given percentage rect (relative to the baked-orientation
/// image) and write it to [CropArgs.outPath]. Runs in a background isolate via
/// `compute` — pure function, no Flutter bindings. Returns the output path
/// (falls back to the input path if decoding fails).
String cropByPercentEntry(CropArgs args) {
  final bytes = File(args.inPath).readAsBytesSync();
  img.Image? src = img.decodeImage(bytes);
  if (src == null) return args.inPath;

  src = img.bakeOrientation(src);

  final l = args.left.clamp(0.0, 1.0);
  final t = args.top.clamp(0.0, 1.0);
  final w = args.width.clamp(0.0, 1.0);
  final h = args.height.clamp(0.0, 1.0);

  final x = (src.width * l).floor();
  final y = (src.height * t).floor();
  final cw = (src.width * w).round().clamp(1, src.width - x);
  final ch = (src.height * h).round().clamp(1, src.height - y);

  final cropped = img.copyCrop(src, x: x, y: y, width: cw, height: ch);
  File(args.outPath).writeAsBytesSync(img.encodeJpg(cropped, quality: args.quality));
  return args.outPath;
}
