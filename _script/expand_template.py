import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str)
parser.add_argument('--output', type=str)
parser.add_argument('--args', type=str)

args = parser.parse_args()

with open(args.input, 'r') as f:
    string = f.read()

    substitutions = json.loads(args.args)

    authors = "\\author{"

    for author in substitutions["authors"]:
        authors += "\\PaperAuthorBlockN{" + author["name"] + "}\n"
        authors += "\\PaperAuthorBlockA{\\textit{" + author["affiliation"] + "}\\\\\n"
        authors += author["city"] + ", " + author["country"] + " \\\\\n"
        authors += author["email"] + "}"

    authors += "}"

    string = string.replace("%%TITLE%%", substitutions["title"])

    if "thankyou" in substitutions:
        thankyou = substitutions["thankyou"]
    else:
        thankyou = ""

    string = string.replace("%%THANKYOU%%", thankyou)

    string = string.replace("%%AUTHORS%%", authors)

    string = string.replace("%%DIRNAME%%", substitutions["directory"])

    if len(substitutions["class_options"]) > 0:
        string = string.replace("%%CLASSOPTS%%", "[" + ",".join(substitutions["class_options"]) + "]")
    else:
        string = string.replace("%%CLASSOPTS%%", "")

    out = open(args.output, 'w')
    out.write(string)
    out.close()
