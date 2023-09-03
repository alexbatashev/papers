load("//bazel:dependencies.bzl", "load_latex_repositories")
def _latex_repositories_impl(_ctx):
    load_latex_repositories()

latex_repositories = module_extension(
    implementation = _latex_repositories_impl,
)

