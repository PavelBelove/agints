# Finishing a Development Branch — Full Reference

## Why This Skill Exists

When implementation is complete, the next step is under-specified. Agents default to the "obvious" action (usually merge, sometimes PR), often skipping test verification and cleanup. This produces merged broken code, orphaned worktrees, and accidental discards.

The skill enforces a structured decision point: verify tests → present options → execute exactly what the user chose → clean up correctly.

---

## The 4 Options

### Option 1: Merge locally

Use when: the change is complete, tested, and you want it in the base branch immediately without a PR.

```bash
git checkout <base-branch>
git pull
git merge <feature-branch>
<run tests on merged result>  # MANDATORY: re-verify after merge
git branch -d <feature-branch>
git worktree remove <worktree-path>
```

**Critical:** Always run tests after merge. Merge conflicts can be resolved incorrectly. A passing test suite on the feature branch does not guarantee a passing test suite after merge.

### Option 2: Push and create a PR

Use when: the change needs code review before merging, or you want a record of the change for the team.

```bash
git push -u origin <feature-branch>
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
- <what changed>
- <why it was needed>
- <known limitations>

## Test Plan
- [ ] <how to verify the change works>
- [ ] <edge cases to check>
EOF
)"
```

**Worktree:** Keep the worktree. The PR may need revisions after review.

### Option 3: Keep as-is

Use when: work is not complete or you want to return to it later.

Report: `"Keeping branch <name>. Worktree preserved at <path>."`

Do not clean up the worktree.

### Option 4: Discard

Use when: the approach was wrong, the feature is no longer needed, or you want to start over.

**Always confirm first:**
```
This will permanently delete:
- Branch: <name>
- All commits: <commit list>
- Worktree at: <path>

Type 'discard' to confirm.
```

Wait for the exact word "discard". Do not proceed with partial confirmation or "yes".

```bash
git checkout <base-branch>
git branch -D <feature-branch>
git worktree remove <worktree-path>
```

---

## Worktree Cleanup Reference

| Option | Action | Worktree |
|--------|--------|----------|
| 1. Merge locally | Clean | Remove (`git worktree remove`) |
| 2. Create PR | Keep | Preserve (revisions expected) |
| 3. Keep as-is | Keep | Preserve (return to later) |
| 4. Discard | Delete | Remove after branch deleted |

---

## Anti-Pattern Examples

### Anti-pattern 1: Skip test verification

```
Implementation done. Let me merge to main.
git checkout main && git merge feature/auth
```

**Why it fails:** Tests were not verified before offering the option. Broken tests are now on main.

**Correction:** Always `npm test` (or equivalent) before presenting options. If tests fail, stop and report — don't proceed.

---

### Anti-pattern 2: Auto-cleanup worktree on PR

```
PR created. Cleaning up worktree...
git worktree remove .worktrees/feature-auth
```

**Why it fails:** PR may need revisions after review. The worktree is needed for follow-up commits. Now the user has to re-create it.

**Correction:** Only remove worktree for Options 1 (merge) and 4 (discard). For Options 2 (PR) and 3 (keep), preserve the worktree.

---

### Anti-pattern 3: Discard without confirmation

```
User: "This approach didn't work. Let's start over."
Agent: git branch -D feature/auth  (branch deleted)
```

**Why it fails:** User said "start over" — that doesn't mean "delete all commits immediately." They may want to look at the commits first, or it may have been a momentary frustration.

**Correction:** Always show the full deletion manifest (branch name, commit list, worktree path) and require the user to type the exact word "discard".

---

### Anti-pattern 4: Merge without post-merge test verification

```
Feature tests pass. Merging to main...
git checkout main && git merge feature/db-migration
✓ Merge complete.
```

**Why it fails:** Merge conflicts resolved incorrectly, or main has diverged. Tests on feature branch passing doesn't mean tests on merged main pass.

**Correction:** Run full test suite on the merged result before declaring completion. If tests fail after merge, abort and report.

---

## Integration Context

This skill is the final step in several workflows:

**Subagent-Driven Development** calls this at Step 7 (after all tasks complete and reviewed).

**Executing Plans** calls this at Step 5 (after all batches complete and reviewed).

**Using Git Worktrees** is the complement: that skill creates and sets up the worktree; this skill tears it down (for Options 1 and 4).

**Requesting Code Review** should often run before Option 2 (PR creation), especially in formal workflows.
