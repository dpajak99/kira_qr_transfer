import 'package:flutter/material.dart';
import 'package:kira_qr_transfer_example/receive_page.dart';
import 'package:kira_qr_transfer_example/send_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('QR transfer - demo'),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(icon: Text('Send')),
                Tab(icon: Text('Receive')),
              ],
            ),
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1000,
              ),
              child: const TabBarView(
                children: [
                  SendPage(),
                  ReceivePage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
