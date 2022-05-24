import 'package:kira_qr_transfer/src/models/qr_frame/frame_type.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/qr_frame.dart';

class QrDataFrame extends QrFrame {
  @override
  final FrameType type = FrameType.objectData;

  /// Encoded via base64 data fragment
  final String data;

  QrDataFrame({
    required this.data,
  });

  factory QrDataFrame.fromFrameData(List<dynamic> data) {
    return QrDataFrame(
      data: data[1] as String,
    );
  }

  @override
  List<dynamic> toFrameData() {
    return <dynamic>[
      type.index,
      data,
    ];
  }
}
