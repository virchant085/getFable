# getFable — 跨项目工程经验库

本仓库不是代码项目，是**经验资产库**：`.claude/skills/` 下的技能文档会通过
`sync.ps1` 同步到 `~/.claude/skills/`，在用户的所有项目中全局生效。
在本仓库工作 = 编写和维护这些技能文档。

## 写入硬约束

1. **收录判据：换一个项目还成立吗？** 不成立的经验不收，指引其写回来源项目自己的 `.claude/skills/`。
2. **每条经验必须带出处**：来源项目名 + 可追溯凭证（commit hash、PR/issue 链接或文件路径）。查不到出处的口头教训不许写。
3. 技能正文 ≤300 行；通用方法论（教科书能查到的）不写，只写实践中验证过的判断。
4. frontmatter 的 `description` 必须同时写明触发条件（"当…时使用"）和禁用场景（"不适用于…"），且不得出现"本项目/本仓库"字样——这些技能在任意项目中触发。
5. 技能之间用相对路径互相引用，禁止复制内容。
6. 每次修改技能后：运行 `.\sync.ps1` 同步到全局，然后 commit + push。
7. `.claude/settings.local.json` 不入库（已在 .gitignore）。
8. `main` 是唯一长期分支；远程为 github.com/virchant085/getFable。

## 三路审校

每积累约 10 条新经验，开三个**全新**会话（不得复用生成经验的会话）分别执行：

- **事实校验**：逐条验证出处是否存在、描述与实际 commit/PR 是否相符。输出：文档位置 + 声称内容 + 实际证据 + 判定（错误/过时/无法验证）。
- **逻辑校验**：通读全部技能，找互相矛盾的规则、循环引用、引用不存在的文档。
- **触发校验**：只看各 `description`，模拟轻量模型在"修 bug / 加功能 / 高危操作 / 收尾提交"场景下会不会在正确时机命中；找出太宽、太窄、互相重叠的触发条件并给出改写。

## 技能索引

- [incident-review](.claude/skills/incident-review/SKILL.md) — 跨项目故障复盘库
- [debugging-playbook](.claude/skills/debugging-playbook/SKILL.md) — 假报错与坑库
- [arch-constraints](.claude/skills/arch-constraints/SKILL.md) — 被证伪的技术路线
- [danger-ops](.claude/skills/danger-ops/SKILL.md) — 高危操作清单
- [acceptance-bar](.claude/skills/acceptance-bar/SKILL.md) — 通用完成门禁
- [solution-blueprints](.claude/skills/solution-blueprints/SKILL.md) — 方案级模板库
