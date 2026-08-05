resource "layout" "two_column" {
  column {
    width = "50"

    tab {
      title = "Instructions"
      type  = "instructions"
    }
  }

  column {
    width = "50"

    tab {
      title    = "Terminal"
      terminal = resource.terminal.shell.meta.id
    }

    # Uncomment if the lab exposes a web UI/service to view in-browser:
    # tab {
    #   title   = "[SYSTEM/PLATFORM] Console"
    #   service = resource.service.console.meta.id
    # }
  }
}
