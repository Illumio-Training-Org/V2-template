resource "layout" "two_column" {
  column {
    width = "50"

    instructions {
      title  = "Instructions"
      active = true
    }
  }

  column {
    width = "50"

    tab "terminal" {
      title  = "Terminal"
      target = resource.terminal.shell
      active = true
    }

    # Uncomment if the lab exposes a web UI/service to view in-browser:
    # tab "console" {
    #   title  = "[SYSTEM/PLATFORM] Console"
    #   target = resource.service.console
    # }
  }
}
