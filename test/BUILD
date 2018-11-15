load("@io_bazel_rules_docker//contrib:test.bzl", "container_test")

container_test(
    name = "image1_test",
    configs = ["configs/image1.yaml"],
    image = "//testdata:image1",
)

container_test(
    name = "image2_test",
    configs = ["configs/image2.yaml"],
    image = "//testdata:image2",
)

container_test(
    name = "allinone_test",
    configs = ["configs/allinone.yaml"],
    image = "//testdata:allinone",
)

container_test(
    name = "allinone_no_base_test",
    configs = ["configs/allinone.yaml"],
    image = "//testdata:allinone_no_base",
)
