package(default_visibility = ["//visibility:public"])

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_image",
)

load(
    "//rpm:rpm.bzl",
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
    rpms = ["@glibc//file", "@ca_certificates//file"],
)

rpm_image(
    name = "image2",
    base = ":image1",
    rpms = ["@ca_certificates//file"],
)

rpm_image(
    name = "image1",
    base = ":files_base",
    rpms = ["@glibc//file"],
)
