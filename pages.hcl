resource "page" "template_layout_example" {
  title = "Template layout example"
  file  = "instructions/page-template.md"

  activities = {
    task_01 = resource.task.task_01
    task_02 = resource.task.task_02
    task_03 = resource.task.task_03
    task_04 = resource.task.task_04
  }
}
