import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:go_router/go_router.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコード読み取り'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'QRコードをスキャンしてください',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isScanning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (isScanning) {
                              controller?.pauseCamera();
                            } else {
                              controller?.resumeCamera();
                            }
                            setState(() {
                              isScanning = !isScanning;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            controller?.flipCamera();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && isScanning) {
        setState(() {
          isScanning = false;
        });
        controller.pauseCamera();
        _handleQRCode(scanData.code!);
      }
    });
  }

  void _handleQRCode(String data) {
    // URLから大会IDを抽出
    final uri = Uri.tryParse(data);
    if (uri != null && uri.pathSegments.length >= 3) {
      final tournamentId = uri.pathSegments.last;
      if (tournamentId.isNotEmpty) {
        // 大会参加ページに遷移
        context.pushReplacementNamed(
          'player_join',
          pathParameters: {'tournamentId': tournamentId},
        );
        return;
      }
    }

    // URLが不正な場合
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('無効なQRコードです')),
    );
    setState(() {
      isScanning = true;
    });
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}