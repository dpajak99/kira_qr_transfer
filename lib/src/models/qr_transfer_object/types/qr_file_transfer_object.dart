import 'dart:typed_data';

import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_object_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object_type.dart';

class QrFileTransferObject extends QrTransferObject {
  @override
  final QrTransferObjectType type = QrTransferObjectType.file;

  final Uint8List bytes;
  final String name;
  final String mimeType;

  QrFileTransferObject({
    required this.bytes,
    required this.name,
    required this.mimeType,
  });

  factory QrFileTransferObject.fromDetails({
    required Uint8List bytes,
    required QrObjectDetailsFrame details,
  }) {
    return QrFileTransferObject(
      bytes: bytes,
      name: details.details[0] as String,
      mimeType: details.details[1] as String,
    );
  }

  @override
  Uint8List toBytes() {
    return bytes;
  }

  @override
  List<dynamic> getDetails() {
    return <dynamic>[name, mimeType];
  }
}
