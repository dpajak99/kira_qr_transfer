import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kira_qr_transfer/kira_qr_transfer.dart';
import 'package:kira_qr_transfer_example/utils/browser_utils.dart';
import 'package:kira_qr_transfer_example/widgets/center_load_spinner.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  _SendPage createState() => _SendPage();
}

class _SendPage extends State<SendPage> {
  bool textLoading = false;
  TextEditingController textEditingController = TextEditingController();
  Uint8List? generatedImage;
  QrTransferObject? actualTransferObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            if (generatedImage != null && actualTransferObject != null)
              Row(
                children: <Widget>[
                  Image.memory(
                    generatedImage!,
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Request size: ${actualTransferObject!.toBytes().length} bytes'),
                        Text('QR image size: ${generatedImage!.length} bytes'),
                        const SizedBox(height: 10),
                        Text('Details: ${actualTransferObject!.getDetails().toString()}')
                      ],
                    ),
                  ),
                ],
              ),
            const Text('Type some text'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: textEditingController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Text',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!textLoading)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    textLoading = true;
                  });
                  QrTransferObject qrTransferObject = QrTextTransferObject(text: textEditingController.text);
                  _generateQrCode(qrTransferObject);
                },
                child: const Text('Generate QR code'),
              )
            else
              const CenterLoadSpinner(),
            const SizedBox(height: 25),
            const Divider(),
            const Text('Or you can upload file'),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
                if (filePickerResult == null) {
                  return;
                }
                QrTransferObject qrTransferObject = QrFileTransferObject(
                  bytes: filePickerResult.files.single.bytes!,
                  mimeType: 'undefined',
                  name: filePickerResult.files.single.name,
                );
                _generateQrCode(qrTransferObject);
              },
              child: const Text('Upload file'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _generateQrCode(QrTransferObject qrTransferObject ) async {
    QrFrameGenerator qrFrameGenerator = QrFrameGenerator(
      data: qrTransferObject,
    );
    List<QrFrameWrapper> frames = qrFrameGenerator.generateAll();
    QrGifGenerator qrGifGenerator = QrGifGenerator();
    Uint8List data = await qrGifGenerator.generateGif(frames);
    BrowserUtils.downloadFile(data, 'generated_qr_code.gif');
    setState(() {
      actualTransferObject = qrTransferObject;
      generatedImage = data;
      textLoading = false;
    });
  }
}
