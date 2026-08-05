# Before You Start: Which Base Image?

> [!IMPORTANT]
> This page is for whoever is **building** this lab from the template, not
> for learners. Delete this page (and its entry in `main.hcl`) once your
> sandbox is set up and before publishing to real learners.

`sandbox.hcl` isn't part of this template (see `../README.md`) — you add it
per lab. When you do, there are **two separate decisions**: `container` vs
`vm` (the compute resource), and **preset vs custom image** (what runs on
it). They're independent — either resource can use either kind of image.

---

# 🧩 Decision 1 — `container` vs `vm`: use `container` unless you hit one of these

**Default to `container`.** It's cheaper to run (shares the host kernel,
no per-lab VM boot/resource overhead) and starts in seconds instead of
tens of seconds to minutes. Use it for:

- Any lab that's just running CLI commands, hitting an API, or editing
  files in a shell.
- Installing and configuring an agent/service in a way that only needs to
  be *demonstrated*, not enforced at the network level.
- Anything where learners interact through a terminal/editor/service tab
  and don't need the sandbox to behave identically to a real production
  host.

**Switch to `vm` when the lab specifically needs one of these:**

- **Real kernel-level enforcement.** Demonstrating a VEN actually writing
  and enforcing iptables/nftables/eBPF rules — container network namespace
  and capability restrictions can make this behave subtly wrong, or
  require extra privileged flags to even approximate a real host.
- **A full boot sequence.** Labs that need real `systemd` as PID 1 (not a
  container-style init substitute), kernel module loading, or sysctls that
  containers restrict.
- **More resources or disks than a container reasonably gives you** — the
  `vm` resource exposes explicit `cpu`/`memory`/`disk`/`startup_script`
  fields a `container` doesn't.
- **Multi-service labs simulating a real host's full software stack**,
  where container isolation between processes would misrepresent how the
  real product behaves.

If none of those apply, stick with `container` — it's the cheaper default,
not a fallback.

---

# 🧩 `container` — lightweight, fast, shares the host kernel

```hcl
resource "container" "main" {
  image {
    name = "rockylinux:9"
  }
  network {
    id = resource.network.main.meta.id
  }
}
```

A container is a Docker/OCI image — a userspace filesystem snapshot, not a
full OS boot. It shares the **host machine's kernel** rather than running
its own.

- Starts in **seconds**.
- No cloud provider or billing involved — runs on Instruqt's own container
  runtime.
- Kernel-level operations (loading kernel modules, some netfilter/iptables
  behaviour, systemd as PID 1, certain sysctls) can behave differently, or
  need extra capabilities, compared to a real machine.

Good for: CLI/API-driven labs, anything that just needs a shell with tools
installed — most labs.

> [!NOTE]
> Confirmed in the "New Container" UI form: the `Image` field is either
> **"Use a preset"** — a curated dropdown (Debian `debian:12`, Fedora
> `fedora:44`, Ubuntu `ubuntu:22.04`, CentOS `centos:8`, Rocky, and more
> below the fold) — or **"Add a new public or private image on GCP"** for
> anything outside that list. So a custom container image is pulled from
> GCP specifically (Artifact Registry/GCR), not an arbitrary Docker Hub
> reference — worth knowing if a lab needs an image that isn't preset.

---

# 🧩 `vm` — heavier, closer to a real machine, same image syntax

```hcl
resource "vm" "main" {
  image {
    name = "ubuntu:24.04"
  }
  resources {
    cpu    = 2
    memory = 2048
  }
  network {
    id = resource.network.main.meta.id
  }
}
```

