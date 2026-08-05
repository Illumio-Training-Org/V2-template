# Before You Start: GitHub & Publishing

> [!IMPORTANT]
> This page is for whoever is **building** this lab from the template, not
> for learners. Delete this page (and its entry in `main.hcl`) once your
> repo is set up and before publishing to real learners.

Instruqt v2 gives every lab version control, but **which** version control
depends entirely on how you create the lab. There are two valid options —
pick based on where this lab needs to live.

---

# 🧩 Option A — Instruqt's built-in GitHub (quick, self-contained)

Use **Create Lab** in the Instruqt UI (from scratch or from a template
picker).

**1 )** Click **Create Lab**, choose a starting point, give it a title.

**2 )** That's it — Instruqt provisions its own internal version control
automatically. No repository to create, no GitHub App permissions to grant.

> [!NOTE]
> Confirmed by testing: commits made this way show up authored as the
> editing user, and the lab's Project Settings → Version Control panel
> shows Account / Repository / Default branch / Directory all blank — this
> lab isn't backed by any GitHub repo, public or otherwise.

Good for: quick drafts, one-off experiments, anything that doesn't need to
live in `Illumio-Training-Org`.

---

# 🧩 Option B — Public `Illumio-Training-Org` GitHub (for real training content)

Use **Import Lab**, pointing at a repo in the public
[Illumio-Training-Org](https://github.com/orgs/Illumio-Training-Org/repositories).

**1 )** Create a new **empty** repository under `Illumio-Training-Org`.

**2 )** Add this template's files to it (see `../README.md` for the exact
`git init` / `git push` commands, or upload manually via the GitHub UI).

**3 )** In Instruqt, use **Import Lab** — not Create Lab — and select that
repository.

From then on the repo is the lab's real source of truth, kept
bidirectionally synced: `git push` updates the lab, and publishing changes
through the Instruqt UI pushes a real commit back to the same repo
(authored by the `illumiotraining` GitHub App identity).

> [!IMPORTANT]
> A lab created with **Create Lab** can be connected to GitHub afterward
> via Project Settings → Version Control — but only to an **empty**
> repository, and it's an easy step to forget. If you know this lab
> belongs in `Illumio-Training-Org` from the start, Option B's Import Lab
> route is the more reliable path.

---

# 🧩 Pushing updates with git (recommended over manual uploads)

GitHub's **Add file → Upload files** button works, but it only adds/
overwrites files — it never deletes anything, and every upload becomes a
flat "Add files via upload" commit with no real history. For a lab you'll
iterate on repeatedly, set up the git CLI once instead:

**1 )** One-time auth setup:

```bash,run
gh auth login
```

Answer: **GitHub.com** → **HTTPS** → **Yes** (authenticate Git with your
GitHub credentials) → **Login with a web browser**. It prints a one-time
code and a URL — open the URL, enter the code, approve in the browser.

> [!IMPORTANT]
> If `gh auth login` was run non-interactively (e.g. backgrounded) and its
> prompts got skipped, git push may fail with
> `Invalid username or token. Password authentication is not supported`.
> Fix it with:
> ```bash,run
> gh auth setup-git
> ```
> This explicitly wires git's credential helper to gh's stored token —
> confirmed to resolve exactly this error.

**2 )** Every update after that, from inside the lab's local folder:

```bash,run
git add -A
git commit -m "Describe what changed"
git push
```

`git add -A` correctly stages adds, edits, **and deletions** in one go —
no more manually trash-canning stale files in the GitHub UI.

See `../v2-migration-notes.md` for the full evidence behind these claims
(exact error messages, what was tested, and what's still unconfirmed).
