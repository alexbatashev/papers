load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def load_dependencies():
    LATEX_COMMIT = "f9e1532513760f1379396e55e9e38013869d2a8c"
    http_archive(
        name = "bazel_latex",
        strip_prefix = "bazel-latex-" + LATEX_COMMIT,
        sha256 = "6be40ba6dfde7e2e2ed2417e467d19e4158214aaad8bc3a9e8f229a0a72bc473",
        urls = ["https://github.com/ProdriveTechnologies/bazel-latex/archive/{commit}.tar.gz".format(commit = LATEX_COMMIT)],
    )

