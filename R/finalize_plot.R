

save_plot <- function(plot_grid, width, height, save_filepath) {
  grid::grid.draw(plot_grid)
  #save it
  ggplot2::ggsave(filename = save_filepath,
                  plot = plot_grid,
                  width = (width / 72),
                  height = (height / 72),
                  bg = "#F0F0F0")
}

#Left align text
left_align <- function(plot_name, pieces){
  grob <- ggplot2::ggplotGrob(plot_name)
  n <- length(pieces)
  grob$layout$l[grob$layout$name %in% pieces] <- 2
  return(grob)
}

create_footer <- function(source_name) {
  #Make the footer
  footer <- grid::grobTree(grid::linesGrob(unit(c(.05, .95), "npc"),
                                           unit(1, "npc"),
                                           gp = grid::gpar(col = "#999999",
                                                           lwd = 2,
                                                           lineend = "square")),

                           grid::textGrob(source_name,
                                          just = "left",
                                          x = 1,
                                          hjust = 0,
                                          gp = grid::gpar(fontsize = 12,
                                                          col = "#999999",
                                                          fontfamily = "mono")))
  return(footer)
}

#' Arrange alignment and save FiveThirtyEight ggplot chart
#'
#' Running this function will save your plot with the guidelines similar to
#' those used in in a FiveThirtyEight graphic. It will left align your title,
#' subtitle and source, add the FiveThirtyEight blocks at the bottom left and
#' save it to your specified location.
#' @param plot_name The variable name of the plot you have created that you want
#'   to format and save
#' @param source_name The text you want to come after the text 'SOURCE:' in the
#'   bottom right hand side of your side
#' @param save_filepath Exact filepath that you want the plot to be saved to
#' @param width_pixels Width in pixels that you want to save your chart to -
#'   defaults to 640
#' @param height_pixels Height in pixels that you want to save your chart to -
#'   defaults to 450
#' @return (Invisibly) an updated ggplot object.

#' #' @keywords finalise_plot
#' @examples
#' library(ggplot2)
#' hist <- ggplot(diamonds) + geom_histogram(aes(x = price))
#' finalize_plot(plot_name = hist,
#' source = "The source for my data",
#' save_filepath = "filename_that_my_plot_should_be_saved_to-nc.png",
#' width_pixels = 640,
#' height_pixels = 450
#' )
#'
#' @export
finalize_plot <- function(plot_name,
                          source_name,
                          save_filepath = file.path(Sys.getenv("TMPDIR"), "tmp-nc.png"),
                          width_pixels = 640,
                          height_pixels = 450) {

  footer <- create_footer(source_name)

  #Draw your left-aligned grid
  plot_left_aligned <- left_align(plot_name, c("subtitle", "title", "caption"))
  plot_grid <- ggpubr::ggarrange(plot_left_aligned, footer,
                                 ncol = 1, nrow = 2,
                                 heights = c(1, 0.045 / (height_pixels / 450)))
  ## print(paste("Saving to", save_filepath))
  save_plot(plot_grid, width_pixels, height_pixels, save_filepath)
  ## Return (invisibly) a copy of the graph. Can be assigned to a
  ## variable or silently ignored.
  invisible(plot_grid)
}
