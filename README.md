my personal [homepage in geminispace](gemini://laniakea.rodoste.de), along with the scripts to generate it.

## how it all works

The gemtext files (`.gmi`) are all generated from raw content files, plus templates, combined through AWK scripts. The browsable website is being generated in the `./static` directory. Anything outside of that is either template or content (or support material).

### includes

To make this all work I've introduced an `include` tag to gemtext:

```
<= path/to/file
```

Note that this is a left-pointing arrow, in contrast to the right-pointing arrow of a normal gemtext link.

Includes are handled through the AWK scripts. They can be recursive, i.e. one include file may include others. It doesn't matter what file ending is included, all includes are assumed to be raw-text.

**it is important that all files do not have carriage-return line endings or AWK will fail**

**My scripts assume GNU AWK, other AWK variants may not work**

Find the AWK scripts in `./scripts`, they are triggered by the `./build` shell script.

### pages

Every browsable page has a template file (`.tmpl`) under `./pages`. The .tmpl file provides the scaffolding.

Some, more static, pages do include the text content directly and make very little use of includes. 

### partials

To re-use recurring parts of my pages, such as the header ASCII art, menu, and so on, I'm frequently making use of `.partial` files which are included. In essence these are semantically identical to `.tmpl` files. The ending merely indicates that they are not generating a complete browsable page but only a component of it.

### multi-stage builds

Some parts of the website, like the journal, do require multi-stage builds. 

In contrast to more static pages, where the starting point of the gemtext generation is the *template* file, the starting points for multi-stage builds are *articles* which increase in size and all of which re-use the same page template.

On the example of the journal, this is how the gemtext generation works:

1. The articles are stored as `.article` files, in `./journal`. Each file is raw content and doesn't contain any includes.
2. Through `./scripts/journal-entries.awk` we're generating a `.tmpl` file dynamically for each `.article` and then a `.gmi` file from that. The awk script is a bit hardcoded as it directly `print`s out the include commands that build the `.tmpl` -- it would be neater if there was a "meta-template" of sorts.
3. The journal provides an index page with links to all articles. This is generated through `./scripts/journal-index.awk` and is in itself a two-stage build: First, a `.partial` file is generated under a fixed name, which only contains the gemtext links to all `.gmi` files generated in the previous step. Secondly, the `./journal/index.gmi` is generated from a static template that includes the generated `.partial`.
4. Lastly, I'm providing a direct link to my latest article from the main navigation menu under a fixed URL. This page is updated with the latest content through `./scripts/journal-latest.awk`. The script itself can directly include the content of a given number of articles, ordered by date. The current setting is `articleNum=1` but nothing prevents a reading experience of the latest 5 articles, for example.

The same or similar approaches might be used for other parts of the website. It is tailored to purpose and doesn't follow a generic approach since that would overly complicate the scripts and I simply don't need it.

