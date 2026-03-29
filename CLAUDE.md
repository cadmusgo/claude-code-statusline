# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案概述

Claude Code statusline 工具 — Shell/Bash 專案，fork 自 [kcchien/claude-code-statusline](https://github.com/kcchien/claude-code-statusline)。

## 語言與溝通

- 一律使用中文為主（文件、註解、commit 訊息描述）
- Commit 訊息格式使用英文前綴：`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

## 開發規範

- Commit 風格：Conventional Commits（例：`feat: 新增狀態列顯示功能`）
- 所有 shell script 應使用 `#!/usr/bin/env bash` 作為 shebang
- 使用 `set -euo pipefail` 作為腳本開頭的安全設定
- **縮排使用 2-space**（不使用 tab）— 保持與上游一致，避免 merge upstream 時產生大量衝突。不要套用 shfmt 的 tab 縮排建議。

## 測試

- 執行測試：`bats test/`
- 測試檔案放在 `test/` 目錄，副檔名 `.bats`
- bats 測試名稱使用英文（中文會有編碼問題）

## 驗證

- shellcheck：`shellcheck *.sh **/*.sh`
- shfmt：`shfmt -d .`（檢查格式差異）

## Git 遠端

- `origin` — 自己的 fork（cadmusgo/claude-code-statusline）
- `upstream` — 上游（kcchien/claude-code-statusline）
- 定期 `git fetch upstream && git merge upstream/main` 同步上游更新
