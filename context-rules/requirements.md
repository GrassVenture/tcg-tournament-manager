# TCGマイスター互換スイスドローシステム 要件定義書

## 1. システム概要

### 1.1 目的
TCGマイスターと互換性のあるスイスドロー形式のカードゲームマッチングシステムを開発し、お店の管理者がPCブラウザで大会運営を行い、プレイヤーがスマホブラウザで参加できるシステムを構築する。

### 1.2 システム概要
- **管理者**: PCブラウザで大会作成・管理
- **プレイヤー**: スマホブラウザでQRコード読み取り・参加
- **形式**: スイスドロー形式（TCGマイスター互換）
- **参加者数**: 最大64名
- **対戦形式**: BO1（1本勝負）

## 2. 機能要件

### 2.1 管理者機能
- **大会作成・管理**
  - 大会の新規作成
  - 大会設定（ラウンド数、引き分け処理方式）
  - 参加者一覧の確認
  - QRコード発行・表示

- **対戦管理**
  - 対戦表の表示・編集
  - 勝敗結果の修正
  - 不戦勝の手動設定
  - 次ラウンドの生成

- **認証・セキュリティ**
  - 管理者ログイン機能
  - アクセス権限管理

### 2.2 プレイヤー機能
- **参加登録**
  - QRコード読み取りによる大会参加
  - 名前登録（名前のみ）
  - 参加確認

- **対戦管理**
  - 現在の対戦相手確認
  - 勝敗登録
  - 対戦履歴確認

- **情報確認**
  - リーグ表（順位表）表示
  - 自分の戦績確認

### 2.3 システム機能
- **スイスドローエンジン**
  - 標準スイスドローアルゴリズム
  - 同一対戦相手回避機能
  - 不戦勝（Bye）の自動割り当て
  - ラウンド数自動計算

- **リアルタイム更新**
  - 対戦表のリアルタイム同期
  - 勝敗登録の即時反映
  - 順位表の自動更新

## 3. 非機能要件

### 3.1 性能要件
- **応答時間**: 通常操作で2秒以内
- **同時接続数**: 最大64名のプレイヤー + 管理者
- **可用性**: 99%以上（大会中）

### 3.2 技術要件
- **フロントエンド**: Flutter Web
- **バックエンド**: Go言語
- **データベース**: Cloud Firestore
- **認証**: Firebase Authentication
- **デプロイ**: Google Cloud Platform

### 3.3 運用要件
- **データ永続化**: 必要（サーバー再起動後も大会データ保持）
- **バックアップ**: 大会終了後のデータ保存
- **監視**: 基本的なログ記録

## 4. ユーザーストーリー

### 4.1 管理者ストーリー
**大会作成**
- As a 管理者, I want to 新しい大会を作成できる so that プレイヤーが参加できる大会を用意できる
- As a 管理者, I want to ラウンド数を設定できる so that 大会の規模に応じた運営ができる
- As a 管理者, I want to 引き分け処理方式を選択できる so that 大会ルールに合わせた運営ができる

**参加者管理**
- As a 管理者, I want to QRコードを発行できる so that プレイヤーが簡単に参加できる
- As a 管理者, I want to 参加者一覧を確認できる so that 大会の参加状況を把握できる
- As a 管理者, I want to 参加を締め切れる so that 大会を開始できる

**対戦管理**
- As a 管理者, I want to 対戦表を確認できる so that 各ラウンドの対戦状況を把握できる
- As a 管理者, I want to 勝敗結果を修正できる so that 登録ミスを訂正できる
- As a 管理者, I want to 不戦勝を手動設定できる so that 特殊な状況に対応できる
- As a 管理者, I want to 次ラウンドを生成できる so that 大会を進行できる

### 4.2 プレイヤーストーリー
**参加登録**
- As a プレイヤー, I want to QRコードを読み取って参加できる so that 簡単に大会に参加できる
- As a プレイヤー, I want to 名前を登録できる so that 他のプレイヤーに識別してもらえる
- As a プレイヤー, I want to 参加確認ができる so that 正常に登録されたことを確認できる

**対戦管理**
- As a プレイヤー, I want to 対戦相手を確認できる so that 誰と対戦するかわかる
- As a プレイヤー, I want to 勝敗を登録できる so that 試合結果を記録できる
- As a プレイヤー, I want to 対戦履歴を確認できる so that 自分の戦績を把握できる

**情報確認**
- As a プレイヤー, I want to リーグ表を確認できる so that 現在の順位を把握できる
- As a プレイヤー, I want to 自分の戦績を確認できる so that 進行状況を把握できる

## 5. ユースケース図

```
システム境界: TCGスイスドローシステム

管理者
├── 大会作成
├── QRコード発行
├── 参加者管理
├── 対戦表管理
├── 勝敗結果修正
├── 不戦勝設定
└── 次ラウンド生成

プレイヤー
├── QRコード読み取り
├── 参加登録
├── 対戦相手確認
├── 勝敗登録
├── 対戦履歴確認
└── リーグ表確認

システム
├── スイスドローペアリング
├── 不戦勝自動割り当て
├── ラウンド数自動計算
└── リアルタイム更新

外部システム
├── Firebase Authentication
├── Cloud Firestore
└── QRコード生成API
```

## 6. シーケンス図

### 6.1 大会作成・参加フロー

```
管理者 -> システム: 大会作成
システム -> Firestore: 大会データ保存
システム -> 管理者: QRコード発行

プレイヤー -> システム: QRコード読み取り
システム -> プレイヤー: 参加登録画面表示
プレイヤー -> システム: 名前登録
システム -> Firestore: 参加者データ保存
システム -> 管理者: 参加者一覧更新（リアルタイム）
```

