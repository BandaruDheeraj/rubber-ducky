---
name: rubber-duck-debugging
description: >
  Use BEFORE pushing any code fix, debug patch, or behavioral change. Forces the agent to
  explain the code step-by-step to a silent rubber duck, exposing logical gaps, false
  assumptions, and misunderstandings through the act of self-explanation alone — no feedback
  needed. Based on the classic rubber duck debugging method from The Pragmatic Programmer.
---

# Rubber Duck Debugging 🦆

## The Method

> "Explain your code to a rubber duck, line by line. At some point you will
> tell the duck what you are doing next and then realize that is not in fact
> what you are actually doing."
>
> — *The Pragmatic Programmer* (1999)

The duck is **silent**. It does not ask questions. It does not give feedback.
It does not suggest fixes. It sits there. You do all the talking.

The power is in the **act of explaining** — not in receiving a response.
When you force yourself to articulate what code does, step by step, to an
audience that offers nothing back, you switch from skimming to scrutinizing.
Bugs reveal themselves mid-sentence, because what you're *about to say*
contradicts what the code *actually does*.

## The Iron Rule

```
NO CODE GETS PUSHED UNTIL YOU'VE EXPLAINED IT TO THE DUCK.
```

If you haven't completed the Explain → Walk → Catch → Verify cycle, you
cannot commit, push, or declare the task done. No exceptions.

## When to Use

**ALWAYS use this skill when:**
- Debugging any bug, test failure, or unexpected behavior
- Proposing a fix for an issue
- About to push code that changes existing behavior
- A previous fix attempt didn't work
- You're not 100% sure *why* a change fixes the problem
- The fix was found by trial-and-error rather than understanding

**Especially use when:**
- The fix seems "obvious" (obvious fixes hide assumptions)
- You're under time pressure (pressure increases error rate)
- Working in unfamiliar code (gaps in understanding = gaps in fixes)
- Multiple agents or teammates have attempted the same issue
- The bug has been reopened before

**You may skip ONLY when:**
- Change is purely cosmetic (whitespace, comments, formatting)
- Adding new code that doesn't modify existing behavior
- The change was already rubber-ducked in a prior pass this session

## The Five Quacks

The duck sits on the desk. You talk. It listens. That's it.

Each Quack is a phase of self-explanation. You must complete all five,
in order, talking to the duck the entire time. The duck never responds —
you catch your own mistakes by hearing yourself explain.

### 🦆 Quack 1: Tell the Duck What's Wrong

Talk to the duck. Explain:

1. **What this code is supposed to do** — the intent, in plain language
2. **What it's actually doing instead** — the observed behavior
3. **How you know** — the error message, test failure, log output, or user report

State the gap between intent and reality in one sentence. If you can't
form that sentence, you don't understand the problem yet — keep explaining
until you can.

*The duck says nothing. It just looks at you with its plastic eyes.*

### 🦆 Quack 2: Walk the Duck Through the Code

Now trace the execution path, line by line, explaining to the duck as you go.
The duck knows nothing about your codebase — explain everything:

1. **Start at the entry point** — "Okay duck, execution starts here..."
2. **At each line, say what it's supposed to do** — then check if it actually
   does that. State both. "This line is supposed to do X. It actually does... Y."
3. **At every function call** — trace into it. Don't say "this calls doThing()
   and it works." Explain what doThing() actually returns and why.
4. **At every conditional** — state which branch is taken and why.
5. **At every variable** — state what value it holds at this point. Not what
   you think it holds — what the code actually computes.
6. **At every boundary** — function calls, API calls, async gaps, module
   imports. These are where assumptions break. Trace across them.

**Do not hand-wave.** If you catch yourself saying "this part's fine" or
"that obviously works" — that's the part the duck wants to hear about.
Explain it anyway. The bug is almost always in the part you want to skip.

*The duck says nothing. You keep talking.*

### 🦆 Quack 3: The Quack Point

At some point during Quack 2, you will say something like "and then this
line does X—" and realize, mid-sentence, that it doesn't do X at all.

**That's the quack point.** The moment your explanation diverges from reality.

When you catch it, tell the duck:

1. **What you assumed was true** — the false assumption
2. **Why you assumed it** — misleading name? similar pattern? didn't read closely?
3. **What's actually true** — prove it with evidence from the code
4. **Whether this is root cause or symptom** — if it's a symptom, keep
   walking the code until you find the real source

If you finish Quack 2 without finding a discrepancy, you either:
- Skipped a section (go back and explain it properly), or
- Need to explain at a finer level of detail

The bug is in the explanation gap. Always.

*The duck says nothing. But you just found the bug.*

### 🦆 Quack 4: Explain the Fix to the Duck

Before writing ANY code, explain to the duck what you're going to change:

1. **The fix, in plain English** — what will change and why
2. **Why this fixes the root cause** — connect it directly to the quack point
3. **What else this change touches** — callers, tests, side effects,
   downstream consumers
4. **What you are NOT changing** — and why those are safe to leave alone

Test: could someone implement your fix from just this English description,
without seeing the code? If not, your understanding has holes — keep
explaining to the duck until it's airtight.

*The duck says nothing. You now know exactly what to do.*

### 🦆 Quack 5: Show the Duck It Works

After implementing the fix, walk the duck through the code path one more time:

1. **Re-trace from Quack 2** — same path, with the fix in place
2. **At the quack point** — confirm the discrepancy is gone. X = Y now.
3. **Run the tests** — does the failing test pass? Do other tests still pass?
4. **Check for regression** — did the fix break anything adjacent?
5. **State your confidence to the duck** — "Duck, I am [confident / somewhat
   confident / uncertain] this is correct, because [reason]."

If you're confident: the duck session is complete. Approved to push.

