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
    sha256 = "29d109605e0d6f9c892584f07275b8c9260803bf0c6fcb7de2623b2bedc910bd",
    strip_prefix = "rules_docker-0.5.1",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.5.1.tar.gz"],
)

load(
    "@io_bazel_rules_docker//container:container.bzl",
    container_repositories = "repositories",
)
container_repositories()

http_archive(
    name = "io_bazel_rules_container_rpm",
    sha256 = "d0a166040a5795acd3b04a557c8996f0abf5f9ede60a85aafa1a068e278b41a2",
    strip_prefix = "rules_container_rpm-0.0.2",
    urls = ["https://github.com/rmohr/rules_container_rpm/archive/v0.0.2.tar.gz"],
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
