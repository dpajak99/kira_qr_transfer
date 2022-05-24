import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_data_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/qr_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_object_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_transfer_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame_wrapper.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/types/qr_file_transfer_object.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/types/qr_text_transfer_object.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object_type.dart';
import 'package:kira_qr_transfer/src/utils/cryptography/aes256.dart';

class TransferReceiveController extends ChangeNotifier {
  Map<int, QrFrame> receivedFrames = <int, QrFrame>{};
  int? totalFrames;
  bool finished = false;

  List<int>? get missingFrames {
    if (totalFrames == null || receivedFrames.isEmpty) {
      return null;
    }
    return List<int>.generate(totalFrames!, (int i) => i + 1).where((int i) => !receivedFrames.containsKey(i)).toList();
  }

  void tryAddFrame(String data) {
    try {
      QrFrameWrapper frameWrapper = QrFrameWrapper.parse(data);
      totalFrames = frameWrapper.totalFrames;
      QrFrame frame = QrFrame.parse(frameWrapper.data);
      receivedFrames[frameWrapper.index] = frame;
      notifyListeners();
    } catch (e) {
      // Do nothing
    }
    _validateFrames();
  }

  void _validateFrames() {
    if (totalFrames == null || receivedFrames.isEmpty) {
      return;
    }
    if (receivedFrames.length == totalFrames) {
      finished = true;
      notifyListeners();
    }
  }

  QrTransferObject generateObject({String? password}) {
    StringBuffer sb = StringBuffer();
    List<int> keys = receivedFrames.keys.toList()..sort((int a, int b) => a.compareTo(b));
    QrDetailsFrame transferDetails = receivedFrames[0] as QrDetailsFrame;
    QrObjectDetailsFrame objectDetails = receivedFrames[1] as QrObjectDetailsFrame;
    for (int key in keys) {
      QrFrame frame = receivedFrames[key]!;
      if (frame is QrDataFrame) {
        sb.write(frame.data);
      }
    }
    String decryptedData = sb.toString();
    if( password != null ) {
      bool validPassword = Aes256.verifyPassword(password, decryptedData);
      if( !validPassword ) {
        throw Exception("Invalid password");
      }
      decryptedData = Aes256.decrypt(decryptedData, password);
    }
    List<int> encodedBytes = base64Decode(decryptedData);
    List<int> decodedBytes = GZipDecoder().decodeBytes(encodedBytes);

    if (transferDetails.objectType == QrTransferObjectType.text) {
      return QrTextTransferObject(text: utf8.decode(decodedBytes));
    } else {
      return QrFileTransferObject.fromDetails(
        bytes: Uint8List.fromList(decodedBytes),
        details: objectDetails,
      );
    }
  }
}
