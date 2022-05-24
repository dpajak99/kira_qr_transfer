import 'package:kira_qr_transfer/src/models/qr_frame/frame_type.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/qr_frame.dart';

class QrObjectDetailsFrame extends QrFrame {
  @override
  final FrameType type = FrameType.objectDetails;

  final List<dynamic> details;

  QrObjectDetailsFrame({
    required this.details,
  });

  factory QrObjectDetailsFrame.fromFrameData(List<dynamic> data) {
    return QrObjectDetailsFrame(
      details: data[1] as List<dynamic>,
    );
  }

  @override
  List<dynamic> toFrameData() {
    return <dynamic>[
      type.index,
      details,
    ];
  }
}
