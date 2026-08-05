# One task resource per template step. Rename/duplicate as the real
# lab's tasks are fleshed out — these are 1:1 with the
# <instruqt-task id="task_0N"> markers in instructions/page-template.md
# and the activities map in pages.hcl.
#
# This template has no sandbox infrastructure of its own (see layouts.hcl),
# so there's no `config { target = ... }` block here yet. Once you add a
# sandbox (network/container/vm resources) for the real lab, add:
#   config {
#     target = resource.container.<name>
#   }
# either here at the task level (default for all its conditions) or inside
# an individual `condition` block to override it per-condition.

resource "task" "task_01" {
  description = "[Short summary of what learners must achieve in Task 01]"

  condition "step_completed" {
    description = "[Describe what the learner must configure in Task 01]"

    check {
      script          = "scripts/check_task_01.sh"
      failure_message = "[Message shown if Task 01's check fails]"
    }
  }
}

resource "task" "task_02" {
  description = "[Short summary of what learners must achieve in Task 02]"

  condition "step_completed" {
    description = "[Describe what the learner must run/verify in Task 02]"

    check {
      script          = "scripts/check_task_02.sh"
      failure_message = "[Message shown if Task 02's check fails]"
    }
  }
}

resource "task" "task_03" {
  description = "[Short summary of what learners must achieve in Task 03]"

  condition "step_completed" {
    description = "[Describe what the learner must review/update in Task 03]"

    check {
      script          = "scripts/check_task_03.sh"
      failure_message = "[Message shown if Task 03's check fails]"
    }
  }
}

resource "task" "task_04" {
  description = "[Short summary of what learners must achieve in Task 04]"

  condition "step_completed" {
    description = "[Describe what the learner must remove/finish in Task 04]"

    check {
      script          = "scripts/check_task_04.sh"
      failure_message = "[Message shown if Task 04's check fails]"
    }
  }
}
