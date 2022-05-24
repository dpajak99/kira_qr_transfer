import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kira_qr_transfer_example/widgets/center_load_spinner.dart';
import 'package:kira_qr_transfer_example/widgets/qr_scanner/qr_scanner.dart';

class CameraWidget extends StatefulWidget {
  final String? errorMessage;
  final double width;
  final double height;
  final String? Function(String value) validate;
  final VoidQrReceivedCallback onReceiveQrCode;

  const CameraWidget({
    required this.validate,
    required this.onReceiveQrCode,
    this.errorMessage,
    this.width = double.infinity,
    this.height = 228,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraWidget();
}

class _CameraWidget extends State<CameraWidget> {
  String? errorMessage;

  @override
  void initState() {
    errorMessage = widget.errorMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: QrScanner(
            width: widget.width,
            height: widget.height,
            cameraLoadingWidget: _buildLoadingWidget(),
            errorWidgetBuilder: _buildErrorWidget,
            onReceivedQrCode: (String qrData) {
              bool qrCodeValid = widget.validate(qrData) == null;
              if (qrCodeValid) {
                widget.onReceiveQrCode(qrData);
              }
            }),
      ),
    );
  }
}

Widget _buildLoadingWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const CenterLoadSpinner(),
      const SizedBox(height: 15),
      Text(
        'Open camera'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    ],
  );
}

Widget _buildErrorWidget(CameraException error) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      ),
      const SizedBox(height: 15),
      Text(
        error.code.toUpperCase(),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    ],
  );
}
