# netflix-data-analysis

# PowerBI-MySQL-Dashboard

MySQL に格納したCSVデータをPowerBIで可視化したダッシュボードのポートフォリオです。

---

## プロジェクト概要

映画データ（`movies.csv` / `ratings.csv`）をMySQLに取り込み、PowerBI Desktopと接続してインタラクティブなダッシュボードを作成しました。スライサーを活用することで、カードやテーブルが動的に連動するUIを実現しています。

---

## 使用技術

| ツール | 用途 |
|--------|------|
| MySQL 8.x | データ格納・リレーショナルDB管理 |
| MySQL Connector/NET | PowerBIとMySQLの接続 |
| Power BI Desktop | データ可視化・ダッシュボード作成 |

---

## ダッシュボード構成

### Overview ページ
全タイトルの集計ビュー。ジャンル別・年別の分布をグラフで表示。スライサーで絞り込むと、KPIカードとテーブルが動的に連動します。

### SingleTitleView ページ
個別タイトルの詳細ビュー。スライサーで作品を選択すると、評価スコア・レビュー数・監督情報がリアルタイムに切り替わります。

---

## リポジトリ構成

```
PowerBI-MySQL-Dashboard/
├── data/
│   ├── movies.csv       # 映画マスタデータ（15件）
│   └── ratings.csv      # ユーザー評価データ（20件）
├── docs/
│   ├── dashboard_overview.png    # Overviewページのスクリーンショット
│   └── dashboard_single.png      # SingleTitleViewページのスクリーンショット
├── sql/
│   └── create_tables.sql  # テーブル作成 & データロードSQL
└── README.md
```

---

## 環境構築手順

### 1. CSVファイルの文字コード変換

MySQLへのインポート時に文字化けが発生する場合は、CSVファイルの文字コードをANSIに変換します。

1. CSVファイルをメモ帳で開く
2. 「名前を付けて保存」を選択
3. 文字コード（エンコード）を **ANSI** に変更して保存

> UTF-8のBOMが原因でMySQLのLOAD DATAが失敗するケースへの対処です。

### 2. MySQLデータベースのセットアップ

```sql
-- sql/create_tables.sql を実行
source /path/to/sql/create_tables.sql;
```

### 3. MySQL Connectorのインストール

PowerBIからMySQLに接続するために、**MySQL Connector/NET** をインストールします。

- 公式ダウンロード: https://dev.mysql.com/downloads/connector/net/
- PowerBI Desktopを再起動してから接続操作を行ってください。

### 4. PowerBIとMySQLの接続

1. PowerBI Desktop を起動
2. 「データを取得」→「データベース」→「MySQL データベース」を選択
3. サーバー名: `localhost`、データベース名: `movie_db` を入力
4. 認証情報を入力して接続

### 5. リレーションシップの設定

PowerBI の「モデルビュー」で以下のリレーションシップを設定します。

```
movies.movie_id  ──< ratings.movie_id
（1対多）
```

---

## 工夫した点・ハマったポイント

- **文字化け対応**: CSVをUTF-8のままMySQLにインポートすると文字化けが発生。メモ帳でANSIに再保存することで解決しました。
- **Connector導入**: PowerBIはデフォルトではMySQLに接続できないため、MySQL Connector/NETのインストールが必要です。
- **動的スライサー**: スライサーを配置することで、同ページのカード・テーブル・グラフが連動して絞り込まれるインタラクティブなUIを構築しました。

---

## スクリーンショット

> ※ PowerBIでダッシュボード完成後、`docs/` フォルダに画像を追加してください。

| Overview | SingleTitleView |
|----------|-----------------|
| ![Overview](docs/dashboard_overview.png) | ![SingleTitleView](docs/dashboard_single.png) |

---

## 今後の予定

- データ件数を増やしてより本格的な分析を行う
- DAXメジャーを活用した計算列の追加
- PowerBI Serviceへの公開

---

*作成日: 2025年*
