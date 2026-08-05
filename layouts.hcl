resource "layout" "instructions_only" {
  column {
    width = "100"

    instructions {
      title  = "Instructions"
      active = true
    }
  }
}

# This template ships with an instructions-only layout since it has no
# sandbox infrastructure defined (see tasks.hcl). Once you add a sandbox
# (network/container/vm resources — not part of this starting-point
# template) and want a terminal, editor, or service visible alongside the
# instructions, add a second column here, e.g.:
#
# resource "layout" "two_column" {
#   column {
#     width = "50"
#     instructions {
#       title  = "Instructions"
#       active = true
#     }
#   }
#   column {
#     width = "50"
#     tab "terminal" {
#       title  = "Terminal"
#       target = resource.terminal.shell
#       active = true
#     }
#   }
# }
#
# and update main.hcl's `layout = resource.layout.instructions_only` to
# point at the new layout resource.
