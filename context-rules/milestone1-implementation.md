# Milestone 1: 基本フロー確認 - 実装ドキュメント

## 実装概要

Milestone 1では、TCG大会管理システムの最小限の基本フローを実装し、管理者による大会作成からプレイヤーの参加登録までの一連の流れを確認できるようにしました。

## 実装した機能

### ✅ 管理者機能
- 大会作成フォーム（大会名、参加者数、引き分け処理設定）
- QRコード生成・表示
- デバッグ用URL表示・コピー機能

### ✅ プレイヤー機能
- QRコード読み取り（スマホカメラ使用）
- 参加登録フォーム（名前入力）
- 参加完了確認

### ✅ 技術基盤
- Flutter Web + HooksRiverpod
- Clean Architecture + MVC設計
- go_router によるルーティング
- Freezed データモデル
- QR コード生成ライブラリ

## ユースケース図

```
システム境界: TCG大会管理システム (Milestone 1)

管理者
├── 大会作成
├── QRコード生成・表示
└── デバッグ用URL確認

プレイヤー
├── QRコード読み取り（スマホカメラ）
├── 参加登録（名前入力）
└── 参加完了確認

システム
├── データモデル管理 (Tournament, Player, Match)
├── ルーティング処理
└── QRコード生成
```

## シーケンス図

### 1. 大会作成・QRコード生成フロー

```
管理者 -> AdminHomePage: 「新しい大会を作成」クリック
AdminHomePage -> TournamentCreatePage: 画面遷移
管理者 -> TournamentCreatePage: 大会情報入力（名前、参加者数、引き分け処理）
TournamentCreatePage -> TournamentCreatePage: バリデーション実行
TournamentCreatePage -> システム: 仮の大会ID生成 (timestamp)
システム -> TournamentQrPage: QRコード表示画面に遷移
TournamentQrPage -> QRライブラリ: QRコード生成（URL含む）
TournamentQrPage -> 管理者: QRコード + デバッグ情報表示
```

### 2. プレイヤー参加フロー

```
プレイヤー -> スマホカメラ: QRコード読み取り
スマホカメラ -> ブラウザ: URLを自動で開く
note: URL例: http://localhost:3000/#/player/join/1751706818809

ブラウザ -> go_router: ルーティング処理
go_router -> PlayerJoinPage: 参加登録画面表示
PlayerJoinPage -> プレイヤー: 大会情報 + 名前入力フォーム表示
プレイヤー -> PlayerJoinPage: 参加者名入力
PlayerJoinPage -> PlayerJoinPage: バリデーション（名前必須）
PlayerJoinPage -> システム: 参加登録処理（TODO: 実装予定）
システム -> プレイヤー: 参加完了メッセージ表示
```

### 3. デバッグ・テストフロー

```
管理者 -> TournamentQrPage: デバッグ情報確認
TournamentQrPage -> 管理者: 生成URL、文字数表示
管理者 -> TournamentQrPage: 「URLコピー」ボタンクリック
TournamentQrPage -> クリップボード: URLコピー
TournamentQrPage -> 管理者: コピー完了通知
管理者 -> ブラウザ: URL手動入力でテスト
ブラウザ -> PlayerJoinPage: 参加登録画面表示
```

## データフロー

### Tournament データモデル
```dart
Tournament {
  id: String,                    // タイムスタンプベースの一意ID
  name: String,                  // 大会名
  maxPlayers: int,               // 最大参加者数 (8-64)
  currentRound: int,             // 現在ラウンド (デフォルト: 0)
  totalRounds: int,              // 総ラウンド数
  drawHandling: DrawHandling,    // 引き分け処理方式
  status: TournamentStatus,      // 大会ステータス
  createdAt: DateTime?,          // 作成日時
  updatedAt: DateTime?           // 更新日時
}
```

### Player データモデル
```dart
Player {
  id: String,                    // プレイヤー一意ID
  tournamentId: String,          // 参加大会ID
  name: String,                  // プレイヤー名
  joinedAt: DateTime?,           // 参加日時
  isActive: bool                 // アクティブ状態
}
```

