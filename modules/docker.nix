{pkgs, ...}: {
  virtualisation.oci-containers.containers = {
    colab = {
      image = "europe-docker.pkg.dev/colab-images/public/cpu-runtime:latest";
      ports = ["127.0.0.1:9000:8080"];
    };
  };
}
