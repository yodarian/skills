# AI Token Usage, Caching, and Cost Optimization

> **Disclaimer:** AI agent tools, models, integrations, pricing, and context or caching behavior change quickly. Check current documentation and test representative tasks in your setup before relying on claims about compatibility or savings.

## TL;DR

Use context and caching carefully, choose a model suited to the task, and keep project guidance clear so agents can work efficiently and check their results. Token use affects costs, while too much context can reduce output quality. Start fresh or hand off only relevant context when switching tasks, and use tools, skills, and hooks to avoid loading unnecessary information.

**Contents**

- [Understanding token consumption](#understanding-token-consumption)
  - [Key factors](#key-factors)
  - [Types of tokens](#types-of-tokens)
  - [What tokens are used for](#what-tokens-are-used-for)
  - [How prompt caching works](#how-prompt-caching-works)
    - [Example: Why a coffee break can become expensive](#example-why-a-coffee-break-can-become-expensive)
  - [Common causes of cache misses](#common-causes-of-cache-misses)
- [Why this matters](#why-this-matters)
- [Recommendations to reduce cost and token consumption](#recommendations-to-reduce-cost-and-token-consumption)
  - [Short-term optimizations](#short-term-optimizations)
    - [Audit usage](#audit-usage)
    - [Optimize context](#optimize-context)
    - [Clean up loaded context](#clean-up-loaded-context)
    - [Choose an appropriate model and reasoning level](#choose-an-appropriate-model-and-reasoning-level)
    - [Use skills for repetitive tasks](#use-skills-for-repetitive-tasks)
    - [Turn deterministic tasks into scripts](#turn-deterministic-tasks-into-scripts)
    - [Plan tasks and prompts in advance](#plan-tasks-and-prompts-in-advance)
  - [Long-term optimization: Make your codebase ready for agents](#long-term-optimization-make-your-codebase-ready-for-agents)
  - [Additional resources](#additional-resources)
    - [Tools](#tools)
      - [Usage & Cost Monitoring](#usage--cost-monitoring)
      - [Context Retrieval & Output Filtering](#context-retrieval--output-filtering)
      - [Codebase Packaging for AI](#codebase-packaging-for-ai)
    - [Skills](#skills)
    - [Best practices for `AGENTS.md` and `CLAUDE.md`](#best-practices-for-agentsmd-and-claudemd)
- [Other considerations](#other-considerations)
- [Conclusion](#conclusion)

## Understanding token consumption

### Key factors

- **Tokens:** The amount of text a model processes. Tokens are the most common unit used to measure this.
- **Model:** The model affects how much compute each token uses. More capable models generally require more compute per token.
- **Compute budget:** The amount of compute available, such as the amount included in a subscription.

**Compute budget used = tokens consumed × model used**

### Types of tokens

When you use AI models, including through coding agents, the input and output are measured in tokens. Different types of tokens can have different prices.

| Token type | Meaning | Cost |
| --- | --- | --- |
| Input tokens | Your prompt, previous chat history, and other context provided to the model | Standard input price |
| Output tokens | Generated responses, code, tool calls, and other outputs | Usually significantly more expensive than input |
| Reasoning tokens | Internal reasoning steps performed by the model when solving complex tasks | Usually billed at the output-token rate |
| Cached input tokens | Previously processed input that can be reused from a cache | Significantly cheaper than regular input |

A coding agent processes more than just your latest prompt. It may also send the previous conversation, system instructions, tool descriptions, and relevant code to the model again.

### What tokens are used for

For example, when you ask an agent to build a website, it uses tokens to:

- Reasoning about the solution
- Generating the code
- Using and interpreting tools
- Producing the final response

### How prompt caching works

Prompt caching lets a model reuse parts of a prompt it has already processed, if the model and provider support it and the cache requirements are met.

- **Cache hit:** The relevant start of the prompt has not changed and is still in the cache. Reused input tokens are charged at the lower cached-input rate.
- **Cache miss:** The relevant start of the prompt has changed, or the cache has expired. The affected input tokens must then be processed at the regular input price.

#### Example: Why a coffee break can become expensive

Imagine you have been working on a project with a coding agent for a while. The agent already has your requirements, code, and conversation history in context.

You take a ten-minute break. When you return, the following might happen:

1. The cache has expired.
2. You send a new message.
3. The agent has to process the previous context again.
4. Instead of the discounted cache price, you pay the regular input price for the tokens that are no longer cached.

This can significantly increase costs, especially in long conversations. The break itself does not use tokens; what matters is whether the cache is still available when you return.

A cache miss does not always mean the entire conversation must be processed again at full price. Depending on the provider, how its cache works, and what changed in the prompt, only some parts may be affected.

### Common causes of cache misses

- **Too much time between messages:** The cache expires after a certain period, which varies by model and provider.
- **Switching models:** For example, changing from one model to another, such as from Opus to Sonnet.
- **Changing the reasoning level:** For example, changing from High to Extra High, if that affects cache compatibility.
- **Changing tools or MCP servers:** New tool descriptions can change the start of the prompt.
- **Changing system prompts:** If the agent's initial instructions change, some or all of the existing cache may no longer be usable.

Whether a particular change causes a cache miss depends on how caching is implemented. The key factor is whether the reusable part at the start of the prompt stays the same.

## Why this matters

1. **Costs and monthly budgets:** Token use adds up across prompts and responses, so managing it can help you stay within your budget.
2. **The DumbZone:** As context grows, a model has more information and connections to keep track of. Its output quality may gradually decline rather than drop all at once. There is no agreement on where the DumbZone begins; it varies by model and task. A useful rule of thumb is around 150,000 tokens.

## Recommendations to reduce cost and token consumption

The recommendations fall into two groups: short-term changes for everyday use and long-term improvements to your codebase.

### Short-term optimizations

#### Audit usage

- <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> **Claude:** Use `/usage` to see how many tokens you have used and what is using your limits. Use `/context` to review the current chat session.
- <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> **GitHub Copilot:** Check the AI credits used.

#### Optimize context

- When you switch tasks, run `/clear` or start a new chat. A long conversation history may need to be considered again with each new message. For an unrelated task, start a new conversation instead of carrying over context you no longer need.
- If you need to keep the existing context, use handoff or compaction skills and tools to start a new session with the relevant information. A handoff document should include:
  - Current implementation status
  - Relevant architectural decisions
  - Modified files
  - Outstanding issues
  - Concrete next steps
- Try to work steadily rather than leaving long gaps between messages. If you wait ten minutes before replying, you may lose the benefits of caching. Cache settings vary between tools.
- <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> Adjust the effort level.
- <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> In GitHub Copilot, availability depends on the plugin version. For example, the effort setting is currently available in VS Code.

#### Clean up loaded context

- Remove any skills, MCP servers, connectors, and plugins you do not use.
- Shorten skill descriptions or, when appropriate, turn off model invocation:

  ```yaml
  name: my-skill
  description: Runs a complex workflow
  disable-model-invocation: true
  ```

- Shorten `AGENTS.md` or <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> `CLAUDE.md` files, following [best practices](#best-practices-for-agentsmd-and-claudemd).

#### Choose an appropriate model and reasoning level

Use a powerful model when a task requires it. For simple refactoring, small changes, or documentation, a cheaper model is often enough. Higher reasoning levels are not always more efficient: they may improve success rates, but they can also increase costs significantly.

A cheaper model does not always mean a cheaper solution. Repeated reasoning, extra prompts, debugging, and code changes can make the task more expensive overall.

Examples:

- Use a more capable model to coordinate the work and smaller models for specific tasks handled by subagents. Some skills let you choose which model to use.
- Use a built-in plan mode or planning skill with a more capable model, then use a faster, smaller model to implement the plan.

#### Use skills for repetitive tasks

If you often do the same tasks, such as code reviews, documentation, or refactoring, create reusable skills or instructions. This makes prompts more consistent, clarifies requirements, and reduces unnecessary follow-up questions. Make sure the skill itself does not add too much context.

#### Turn deterministic tasks into scripts

Agents are often good at writing scripts for tasks that follow predictable steps.

#### Plan tasks and prompts in advance

Instead of refining a prompt through repeated attempts, define the task and its constraints up front.

A useful prompt framework:

1. **The job:** The task or goal.
2. **The why:** Why the task matters.
3. **The guardrails:** What could go wrong and what rules can prevent it.
4. **Done means:** A clear definition of completion.

You can ask a model to brainstorm a topic and then help draft the prompt. Skills like [grilling](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md) can help with this.

**Example prompt for reviewing session-start context:**

```text
Audit everything that is preloaded into my context at the start of a session and help me cut it down. Three parts:
1. MCPs: list every connected MCP server and flag the ones I haven't used. Recommend which to remove.
2. Skills: list my skills and their descriptions. Flag unused ones to delete, and shorten any description longer than it needs to be.
3. AGENTS.md: trim it to under 200 lines without losing how the system works.

Show me the list with your recommendations before removing or editing anything.
```

**Example prompt for turning skills into scripts:**

```text
Analyze my project and identify any steps in my existing skills that could be implemented as scripts. Share those skills and explain how you would migrate them to script-optimized skills.

Review the entire conversation history to identify any additional skills I should create.
```

### Long-term optimization: Make your codebase ready for agents

The goal is to help a coding agent quickly understand your project and make fewer mistakes.

1. **Use established technologies.** Prefer well-documented, widely used frameworks and libraries that models know well and that have plenty of examples.
2. **Create a clear project structure.** A monorepo can help an agent understand how the frontend, backend, and shared packages relate. More important than the repository strategy are clear dependencies, consistent conventions, and a structure that makes relevant code easy to find.
3. **Organize documentation so details are easy to find.** Create a concise `AGENTS.md` that explains how the agent should work in the repository, then link to specialized documents, such as:
   - `docs/vision.md` — project vision and goals
   - `docs/db.md` — database decisions
   - `docs/api.md` — API conventions
   - Architecture and development guidelines

   The agent starts with only the most important information and reads more documentation when needed. This reduces unnecessary context and keeps the main instructions manageable.
4. Custom **hooks** can prepare data before an agent sees it. Instead of reading a 10,000-line log file to find errors, a hook can search for `ERROR` and return only matching lines, reducing the amount of context.

### Additional resources

#### Tools

##### Usage & Cost Monitoring
- [Token Optimizer](https://github.com/alexgreensh/token-optimizer/tree/main) reduces wasted tokens, carries your work across sessions and compactions, and shows how much you spend on a live dashboard.

##### Context Retrieval & Output Filtering
- [Code Review Graph](https://github.com/tirth8205/code-review-graph) lets you search a graph through MCP instead of reading files in chunks.
- [RTK](https://github.com/rtk-ai/rtk) filters and shortens command output before it reaches your model's context.

##### Codebase Packaging for AI
- [Gitingest](https://github.com/coderamp-labs/gitingest) turns a Git repository into text that is easier to include in a prompt. It may not suit very large codebases.
- [Repomix](https://github.com/yamadashy/repomix) packages your codebase in formats that work well with AI tools.

#### Skills

- [intent-layer](https://github.com/crafter-station/skills/tree/main/skills/intent-layer) creates hierarchical `AGENTS.md` files to help agents navigate codebases. It works only with harnesses that support hierarchical `AGENTS.md` files. This is currently experimental in <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> GitHub Copilot.
- [handoff](https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff) turns the current conversation into a handoff document that another agent can use.

#### Best practices for `AGENTS.md` and `CLAUDE.md`

- Keep files below 300 lines.
- Include **motivational intent**: one line explaining the project's purpose and why it exists.
- Document **non-obvious tooling**:
  - Include commands that are not obvious from the repository.
  - AI models are often trained on older framework versions, so note potential pitfalls when using newer versions.
- Provide a concise **architectural map**. It does not need to be complete or include diagrams, but it should cover anything unusual, such as `intent-layer`.
- Write **verifiable instructions**. For example, say “parameterize all SQL queries” instead of “write clean code.”
- State **hard constraints and anti-patterns**.
- Point to deeper documentation if the file gets too large.
- Record **gotchas and shared knowledge**, including solutions to problems you encountered.

## Other considerations

- <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> Claude may currently use fewer tokens when you paste text as an image rather than as plain text. [PXPipe](https://github.com/teamchong/pxpipe) can turn text into images; this may change in the future.
- You can run models locally. This does not reduce token use, but it may reduce costs. The tradeoff is that good performance requires high-end hardware, and open-source models are currently less capable.

## Conclusion

The biggest savings do not come from shortening every prompt just for the sake of it. They come from managing context and caching well, choosing the right model, and building a codebase that helps an agent understand the task and check its work.


## Official References

### <img src="./images/claude-code.svg" alt="Claude Code" width="20" /> Claude

- [Prompting best practices for Claude](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) — Covers explicit instructions, output formats and constraints, sequential steps, context, examples, and structuring prompts.
- [Prompt engineering overview for Claude](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview) — Recommends defining success criteria and ways to test them before refining a prompt.
- [Prompt caching (Claude API)](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) — How prefix-based caching works, automatic and explicit cache breakpoints, and 5-minute and 1-hour cache lifetimes.
- [How Claude Code uses prompt caching](https://code.claude.com/docs/en/prompt-caching) — Explains the cache layers, why model or effort changes and `/compact` invalidate the cache, and how to check your cache hit rate.
- [Manage costs effectively (Claude Code)](https://code.claude.com/docs/en/costs) — Tracking usage with `/usage` and ways to reduce token usage.
- [Token counting (Claude API)](https://platform.claude.com/docs/en/build-with-claude/token-counting) — Counting tokens before sending a request; counts are estimates.
- [Pricing (Claude API)](https://platform.claude.com/docs/en/about-claude/pricing) — Input, output, cache write, and cache read prices per model.

### <img src="./images/githubcopilot.svg" alt="GitHub Copilot" width="20" /> GitHub Copilot

- [Prompt engineering for GitHub Copilot](https://docs.github.com/en/copilot/concepts/prompting-and-context/prompt-engineering) — Covers clear requirements, examples, breaking down complex tasks, avoiding ambiguity, providing relevant context, and keeping conversation history relevant.
- [Usage-based billing for individuals (GitHub Copilot)](https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing) — AI credits, how input, output, and cached tokens are priced, and what affects usage.
- [Optimizing your AI usage to maximize efficiency and reduce cost (GitHub Copilot)](https://docs.github.com/en/copilot/tutorials/optimize-ai-usage) — Model choice, reasoning levels, clear prompts, and preserving the cache.
