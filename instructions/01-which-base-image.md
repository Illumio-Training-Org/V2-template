# Before You Start: Which Base Image?

> [!IMPORTANT]
> This page is for whoever is **building** this lab from the template, not
> for learners. Delete this page (and its entry in `main.hcl`) once your
> sandbox is set up and before publishing to real learners.

`sandbox.hcl` isn't part of this template (see `../README.md`) — you add it
per lab. When you do, the first decision is **`container` vs `vm`**, and
which image to put in it.

---

# 🧩 Decision guide — use `container` unless you hit one of these

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
> Confirmed against `/reference/sandbox/compute/vm/`: `vm` uses the **same
> Docker/OCI-style `image { name = "..." }` field as `container`** — it is
> not, as far as the docs show, a way to boot a native cloud provider VM
> image directly. What you get is a heavier, more configurable sandbox
> (explicit CPU/memory, disks, `startup_script`) than `container`, still
> built from an image reference in the same shape.

Good for: labs that need more resources, disks, or boot-time provisioning
than a plain container gives you.

---

# 🧩 A real cloud VM image (e.g. a specific GCP Rocky Linux build)

> [!IMPORTANT]
> **Unconfirmed.** Whether Instruqt has a distinct path to boot a genuine
> native cloud image — e.g. GCP's own
> `rocky-linux-cloud/rocky-linux-9-optimized-gcp-v20241009` release, with
> its real kernel, GCP guest agent, and full hardware-level VM isolation —
> separate from the `container`/`vm` resources above, was **not found** in
> the docs reviewed for this template. There's a documented
> `google_project` resource for provisioning a sandboxed GCP project, and a
> broader "Cloud Providers (AWS, Azure, Google Cloud)" category mentioned
> elsewhere, but not a confirmed example of referencing a specific native
> image build. If a lab genuinely needs that (see below for why it might),
> check `docs.labs.instruqt.com/reference/sandbox/cloud/google/` directly
> or ask Instruqt support before assuming either `container` or `vm` can
> do it.

---

The short version, specific to Illumio content: **any lab demonstrating a
VEN actually enforcing rules needs `vm`; a lab that just installs/inspects/
runs CLI commands against a VEN can stay on the cheaper `container`.**

See `../v2-migration-notes.md` for further evidence/updates as this gets
tested against real labs.
