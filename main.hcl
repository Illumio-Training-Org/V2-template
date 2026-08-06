resource "lab" "main" {
  title       = "READ-ME-FIRST-Template"
  description = "Learn [LAB TOPIC] by performing tasks on [SYSTEM/PLATFORM] and experimenting with [KEY CONCEPTS]."
  layout      = resource.layout.layout_2_columns

  content {
    chapter "start_here" {
      title = "Before You Start"

      page "github_setup" {
        reference = resource.page.github_setup
        layout    = resource.layout.layout_2_columns
      }

      page "which_base_image" {
        reference = resource.page.which_base_image
      }
    }

    chapter "getting_started" {
      title = "[CHAPTER 1 TITLE]"

      page "template_layout_example" {
        reference = resource.page.template_layout_example
        layout    = resource.layout.layout_2_columns
      }
    }
  }

  settings {
    timelimit {
      duration = "60m"
    }
  }
}