If you're uncertain: go back to the quack where doubt crept in and
explain again. The duck has all day.

*The duck says nothing. It never does. But you got it right.*

## Self-Explanation Checks

At each quack, hold yourself to these standards. The duck won't catch you
cheating — but your code will:

| Quack | Ask yourself... |
|-------|----------------|
| **1** | Can I state the intent/reality gap in one sentence? |
| **2** | Did I trace every line, or did I skip "obvious" parts? |
| **2** | At function calls — did I trace into them or assume? |
| **2** | At variables — did I state actual values or guessed values? |
| **3** | Is this the root cause, or am I describing a symptom? |
| **3** | Can I explain the root cause to someone who's never seen this code? |
| **4** | Could someone implement my fix from just my English description? |
| **4** | Does my fix address the quack point directly? |
| **5** | At the quack point — does X genuinely equal Y now? |
| **5** | Would reverting my fix bring the original bug back? |

## Anti-Patterns the Duck Silently Judges You For

The duck doesn't say anything. But if you do any of these, the duck
session is invalid and you must start over:

| You did this... | Why it's not rubber ducking |
|-----------------|---------------------------|
| Jumped to a fix without Quacks 1-3 | You guessed instead of explaining |
| Said "let me try X and see if it works" | Trial-and-error is not understanding |
| Said "tests pass, shipping it" without walkthrough | Coincidental correctness is not confidence |
| Said "this part's too complex to explain" | If you can't explain it, you can't fix it safely |
| Said "I've seen this before, it's always X" | Past patterns don't prove present root cause |
| Fixed the symptom instead of the root cause | The duck heard you skip the quack point |
| Said "quick fix now, proper fix later" | Later never comes. The duck knows this. |
| Pushed code you couldn't explain to the duck | The one rule. You broke the one rule. |

## Integration with Other Skills

- **After `systematic-debugging`** → Rubber-duck your fix before pushing
- **After `test-driven-development`** → Explain your test rationale to the duck
- **Before `verification-before-completion`** → Duck walkthrough is a pre-verification gate
- **With `requesting-code-review`** → Your duck explanation becomes your PR description

## Output Format

When using this skill, structure your response as a rubber duck session.
This is YOUR explanation TO the duck — the duck's contribution is silence:

```
🦆 RUBBER DUCK SESSION
━━━━━━━━━━━━━━━━━━━━━━

📋 THE PROBLEM (Quack 1)
  "Duck, here's what's going on..."
  Expected: [what code should do]
  Actual:   [what code does instead]
  Evidence: [how I know]

🔍 CODE WALKTHROUGH (Quack 2)
  "Let me walk you through this, line by line..."
  [line-by-line trace: "supposed to do X" → "actually does Y"]

💡 THE QUACK POINT (Quack 3)
  "Wait — I just said... but that's not right."
  Discrepancy: [where X ≠ Y]
  False assumption: [what I got wrong and why]
  Root cause: [the real issue]

🔧 THE FIX (Quack 4)
  "Here's what I'm going to change, duck..."
  Change: [plain English description]
  Why it works: [connects to root cause]
  Side effects: [what else is affected]
  Not changing: [what's safe to leave alone]

✅ VERIFICATION (Quack 5)
  "Let me walk through it again with the fix..."
  [Re-traced code path — X = Y now at quack point]
  Tests: [pass/fail status]
  Confidence: [level + reason]

🦆 QUACK! (approved to push)
━━━━━━━━━━━━━━━━━━━━━━
```

## Why This Works

Rubber duck debugging exploits five cognitive phenomena:

| Mechanism | What happens |
|-----------|-------------|
| **Self-explanation effect** | Generating explanations reveals gaps that passive thinking hides (Chi et al.) |
| **Cognitive offloading** | Externalizing your logic frees working memory for insight |
| **Psychological distance** | Explaining to an "other" — even an inanimate one — shifts you from recognition mode to generation mode |
| **Metacognition** | Verbalizing activates thinking-about-your-thinking, exposing hidden assumptions |
| **No interruption** | Unlike a human, the duck never derails your train of thought with premature suggestions |

The duck doesn't need to be smart. The duck doesn't need to respond.
The act of **thorough, committed self-explanation to a silent audience**
is what catches bugs. This is why Jeff Atwood observed that Stack Overflow
users solve their own problems while *writing* the question — before anyone
answers. The explanation IS the debugging.

For AI code agents specifically:
- Prevents "confident but wrong" fixes that pass tests accidentally
- Forces the agent to generate a complete explanation rather than pattern-match
- Creates an auditable trail showing the agent understood what it changed
- The silent duck can't be gamed — the agent either explained or it didn't
- Catches the gap between "this looks right" and "I can prove this is right"

## References

- Hunt, Andrew; Thomas, David (1999). *The Pragmatic Programmer*. Addison Wesley. p. 95.
- Atwood, Jeff (2012). "Rubber Duck Problem Solving." codinghorror.com.
- rubberduckdebugging.com — "The rubber duck debugging method."
- Wikipedia: "Rubber duck debugging" — overview and cognitive science references.
- Byrd et al. (2023). "Tell Us What You Really Think: A Think Aloud Protocol
  Analysis." *Journal of Intelligence*, 11(4):76.

## Quick Reference

| Quack | You explain to the duck... | The duck does... |
|-------|---------------------------|-----------------|
| 🦆 1 | What's wrong — intent vs reality | Nothing |
| 🦆 2 | The code, line by line | Nothing |
| 🦆 3 | The moment your explanation broke | Nothing |
| 🦆 4 | What you'll fix and why | Nothing |
| 🦆 5 | That the fix works, re-traced | Nothing |

The duck never talks. That's the whole point.
