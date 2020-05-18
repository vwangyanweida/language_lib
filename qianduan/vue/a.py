import os


with open("index.md", "r+") as f:
    lines = [i.strip() for i in f if i.strip()]
    titles = [i.strip() for i in lines if ":" in i]
    ignore_files = list(set(lines) - set(titles)) 

    result = ["# vue索引","\n", "## vue官方文档", "\n"]
    for title in titles:
        toc, md = title.split(":")
        result.append("### " + toc.strip() + "\n")
        result.append("1. 文件: " + md.strip() + "\n\n")

    result.extend(['## vue官方文档不重要模块', "\n"])
    result.extend([str(key) + ". " + i + "\n\n" for key, i in enumerate(ignore_files)])   

    f.seek(0);
    f.writelines(result)
