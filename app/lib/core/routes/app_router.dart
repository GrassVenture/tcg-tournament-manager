import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/admin/views/admin_home_page.dart';
import '../../features/admin/views/tournament_create_page.dart';
import '../../features/admin/views/tournament_qr_page.dart';
import '../../features/admin/views/tournament_matches_page.dart';
import '../../features/player/views/player_join_page.dart';
import '../../features/player/views/player_match_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/admin',
    routes: [
      // 管理者ルート
      GoRoute(
        path: '/admin',
        name: 'admin_home',
        builder: (context, state) => const AdminHomePage(),
      ),
      GoRoute(
        path: '/admin/tournament/create',
        name: 'tournament_create',
        builder: (context, state) => const TournamentCreatePage(),
      ),
      GoRoute(
        path: '/admin/tournament/:tournamentId/qr',
        name: 'tournament_qr',
        builder: (context, state) => TournamentQrPage(
          tournamentId: state.pathParameters['tournamentId']!,
          tournamentName: state.uri.queryParameters['name'] ?? '大会',
        ),
      ),
      GoRoute(
        path: '/admin/tournament/:tournamentId/matches',
        name: 'tournament_matches',
        builder: (context, state) => TournamentMatchesPage(
          tournamentId: state.pathParameters['tournamentId']!,
        ),
      ),

      // プレイヤールート
      GoRoute(
        path: '/player/join/:tournamentId',
        name: 'player_join',
        builder: (context, state) => PlayerJoinPage(
          tournamentId: state.pathParameters['tournamentId']!,
        ),
      ),
      GoRoute(
        path: '/player/match/:tournamentId/:playerId',
        name: 'player_match',
        builder: (context, state) => PlayerMatchPage(
          tournamentId: state.pathParameters['tournamentId']!,
          playerId: state.pathParameters['playerId']!,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('エラー: ${state.error}'),
      ),
    ),
  );
});
