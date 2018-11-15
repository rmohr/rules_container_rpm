package(default_visibility = ["//visibility:public"])

load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")
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
    rpms = [
        "@glibc//file",
        "@ca_certificates//file",
    ],
)

rpm_image(
    name = "allinone_no_base",
    rpms = [
        "@glibc//file",
        "@ca_certificates//file",
    ],
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

rpm_image(
    name = "image_with_extra_tar",
    base = ":files_base",
    rpms = ["@glibc//file"],
    tars = [":foo_tar"],
)

pkg_tar(
    name = "foo_tar",
    srcs = ["foo"],
    mode = "0o644",
    package_dir = "/etc/test",
)
