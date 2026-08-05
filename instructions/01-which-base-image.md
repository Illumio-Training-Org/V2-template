# Before You Start: Which Base Image?

> [!IMPORTANT]
> This page is for whoever is **building** this lab from the template, not
> for learners. Delete this page (and its entry in `main.hcl`) once your
> sandbox is set up and before publishing to real learners.

`sandbox.hcl` isn't part of this template (see `../README.md`) — you add it
per lab. Two separate decisions: **`container` vs `vm`** (the compute
resource), and **preset vs custom image** (what runs on it). Independent —
either resource can use either kind of image.

---

# 🧩 Decision 1 — `container` vs `vm`

**Default to `container`** — shares the host kernel, starts in seconds, no
cloud billing. Good for anything CLI/API-driven, or a service that just
needs to be *demonstrated*, not enforced at the network level.

**Switch to `vm` when the lab needs:**
- **Real kernel-level enforcement** — a VEN actually writing/enforcing
  iptables/nftables/eBPF rules. Container namespace/capability limits can
  make this subtly wrong. **Confirmed: v1 VEN labs used VMs, not
  containers** — same rule applies in v2.
- A real boot sequence (`systemd` as PID 1, kernel modules, restricted
  sysctls).
- More CPU/memory/disk than a container reasonably gives you, or
  multi-service labs where container isolation would misrepresent the real
  product.

```hcl
resource "container" "main" {
  image { name = "rockylinux:9" }
  network { id = resource.network.main.meta.id }
}

resource "vm" "main" {
  image { name = "ubuntu:24.04" }
  resources {
    cpu    = 2
    memory = 2048
  }
  network { id = resource.network.main.meta.id }
}
```

`vm` takes the **same Docker/OCI-style `image` field as `container`**
(confirmed against the platform, including matching `username`/`password`
fields for private registries) — it's not a way to boot a native cloud VM
image. See Decision 3 below if a lab genuinely needs that.

---

# 🧩 Decision 2 — preset, custom, or custom + setup scripts

Both `container` and `vm` offer the same image choice in the UI: **"Use a
preset"** (Debian, Fedora, Ubuntu, CentOS, Rocky, more) or **"Add a new
public or private image"** (pulled from GCP — Artifact Registry/GCR, not
an arbitrary Docker Hub path). Same `image { name = "..." }` field in HCL
either way, so switching later is cheap.

**Preset** — default choice. No registry to manage, covers any lab where a
generic OS shell is enough and setup can happen live via `startup_script`
or task steps.

**Custom image (build once, reuse everywhere)** — start from a preset,
install/configure what you need, save it as your own image in your
registry, then reference that going forward instead of repeating setup
every run. Worth it when:
- A product needs to already be running at sandbox start (e.g. a
  pre-installed, version-pinned VEN), rather than spending the lab's first
  few minutes on unrelated setup.
- Exact version pinning matters — a preset's tag can move; a saved custom
  image doesn't.
- The same non-standard build gets reused across several labs.

**Custom image + setup scripts on top** — a common hybrid (used this way
for Kubernetes classes in v1): bake the slow/repetitive parts into the
saved image, then use `startup_script` (`vm`) or task setup steps
(`container`) for whatever still needs to vary per-lab or per-run. Good
when the base is stable but final config/state shouldn't be permanently
baked in.

If none of the above apply, a preset is simpler and one less thing to
maintain.

---

# 🧩 Decision 3 — a real native cloud VM image

**Not possible through `container`/`vm`** — confirmed against the full
sandbox resource catalog, neither takes a native GCP Compute Engine image
(e.g. `rocky-linux-cloud/rocky-linux-9-optimized-gcp-v20241009`), only
Docker/OCI-style references. The actual path is the **`terraform`**
resource — your own `.tf` files, run via real `terraform apply`, outputs
available to other Instruqt resources:

```hcl
resource "terraform" "gcp_vm" {
  source  = "./terraform"
  version = "1.9.8"
}
```

`./terraform` is a folder you write yourself, using the real Google
provider's `google_compute_instance` with that image reference. Real GCP
credentials/project, real state, real boot time/cost — only reach for this
when a lab genuinely needs hypervisor-level fidelity a `vm` can't give.

---

**Short version for Illumio content:** enforcement demos need `vm`; CLI/
inspection-only labs can stay on `container`. Reach for a custom (or
custom + scripts) image once a preset stops being enough — usually because
something needs to be pre-installed or version-pinned.

See `../v2-migration-notes.md` for the full evidence trail behind these
claims.
