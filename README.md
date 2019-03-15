# rules_container_rpm

[![Build Status](https://travis-ci.org/rmohr/rules_container_rpm.svg?branch=master)](https://travis-ci.org/rmohr/rules_container_rpm)

Bazel rules to install and manage rpms inside of containers.

These rules can be used to install RPM packages into a cointainer and update its included RPM database without the need to run the container.
This allows building small and reproducible images with RPMs. Because the rpm database inside the container is also maintained, it can later be queried by any rpm binary to check what packages are installed.

## Load it into your WORKSPACE

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

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

http_archive(
    name = "io_bazel_rules_container_rpm",
    sha256 = "151261f1b81649de6e36f027c945722bff31176f1340682679cade2839e4b1e1",
    strip_prefix = "rules_container_rpm-0.0.5",
    urls = ["https://github.com/rmohr/rules_container_rpm/archive/v0.0.5.tar.gz"],
)

# Let's define the glibc rpm for reference in a rpm_image rule
http_file(
   name = "glibc",
   url = "https://dl.fedoraproject.org/pub/fedora/linux/releases/28/Everything/x86_64/os/Packages/g/glibc-2.27-8.fc28.x86_64.rpm",
   sha256 = "573ceb6ad74b919b06bddd7684a29ef75bc9f3741e067fac1414e05c0087d0b6"
)
```

## Use it in your BUILD file


```python
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_image",
)

load(
    "@io_bazel_rules_container_rpm//rpm:rpm.bzl",
    "rpm_image",
)

container_image(
    name = "files_base",
    files = ["foo"],
    mode = "0o644",
)

rpm_image(
    name = "allinone",
    base = ":files_base",
    rpms = ["@glibc//file"],
)
```
