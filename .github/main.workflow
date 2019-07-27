workflow "Build container & push to GitHub Registry" {
  on = "push"
  resolves = ["push container image"]
}

action "authenticate at registry" {
  uses = "actions/docker/login@86ff551d26008267bb89ac11198ba7f1d807b699"
  secrets = ["DOCKER_PASSWORD", "DOCKER_REGISTRY_URL", "DOCKER_USERNAME"]
}

action "build container" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  args = "build -t docker.pkg.github.com/ubergesundheit/actions_test/test_image:master ."
}

action "push container image" {
  uses = "actions/docker/cli@86ff551d26008267bb89ac11198ba7f1d807b699"
  needs = ["authenticate at registry", "build container"]
  args = "push $IMAGE_REF"
}
