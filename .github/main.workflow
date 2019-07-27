workflow "Build container & push to GitHub Registry" {
  on = "push"
  resolves = ["Push image"]
}

action "Docker Registry" {
  uses = "actions/docker/login@86ff551d26008267bb89ac11198ba7f1d807b699"
  secrets = ["DOCKER_PASSWORD", "DOCKER_REGISTRY_URL", "DOCKER_USERNAME"]
}

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["Docker Registry"]
  args = "build -t test_image ."
}

action "Docker Tag" {
  uses = "actions/docker/tag@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["GitHub Action for Docker"]
  args = "--env --no-latest --no-sha test_image docker.pkg.github.com/ubergesundheit/actions_test/test_image"
}

action "Push image" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["Docker Tag"]
  args = "push $IMAGE_REF"
}
