# Installing Rubber Ducky 🦆

Rubber duck debugging skill for AI code agents. Forces step-by-step self-explanation
before pushing any fix — catching false assumptions through the act of explaining, not
through feedback.

## GitHub Copilot CLI

1. **Clone the repository:**
   ```bash
   git clone https://github.com/BandaruDheeraj/rubber-ducky.git ~/.copilot/marketplace-cache/rubber-ducky
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.copilot/skills
   ln -s ~/.copilot/marketplace-cache/rubber-ducky/plugins/rubber-ducky/skills/rubber-duck-debugging ~/.copilot/skills/rubber-duck-debugging
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.copilot\skills"
   Copy-Item -Recurse -Force "$env:USERPROFILE\.copilot\marketplace-cache\rubber-ducky\plugins\rubber-ducky\skills\rubber-duck-debugging" "$env:USERPROFILE\.copilot\skills\rubber-duck-debugging"
   ```

3. **Create the agents symlink:**
   ```bash
   mkdir -p ~/.copilot/agents
   ln -s ~/.copilot/marketplace-cache/rubber-ducky/plugins/rubber-ducky/agents/rubber-ducky.md ~/.copilot/agents/rubber-ducky.md
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.copilot\agents"
   Copy-Item -Force "$env:USERPROFILE\.copilot\marketplace-cache\rubber-ducky\plugins\rubber-ducky\agents\rubber-ducky.md" "$env:USERPROFILE\.copilot\agents\rubber-ducky.md"
   ```

4. **Add to your custom instructions.** Append the following to `~/.copilot/copilot-instructions.md`:

   ```markdown
   <!-- rubber-ducky-installed -->
   ## Rubber Duck Debugging 🦆

   You have the rubber-duck-debugging skill installed. BEFORE pushing any debug
   fix, behavioral change, or patch, you MUST invoke this skill to walk through
   the fix with the rubber duck.

   The Iron Rule: No code gets pushed until you've explained it to the duck.

   Available: rubber-duck-debugging (skill), rubber-ducky (agent)

   When to use:
   - "Fix this bug" → rubber-duck-debugging BEFORE pushing the fix
   - "Debug this" → rubber-duck-debugging to explain the code line by line
   - "Why is this failing?" → rubber-duck-debugging to find where explanation ≠ reality
   - Any fix found by trial-and-error rather than understanding → MUST rubber-duck first
   - Any fix you're not 100% sure about → MUST rubber-duck first
   ```

5. **Restart** your Copilot CLI session.

## Codex

1. **Clone:**
   ```bash
   git clone https://github.com/BandaruDheeraj/rubber-ducky.git ~/.codex/rubber-ducky
   ```

2. **Symlink skills:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/rubber-ducky/plugins/rubber-ducky/skills ~/.agents/skills/rubber-ducky
   ```

3. **Restart Codex.**

## Claude Code

Register the marketplace, then install:

```bash
/plugin marketplace add BandaruDheeraj/rubber-ducky
/plugin install rubber-ducky@rubber-ducky
```

Or manually clone and symlink into your `.claude/skills/` directory.

## Any Other Agent

The skill is a standalone markdown file. You can use it by:

1. Fetching `plugins/rubber-ducky/skills/rubber-duck-debugging/SKILL.md` from this repo
2. Placing it in your agent's skills directory
3. Adding the custom instructions snippet from step 4 above to your agent's system instructions

## Verify

Start a new session and try:
```
Use the rubber-duck-debugging skill to review my last fix
```

The agent should produce a structured 🦆 RUBBER DUCK SESSION with all Five Quacks.

## Updating

```bash
cd ~/.copilot/marketplace-cache/rubber-ducky && git pull
```

Skills update instantly through the symlink (macOS/Linux) or re-run the copy step (Windows).

## Uninstalling

```bash
rm -rf ~/.copilot/skills/rubber-duck-debugging
rm -f ~/.copilot/agents/rubber-ducky.md
rm -rf ~/.copilot/marketplace-cache/rubber-ducky
```

Remove the `<!-- rubber-ducky-installed -->` section from `~/.copilot/copilot-instructions.md`.
