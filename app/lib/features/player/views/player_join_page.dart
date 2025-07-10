import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../tournament/controllers/tournament_controller.dart';
import '../../tournament/models/tournament.dart';
import '../models/player.dart';

class PlayerJoinPage extends HookConsumerWidget {
  final String tournamentId;

  const PlayerJoinPage({
    super.key,
    required this.tournamentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final isJoining = useState(false);
    final isJoined = useState(false);
    final playerId = useState<String?>(null);
    final state = ref.watch(tournamentControllerProvider);

    // 大会データを読み込み
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(tournamentControllerProvider.notifier)
            .loadTournament(tournamentId);
      });
      return null;
    }, [tournamentId]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('大会参加'),
        automaticallyImplyLeading: false,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('エラー: ${state.error}'),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(tournamentControllerProvider.notifier)
                              .loadTournament(tournamentId);
                        },
                        child: const Text('再読み込み'),
                      ),
                    ],
                  ),
                )
              : _buildContent(context, ref, nameController, isJoining, isJoined,
                  playerId, state),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameController,
    ValueNotifier<bool> isJoining,
    ValueNotifier<bool> isJoined,
    ValueNotifier<String?> playerId,
    TournamentState state,
  ) {
    final tournament = state.tournament;
    if (tournament == null) {
      return const Center(child: Text('大会データが見つかりません'));
    }

    if (isJoined.value && playerId.value != null) {
      return _buildJoinedContent(context, tournament, playerId.value!);
    }

    return Padding(
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
                    '大会情報',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('大会名: ${tournament.name}'),
                  Text('最大参加者数: ${tournament.maxPlayers}名'),
                  Text('現在の参加者数: ${state.players.length}名'),
                  Text('総ラウンド数: ${tournament.totalRounds}ラウンド'),
                  Text('ステータス: ${_getStatusText(tournament.status)}'),
                  const SizedBox(height: 24),
                  const Text(
                    '大会参加登録',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '参加者名',
                      hintText: '例: 田中太郎',
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '大会ID: $tournamentId',
                    style: const TextStyle(
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
            onPressed: isJoining.value ||
                    tournament.status != TournamentStatus.registration ||
                    state.players.length >= tournament.maxPlayers
                ? null
                : () => _joinTournament(context, ref, nameController, isJoining,
                    isJoined, playerId, tournament),
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
    );
  }

  Widget _buildJoinedContent(
      BuildContext context, Tournament tournament, String playerId) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          Text(
            '参加登録が完了しました！',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '${tournament.name}への参加登録が完了しました。\n大会開始まで少しお待ちください。',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/player/match/$tournamentId/$playerId');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('対戦情報を確認'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinTournament(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameController,
    ValueNotifier<bool> isJoining,
    ValueNotifier<bool> isJoined,
    ValueNotifier<String?> playerId,
    Tournament tournament,
  ) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('参加者名を入力してください')),
      );
      return;
    }

    isJoining.value = true;

    try {
      // プレイヤーを追加
      final newPlayerId =
          '${tournament.id}_${DateTime.now().millisecondsSinceEpoch}';
      final player = Player(
        id: newPlayerId,
        tournamentId: tournament.id,
        name: name,
        joinedAt: DateTime.now(),
        isActive: true,
      );

      await ref.read(tournamentControllerProvider.notifier).addPlayer(player);
      playerId.value = newPlayerId;
      isJoined.value = true;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('参加登録が完了しました')),
        );
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
  }

  String _getStatusText(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.registration:
        return '参加登録中';
      case TournamentStatus.inProgress:
        return '進行中';
      case TournamentStatus.completed:
        return '完了';
    }
  }
}
