import 'package:flutter/material.dart';
import 'package:kira_qr_transfer/kira_qr_transfer.dart';
import 'package:kira_qr_transfer_example/utils/browser_utils.dart';
import 'package:kira_qr_transfer_example/widgets/camera_widget.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({Key? key}) : super(key: key);

  @override
  _ReceivePage createState() => _ReceivePage();
}

class _ReceivePage extends State<ReceivePage> {
  TransferReceiveController transferReceiveController = TransferReceiveController();
  QrTransferObject? qrTransferObject;

  List<int> missingFrames = List<int>.empty(growable: true);

  @override
  void initState() {
    transferReceiveController.addListener(() {
      if (transferReceiveController.missingFrames != null) {
        setState(() {
          missingFrames = transferReceiveController.missingFrames!;
        });
      }
      if (transferReceiveController.finished) {
        qrTransferObject = transferReceiveController.generateObject();
        if (qrTransferObject is QrFileTransferObject) {
          QrFileTransferObject qrFileTransferObject = qrTransferObject as QrFileTransferObject;
          BrowserUtils.downloadFile(qrFileTransferObject.bytes, qrFileTransferObject.name);
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            if (qrTransferObject == null) ...<Widget>[
              const SizedBox(height: 16),
              const Text('Scan QR code'),
              const SizedBox(height: 16),
              Container(
                width: 300,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: CameraWidget(
                  validate: (_) => null,
                  onReceiveQrCode: (String value) {
                    print('Received $value');
                    transferReceiveController.tryAddFrame(value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Total frames: ${transferReceiveController.totalFrames}'),
              Text('Missing frames: $missingFrames'),
            ] else
              Text(
                qrTransferObject.toString(),
              ),
          ],
        ),
      ),
    );
  }
}
