resource "lab" "main" {
  title       = "[LAB TITLE]"
  description = "Learn [LAB TOPIC] by performing tasks on [SYSTEM/PLATFORM] and experimenting with [KEY CONCEPTS]."
  layout      = resource.layout.layout_2_columns

  content {
    chapter "start_here" {
      title = "Before You Start"

      page "github_setup" {
        reference = resource.page.github_setup
        layout    = resource.layout.layout_2_columns
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
}
