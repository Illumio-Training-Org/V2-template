resource "network" "main" {
  subnet = "10.0.200.0/24"
}

# Placeholder compute target for the lab's console/CLI steps.
# Swap the image (or replace with a "vm" resource) for the actual
# [SYSTEM/PLATFORM] this lab is built around.
resource "container" "main" {
  image {
    name = "[PLATFORM_IMAGE:TAG]"
  }

  network {
    id = resource.network.main.meta.id
  }
}
