# Forerouter VPA Agent（Release）

Forerouter 是一个运行在本地设备上的跨平台 VPA（Virtual Personal Assistant）智能体。  
在 `local` 模式下，Gateway 与 Agent 同进程运行，开箱即可使用。

## 功能概览

- **本地优先**：`local` 模式下无需远程网关，适合个人电脑独立部署。
- **多模型支持**：支持 OpenAI 兼容接口、Claude、Ollama。
- **工具调用**：支持文件读写、目录操作、命令执行、网页搜索/抓取、记忆读写等。
- **多模态能力**：支持图片分析、视频分析、音频转写（由配置中的 provider 决定是否启用）。
- **Agent Skills**：内置和自定义 skill 按需激活，按会话控制工具权限。
- **Code Interpreter**：子智能体可生成并执行 Python，用于数据分析与脚本任务。
- **MCP Server**：可对接 Claude Desktop、Cursor、VS Code 等 MCP 客户端。

## 目录说明

- `bin/`：可执行文件
- `configs/`：配置模板（含 `config.local.yaml`）
- `start-local.sh`：Linux/macOS 一键启动脚本
- `start-local.bat`：Windows 一键启动脚本
- `LICENSE`：许可证

## 一键启动脚本

在 `release` 目录中已提供跨系统启动脚本：

### Linux / macOS

```bash
chmod +x ./start-local.sh
./start-local.sh

# 可选：指定自定义配置文件
./start-local.sh ./configs/config.local.yaml
```

脚本会自动根据系统和架构选择：

- macOS: `bin/forerouter-darwin-amd64` 或 `bin/forerouter-darwin-arm64`
- Linux: `bin/forerouter-linux-amd64` 或 `bin/forerouter-linux-arm64`

### Windows

```bat
start-local.bat

REM 可选：指定自定义配置文件
start-local.bat .\configs\config.local.yaml
```

Windows 脚本会优先使用 `bin\\forerouter-windows-arm64.exe`（若存在），否则使用 `bin\\forerouter-windows-amd64.exe`。

## Local 模式快速开始

### 1) 准备配置

编辑 `configs/config.local.yaml`：

- `mode` 保持为 `local`
- 在 `agent.llm.providers` 中配置可用模型（至少一个）
- 若使用视觉/音频能力，补充 `vision_provider` / `video_provider` / `audio_provider`

> 注意：请务必替换配置中的示例 API Key，不要将真实密钥提交到仓库。

### 2) 启动

在 release 目录执行（按你的平台选择二进制）：

```bash
# macOS arm64
./bin/forerouter-darwin-arm64 --mode=local --config ./configs/config.local.yaml

# macOS amd64
./bin/forerouter-darwin-amd64 --mode=local --config ./configs/config.local.yaml
```

### 3) 验证服务是否正常

默认 local 模式（以 `configs/config.local.yaml` 为准）会启动：

- HTTP API：`http://127.0.0.1:31889`
- gRPC：`127.0.0.1:318090`
- MCP：`http://127.0.0.1:31891/mcp`

健康检查：

```bash
curl http://127.0.0.1:31889/api/v1/health
```

正常返回示例：

```json
{"status":"ok"}
```

## MCP 客户端连接（Local）

如果要让外部 AI 客户端通过 MCP 调用本地 Agent，可使用：

- URL：`http://127.0.0.1:31891/mcp`
- local 默认可不启用鉴权（以配置为准）

如需限制暴露工具，可在 `gateway.mcp.tool_whitelist` 中配置白名单。

## 常用运行参数

- `--mode=local`：本地一体化模式（推荐）
- `--mode=gateway`：仅网关
- `--mode=agent`：仅智能体
- `--config=...`：指定配置文件路径

## 常见问题

### 启动失败：模型调用报错

- 检查 `config.local.yaml` 中的 `api_key`、`base_url`、`model` 是否匹配。
- 若走 OpenAI 兼容平台，确认 `base_url` 是否为 API 根路径（通常以 `/v1` 结尾）。

### MCP 客户端连不上

- 确认进程已启动且监听端口与配置一致。
- 检查是否被本机防火墙拦截。
- 检查 MCP 路径是否为 `/mcp`。

### 命令执行需要确认

默认开启命令执行确认（`agent.security.command_execution.require_confirmation: true`），这是预期安全行为。

## 许可证

MIT
