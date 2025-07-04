import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/admin/views/admin_home_page.dart';
import '../../features/admin/views/tournament_create_page.dart';
import '../../features/admin/views/tournament_qr_page.dart';
import '../../features/player/views/player_home_page.dart';
import '../../features/player/views/player_join_page.dart';
import '../../features/player/views/qr_scanner_page.dart';

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
      
      // プレイヤールート
      GoRoute(
        path: '/player',
        name: 'player_home',
        builder: (context, state) => const PlayerHomePage(),
      ),
      GoRoute(
        path: '/player/qr-scanner',
        name: 'qr_scanner',
        builder: (context, state) => const QrScannerPage(),
      ),
      GoRoute(
        path: '/player/join/:tournamentId',
        name: 'player_join',
        builder: (context, state) => PlayerJoinPage(
          tournamentId: state.pathParameters['tournamentId']!,
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