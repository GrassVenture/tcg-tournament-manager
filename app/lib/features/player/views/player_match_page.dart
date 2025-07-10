import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../tournament/controllers/tournament_controller.dart';
import '../../tournament/models/match.dart';
import '../../tournament/models/tournament.dart';
import '../models/player.dart';

class PlayerMatchPage extends ConsumerStatefulWidget {
  final String tournamentId;
  final String playerId;

  const PlayerMatchPage({
    super.key,
    required this.tournamentId,
    required this.playerId,
  });

  @override
  ConsumerState<PlayerMatchPage> createState() => _PlayerMatchPageState();
}

class _PlayerMatchPageState extends ConsumerState<PlayerMatchPage> {
  @override
  void initState() {
    super.initState();
    // 大会データの読み込み
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tournamentControllerProvider.notifier).loadTournament(widget.tournamentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tournamentControllerProvider);
    final controller = ref.read(tournamentControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('対戦情報 - ${state.tournament?.name ?? ''}'),
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
                          controller.loadTournament(widget.tournamentId);
                        },
                        child: const Text('再読み込み'),
                      ),
                    ],
                  ),
                )
              : _buildContent(state, controller),
    );
  }

  Widget _buildContent(TournamentState state, TournamentController controller) {
    final tournament = state.tournament;
    if (tournament == null) {
      return const Center(child: Text('大会データが見つかりません'));
    }

    // デバッグログを追加
    debugPrint('プレイヤーID: ${widget.playerId}');
    debugPrint('全プレイヤー数: ${state.players.length}');
    for (final p in state.players) {
      debugPrint('プレイヤー: ${p.id} - ${p.name}');
    }

    final player = state.players.firstWhere(
      (p) => p.id == widget.playerId,
      orElse: () => const Player(id: '', tournamentId: '', name: '不明'),
    );

    if (player.id.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('プレイヤーデータが見つかりません'),
            const SizedBox(height: 16),
            Text('探しているプレイヤーID: ${widget.playerId}'),
            Text('読み込まれたプレイヤー数: ${state.players.length}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.loadTournament(widget.tournamentId);
              },
              child: const Text('再読み込み'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlayerInfo(player, tournament),
          const SizedBox(height: 24),
          _buildCurrentMatch(state, player),
          const SizedBox(height: 24),
          _buildMatchHistory(state, player),
          const SizedBox(height: 24),
          _buildStandings(state, player),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(Player player, Tournament tournament) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              player.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('大会名: ${tournament.name}'),
            Text('現在ラウンド: ${tournament.currentRound}/${tournament.totalRounds}'),
            Text('大会ステータス: ${_getStatusText(tournament.status)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMatch(TournamentState state, Player player) {
    final currentMatch = _getCurrentMatch(state, player);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '現在の対戦',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (currentMatch == null)
              const Text('現在の対戦はありません')
            else
              _buildMatchInfo(currentMatch, state, player),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchInfo(Match match, TournamentState state, Player currentPlayer) {
    final opponent = _getOpponent(match, currentPlayer, state);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ラウンド ${match.round}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (opponent != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  '対戦相手: ${opponent.name}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          )
        else
          const Text(
            '不戦勝',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          '結果: ${_getResultText(match.result, match, currentPlayer)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _getResultColor(match.result, match, currentPlayer),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchHistory(TournamentState state, Player player) {
    final matches = _getPlayerMatches(state, player);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '対戦履歴',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (matches.isEmpty)
              const Text('対戦履歴はありません')
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matches.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final match = matches[index];
                  final opponent = _getOpponent(match, player, state);
                  
                  return ListTile(
                    title: Text('ラウンド ${match.round}'),
                    subtitle: opponent != null
                        ? Text('vs ${opponent.name}')
                        : const Text('不戦勝'),
                    trailing: Text(
                      _getResultText(match.result, match, player),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _getResultColor(match.result, match, player),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandings(TournamentState state, Player player) {
    final controller = ref.read(tournamentControllerProvider.notifier);
    final standings = controller.getStandings();
    final playerStanding = standings.firstWhere(
      (s) => s.player.id == player.id,
      orElse: () => PlayerStanding(
        player: player,
        wins: 0,
        losses: 0,
        draws: 0,
        byes: 0,
        points: 0,
        opponents: [],
      ),
    );

    final rank = standings.indexOf(playerStanding) + 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '現在の戦績',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('順位', '$rank位'),
                _buildStatItem('勝', '${playerStanding.wins}'),
                _buildStatItem('敗', '${playerStanding.losses}'),
                _buildStatItem('分', '${playerStanding.draws}'),
                _buildStatItem('ポイント', '${playerStanding.points}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Match? _getCurrentMatch(TournamentState state, Player player) {
    final tournament = state.tournament;
    if (tournament == null || tournament.currentRound == 0) return null;

    try {
      return state.matches.firstWhere(
        (match) => 
            match.round == tournament.currentRound &&
            (match.player1Id == player.id || match.player2Id == player.id),
      );
    } catch (e) {
      return null;
    }
  }

  List<Match> _getPlayerMatches(TournamentState state, Player player) {
    return state.matches
        .where((match) => 
            match.player1Id == player.id || match.player2Id == player.id)
        .toList()
        ..sort((a, b) => a.round.compareTo(b.round));
  }

  Player? _getOpponent(Match match, Player currentPlayer, TournamentState state) {
    if (match.player2Id == null) return null;

    final opponentId = match.player1Id == currentPlayer.id 
        ? match.player2Id 
        : match.player1Id;

    try {
      return state.players.firstWhere(
        (p) => p.id == opponentId,
      );
    } catch (e) {
      return null;
    }
  }

  String _getResultText(MatchResult result, Match match, Player player) {
    switch (result) {
      case MatchResult.player1Win:
        return match.player1Id == player.id ? '勝利' : '敗北';
      case MatchResult.player2Win:
        return match.player2Id == player.id ? '勝利' : '敗北';
      case MatchResult.draw:
        return '引き分け';
      case MatchResult.bye:
        return '不戦勝';
      case MatchResult.pending:
        return '未決定';
    }
  }

  Color _getResultColor(MatchResult result, Match match, Player player) {
    switch (result) {
      case MatchResult.player1Win:
        return match.player1Id == player.id ? Colors.green : Colors.red;
      case MatchResult.player2Win:
        return match.player2Id == player.id ? Colors.green : Colors.red;
      case MatchResult.draw:
        return Colors.orange;
      case MatchResult.bye:
        return Colors.green;
      case MatchResult.pending:
        return Colors.grey;
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