## 画面構成

### 管理者画面
1. **AdminHomePage** (`/admin`)
   - システム概要表示
   - 大会作成ボタン
   - 大会履歴ボタン（未実装）

2. **TournamentCreatePage** (`/admin/tournament/create`)
   - 大会名入力
   - 最大参加者数設定 (8-64)
   - 引き分け処理選択（両者敗北 / 引き分けポイント）
   - バリデーション付き作成ボタン

3. **TournamentQrPage** (`/admin/tournament/:id/qr`)
   - 大会情報表示
   - QRコード表示
   - デバッグ情報（URL、文字数）
   - URLコピーボタン
   - 参加者一覧ボタン（未実装）

### プレイヤー画面
1. **PlayerJoinPage** (`/player/join/:tournamentId`)
   - 大会情報表示
   - 参加者名入力フォーム
   - バリデーション付き参加ボタン
   - 参加完了メッセージ

## ルーティング構成

```dart
// 管理者ルート
/admin                           -> AdminHomePage
/admin/tournament/create         -> TournamentCreatePage  
/admin/tournament/:id/qr         -> TournamentQrPage

// プレイヤールート  
/player/join/:tournamentId       -> PlayerJoinPage

// エラーページ
/*                              -> 404 エラー表示
```

## QRコード仕様

### 生成URL形式
```
http://localhost:3000/#/player/join/{tournamentId}
```

### 含まれる情報
- **プロトコル**: http（開発環境用）
- **ホスト**: localhost:3000（Flutter開発サーバー）
- **ハッシュルーティング**: `#` を使用
- **大会ID**: タイムスタンプベース（例: 1751706818809）

## 技術的制約・課題

### 開発環境の制約
- **ローカルアクセスのみ**: Flutter開発サーバーは localhost のみリッスン
- **スマホテスト不可**: 192.168.x.x でのアクセス不可
- **Hash Routing**: Flutter Web のデフォルト動作

### 今後の改善点
- **本番環境デプロイ**: 実際のスマホテストのため
- **Path Routing**: SEOに優しいURL構造
- **外部公開**: ngrok等を使用した開発時テスト

## テスト手順

### PCブラウザでのテスト
1. **管理者フロー**:
   - http://localhost:3000 にアクセス
   - 「新しい大会を作成」→ 大会情報入力 → QRコード表示確認

2. **プレイヤーフロー**:
   - デバッグ情報のURLをコピー
   - 新しいタブで貼り付けてアクセス
   - 参加者名入力 → 参加登録完了確認

### スマホでのテスト（制限あり）
- **現状**: localhost URL のためアクセス不可
- **対応策**: ngrok使用または本番環境デプロイ

## 実装済みファイル構成

```
app/lib/
├── main.dart                    # アプリエントリーポイント
├── core/
│   ├── routes/app_router.dart   # ルーティング設定
│   └── theme/app_theme.dart     # アプリテーマ
└── features/
    ├── admin/views/
    │   ├── admin_home_page.dart
    │   ├── tournament_create_page.dart
    │   └── tournament_qr_page.dart
    ├── player/
    │   ├── models/player.dart
    │   └── views/player_join_page.dart
    └── tournament/models/
        ├── tournament.dart
        └── match.dart
```

## 次のマイルストーン への準備

### Milestone 2: ペアリング確認
実装予定の機能:
- スイスドローペアリングアルゴリズム
- 対戦表生成・表示
- 参加者一覧管理
- データ永続化（Firebase連携）

### 技術的改善
- 状態管理の強化（HooksRiverpod Controllers）
- Repository パターンによるデータアクセス
- UseCase による ビジネスロジック分離
- リアルタイム更新（Firestore Streams）

---

**Milestone 1 完了日**: 2025年7月5日  
**実装者**: Claude Code  
**テスト状況**: PCブラウザでの基本フロー確認済み