> [!NOTE]
> Confirmed against `/reference/sandbox/compute/vm/` **and** the "New
> Virtual Machine" UI form: `vm` uses the **same Docker/OCI-style
> `image { name = "..." }` field as `container`**, right down to
> `username`/`password` fields explicitly labelled "Docker registry user/
> password to use for private repositories." It is not a way to boot a
> native cloud provider VM image directly — same preset-or-custom-GCP-image
> pattern as `container` above. What you get over `container` is a
> heavier, more configurable sandbox: explicit `cpu`/`memory` (seen in the
> UI's Resources section), disks, `startup_script`.

Good for: labs that need more resources, disks, or boot-time provisioning
than a plain container gives you.

---

# 🧩 Decision 2 — preset vs custom image: use a preset unless you hit one of these

Both `container` and `vm` offer the same choice in the UI: **"Use a
preset"** (Debian, Fedora, Ubuntu, CentOS, Rocky, and more) or **"Add a new
public or private image"** (pulled from GCP). In HCL this is just which
value goes in `image { name = "..." }` (plus `username`/`password` for a
private custom image) — same field either way, so switching later is
cheap.

**Default to a preset.** No registry auth to manage, already vetted, and
covers almost every "just need a standard Linux shell" case:

- Generic OS version is all the lab cares about (e.g. "a Rocky 9 box," "an
  Ubuntu shell") and standard package managers/repos are enough to install
  whatever's needed at runtime via `startup_script` or task setup steps.
- Nothing proprietary needs to be baked in ahead of time.

**Switch to a custom image when:**

- **A specific product needs to already be installed/configured** at
  sandbox start — e.g. a VEN pre-installed at a pinned version, so the lab
  doesn't spend its first several minutes on setup steps unrelated to what
  it's actually teaching.
- **Exact version pinning matters for reproducibility** beyond what a
  preset's tag gives you (presets can move, e.g. `ubuntu:22.04` today vs.
  whatever `22.04` resolves to later) — build once, reference the same
  custom image everywhere it's needed.
- **The OS/config isn't in the preset list at all** (a specific
  distro/version combo, or a hardened/customer-representative build).
- **The same non-standard setup is reused across many labs** — build the
  custom image once, reference it from every lab's `sandbox.hcl`, instead
  of repeating setup steps/scripts in each one.

If none of those apply, a preset is simpler and one less thing to maintain.

---

# 🧩 A real cloud VM image (e.g. a specific GCP Rocky Linux build)

**Confirmed: not through `container`/`vm`, but possible via the `terraform`
resource.** The full sandbox resource catalog has no dedicated
"native GCP VM" resource — `container` and `vm` are always Docker/OCI-style
image references (preset or GCP-hosted custom), and `google_project` only
provisions a sandboxed GCP *project* (IAM users/service accounts/API
enablement), not compute instances.

What actually gets you a real native cloud image is the separate
**`terraform`** sandbox resource — it runs your own `.tf` files (standard
Terraform, any provider) inside a container and can pass variables in and
capture outputs back out for other Instruqt resources to use:

```hcl
resource "terraform" "gcp_vm" {
  source            = "./terraform"
  version           = "1.9.8"
  working_directory = "/terraform"
  variables = {
    image = "rocky-linux-cloud/rocky-linux-9-optimized-gcp-v20241009"
  }
}
```

`./terraform` here is a folder of ordinary `.tf` files you write yourself,
using the real Google Terraform provider's `google_compute_instance`
resource with that exact image reference — Instruqt just runs
`terraform apply` for you and can wire the result (e.g. an IP address)
into a `terminal`/`service` tab via captured outputs. This is a
meaningfully bigger lift than `container`/`vm` (real GCP credentials/
project, real Terraform state, real boot time/cost) — only reach for it
when a lab specifically needs the real OS/hypervisor-level behaviour a
Docker-style image genuinely can't provide, not as a default.

---

The short version, specific to Illumio content: **any lab demonstrating a
VEN actually enforcing rules needs `vm`; a lab that just installs/inspects/
runs CLI commands against a VEN can stay on the cheaper `container`. And on
top of that, reach for a custom image only once a preset stops being
enough** — e.g. the VEN needs to be pre-installed rather than set up live,
or the same non-standard build gets reused across several labs.

See `../v2-migration-notes.md` for further evidence/updates as this gets
tested against real labs.
