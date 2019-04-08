FiveThirtyPlot
--------------

This repo contains the functions of the `fivethirtyplot` package, which
once installed locally, provides helpful functions for creating and
exporting graphics made in ggplot in the style used by the
FiveThirtyEight data team.

This package is an unabashed clone of the BBC New's teams amazing
[`bbplot`](https://github.com/bbc/bbplot) package. I have only barely
tweaked it to the FiveThirtyEight style. Even this README is the same.
Seriously, it's the same package.

Installing fivethirtyplot
-------------------------

`fivethirtyplot` is not on CRAN, so you will have to install it directly
from Github using `devtools`.

If you do not have the `devtools` package installed, you will have to
run the first line in the code below as well.

    # install.packages('devtools')
    devtools::install_github('kiernann/fivethirtyplot')

Using the functions
-------------------

The package has two functions for plots: `style_538()` and
`finalize_plot`.

Detailed examples on how to use the BBC's version of this package to
produce graphics are included in the [BBC R
cookbook](https://bbc.github.io/rcookbook/), as well as a more general
reference manual for working with `ggplot2`.

A basic explanation and summary here:

### `style_538()`

`style_538()`: has no arguments and is added to the ggplot chain after you have
created a plot. What it does is generally makes text size, font and colour, axis
lines, axis text and many other standard chart components into FiveThirtyEight
style, which has discerned by studying the graphics published by FiveThirtyEight
by an outside perspective.

Examples of such style can be found in the article [*The 45 Best Charts
We Made In 2018*](https://53eig.ht/2FwUoJR). Below is an example of a
histogram plot, from which much of this style was initially based.

![movie\_ratings](https://fivethirtyeight.com/wp-content/uploads/2018/02/hickey-imdb250-1.png)

The function is pretty basic and does not change or adapt based on the
type of chart you are making, so in some cases you will need to make
additional `theme` arguments in your ggplot chain if you want to make
any additions or changes to the style, for example to add or remove
gridlines etc. Also note that colours for lines in the case of a line
chart or bars for a bar chart, do not come out of the box from the
`style_538` function, but need to be explicitly set in your other
standard `ggplot` chart functions.

Example of how it is used in a standard workflow:

    library(ggplot2)
    histogram <- 
      ggplot(data = diamonds, mapping = aes(x = price)) +
      geom_histogram(fill = "#ed713a", bins = 10) +
      geom_vline(xintercept = median(diamonds$price), colour = "#222222") +
      style_538()

### `finalize_plot`

`finalize_plot`: will save out your plot with the correct guidelines for
publication for a BBC News graphic. It is made up of functions that will left
align your title, subtitle and source, add the BBC blocks at the bottom right
and save it to your specified location. The function has six arguments, three of
which need to be explicitly set and three that are defaults unless you overwrite
them.

Here are the function arguments:

    function(plot_name,
             source_name,
             save_filepath = file.path(),
             width_pixels = 640,
             height_pixels = 450,
             logo_image_path = file.path(system.file("data", 
                                                     package = 'fivethirtyplot'),
                                         "placeholder.png"))

-   `plot_name`: the variable name that you have called your plot, for
    example for the chart example above `plot_name` would be
    `"histogram"`
-   `source_name`: the source text that you want to appear at the bottom
    right corner of your plot. You will need to type the word
    `"Source:"` before it, so for example
    `source = "Source: ggplot2::diamonds"` would be correct.
-   `save_filepath`: the precise filepath that you want your graphic to
    save to, including the `.png` extension at the end. This does depend
    on your working directory and if you are in a specific R project. An
    example of a relative filepath would be: `/charts/histogram.png`.
-   `width_pixels`: this is set to 640px by default, so only call this
    argument and specify the width you want your chart to be.
-   `height_pixels`: this is set to 450px by default, so only call this
    argument and specify the height you want your chart to be.
-   `logo_image_path`: this argument specifies the path for the
    image/logo in the bottom left corner of the plot. The default is for
    a placeholder PNG file with a background that matches the background
    colour of the plot, so do not specify the argument if you want it to
    appear without a logo. If you want to add your own logo, just
    specify the path to your PNG file. The package has been prepared
    with a wide and thin image in mind.

Example of how the `finalize_plot()` is used in a standard workflow.
This function is called once you have created and finalized your chart
data, titles and added the `style_538()` to it (see above):

    finalize_plot(plot_name = histogram,
                  source = "Source: ggplot2::diamonds",
                  save_filepath = "filename_that_my_plot_should_be_saved_to-nc.png",
                  width_pixels = 640,
                  height_pixels = 550)
