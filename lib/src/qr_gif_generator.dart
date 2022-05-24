import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:kira_qr_transfer/src/models/gif_settings.dart';
import 'package:kira_qr_transfer/src/models/qr_frame_wrapper.dart';
import 'package:kira_qr_transfer/src/utils/gif_layout_builders/basic_gif_layout_builder.dart';
import 'package:kira_qr_transfer/src/utils/gif_layout_builders/gif_layout_builder.dart';

class QrGifGenerator {
  final GifLayoutBuilder gifLayoutBuilder;
  final Duration frameDuration;

  QrGifGenerator({
    this.gifLayoutBuilder = const BasicGifLayoutBuilder(),
    this.frameDuration = const Duration(milliseconds: 500),
  });

  Future<Uint8List> generateGif(List<QrFrameWrapper> frames) async {
    img.GifEncoder gifEncoder = img.GifEncoder();
    for (QrFrameWrapper qrFrameWrapper in frames) {
      gifLayoutBuilder.drawFrameLayout(
        gifEncoder: gifEncoder,
        gifSettings: GifSettings(
          data: qrFrameWrapper.getRawData(),
          frameDuration: frameDuration,
        ),
      );
    }
    List<int> gifAnimation = gifEncoder.finish()!;
    Uint8List gifData = Uint8List.fromList(gifAnimation);
    return gifData;
  }
}
