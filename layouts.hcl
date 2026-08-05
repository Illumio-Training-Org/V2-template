# Default layout: two 50/50 columns, instructions on the right. The left
# column is empty since this template ships with no sandbox infrastructure
# (see tasks.hcl / README.md). Once you add a sandbox (network/container/vm
# resources), give that left column a tab so it's not blank, e.g.:
#
# resource "layout" "layout_2_columns" {
#   column {
#     width = "50%"
#     tab "terminal" {
#       title  = "Terminal"
#       target = resource.terminal.shell
#       active = true
#     }
#   }
#   column {
#     width = "50%"
#     instructions {
#       title = "Instructions"
#     }
#   }
# }

resource "layout" "layout_2_columns" {
  column {
    width = "50%"
  }

  column {
    instructions {
      title = "Instructions"
    }

    width = "50%"
  }
}
