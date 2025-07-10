import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../tournament/controllers/tournament_controller.dart';
import '../../tournament/models/match.dart';
import '../../tournament/models/tournament.dart';
import '../../player/models/player.dart';

class TournamentMatchesPage extends ConsumerStatefulWidget {
  final String tournamentId;

  const TournamentMatchesPage({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  @override
  ConsumerState<TournamentMatchesPage> createState() => _TournamentMatchesPageState();
}

class _TournamentMatchesPageState extends ConsumerState<TournamentMatchesPage> {
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
        title: Text('対戦表 - ${state.tournament?.name ?? ''}'),
        actions: [
          if (state.tournament?.status == TournamentStatus.registration)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                // デバッグ用のダミーデータ追加
                try {
                  await controller.addDummyPlayers();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ダミーデータを追加しました')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('エラー: $e')),
                    );
                  }
                }
              },
            ),
          if (state.players.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () async {
                try {
                  await controller.generateNextRound();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('次のラウンドを生成しました')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('エラー: $e')),
                    );
                  }
                }
              },
            ),
        ],
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

    return Column(
      children: [
        _buildTournamentInfo(tournament, state),
        const Divider(),
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: '対戦表'),
                    Tab(text: '参加者'),
                    Tab(text: '順位表'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMatchesTab(state, controller),
                      _buildPlayersTab(state),
                      _buildStandingsTab(state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTournamentInfo(Tournament tournament, TournamentState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tournament.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('ラウンド: ${tournament.currentRound}/${tournament.totalRounds}'),
              const SizedBox(width: 16),
              Text('参加者: ${state.players.length}/${tournament.maxPlayers}'),
              const SizedBox(width: 16),
              Text('ステータス: ${_getStatusText(tournament.status)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(TournamentState state, TournamentController controller) {
    final currentRoundMatches = controller.getCurrentRoundMatches();
    
    if (currentRoundMatches.isEmpty) {
      return const Center(
        child: Text('対戦がありません\nラウンドを生成してください'),
      );
    }

    return ListView.builder(
      itemCount: currentRoundMatches.length,
      itemBuilder: (context, index) {
        final match = currentRoundMatches[index];
        return _buildMatchCard(match, state, controller);
      },
    );
  }

  Widget _buildMatchCard(Match match, TournamentState state, TournamentController controller) {
    final player1 = state.players.firstWhere(
      (p) => p.id == match.player1Id,
      orElse: () => Player(id: '', tournamentId: '', name: '不明'),
    );
    
    final player2 = match.player2Id != null
        ? state.players.firstWhere(
            (p) => p.id == match.player2Id,
            orElse: () => Player(id: '', tournamentId: '', name: '不明'),
          )
        : null;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ラウンド ${match.round}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(_getResultText(match.result)),
              ],
            ),
            const SizedBox(height: 8),
            if (player2 != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      player1.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Text(' vs '),
                  Expanded(
                    child: Text(
                      player2.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              )
            else
              Text(
                '${player1.name} (不戦勝)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (match.result == MatchResult.pending && player2 != null)
              const SizedBox(height: 8),
            if (match.result == MatchResult.pending && player2 != null)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await controller.updateMatchResult(match.id, MatchResult.player1Win, reportedBy: 'admin');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラー: $e')),
                            );
                          }
                        }
                      },
                      child: Text('${player1.name} 勝利'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await controller.updateMatchResult(match.id, MatchResult.player2Win, reportedBy: 'admin');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラー: $e')),
                            );
                          }
                        }
                      },
                      child: Text('${player2.name} 勝利'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await controller.updateMatchResult(match.id, MatchResult.draw, reportedBy: 'admin');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラー: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('引き分け'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersTab(TournamentState state) {
    if (state.players.isEmpty) {
      return const Center(
        child: Text('参加者がいません'),
      );
    }

    return ListView.builder(
      itemCount: state.players.length,
      itemBuilder: (context, index) {
        final player = state.players[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(player.name),
          subtitle: Text('ID: ${player.id}'),
        );
      },
    );
  }

  Widget _buildStandingsTab(TournamentState state) {
    final controller = ref.read(tournamentControllerProvider.notifier);
    final standings = controller.getStandings();

    if (standings.isEmpty) {
      return const Center(
        child: Text('順位表のデータがありません'),
      );
    }

    return ListView.builder(
      itemCount: standings.length,
      itemBuilder: (context, index) {
        final standing = standings[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(standing.player.name),
          subtitle: Text(
            '${standing.wins}勝 ${standing.losses}敗 ${standing.draws}分 ${standing.byes}不戦勝',
          ),
          trailing: Text(
            '${standing.points}pt',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      },
    );
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

  String _getResultText(MatchResult result) {
    switch (result) {
      case MatchResult.player1Win:
        return 'Player1 勝利';
      case MatchResult.player2Win:
        return 'Player2 勝利';
      case MatchResult.draw:
        return '引き分け';
      case MatchResult.bye:
        return '不戦勝';
      case MatchResult.pending:
        return '未決定';
    }
  }
}

