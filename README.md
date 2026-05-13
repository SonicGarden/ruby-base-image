# ruby-docker-image

https://gallery.ecr.aws/sonicgarden/ruby のソースコードです。

## Ruby バージョン追加の自動化

[.github/workflows/add_ruby_versions.yml](.github/workflows/add_ruby_versions.yml) が毎日 09:00 JST に Docker Hub の `library/ruby` タグ一覧を確認し、未登録のバージョンを [.github/workflows/ruby_versions.json](.github/workflows/ruby_versions.json) に追加する Pull Request を自動作成します。

### 動作仕様

- 対象タグ: `^[0-9]+\.[0-9]+\.[0-9]+$` に一致するもののみ（`-slim`, `-alpine`, `-preview*` などは除外）
- 追加対象:
  - 既存のマイナー系列で、現状の最大パッチより新しいもの（例: 3.4 系の最大が 3.4.9 のときに 3.4.10 が出たら追加）
  - どの系列にも記載がない新マイナー/メジャー系列（例: 3.5.0、5.0.0）
- **欠番（過去にスキップしたバージョン）は埋めません**。既存エントリも削除・変更しません
- 並び順: メジャー.マイナー.パッチで数値比較した降順
- PR ブランチ: `automated/add-ruby-versions`（固定）。新バージョンが追加検知されるたびに同 PR が force-update されます
- ラベル: `ruby-version`, `automated`
- マージは**手動レビュー必須**（auto-merge 無効）

### マージ後の動作

PR をマージすると、`build_and_push.yml` が main push をトリガーに新バージョンを含めてビルド・ECR Public push を行います。

### 即時実行したい場合

Actions タブから「Add new Ruby versions」ワークフローを `workflow_dispatch` で実行してください。

### レビュー中に上書きされるのを防ぐ

cron が同ブランチへ force-push するため、レビュー中に手動コミットを追加すると次回 cron 実行で消える可能性があります。レビューで微調整が必要なときは `automated/add-ruby-versions` から別ブランチを切ってそちらをマージしてください。
