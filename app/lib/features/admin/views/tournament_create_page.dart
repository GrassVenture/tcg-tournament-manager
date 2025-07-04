import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../tournament/models/tournament.dart';

class TournamentCreatePage extends HookWidget {
  const TournamentCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                        // TODO: 大会作成処理を実装
                        await Future.delayed(const Duration(seconds: 2));
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('大会が作成されました')),
                          );
                          context.pop();
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
}