import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_data_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_object_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame/types/qr_transfer_details_frame.dart';
import 'package:kira_qr_transfer/src/models/qr_frame_wrapper.dart';
import 'package:kira_qr_transfer/src/models/qr_scene.dart';
import 'package:kira_qr_transfer/src/models/qr_transfer_object/qr_transfer_object.dart';
import 'package:kira_qr_transfer/src/utils/cryptography/aes256.dart';
import 'package:kira_qr_transfer/src/utils/cryptography/sha256.dart';

/// Class that allows to generate list of [QrFrameWrapper], which is needed to generate QR animation
class QrFrameGenerator {
  /// Generates a QR code frames for the given object
  final QrTransferObject data;

  /// Password to encode data
  ///
  /// If null, data will be encoded without password
  /// but if password's set, received data could be decoded only with this password
  final String? password;

  /// Length of the data fragment
  ///
  /// Optimal max String length for QR code is 300 characters.
  /// [splitSize] default is set to 200 characters, because we leave
  /// the place for additional params
  final int splitSize;

  QrFrameGenerator({
    required this.data,
    this.password,
    this.splitSize = 200,
  });

  /// Method to generate QR code with specified frames
  List<QrFrameWrapper> generateOnly(List<int> frameIndexes) {
    List<QrFrameWrapper> generateFrames = generateAll();
    return generateFrames.where((QrFrameWrapper e) => frameIndexes.contains(e.index)).toList();
  }

  /// Method to generate QR code with all frames
  List<QrFrameWrapper> generateAll() {
    List<QrFrameWrapper> generateFrames = _getQrFrames();
    return generateFrames;
  }

  List<QrFrameWrapper> _getQrFrames() {
    String encodedData = _encodeData();
    String checksum = _calculateChecksum(encodedData);
    if (password != null) {
      encodedData = _encryptData(password!, encodedData);
    }
    List<String> fragments = _splitByLength(encodedData, splitSize);
    List<QrDataFrame> frames = List<QrDataFrame>.empty(growable: true);
    for (int i = 0; i < fragments.length; i++) {
      String frameData = fragments[i];
      frames.add(QrDataFrame(
        data: frameData,
      ));
    }

    QrScene qrScene = QrScene(
      details: QrDetailsFrame(
        checksum: checksum,
        framesCount: frames.length,
        bytesCount: data.toBytes().length,
        encrypted: password != null,
        objectType: data.type,
      ),
      objectDetails: QrObjectDetailsFrame(
        details: data.getDetails(),
      ),
      frames: frames,
    );

    return qrScene.buildFrames();
  }

  String _encodeData() {
    Uint8List objectBytes = data.toBytes();
    List<int> gzipBytes = GZipEncoder().encode(objectBytes)!;
    String encodedData = base64Encode(gzipBytes);
    return encodedData;
  }

  String _calculateChecksum(String value) {
    return Sha256.encrypt(value).toString();
  }

  String _encryptData(String password, String data) {
    return Aes256.encrypt(password, data);
  }

  List<String> _splitByLength(String value, int length) {
    List<String> pieces = List<String>.empty(growable: true);

    for (int i = 0; i < value.length; i += length) {
      int offset = i + length;
      pieces.add(value.substring(i, offset >= value.length ? value.length : offset));
    }
    return pieces;
  }
}
