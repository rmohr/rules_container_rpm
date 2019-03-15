load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "aed1c249d4ec8f703edddf35cbe9dfaca0b5f5ea6e4cd9e83e99f3b0d1136c3d",
    strip_prefix = "rules_docker-0.7.0",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.7.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

http_file(
    name = "glibc",
    sha256 = "573ceb6ad74b919b06bddd7684a29ef75bc9f3741e067fac1414e05c0087d0b6",
    urls = ["https://dl.fedoraproject.org/pub/fedora/linux/releases/28/Everything/x86_64/os/Packages/g/glibc-2.27-8.fc28.x86_64.rpm"],
)

http_file(
    name = "ca_certificates",
    sha256 = "dfc3d2bf605fbea7db7f018af53fe0563628f788a40cb1e7f84434606b7b6a12",
    urls = ["https://dl.fedoraproject.org/pub/fedora/linux/releases/28/Everything/x86_64/os/Packages/c/ca-certificates-2018.2.22-3.fc28.noarch.rpm"],
)
