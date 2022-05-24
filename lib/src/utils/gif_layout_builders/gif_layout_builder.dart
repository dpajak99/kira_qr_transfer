import 'package:image/image.dart' as img;
import 'package:kira_qr_transfer/src/models/gif_settings.dart';

// ignore: one_member_abstracts
abstract class GifLayoutBuilder {
  const GifLayoutBuilder();

  void drawFrameLayout({required img.GifEncoder gifEncoder, required GifSettings gifSettings});
}
