# getFable — 跨项目工程经验库

把 Fable 5 在各项目中的高阶产出（难 bug 根因、被证伪的方案、可复用的解决方案）
沉淀为结构化技能文档，同步到全局 `~/.claude/skills/`，供轻量模型（Opus 4.8 等）
在**所有项目**中自动触发复用。

## 工作流

```
Fable 5 解决难题（任意项目）
        │
        ▼
判断：换一个项目还成立吗？
        │ 是                          │ 否
        ▼                             ▼
回写一条到本库对应技能          写回那个项目自己的 .claude/skills/
        │
        ▼
运行 .\sync.ps1 → 同步到 ~/.claude/skills/（全局生效）
        │
        ▼
git commit + push（经验资产可版本化、可回滚）
```

## 技能目录

| 技能 | 收什么 |
|---|---|
| [incident-review](.claude/skills/incident-review/SKILL.md) | 跨项目故障复盘：现象 + 根因 + 修复出处 + 防再发 |
| [debugging-playbook](.claude/skills/debugging-playbook/SKILL.md) | 假报错与坑：报错指向 A、真因是 B |
| [arch-constraints](.claude/skills/arch-constraints/SKILL.md) | 被实际失败证伪过的技术路线 |
| [danger-ops](.claude/skills/danger-ops/SKILL.md) | 难以撤销的高危操作及其前置动作 |
| [acceptance-bar](.claude/skills/acceptance-bar/SKILL.md) | 通用完成门禁：什么算改完了 |
| [solution-blueprints](.claude/skills/solution-blueprints/SKILL.md) | 方案级模板：步骤 + 验收标准 + 风险点 |

## 维护节奏

- **回写**：Fable 5 会话结束前，用一句话提示：「把本次可跨项目复用的经验回写到 D:\getFable 对应技能，遵守其 CLAUDE.md 写入规则」。
- **审校**：每积累约 10 条新经验，开三个全新会话跑三路交叉审校（事实 / 逻辑 / 触发条件），提示词见 [CLAUDE.md](CLAUDE.md#三路审校)。
- **冲突**：若某项目已有同名技能，项目级技能优先；本库技能改名避让即可。
