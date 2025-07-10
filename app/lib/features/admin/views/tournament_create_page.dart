import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../tournament/models/tournament.dart';
import '../../tournament/controllers/tournament_controller.dart';

class TournamentCreatePage extends HookConsumerWidget {
  const TournamentCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final maxPlayersController = useTextEditingController(text: '16');
    final drawHandling = useState(DrawHandling.bothLose);
    final isCreating = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('大会作成'),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '大会設定',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '大会名',
                        hintText: '例: 第1回店舗大会',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: maxPlayersController,
                      decoration: const InputDecoration(
                        labelText: '最大参加者数',
                        hintText: '8〜64',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '引き分け処理',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<DrawHandling>(
                      title: const Text('両者敗北'),
                      subtitle: const Text('引き分けの場合、両者とも敗北扱い'),
                      value: DrawHandling.bothLose,
                      groupValue: drawHandling.value,
                      onChanged: (value) {
                        if (value != null) {
                          drawHandling.value = value;
                        }
                      },
                    ),
                    RadioListTile<DrawHandling>(
                      title: const Text('引き分けポイント'),
                      subtitle: const Text('引き分けの場合、両者に0.5ポイント'),
                      value: DrawHandling.drawPoint,
                      groupValue: drawHandling.value,
                      onChanged: (value) {
                        if (value != null) {
                          drawHandling.value = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isCreating.value
                  ? null
                  : () async {
                      // バリデーション
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('大会名を入力してください')),
                        );
                        return;
                      }

                      final maxPlayers = int.tryParse(maxPlayersController.text);
                      if (maxPlayers == null || maxPlayers < 8 || maxPlayers > 64) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('参加者数は8〜64の間で入力してください')),
                        );
                        return;
                      }

                      isCreating.value = true;

                      try {
                        // 大会IDを生成
                        final tournamentId = DateTime.now().millisecondsSinceEpoch.toString();
                        
                        // 総ラウンド数を自動計算
                        final totalRounds = _calculateTotalRounds(maxPlayers);
                        
                        // 大会オブジェクトを作成
                        final tournament = Tournament(
                          id: tournamentId,
                          name: nameController.text,
                          maxPlayers: maxPlayers,
                          currentRound: 0,
                          totalRounds: totalRounds,
                          drawHandling: drawHandling.value,
                          status: TournamentStatus.registration,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );
                        
                        // Firestoreに大会を作成
                        final tournamentRepo = ref.read(tournamentRepositoryProvider);
                        await tournamentRepo.createTournament(tournament);
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('大会が作成されました')),
                          );
                          
                          // QRコード表示ページに遷移
                          context.pushReplacementNamed(
                            'tournament_qr',
                            pathParameters: {'tournamentId': tournamentId},
                            queryParameters: {'name': nameController.text},
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('エラーが発生しました: $e')),
                          );
                        }
                      } finally {
                        isCreating.value = false;
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isCreating.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '大会を作成',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // スイスドロー形式の総ラウンド数を計算
  int _calculateTotalRounds(int playerCount) {
    if (playerCount <= 8) return 3;
    if (playerCount <= 16) return 4;
    if (playerCount <= 32) return 5;
    if (playerCount <= 64) return 6;
    return 6; // 最大6ラウンド
  }
}