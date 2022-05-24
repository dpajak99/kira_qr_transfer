import 'dart:convert';

import 'package:kira_qr_transfer/src/models/qr_frame/qr_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_object_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_transfer_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame_wrapper.dart';

/// Container for all QR frames
class QrScene {
  /// Contains QR details
  final QrDetailsFrame details;

  /// Contains details of QR object (like metadata)
  final QrObjectDetailsFrame objectDetails;

  /// List of all QR data frames
  final List<QrFrame> frames;

  QrScene({
    required this.details,
    required this.objectDetails,
    required this.frames,
  });

  /// Returns QR frames ready to be sent into Animation generator
  List<QrFrameWrapper> buildFrames() {
    final List<String> data = <String>[
      json.encode(details.toFrameData()),
      json.encode(objectDetails.toFrameData()),
      ...frames.map((QrFrame e) => json.encode(e.toFrameData())),
    ];
    final List<QrFrameWrapper> indexedAllFrames = List<QrFrameWrapper>.empty(growable: true);
    for (int i = 0; i < data.length; i++) {
      indexedAllFrames.add(QrFrameWrapper(
        index: i,
        totalFrames: details.framesCount + 2,
        data: data[i],
      ));
    }
    return indexedAllFrames;
  }
}
