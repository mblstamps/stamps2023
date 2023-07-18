###############################################
#
# Markdown
#
###############################################

## Rmarkdown is a great way to combine R code with text, either to
## share your work with others or to keep notes for yourself.
## Markdown is a lightweight text formatting system. It gives you
## control over some simple things, like headings, bold/italic, and
## links, but the idea is that when you write a markdown document you
## focus on the text and not on the formatting. Markdown documents are
## readable as plain text, and can later be formatted as html.
##
## There is a short tutorial at http://www.markdowntutorial.com/ that
## allows you to go through some examples. You should work through it,
## as it only takes a couple of minutes.
##
## Once you know about markdown, Rmarkdown is a simple extension. It
## allows you to place R code into markdown documents, and the R code
## and markdown text can then be processed with knitr to create an
## html document containing both. Knitr will run the R code, create
## any output or plots described in the code, and create a single html
## document containing everything. Adding R code to a markdown
## document is just a matter of putting
##
## ```{r chunk_name}
##
## before the R code (without the leading ##, and with chunk_name
## replaced with a descriptive name for what the code does), and
## putting
##
## ```
##
## below the R code to indicate the end of a chunk (again, without the
## leading ##).
##
## Rmarkdown (Rmd) documents can be converted to html using the render
## command in rmarkdown package, so if you have a file called
## my_rmarkdown.Rmd it can be converted to html using
## render("my_rmarkdown.Rmd"). If you are using Rstudio, there is a
## button "knit" that will do this for you.
##
##
## Exercise: Make your own Rmd document with some of the code and
## plots from the ggplot lecture. Try modifying the width and
## height of the figures (look at the fig.width and fig.height options
## on this web page: https://yihui.name/knitr/options/).
