load("@bazel_latex//:latex.bzl", "latex_document")

def define_paper(name, directory, templates, title, authors, packages = []):
    parameters = {
      "title": title,
      "authors": authors,
      "directory": directory,
    }
    string_parameters = json.encode(parameters)

    for tpl in templates:
        native.genrule(
            name = name + "_template_" + tpl,
            outs = [name + "_main_" + tpl + ".tex"],
            srcs = ["_template/" + tpl + "/template.tex", "_script/expand_template.py"],
            cmd = "python _script/expand_template.py --input " + "_template/" + tpl + "/template.tex" + " --output $@ --args '" + string_parameters + "'",
        )

        latex_document(
            name = name + "_" + tpl,
            srcs = native.glob([directory + "/*.tex"]) +
                native.glob(["_template/" + tpl + "/**/*"], exclude=["_template/" + tpl + "/template.tex"]) + 
                [
                    "@bazel_latex//packages:biblatex",
                    "@bazel_latex//packages:amsmath",
                    "@bazel_latex//packages:amssymb",
                    # "@bazel_latex//packages:amsfonts",
                    "@bazel_latex//packages:graphicx",
                    "@bazel_latex//packages:cite",
                    # "@bazel_latex//packages:textcomp",
                    "@bazel_latex//packages:xcolor",
                ],
            bib_tool = "biber",
            format = "pdf",
            main = name + "_main_" + tpl + ".tex",
        )
