import 'dart:convert';

import 'package:kira_qr_transfer/src/models/qr_frame/frame_type.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_data_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_object_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_transfer_details_frame.dart';

abstract class QrFrame {
  FrameType get type;

  List<dynamic> toFrameData();

  static QrFrame parse(String data) {
    List<dynamic> dataList = json.decode(data) as List<dynamic>;
    FrameType frameType = FrameType.values[dataList[0] as int];
    if (frameType == FrameType.transferDetails) {
      return QrDetailsFrame.fromFrameData(dataList);
    } else if (frameType == FrameType.objectData) {
      return QrDataFrame.fromFrameData(dataList);
    } else {
      return QrObjectDetailsFrame.fromFrameData(dataList);
    }
  }
}
