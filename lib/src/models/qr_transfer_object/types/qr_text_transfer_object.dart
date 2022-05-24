import 'dart:typed_data';

import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object_type.dart';

class QrTextTransferObject extends QrTransferObject {
  @override
  final QrTransferObjectType type = QrTransferObjectType.text;
  final String text;

  QrTextTransferObject({
    required this.text,
  });

  @override
  Uint8List toBytes() {
    return Uint8List.fromList(text.codeUnits);
  }

  @override
  List<dynamic> getDetails() {
    return <dynamic>[];
  }

  @override
  String toString() {
    return 'QrCodeTextObject{type: $type, text: $text}';
  }
}
