# netflix-data-analysis
# Netflix Data Analysis Dashboard
**Power BI × MySQL**

NetflixのタイトルデータをMySQLに取り込み、Power BIで可視化したダッシュボードのポートフォリオです。

---

## プロジェクト概要

Kaggleなどで公開されているNetflixデータセット（CSVファイル）をMySQLに読み込み、Power BIと接続してインタラクティブなダッシュボードを作成しました。スライサーで作品を選択すると、キャスト・監督・あらすじ・評価などが動的に切り替わるUIを実現しています。

---

## 使用技術

| ツール | 用途 |
|--------|------|
| MySQL 8.x | CSVデータの格納・リレーショナルDB管理 |
| MySQL Connector/NET | Power BIとMySQLの接続 |
| Power BI Desktop | データ可視化・ダッシュボード作成 |

---

## ダッシュボード構成

### Overview ページ
Netflixコンテンツ全体の集計ビュー。

| ビジュアル | 内容 |
|-----------|------|
| 面グラフ（Area Chart） | **Shows Added by Date** — 追加日別の作品数推移（Movie / TV Show 別） |
| 縦棒グラフ（Column Chart） | **Shows by Rating** — 年齢レーティング別の作品数 |
| 横棒グラフ（Clustered Bar Chart） | **Top 10 Genres** — 上位10ジャンルの作品数 |
| マップ | **Countries Available** — 配信国の地理的分布 |

### Single Title View ページ
個別タイトルの詳細ビュー。スライサーで作品を選ぶと全カードが動的に更新されます。

| ビジュアル | 内容 |
|-----------|------|
| スライサー | **Movie/TV Show** — タイトルで絞り込み（全ビジュアルに連動） |
| カード | **Rating** — 選択作品の年齢レーティング |
| カード | **Release Year** — 公開年 |
| カード | あらすじ（Description） |
| テーブル | 出演キャスト（Cast） |
| テーブル | 監督（Director） |
| マップ | **Countries Available** — 配信国 |

---

## データモデル（MySQLテーブル構成）

CSVデータを正規化し、以下のテーブル構成でMySQLに格納しました。

```
netflix_data titles            メインテーブル（show_id, title, type, rating, release_year, date_added）
        │
        ├── netflix_data netflix_cast          キャスト情報（cast）
        ├── netflix_data netflix_directors     監督情報（director）
        ├── netflix_data netflix_listed_in     ジャンル情報（category）
        ├── netflix_data countries_released    配信国情報（country）
        └── netflix_data description           あらすじ（description）
```

`titles` テーブルの `show_id` を主キーとして、各サブテーブルと1対多でリレーションを設定。

---

## リポジトリ構成

```
Netflix-Dashboard/
├── data/
│   └── netflix_data.csv       # Netflixデータセット（元データ）
├── docs/
│   ├── dashboard_overview.png     # Overviewページのスクリーンショット
│   └── dashboard_single.png       # Single Title Viewページのスクリーンショット
├── sql/
│   └── create_tables.sql          # テーブル作成・データロードSQL
└── README.md
```

---

## 環境構築手順

### 1. CSVファイルの文字コード変換

MySQLへのインポート時に文字化けが発生する場合は、文字コードをANSIに変換します。

1. CSVファイルをメモ帳で開く
2. 「名前を付けて保存」を選択
3. エンコードを **ANSI** に変更して保存

> UTF-8のBOMが原因で `LOAD DATA` が失敗するケースへの対処です。

### 2. MySQLデータベースのセットアップ

```sql
source /path/to/sql/create_tables.sql;
```

### 3. MySQL Connectorのインストール

Power BIからMySQLに接続するために、**MySQL Connector/NET** が必要です。

- 公式ダウンロード: https://dev.mysql.com/downloads/connector/net/
- インストール後、Power BI Desktopを再起動してから接続操作を行ってください。

### 4. Power BIとMySQLの接続

1. Power BI Desktop を起動
2. 「データを取得」→「データベース」→「MySQL データベース」を選択
3. サーバー: `localhost`、データベース: `netflix_data` を入力
4. 認証情報を入力して接続

### 5. リレーションシップの設定

Power BI の「モデルビュー」で `show_id` をキーに各テーブルを接続します。

```
titles.show_id  ──<  netflix_cast.show_id
titles.show_id  ──<  netflix_directors.show_id
titles.show_id  ──<  netflix_listed_in.show_id
titles.show_id  ──<  countries_released.show_id
titles.show_id  ──<  description.show_id
```

---

## 工夫した点・ハマったポイント

**文字化け対応**
CSVをUTF-8のままMySQLにインポートすると文字化けが発生しました。メモ帳で「名前を付けて保存」→エンコードをANSIに変更して再保存することで解決しました。

**MySQL Connectorの導入**
Power BIはデフォルトではMySQLに接続できないため、MySQL Connector/NETのインストールが必要でした。インストール後はPower BI Desktopの再起動が必要です。

**正規化とリレーション設計**
Netflixデータは1行にカンマ区切りでキャスト・ジャンルなどが入っているため、Pythonで前処理して正規化し、6つのテーブルに分割してMySQLに格納しました。

**スライサーによる動的連動**
Single Title Viewではタイトルのスライサーをページレベルのフィルターとして設定することで、キャスト・監督・あらすじ・評価・配信国がすべて一括で切り替わるUIを実現しました。

---

## スクリーンショット

| Overview | Single Title View |
|----------|-----------------|
| ![Overview](docs/dashboard_overview.png) | ![Single Title View](docs/dashboard_single.png) |

---

*作成: 2026年5月*

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

*作成日: 06/05/2026
