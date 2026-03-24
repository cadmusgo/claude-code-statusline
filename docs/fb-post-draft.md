# FB 貼文草稿

---

**【用 Claude Code 寫了一個 Claude Code 的狀態列】**

身為一個每天跟 AI 結對編程的開發者，最讓我焦慮的事情不是 bug，而是——

「我的 context window 還剩多少？」

Claude Code 內建的狀態列只顯示目錄名和 Git 分支。但當你在一個長 session 裡跟 AI 協作，你真正需要知道的是：上下文快用完了嗎？花了多少錢？速率限制還好嗎？

所以我做了一個美化版的狀態列 🔧

━━━━━━━━━━━━━━━━━━━━━━━

**它長這樣：**

正常狀態（綠色，安心工作）：
```
◆ Claude Opus 4.6 │ ████░░░░░░ 42% │ $0.85 │ 3m42s
⎇main* │ +150/-30 │ my-project
```

快爆了（紅色 + 警告）：
```
◆ Claude Opus 4.6 │ █████████░ 92% ⚠ │ $15.30 │ 45m12s
⎇main │ +500/-120 │ api-server
```

Session 剛開始（智慧隱藏，沒有噪音）：
```
◆ Opus 4.6 (1M context) │ ░░░░░░░░░░ 0% │ $0.00
claude-temp
```

━━━━━━━━━━━━━━━━━━━━━━━

**重點功能：**

🎨 真彩色漸層進度條 — 每一格的顏色都不一樣，從綠漸變到紅。不用讀數字，用眼角餘光就知道狀態。

🧹 零值智慧隱藏 — 剛開始的 session 不會充滿 `+0/-0`、`0m0s` 這些沒意義的數字。

⚡ < 50ms — 整個腳本只呼叫一次 jq，git 狀態快取 5 秒。完全無感延遲。

🔀 三層渲染降級 — 真彩色 → ANSI 256 色 → 純 ASCII。不管你用什麼終端機都能跑。

🔧 選配 Nerd Font + Powerline — 喜歡  分支圖示和  箭頭分隔符的極客可以啟用。

━━━━━━━━━━━━━━━━━━━━━━━

**技術上有趣的地方：**

這個專案本身就是用 Claude Code 完成的。整個過程中我學到幾個 bash 的暗坑：

1. `bash 3.2`（macOS 預設）的 `read` 會靜默合併連續的 tab 分隔符 — 空欄位直接消失，後面的值全部位移。解法：改用每行一個值 + 逐行讀取。

2. `$()` 命令替換會吃掉尾部所有換行 — 如果 jq 最後一個欄位輸出空字串，那一行會被當成「尾部換行」直接吞掉。解法：在最後加一個哨兵值 `"END"`。

3. Claude Code 的 `statusLine` 機制其實已經把完整的 session 狀態包成 JSON 餵給你了，根本不需要自己去解析 session 檔案。大多數人不知道這件事。

━━━━━━━━━━━━━━━━━━━━━━━

**安裝：**

```bash
git clone https://github.com/kcchien/claude-code-statusline.git
cd claude-code-statusline
./install.sh
```

GitHub: https://github.com/kcchien/claude-code-statusline

歡迎 star ⭐ 和提 issue！

#ClaudeCode #DeveloperTools #Bash #CLI #AI #Anthropic

---

## 建議配圖

1. **主圖**：終端機截圖，顯示三種狀態（正常/警告/危險）的 before-after 對比
2. **細節圖**：漸層進度條的特寫，標注每格的顏色變化
3. **安裝流程**：三步驟的簡潔截圖（clone → install → restart）
