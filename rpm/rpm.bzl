load(
    "@io_bazel_rules_docker//container:container.bzl",
    _container = "container",
)
load(
    "@io_bazel_rules_docker//container:layer_tools.bzl",
    _get_layers = "get_from_target",
)

def rpm_image(**kwargs):
    _rpms_layer(**kwargs)

def _rpms_impl(ctx, rpms = None):
    rpms = rpms or ctx.files.rpms
    rpm_installer = ctx.executable._rpm_installer
    parent_parts = _get_layers(ctx, ctx.label.name, ctx.attr.base)
    uncompressed_blobs = parent_parts.get("unzipped_layer", [])
    uncompressed_layer_args = ["--uncompressed_layer=" + f.path for f in uncompressed_blobs]
    rpm_args = ["--", rpm_installer.path] + ["--rpm=" + f.path for f in rpms]
    finaltar = ctx.actions.declare_file(ctx.label.name + "-installed-rpms.tar")
    target = "--output=%s" % finaltar.path
    ctx.actions.run(
        executable = 'fakeroot',
        arguments = rpm_args + uncompressed_layer_args + [target],
        inputs = rpms + uncompressed_blobs,
        outputs = [finaltar],
        use_default_shell_env = True,
        progress_message = "Install RPMs inside a container",
        mnemonic = "installrpms",
        tools = [rpm_installer],
    )
    tars = [finaltar]
    if ctx.attr.tars:
        tars = tars + ctx.files.tars
    return _container.image.implementation(ctx, tars = tars)

_rpms_layer = rule(
    attrs = dict(_container.image.attrs.items() + {
        # The dependency whose runfiles we're appending.
        "rpms": attr.label_list(allow_files = True, mandatory = True),
        "_rpm_installer": attr.label(
            default = Label("//rpm:install_rpms"),
            cfg = "host",
            executable = True,
            allow_files = True,
        ),
    }.items()),
    executable = True,
    outputs = _container.image.outputs,
    toolchains = ["@io_bazel_rules_docker//toolchains/docker:toolchain_type"],
    implementation = _rpms_impl,
)
