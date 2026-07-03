---
name: acceptance-bar
description: 当认为一项改动已完成、准备 commit 或 push 时使用，逐项核对通用完成标准；也在开工前用于预估"改完"要过几道门。不适用于：探索性/一次性的中间改动、纯调查任务、不产生提交的会话。
---

# 通用完成门禁

任何项目中"改完了"的下限标准。各项目自己的构建/测试/CI 门禁写在该项目的
`.claude/skills/` 或 CLAUDE.md 里，与本清单**叠加**而非替代。

## 必过门禁

1. `git status --short` 干净——没有忘记提交的文件，也没有误提交的临时文件、
   调试残留（console.log / print / 注释掉的代码块）。
2. 项目声明的测试/构建/lint 命令全部执行过且通过——没找到声明就检查
   package.json scripts、Makefile、CI 配置，仍没有则在交付说明里明示"未经测试验证"。
3. commit message 说清"为什么改"，而不只是"改了什么"。
4. 改动触及 [danger-ops](../danger-ops/SKILL.md) 中的操作类别时，其前置动作已完成。

## 写入门槛

- 新增门禁必须来自实际漏网事故：某次"以为改完了"但没改完，
  附项目 + 出处（commit / incident-review 条目）。
- 教科书式的通用最佳实践不收——只收被漏网证明过"确实会忘"的检查项。

条目格式：

```
### <门禁名>
- 检查动作：可直接执行的一行命令或明确的核对步骤
- 怎样算过 / 怎样算挂
- 引入原因：<项目名 + commit / incident-review 条目>
```

## 关联

- 门禁挂了且原因不明 → [debugging-playbook](../debugging-playbook/SKILL.md)