### 6.2 対戦ペアリング・勝敗登録フロー

```
管理者 -> システム: 大会開始
システム -> システム: スイスドローペアリング実行
システム -> Firestore: 対戦表保存
システム -> 全プレイヤー: 対戦表更新通知（リアルタイム）

プレイヤーA -> システム: 勝敗登録（勝利）
システム -> Firestore: 勝敗結果保存
システム -> プレイヤーB: 対戦結果通知（リアルタイム）
システム -> 管理者: 勝敗結果更新（リアルタイム）

管理者 -> システム: 次ラウンド生成
システム -> システム: 次ラウンドペアリング実行
システム -> Firestore: 新対戦表保存
システム -> 全プレイヤー: 新対戦表通知（リアルタイム）
```

### 6.3 勝敗結果修正フロー

```
管理者 -> システム: 勝敗結果修正画面表示
システム -> 管理者: 現在の勝敗結果表示
管理者 -> システム: 勝敗結果修正
システム -> Firestore: 修正結果保存
システム -> システム: 順位表再計算
システム -> 全プレイヤー: 順位表更新通知（リアルタイム）
```

## 7. 技術仕様

### 7.1 アーキテクチャ

#### システム全体構成
```
[Flutter Web] ←→ [Go API Server] ←→ [Cloud Firestore]
                      ↓
               [Firebase Auth]
```

#### Flutter Web アーキテクチャ（MVC + Clean Architecture）
```
lib/
├── features/                 # 機能別モジュール
│   ├── tournament/          # 大会管理機能
│   │   ├── controllers/     # 状態管理・UI制御
│   │   ├── models/          # データ構造
│   │   ├── repositories/    # データアクセス
│   │   ├── usecases/        # ビジネスロジック
│   │   └── views/           # UI コンポーネント
│   ├── admin/               # 管理者機能
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── usecases/
│   │   └── views/
│   ├── player/              # プレイヤー機能
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── usecases/
│   │   └── views/
│   └── auth/                # 認証機能
│       ├── controllers/
│       ├── models/
│       ├── repositories/
│       ├── usecases/
│       └── views/
└── core/                    # 共通機能
    ├── routes/              # ルーティング
    ├── services/            # 共通サービス
    ├── widgets/             # 共通UIコンポーネント
    ├── theme/               # テーマ・スタイル
    ├── utils/               # ユーティリティ
    └── env/                 # 環境設定
```

#### 技術スタック
**必須依存関係**
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
  
  # ルーティング
  go_router: ^13.2.1
  
  # データモデリング
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # HTTP通信
  dio: ^5.8.0+1
  
  # QRコード
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1
  
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

#### 層の責任分離
- **Models**: データ構造とビジネスエンティティ（Tournament, Player, Match）
- **Views**: UI コンポーネントとページ（管理者画面、プレイヤー画面）
- **Controllers**: 状態管理とUI制御ロジック（HooksRiverpod使用）
- **Repositories**: データアクセスの抽象化（Firestore操作）
- **UseCases**: 単一責任のビジネスロジック（スイスドローペアリング等）

### 7.2 データモデル

**Tournament（大会）**
```
{
  id: string,
  name: string,
  maxPlayers: number,
  currentRound: number,
  totalRounds: number,
  drawHandling: "both_lose" | "draw_point",
  status: "registration" | "in_progress" | "completed",
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**Player（プレイヤー）**
```
{
  id: string,
  tournamentId: string,
  name: string,
  joinedAt: timestamp,
  isActive: boolean
}
```

**Match（対戦）**
```
{
  id: string,
  tournamentId: string,
  round: number,
  player1Id: string,
  player2Id: string,
  result: "player1_win" | "player2_win" | "draw" | "bye" | "pending",
  reportedBy: string,
  reportedAt: timestamp
}
```

### 7.3 API設計

**大会管理**
- POST /tournaments - 大会作成
- GET /tournaments/{id} - 大会詳細取得
- PUT /tournaments/{id} - 大会更新

**参加者管理**
- POST /tournaments/{id}/players - 参加者登録
- GET /tournaments/{id}/players - 参加者一覧取得

**対戦管理**
- POST /tournaments/{id}/pairings - ペアリング生成
- GET /tournaments/{id}/matches - 対戦一覧取得
- PUT /matches/{id} - 勝敗登録
- GET /tournaments/{id}/standings - 順位表取得

## 8. 実装マイルストーン

### Milestone 1: 基本フロー確認
- 最小限の管理者画面（大会作成）
- 最小限のプレイヤー画面（参加登録）
- QRコード生成・読み取り機能

### Milestone 2: ペアリング確認
- スイスドローペアリング機能
- 対戦表表示

### Milestone 3: 勝敗登録確認
- 勝敗登録機能
- 次ラウンド生成

### Milestone 4: 管理者機能確認
- 勝敗修正機能
- 管理者ダッシュボード

### Milestone 5: 最終調整
- UI/UX改善
- リアルタイム更新
- 総合テスト

## 9. 制約・前提条件

### 9.1 制約
- 最大参加者数: 64名
- 対戦形式: BO1のみ
- 時間制限: 管理しない
- 途中参加: 大会開始後は不可
- 複数大会: 同時開催は考慮しない

### 9.2 前提条件
- 管理者はPCブラウザを使用
- プレイヤーはスマホブラウザを使用
- インターネット接続が安定している
- Firebase/GCPアカウントが利用可能

## 10. 今後の拡張可能性

### 10.1 機能拡張
- 複数大会同時開催
- レーティングシステム
- 大会結果エクスポート
- 詳細な統計情報

### 10.2 技術拡張
- PWA対応
- オフライン機能
- 通知機能
- 大会テンプレート機能