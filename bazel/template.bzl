load("@bazel_latex//:latex.bzl", "latex_document")

def define_paper(name, directory, templates, title, authors, class_options = {}):

    for tpl in templates:
        class_opts = []

        if tpl in class_options:
            class_opts = class_options[tpl]

        parameters = {
          "title": title,
          "authors": authors,
          "directory": directory,
          "class_options": class_opts
        }
        
        string_parameters = json.encode(parameters)

        parameters_draft = {
          "title": title,
          "authors": authors,
          "directory": directory,
          "class_options": class_opts + ["draft"]
        }
        
        string_parameters_draft = json.encode(parameters_draft)

        native.genrule(
            name = name + "_template_" + tpl,
            outs = [name + "_main_" + tpl + ".tex"],
            srcs = ["_template/" + tpl + "/template.tex", "_script/expand_template.py"],
            cmd = "python _script/expand_template.py --input " + "_template/" + tpl + "/template.tex" + " --output $@ --args '" + string_parameters + "'",
        )

        native.genrule(
            name = name + "_template_" + tpl + "_draft",
            outs = [name + "_main_" + tpl + "_draft" + ".tex"],
            srcs = ["_template/" + tpl + "/template.tex", "_script/expand_template.py"],
            cmd = "python _script/expand_template.py --input " + "_template/" + tpl + "/template.tex" + " --output $@ --args '" + string_parameters_draft + "'",
        )

        srcs = []

        srcs += native.glob([directory + "/*.tex", directory + "/*.pdf"])
        srcs += native.glob(["_template/" + tpl + "/**/*"], exclude=["_template/" + tpl + "/template.tex"])
        srcs += [
            "@//:_template/common.sty",
            "@bazel_latex//packages:biblatex",
            "@bazel_latex//packages:amsmath",
            "@bazel_latex//packages:amssymb",
            "@bazel_latex//packages:graphicx",
            "@bazel_latex//packages:algorithm2e",
            "@bazel_latex//packages:xcolor",
            "@bazel_latex//packages:fontspec",
            "@bazel_latex//packages:listings",
            "@bazel_latex//packages:tikz",
            "@//:references.bib",
        ]

        latex_document(
            name = name + "_" + tpl,
            srcs = srcs,
            bib_tool = "biber",
            format = "pdf",
            main = name + "_main_" + tpl + ".tex",
        )

        latex_document(
            name = name + "_" + tpl + "_draft",
            srcs = srcs,
            bib_tool = "biber",
            format = "pdf",
            main = name + "_main_" + tpl + "_draft" + ".tex",
        )
