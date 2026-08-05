# v2template — v2 lab starter

A v2 replacement for `oldtemplate/assignment.md`, carrying over its authoring
style (numbered tasks, bracketed placeholders, NOTE/IMPORTANT callouts,
runnable command block) into Instruqt Labs 2.0's lab/chapter/page/task model.
See `../v2-migration-notes.md` for the full v1 → v2 rationale.

**This template is a formatting/content starting point only — it has no
sandbox infrastructure.** There's no `sandbox.hcl`/`tabs.hcl` and no
`config.target` on the tasks. Add those yourself once a real lab needs a
container/VM to run checks against; see the comments in `layouts.hcl` and
`tasks.hcl` for exactly where they plug in.

## Files

| File | Purpose |
|---|---|
| `main.hcl` | Lab metadata + chapter/page content tree |
| `layouts.hcl` | UI layout — instructions-only by default; comments show how to add a terminal/tab column once you have a sandbox |
| `pages.hcl` | Page resources → markdown files, activities map |
| `tasks.hcl` | One `task` resource per template step, each with a `condition`/`check` |
| `instructions/00-github-setup.md` | First page in the lab: Create Lab vs Import Lab, and which to use for `Illumio-Training-Org` content. **Delete before publishing to real learners.** |
| `instructions/01-which-base-image.md` | Second page in the lab: `container` vs `vm`, image syntax, and why real enforcement demos need `vm`. **Delete before publishing to real learners.** |
| `instructions/page-template.md` | The learner-facing markdown content |
| `scripts/check_task_0N.sh` | Validation script per task (exit 0 = pass) |
| `assets/` | Images referenced from `instructions/*.md` |
| `notes/` | Supplementary note-tab content, if used |

## Filling in the template

1. Replace every `[BRACKETED_PLACEHOLDER]` across `main.hcl`, `tasks.hcl`,
   and `instructions/page-template.md` with real content.
2. Add/remove `task_0N` resources in `tasks.hcl`, matching keys in
   `pages.hcl`'s `activities` map and `<instruqt-task id="task_0N">` markers
   in the markdown — these three must stay in sync.
3. Implement the real logic in each `scripts/check_task_0N.sh` (replace the
   `exit 1` stub) and keep them executable (`chmod +x`).
4. Add chapters/pages in `main.hcl` as the lab grows past one page —
   duplicate the `pages.hcl` + `instructions/*.md` + `tasks.hcl` pattern per
   new page rather than overloading a single page.
5. When the lab needs real infrastructure: add `sandbox.hcl`
   (`network`/`container`/`vm` resources — see
   `docs.labs.instruqt.com/reference/sandbox/`), wire `config.target` into
   `tasks.hcl`, and expand `layouts.hcl` per its inline example to expose a
   terminal/service/editor tab alongside the instructions.

## Validating and publishing

```bash
instruqt lab validate
```

checks for syntax errors, missing references, and broken resource
connections. **There is no separate publish/push CLI command in v2** —
`instruqt lab push` / the old `instruqt track push` don't exist. Getting
this folder into Instruqt as live v2 content is a git-native, two-part
process:

1. **One-time setup**: push this folder to a repo under the existing public
   [Illumio-Training-Org](https://github.com/orgs/Illumio-Training-Org/repositories)
   GitHub org (same org as v1), then in the Instruqt v2 web UI use
   **Import Lab** (or the "Connect repository" prompt on an existing lab)
   to link that repo. The Instruqt GitHub App needs access to the repo —
   an org admin may need to grant that once.
2. **Every push after that syncs automatically** — plain `git push`, no
   extra CLI or UI step.

**Recommended: use the git CLI, not manual browser uploads**, once a lab
will see repeated iterations — GitHub's Upload Files button never deletes
stale files and produces flat, unhelpful commits. One-time auth setup:

```bash
gh auth login   # GitHub.com → HTTPS → Yes → Login with a web browser
gh auth setup-git   # only needed if push later fails with
                     # "Invalid username or token" — wires git's
                     # credential helper to gh's stored token
```

Then, from inside this folder:

```bash
git init
git branch -m main
git remote add origin https://github.com/Illumio-Training-Org/REPO_NAME.git
git add .
git commit -m "Initial lab structure from v2template"
git push -u origin main
# then: Import Lab in the v2 UI, select this repo, once
```

Every update after that first push is just:

```bash
git add -A
git commit -m "Describe what changed"
git push
```

`git add -A` correctly stages adds, edits, *and* deletions in one commit —
solving the exact "old files left behind" problem manual uploads have.

v2's built-in internal version control (branches, tags, history) runs
underneath this automatically too — nothing extra to configure for that.

Known restrictions: only GitHub is supported as an external VCS; a lab
created through the UI can't be connected to a remote repo that already has
files in it; and only labs using `/` as their Lab directory can later be
disconnected from version control. See `../v2-migration-notes.md` for
details.
