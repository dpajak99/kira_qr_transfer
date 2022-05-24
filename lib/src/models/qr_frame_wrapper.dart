import 'dart:convert';

/// Container for any type of QR frame.
///
/// Contains frame data, all frames count and current frame number.
class QrFrameWrapper {
  /// Index of current frame
  final int index;

  /// All frames count
  final int totalFrames;

  /// Encoded QR frame data
  final String data;

  QrFrameWrapper({
    required this.index,
    required this.totalFrames,
    required this.data,
  });

  List<dynamic> toArray() {
    return <dynamic>[index, totalFrames, data];
  }

  factory QrFrameWrapper.parse(String data) {
    List<dynamic> dataArray = json.decode(data) as List<dynamic>;
    return QrFrameWrapper(
      index: dataArray[0] as int,
      totalFrames: dataArray[1] as int,
      data: dataArray[2] as String,
    );
  }

  String getRawData() {
    String rawData = json.encode(toArray());
    if (rawData.length > 300) {
      // ignore: avoid_print
      print('QR data is longer than 300 characters. Some older devices may not be able to read it.');
    }
    return rawData;
  }
}
