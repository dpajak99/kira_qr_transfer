# kira_qr_transfer

A package that creates animated gif to secure transfer data 


#### Usage

Import it into your dart file
```dart
    import 'package:kira_qr_transfer/kira_qr_transfer.dart';
```
#### Example
Creating gif from file
``` dart
/// Pick file to upload
FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
if (filePickerResult == null) {
    return;
}

/// Create [QrFileTransferObject]
QrTransferObject qrTransferObject = QrFileTransferObject(
    bytes: filePickerResult.files.single.bytes!,
    mimeType: 'undefined',
    name: filePickerResult.files.single.name,
);

/// Create [QrFrameGenerator] instance
QrFrameGenerator qrFrameGenerator = QrFrameGenerator(
    data: qrTransferObject,
);
```
```dart
/// You can generate all frames
List<QrFrameWrapper> frames = qrFrameGenerator.generateAll();

/// or specified frames
List<QrFrameWrapper> frames = qrFrameGenerator.generateOnly([1,3,5,7]);
```
```dart
/// Provide generated frames into [QrGifGenerator]
QrGifGenerator qrGifGenerator = QrGifGenerator();

/// Get created gif as bytes
Uint8List data = await qrGifGenerator.generateGif(frames);

/// Now you can display, save or download gif 
Image.memory(data)
BrowserUtils.downloadFile(data, 'generated_qr_code.gif');
```
---------------------------------------------
Creating git from text
```dart
/// Create [QrTextTransferObject]
QrTransferObject qrTransferObject = QrTextTransferObject(text: "some text");

/// Create [QrFrameGenerator] instance
QrFrameGenerator qrFrameGenerator = QrFrameGenerator(
    data: qrTransferObject,
);

/// Generate frames
List<QrFrameWrapper> frames = qrFrameGenerator.generateAll();

/// Provide generated frames into [QrGifGenerator]
QrGifGenerator qrGifGenerator = QrGifGenerator();

/// Get created gif as bytes
Uint8List data = await qrGifGenerator.generateGif(frames);

/// Now you can display, save or download gif 
Image.memory(data)
BrowserUtils.downloadFile(data, 'generated_qr_code.gif');
```
---------------------------------------------
Reading gif / Receive transfer
```dart
/// Setup [TransferReceiveController]
TransferReceiveController transferReceiveController = TransferReceiveController();
```
```dart
/// Add listener to controller
@override
void initState() {
    transferReceiveController.addListener(() {
        if (transferReceiveController.missingFrames != null) {
            onMissingFramesChanged();
         }
         if (transferReceiveController.finished) {
            qrTransferObject = transferReceiveController.generateObject();
            onTransferCompleted(qrTransferObject);
          }
    });
    super.initState();
}
```
```dart
/// Setup frame capturing
CameraWidget(
    onReceiveQrCode: (String value) {
        print('Received $value');
        transferReceiveController.tryAddFrame(value);
    },
),
```
