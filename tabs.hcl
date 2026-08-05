resource "terminal" "shell" {
  target = resource.container.main
  shell  = "/bin/bash"
}

# Uncomment and point at the right port if the lab exposes a web console:
# resource "service" "console" {
#   target = resource.container.main
#   port   = 8080
#   scheme = "http"
# }
