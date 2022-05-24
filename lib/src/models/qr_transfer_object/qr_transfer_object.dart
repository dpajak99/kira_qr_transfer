import 'dart:typed_data';

import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object_type.dart';

abstract class QrTransferObject {
  QrTransferObjectType get type;

  Uint8List toBytes();

  List<dynamic> getDetails();
}
