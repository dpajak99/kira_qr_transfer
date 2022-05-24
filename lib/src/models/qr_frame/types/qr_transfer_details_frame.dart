import 'package:kira_qr_transfer/src/models/qr_frame/frame_type.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/qr_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object_type.dart';

class QrDetailsFrame extends QrFrame {
  @override
  final FrameType type = FrameType.transferDetails;

  final QrTransferObjectType objectType;
  final String checksum;
  final int bytesCount;
  final int framesCount;
  final bool encrypted;

  QrDetailsFrame({
    required this.objectType,
    required this.checksum,
    required this.bytesCount,
    required this.framesCount,
    required this.encrypted,
  });

  factory QrDetailsFrame.fromFrameData(List<dynamic> data) {
    return QrDetailsFrame(
      // type: data[0],
      objectType: QrTransferObjectType.values[data[1] as int],
      bytesCount: data[2] as int,
      checksum: data[3] as String,
      framesCount: data[4] as int,
      encrypted: data[5] == 1,
    );
  }

  @override
  List<dynamic> toFrameData() {
    return <dynamic>[
      type.index,
      objectType.index,
      bytesCount,
      checksum,
      framesCount,
      if (encrypted) 1 else 0,
    ];
  }
}
