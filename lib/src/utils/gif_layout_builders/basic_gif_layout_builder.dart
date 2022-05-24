import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as img;
import 'package:kira_qr_transfer/src/models/gif_settings.dart';
import 'package:kira_qr_transfer/src/utils/gif_layout_builders/gif_layout_builder.dart';

class BasicGifLayoutBuilder extends GifLayoutBuilder {
  const BasicGifLayoutBuilder() : super();

  @override
  void drawFrameLayout({required img.GifEncoder gifEncoder, required GifSettings gifSettings}) {
    img.Image image = img.Image.rgb(500, 500);
    img.fill(image, img.getColor(255, 255, 255));
    drawBarcode(image, Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.medium), gifSettings.data,
        width: 450, height: 450, x: 25, y: 25);
    gifEncoder.addFrame(image, duration: (gifSettings.frameDuration.inMilliseconds * 0.1).toInt());
  }
}
