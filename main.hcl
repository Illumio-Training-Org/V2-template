resource "lab" "main" {
  title       = "[LAB TITLE]"
  description = "Learn [LAB TOPIC] by performing tasks on [SYSTEM/PLATFORM] and experimenting with [KEY CONCEPTS]."
  layout      = resource.layout.instructions_only

  content {
    chapter "start_here" {
      title = "Before You Start"

      page "github_setup" {
        reference = resource.page.github_setup
      }

      page "which_base_image" {
        reference = resource.page.which_base_image
      }
    }

    chapter "getting_started" {
      title = "[CHAPTER 1 TITLE]"

      page "template_layout_example" {
        reference = resource.page.template_layout_example
      }
    }

    # Add more chapters/pages as the lab grows, e.g.:
    # chapter "cleanup" {
    #   title = "[CHAPTER 2 TITLE]"
    #
    #   page "next_page" {
    #     reference = resource.page.next_page
    #   }
    # }
  }
}
