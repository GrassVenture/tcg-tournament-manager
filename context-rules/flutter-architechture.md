# Flutter アプリケーション アーキテクチャガイド

## 概要

このドキュメントは、スケーラブルで保守性の高い Flutter アプリケーションのアーキテクチャパターンと実装方法を説明します。MVC + Clean Architecture を基盤とした設計で、他の Flutter プロジェクトでも再利用可能です。

## アーキテクチャパターン

### 1. 基本構造 - MVC + Clean Architecture

```
lib/
├── features/               # 機能別モジュール
│   ├── auth/              # 認証機能
│   │   ├── controllers/   # 状態管理・UI制御
│   │   ├── models/        # データ構造
│   │   ├── repositories/  # データアクセス
│   │   ├── usecases/      # ビジネスロジック
│   │   └── views/         # UI コンポーネント
│   ├── upload/            # ファイルアップロード
│   ├── analysis/          # 分析機能
│   └── files/             # ファイル管理
└── core/                  # 共通機能
    ├── routes/            # ルーティング
    ├── services/          # 共通サービス
    ├── widgets/           # 共通UIコンポーネント
    ├── theme/             # テーマ・スタイル
    └── utils/             # ユーティリティ
```

### 2. 層の責任分離

- **Models**: データ構造とビジネスエンティティ
- **Views**: UI コンポーネントとページ
- **Controllers**: 状態管理と UI 制御ロジック
- **Repositories**: データアクセスの抽象化
- **UseCases**: 単一責任のビジネスロジック

## 技術スタック

### 必須依存関係

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 状態管理
  hooks_riverpod: ^2.5.1
  flutter_hooks: ^0.20.5

  # Firebase
  firebase_core: ^3.13.0
  firebase_auth: ^5.5.3
  cloud_firestore: ^5.6.7
  firebase_storage: ^12.4.5

  # ルーティング
  go_router: ^13.2.1

  # データモデリング
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # HTTP通信
  dio: ^5.8.0+1

  # ユーティリティ
  universal_html: ^2.2.4
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
```

## 実装パターン

### 1. 状態管理 - HooksRiverpod

#### Provider 定義

```dart
// 状態管理用Provider
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// サービス用Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// UseCase用Provider
final signInUseCaseProvider = Provider.autoDispose((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});
```

#### Controller 実装

```dart
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  SignInUseCase get _signInUseCase => ref.read(signInUseCaseProvider);

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _signInUseCase.call(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
```

#### UI 実装

```dart
class LoginPage extends HookConsumerWidget {
  static const routePath = '/login';
  static const routeName = 'login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'メールアドレス'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () => authNotifier.signIn(
                        emailController.text,
                        passwordController.text,
                      ),
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('ログイン'),
            ),
            if (authState.error != null)
              Text(
                authState.error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
```

### 2. データモデル - Freezed

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    @TimestampConverter() DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// カスタムコンバーター
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}
```

### 3. ルーティング - go_router

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: LoginPage.routePath,
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoggingIn = state.location == LoginPage.routePath;

      if (!isLoggedIn && !isLoggingIn) {
        return LoginPage.routePath;
      }
      if (isLoggedIn && isLoggingIn) {
        return HomePage.routePath;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: HomePage.routePath,
        name: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('エラー: ${state.error}'),
      ),
    ),
  );
});
```

### 4. UseCase 実装

```dart
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<User> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('メールアドレスとパスワードは必須です');
    }

    final firebaseUser = await _repository.signInWithEmailAndPassword(
      email,
      password,
    );

    if (firebaseUser == null) {
      throw Exception('ログインに失敗しました');
    }

    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      createdAt: firebaseUser.metadata.creationTime,
    );
  }
}
```

### 5. Repository 実装

```dart
class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<firebase_auth.User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Exception _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('ユーザーが見つかりません');
      case 'wrong-password':
        return Exception('パスワードが間違っています');
      case 'invalid-email':
        return Exception('無効なメールアドレスです');
      default:
        return Exception('認証エラーが発生しました: ${e.message}');
    }
  }
}
```

## プロジェクトセットアップ

### 1. プロジェクト作成

```bash
flutter create your_app_name
cd your_app_name
```

### 2. ディレクトリ構造作成

```bash
mkdir -p lib/features/{auth,upload,analysis,files}/{controllers,models,repositories,usecases,views}
mkdir -p lib/core/{routes,services,widgets,theme,utils,env}
```

### 3. main.dart 設定

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Your App Name',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### 4. Firebase 設定

```bash
# Firebase CLI インストール
npm install -g firebase-tools

# ログイン
firebase login

# Flutter用Firebase設定
dart pub global activate flutterfire_cli
flutterfire configure
```

### 5. コード生成

```bash
# 依存関係インストール
flutter pub get

# コード生成実行
flutter packages pub run build_runner build --delete-conflicting-outputs

# 開発中の自動生成
flutter packages pub run build_runner watch
```

## ベストプラクティス

### 1. エラーハンドリング

```dart
// 共通エラーハンドリング
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class ValidationException extends AppException {
  ValidationException(String message) : super(message, code: 'VALIDATION_ERROR');
}

// Controller でのエラーハンドリング
Future<void> performAction() async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    await _useCase.call();
    state = state.copyWith(isLoading: false);
  } on AppException catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: e.message,
    );
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: '予期せぬエラーが発生しました',
    );
  }
}
```

### 2. 環境設定管理

```dart
// lib/core/env/app_env.dart
abstract class AppEnv {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Your App',
  );

  static const bool isProduction = bool.fromEnvironment('IS_PRODUCTION');
}

// 実行時の環境指定
// flutter run --dart-define=API_BASE_URL=https://dev-api.example.com
```

### 3. テスト戦略

```dart
// test/features/auth/controllers/auth_notifier_test.dart
void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepository;
    late MockSignInUseCase mockUseCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockUseCase = MockSignInUseCase();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
          signInUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は空のAuthState', () {
      final authState = container.read(authNotifierProvider);

      expect(authState.user, isNull);
      expect(authState.isLoading, isFalse);
      expect(authState.error, isNull);
    });

    test('ログイン成功時にユーザー情報を設定', () async {
      final user = User(id: '123', email: 'test@example.com');
      when(() => mockUseCase.call(any(), any())).thenAnswer((_) async => user);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signIn('test@example.com', 'password');

      final state = container.read(authNotifierProvider);
      expect(state.user, equals(user));
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });
  });
}
```

## 運用・保守のポイント

### 1. パフォーマンス最適化

- **AutoDisposeProvider**を使用してメモリリークを防止
- **FutureProvider**でキャッシュ機能を活用
- **select**メソッドで必要な部分のみを監視

### 2. 国際化対応

```dart
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

# 多言語対応
flutter:
  generate: true
```

### 3. ログとデバッグ

```dart
// lib/core/utils/logger.dart
import 'dart:developer' as developer;

class Logger {
  static void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'INFO');
  }

  static void error(String message, {String? tag, Object? error}) {
    developer.log(message, name: tag ?? 'ERROR', error: error);
  }
}
```

このアーキテクチャガイドを参考に、保守性とスケーラビリティに優れた Flutter アプリケーションを構築してください。
