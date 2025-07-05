import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PlayerJoinPage extends HookWidget {
  final String tournamentId;

  const PlayerJoinPage({
    super.key,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final isJoining = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('大会参加'),
        centerTitle: true,
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
            // 大会情報カード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TCG大会への参加',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
            const SizedBox(height: 16),
            // 参加登録フォーム
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '参加者情報',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '参加者名',
                        hintText: '例: 田中太郎',
                        prefixIcon: Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '※ 大会中に表示される名前です',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isJoining.value
                  ? null
                  : () async {
                      // バリデーション
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('参加者名を入力してください')),
                        );
                        return;
                      }

                      isJoining.value = true;

                      try {
                        // TODO: 大会参加処理を実装
                        await Future.delayed(const Duration(seconds: 2));
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('大会に参加しました！大会開始までお待ちください。'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          // 参加完了後は待機ページに遷移（今後実装）
                          // context.pushReplacementNamed('tournament_lobby', pathParameters: {'tournamentId': tournamentId});
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('エラーが発生しました: $e')),
                          );
                        }
                      } finally {
                        isJoining.value = false;
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isJoining.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      '大会に参加',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}