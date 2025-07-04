# TCG Tournament Manager

TCGマイスター互換のスイスドロー形式カードゲーム大会管理システム

## 概要

- **管理者**: PCブラウザで大会作成・管理
- **プレイヤー**: スマホブラウザでQRコード読み取り・参加
- **形式**: スイスドロー形式（TCGマイスター互換）
- **参加者数**: 最大64名
- **対戦形式**: BO1（1本勝負）

## 技術スタック

- **フロントエンド**: Flutter Web
- **状態管理**: HooksRiverpod
- **アーキテクチャ**: Clean Architecture + MVC
- **バックエンド**: Go言語（予定）
- **データベース**: Cloud Firestore
- **認証**: Firebase Authentication

## 開発環境セットアップ

```bash
# 依存関係インストール
flutter pub get

# コード生成
flutter packages pub run build_runner build

# 開発サーバー起動
flutter run -d chrome
```

## マイルストーン進捗

- ✅ Milestone 1: 基本フロー確認（完了）
  - 最小限の管理者画面（大会作成）
  - 最小限のプレイヤー画面（参加登録）
  - QRコード生成・読み取り機能

- 🔄 Milestone 2: ペアリング確認（次回）
  - スイスドローペアリング機能
  - 対戦表表示

## アーキテクチャ

```
lib/
├── features/               # 機能別モジュール
│   ├── tournament/        # 大会管理機能
│   ├── admin/             # 管理者機能
│   ├── player/            # プレイヤー機能
│   └── auth/              # 認証機能
└── core/                  # 共通機能
    ├── routes/            # ルーティング
    ├── services/          # 共通サービス
    ├── widgets/           # 共通UIコンポーネント
    ├── theme/             # テーマ・スタイル
    └── utils/             # ユーティリティ
```
