import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

class TournamentQrPage extends StatelessWidget {
  final String tournamentId;
  final String tournamentName;

  const TournamentQrPage({
    super.key,
    required this.tournamentId,
    required this.tournamentName,
  });

  @override
  Widget build(BuildContext context) {
    // ローカル開発用URL（PCのIPアドレス:ポート番号）
    final joinUrl = 'http://192.168.30.106:3000/player/join/$tournamentId';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('大会QRコード'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      tournamentName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '大会ID: $tournamentId',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'プレイヤー参加用QRコード',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: QrImageView(
                        data: joinUrl,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'プレイヤーはこのQRコードを\nスマートフォンで読み取って参加できます\n\n📱 同じWi-Fiネットワークに接続してください',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'URL: http://192.168.30.106:3000/player/join/$tournamentId',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '参加方法',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('1. プレイヤーのスマホを同じWi-Fiに接続'),
                    const Text('2. プレイヤーにQRコードを見せる'),
                    const Text('3. スマホのカメラでQRコードを読み取る'),
                    const Text('4. 参加者名を入力してもらう'),
                    const Text('5. 参加登録完了'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: 参加者一覧画面への遷移
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('参加者一覧機能は今後実装予定です')),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text('参加者一覧を確認'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}