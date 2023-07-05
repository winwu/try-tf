terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }

  required_version = "~> 1.5.2"
}

provider "docker" {
  # please see README.md > Troubleshooting > issue 2
  # @TODO how to pass env variable to this line? like: unix:///Users/${USER}/.docker/run/docker.sock
  host = "unix:///Users/win/.docker/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  # localhost:8000 
  ports {
    internal = 80
    external = 8000
  }
}
