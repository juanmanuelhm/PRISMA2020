library(shiny)
library(rsvg)


#' Plot interactive flow charts for systematic reviews
#' 
#' @description Produces a PRISMA2020 style flow chart for systematic reviews, 
#' with the option to add interactivity through tooltips (mouseover popups) and 
#' hyperlink URLs to each box. Data can be imported from the standard CSV template 
#' provided.
#' @param data List of data inputs including numbers of studies, box text, tooltips 
#' and urls for hyperlinks. Data inputted via the `read_PRISMAdata()` function. If 
#' inputting individually, see the necessary parameters listed in the 
#' `read_PRISMAdata()` function and combine them in a list using `data <- list()`.
#' @param interactive Logical argument TRUE or FALSE whether to plot interactivity 
#' (tooltips and hyperlinked boxes).
#' @param previous Logical argument (TRUE or FALSE) specifying whether previous 
#' studies were sought.
#' @param other Logical argument (TRUE or FALSE) specifying whether other studies 
#' were sought.
#' @param font The font for text in each box. The default is 'Helvetica'.
#' @param title_colour The colour for the upper middle title box (new studies). 
#' The default is 'Goldenrod1'. See DiagrammeR colour scheme 
#' <http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html#colors>.
#' @param greybox_colour The colour for the left and right column boxes. The 
#' default is 'Gainsboro'. See DiagrammeR colour scheme 
#' <http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html#colors>.
#' @param main_colour The colour for the main box borders. The default is 
#' 'Black'. See DiagrammeR colour scheme 
#' <http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html#colors>.
#' @param arrow_colour The colour for the connecting lines. The default
#' is 'Black'. See DiagrammeR colour scheme 
#' <http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html#colors>.
#' @param arrow_head The head shape for the line connectors. The default is 
#' 'normal'. See DiagrammeR arrow shape specification 
#' <http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html#arrow-shapes>.
#' @param arrow_tail The tail shape for the line connectors. The default is 
#' 'none'. See DiagrammeR arrow shape specification 
#' <http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html#arrow-shapes>.
#' @return A flow chart plot.
#' @examples 
#' \dontrun{
#' data <- read.csv(file.choose());
#' data <- read_PRISMAdata(data);
#' attach(data); 
#' plot <- PRISMA_flowchart(data,
#'                 interactive = TRUE,
#'                 previous = TRUE,
#'                 other = TRUE);
#' plot
#' }
#' @export
PRISMA_flowchart <- function (data,
                              interactive = FALSE,
                              previous = TRUE,
                              other = TRUE,
                              font = 'Helvetica',
                              title_colour = 'Goldenrod1',
                              greybox_colour = 'Gainsboro',
                              main_colour = 'Black',
                              arrow_colour = 'Black',
                              arrow_head = 'normal',
                              arrow_tail = 'none') {
  
  if(previous == TRUE){
    xstart <- 0
    ystart <- 0
    A <- paste0("A [label = '', pos='",xstart+0.5,",",ystart+0,"!', tooltip = '']")
    Aedge <- paste0("subgraph cluster0 {
                  edge [color = White, 
                      arrowhead = none, 
                      arrowtail = none]
                  1->2;
                  edge [color = ", arrow_colour, ", 
                      arrowhead = none, 
                      arrowtail = ", arrow_tail, "]
                  2->A; 
                  edge [color = ", arrow_colour, ", 
                      arrowhead = ", arrow_head, ", 
                      arrowtail = none,
                      constraint = FALSE]
                  A->19;
                }")
    bottomedge <- paste0("edge [color = ", arrow_colour, ", 
  arrowhead = ", arrow_head, ", 
  arrowtail = ", arrow_tail, "]
              12->19;\n")
    h_adj1 <- 0
    h_adj2 <- 0
    previous_nodes <- paste0("node [shape = box,
          fontname = ", font, ",
          color = ", greybox_colour, "]
    1 [label = '", previous_text, "', style = 'rounded,filled', width = 3, height = 0.5, pos='",xstart+0.5,",",ystart+9,"!', tooltip = '", tooltips[1], "']
    
    node [shape = box,
          fontname = ", font, ",
          color = ", greybox_colour, "]
    2 [label = '",paste0(stringr::str_wrap(paste0(previous_studies_text,
                                                  " (n = ",
                                                  previous_studies, 
                                                  ")"), 
                                           width = 33),
                         "\n\n",
                         paste0(stringr::str_wrap(previous_reports_text, 
                                                  width = 33),
                                "\n(n = ",
                                previous_reports,
                                ')')), 
                         "', style = 'filled', width = 3, height = 0.5, pos='",xstart+0.5,",",ystart+7.5,"!', tooltip = '", tooltips[2], "']")
    finalnode <- paste0("
  node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  19 [label = '",paste0(stringr::str_wrap(paste0(total_studies_text,
                                                 " (n = ",
                                                 total_studies, 
                                                 ")"), 
                                          width = 33),
                        "\n",
                        stringr::str_wrap(paste0(total_reports_text,
                                                 " (n = ",
                                                 total_reports,
                                                 ')'), 
                                          width = 33)),  
                        "', style = 'filled', width = 3, height = 0.5, pos='",xstart+4,",",ystart+0,"!', tooltip = '", tooltips[19], "']")
    prev_rank1 <- "{rank = same; A; 19}"
    prevnode1 <- "1; "
    prevnode2 <- "2; "
    
  } else {
    xstart <- -3.5
    ystart <- 0
    A <- ""
    Aedge <- ""
    bottomedge <- ""
    previous_nodes <- ""
    finalnode <- ""
    h_adj1 <- 0.63
    h_adj2 <- 1.4
    prev_rank1 <- ""
    prevnode1 <- ""
    prevnode2 <- ""
    
  }
  
  if(other == TRUE){
    B <- paste0("B [label = '', pos='",xstart+11.5,",",ystart+1.5,"!', tooltip = '']")
    cluster2 <- paste0("subgraph cluster2 {
    edge [color = White, 
          arrowhead = none, 
          arrowtail = none]
    13->14;
    edge [color = ", arrow_colour, ", 
        arrowhead = ", arrow_head, ", 
        arrowtail = ", arrow_tail, "]
    14->15; 15->16;
    15->17; 17->18;
    edge [color = ", arrow_colour, ", 
        arrowhead = none, 
        arrowtail = ", arrow_tail, "]
    17->B; 
    edge [color = ", arrow_colour, ", 
        arrowhead = ", arrow_head, ", 
        arrowtail = none,
        constraint = FALSE]
    B->12;
  }")
    othernodes <- paste0("node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  13 [label = '", other_text, "', style = 'rounded,filled', width = 7, height = 0.5, pos='",xstart+13.5,",",ystart+9,"!', tooltip = '", tooltips[5], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  14 [label = '", paste0('Records identified from:\n',
                         website_results_text,
                         " (n = ",
                         website_results,
                         ')\n',
                         organisation_results_text,
                         " (n = ",
                         organisation_results,
                         ')\n',
                         citations_results_text,
                         " (n = ",
                         citations_results,
                         ')'),
                         "', style = 'filled', width = 3, height = 0.5, pos='",xstart+11.5,",",ystart+7.5,"!', tooltip = '", tooltips[6], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  15 [label = '", paste0(other_sought_reports_text,
                         '\n(n = ',
                         other_sought_reports,
                         ')'), "', style = 'filled', width = 3, height = 0.5, pos='",xstart+11.5,",",ystart+4.5,"!', tooltip = '", tooltips[12], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  16 [label = '", paste0(other_notretrieved_reports_text,'\n(n = ',
                         other_notretrieved_reports,
                         ')'), "', style = 'filled', width = 3, height = 0.5, pos='",xstart+15.5,",",ystart+4.5,"!', tooltip = '", tooltips[13], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  17 [label = '", paste0(other_assessed_text,
                         '\n(n = ',
                         other_assessed,
                         ')'),"', style = 'filled', width = 3, height = 0.5, pos='",xstart+11.5,",",ystart+3.5,"!', tooltip = '", tooltips[16], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", greybox_colour, "]
  18 [label = '", paste0(other_excluded_text,
                         paste(paste('\n', 
                                     other_excluded[,1], 
                                     ' (n = ', 
                                     other_excluded[,2], 
                                     ')', 
                                     sep = ''), 
                               collapse = '')), "', style = 'filled', width = 3, height = 0.5, pos='",xstart+15.5,",",ystart+3.5,"!', tooltip = '", tooltips[17], "']\n
                       ")
    extraedges <- "16->18;"
    othernode13 <- "; 13"
    othernode14 <- "; 14"
    othernode1516 <- "; 15; 16"
    othernode1718 <- "; 17; 18"
    othernodeB <- "; B"
    
  } else {
    B <- ""
    cluster2 <- ""
    othernodes <- ""
    extraedges <- ""
    optnodesother <- ""
    othernode13 <- ""
    othernode14 <- ""
    othernode1516 <- ""
    othernode1718 <- ""
    othernodeB <- ""
    
  }
  
  x <- DiagrammeR::grViz(
    paste0("digraph TD {
  
  graph[splines=ortho, layout=neato, tooltip = 'Click the boxes for further information']
  
  node [shape = box]
  identification [color = White, label='', style = 'filled,rounded', pos='",-1.4,",",ystart+7.93,"!', width = 0.4, height = 2.6, tooltip = '", tooltips[20], "'];
  screening [color = White, label='', style = 'filled,rounded', pos='",-1.4,",",ystart+4.5,"!', width = 0.4, height = 3.5, tooltip = '", tooltips[21], "'];
  included [color = White, label='', style = 'filled,rounded', pos='",-1.4,",",h_adj1+0.87,"!', width = 0.4, height = ",2.5-h_adj2,", tooltip = '", tooltips[22], "'];\n
  ",
           previous_nodes,"
  node [shape = box,
        fontname = ", font, ",
        color = ", title_colour, "]
  3 [label = '", newstud_text, "', style = 'rounded,filled', width = 7, height = 0.5, pos='",xstart+6,",",ystart+9,"!', tooltip = '", tooltips[3], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  4 [label = '", paste0('Records identified from:\n', 
                        database_results_text, 
                        ' (n = ',
                        database_results,
                        ')\n', 
                        register_results_text, 
                        ' (n = ',
                        register_results,
                        ')'), "', width = 3, width = 3, height = 0.5, height = 0.5, pos='",xstart+4,",",ystart+7.5,"!', tooltip = '", tooltips[4], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  5 [label = '", paste0('Records removed before\nscreening:\n', 
                        stringr::str_wrap(paste0(duplicates_text,
                                                 ' (n = ',
                                                 duplicates,
                                                 ')'),
                                          width = 32),
                        '\n',
                        stringr::str_wrap(paste0(excluded_automatic_text,
                                                 ' (n = ',
                                                 excluded_automatic,
                                                 ')'),
                                          width = 32)
                        ,'\n', 
                        stringr::str_wrap(paste0(excluded_other_text, 
                                                 ' (n = ',
                                                 excluded_other,
                                                 ')'),
                                          width = 32)),
           "', width = 3, height = 0.5, pos='",xstart+8,",",ystart+7.5,"!', tooltip = '", tooltips[7], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  6 [label = '", paste0(records_screened_text,
                        '\n(n = ',
                        records_screened,
                        ')'), "', width = 3, width = 3, height = 0.5, height = 0.5, pos='",xstart+4,",",ystart+5.5,"!', tooltip = '", tooltips[8], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  7 [label = '", paste0(records_excluded_text,
                        '\n(n = ',
                        records_excluded,
                        ')'), "', width = 3, height = 0.5, pos='",xstart+8,",",ystart+5.5,"!', tooltip = '", tooltips[9], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  8 [label = '", paste0(dbr_sought_reports_text,
                        '\n(n = ',
                        dbr_sought_reports,
                        ')'), "', width = 3, width = 3, height = 0.5, height = 0.5, pos='",xstart+4,",",ystart+4.5,"!', tooltip = '", tooltips[10], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  9 [label = '", paste0(dbr_notretrieved_reports_text,
                        '\n(n = ',
                        dbr_notretrieved_reports,
                        ')'), "', width = 3, height = 0.5, pos='",xstart+8,",",ystart+4.5,"!', tooltip = '", tooltips[11], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  10 [label = '", paste0(dbr_assessed_text,
                         '\n(n = ',
                         dbr_assessed,
                         ')'), "', width = 3, height = 0.5, pos='",xstart+4,",",ystart+3.5,"!', tooltip = '", tooltips[14], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  11 [label = '", paste0(dbr_excluded_text,
                         paste(paste('\n', 
                                     dbr_excluded[,1], 
                                     ' (n = ', 
                                     dbr_excluded[,2], 
                                     ')', 
                                     sep = ''), 
                               collapse = '')), "', width = 3, height = 0.5, pos='",xstart+8,",",ystart+3.5,"!', tooltip = '", tooltips[15], "']
  
  node [shape = box,
        fontname = ", font, ",
        color = ", main_colour, "]
  12 [label = '", paste0(stringr::str_wrap(new_studies_text, width = 33),
                         '\n(n = ',
                         new_studies,
                         ')\n',
                         stringr::str_wrap(new_reports_text, width = 33),
                         '\n(n = ',
                         new_reports,
                         ')'), "', width = 3, height = 0.5, pos='",xstart+4,",",ystart+1.5,"!', tooltip = '", tooltips[18], "']
  
  ",othernodes,
           
           finalnode,"
  
  node [shape = square, width = 0, color=White]\n",
           A,"
  ",B,"
  
  ",
           Aedge,"
  
  subgraph cluster1 {
    edge [style = invis]
    3->4; 3->5;
    
    edge [color = ", arrow_colour, ", 
        arrowhead = ", arrow_head, ", 
        arrowtail = ", arrow_tail, ", 
        style = filled]
    4->5;
    4->6; 6->7;
    6->8; 8->9;
    8->10; 10->11;
    10->12;
    edge [style = invis]
    5->7;
    7->9;
    9->11;
    ",extraedges,"
  }
  
  ",cluster2,"
  
  ",
           bottomedge,"\n\n",
           prev_rank1,"\n",
           "{rank = same; ",prevnode1,"3",othernode13,"} 
  {rank = same; ",prevnode2,"4; 5",othernode14,"} 
  {rank = same; 6; 7} 
  {rank = same; 8; 9",othernode1516,"} 
  {rank = same; 10; 11",othernode1718,"} 
  {rank = same; 12",othernodeB,"} 
  
  }
  ")
  )
  
  # Append in vertical text on blue bars
  if (paste0(previous,  other) == 'TRUETRUE'){
    insertJS <- function(plot){
      javascript <- htmltools::HTML('
var theDiv = document.getElementById("node1");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'610\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Identification</text>";
var theDiv = document.getElementById("node2");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'365\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Screening</text>";
var theDiv = document.getElementById("node3");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'105\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Included</text>";
                              ')
      htmlwidgets::appendContent(plot, htmlwidgets::onStaticRenderComplete(javascript))
    }
    x <- insertJS(x)
  } else if (paste0(previous,  other) == 'FALSETRUE'){
    insertJS <- function(plot){
      javascript <- htmltools::HTML('
var theDiv = document.getElementById("node1");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'502\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Identification</text>";
var theDiv = document.getElementById("node2");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'257\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Screening</text>";
var theDiv = document.getElementById("node3");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'38\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Included</text>";
                              ')
      htmlwidgets::appendContent(plot, htmlwidgets::onStaticRenderComplete(javascript))
    }
    x <- insertJS(x)
  } else if (paste0(previous,  other) == 'TRUEFALSE'){
    insertJS <- function(plot){
      javascript <- htmltools::HTML('
var theDiv = document.getElementById("node1");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'610\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Identification</text>";
var theDiv = document.getElementById("node2");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'365\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Screening</text>";
var theDiv = document.getElementById("node3");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'105\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Included</text>";
                              ')
      htmlwidgets::appendContent(plot, htmlwidgets::onStaticRenderComplete(javascript))
    }
    x <- insertJS(x)
  } else {
    insertJS <- function(plot){
      javascript <- htmltools::HTML('
var theDiv = document.getElementById("node1");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'502\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Identification</text>";
var theDiv = document.getElementById("node2");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'257\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Screening</text>";
var theDiv = document.getElementById("node3");
theDiv.innerHTML += "<text text-anchor=\'middle\' style=\'transform: rotate(-90deg);\' x=\'38\' y=\'19\' font-family=\'Helvetica,sans-Serif\' font-size=\'14.00\'>Included</text>";
                              ')
      htmlwidgets::appendContent(plot, htmlwidgets::onStaticRenderComplete(javascript))
    }
    x <- insertJS(x)
  }
  
  if (interactive == TRUE) {
    x <- sr_flow_interactive(x, urls, previous = previous, other = other)
  }
  
  return(x)
}


#' Read in PRISMA flow chart data
#' 
#' @description Read in a template CSV containing data for the flow chart.
#' @param data File to read in.
#' @return A list of objects needed to plot the flow chart.
#' @examples 
#' \dontrun{
#' data <- read.csv(file.choose());
#' data <- read_PRISMAdata(data);
#' attach(data);
#' }
#' @export
read_PRISMAdata <- function(data){
  
  #Set parameters
  previous_studies <- data[grep('previous_studies', data[,1]),]$n
  previous_reports <- data[grep('previous_reports', data[,1]),]$n
  register_results <- data[grep('register_results', data[,1]),]$n
  database_results <- data[grep('database_results', data[,1]),]$n
  website_results <- data[grep('website_results', data[,1]),]$n
  organisation_results <- data[grep('organisation_results', data[,1]),]$n
  citations_results <- data[grep('citations_results', data[,1]),]$n
  duplicates <- data[grep('duplicates', data[,1]),]$n
  excluded_automatic <- data[grep('excluded_automatic', data[,1]),]$n
  excluded_other <- data[grep('excluded_other', data[,1]),]$n
  records_screened <- data[grep('records_screened', data[,1]),]$n
  records_excluded <- data[grep('records_excluded', data[,1]),]$n
  dbr_sought_reports <- data[grep('dbr_sought_reports', data[,1]),]$n
  dbr_notretrieved_reports <- data[grep('dbr_notretrieved_reports', data[,1]),]$n
  other_sought_reports <- data[grep('other_sought_reports', data[,1]),]$n
  other_notretrieved_reports <- data[grep('other_notretrieved_reports', data[,1]),]$n
  dbr_assessed <- data[grep('dbr_assessed', data[,1]),]$n
  dbr_excluded <- data.frame(reason = gsub(",.*$", "", unlist(strsplit(data[grep('dbr_excluded', data[,1]),]$n, split = '; '))), 
                             n = gsub(".*,", "", unlist(strsplit(data[grep('dbr_excluded', data[,1]),]$n, split = '; '))))
  other_assessed <- data[grep('other_assessed', data[,1]),]$n
  other_excluded <- data.frame(reason = gsub(",.*$", "", unlist(strsplit(data[grep('other_excluded', data[,1]),]$n, split = '; '))), 
                               n = gsub(".*,", "", unlist(strsplit(data[grep('other_excluded', data[,1]),]$n, split = '; '))))
  new_studies <- data[grep('new_studies', data[,1]),]$n
  new_reports <- data[grep('new_reports', data[,1]),]$n
  total_studies <- data[grep('total_studies', data[,1]),]$n
  total_reports <- data[grep('total_reports', data[,1]),]$n
  tooltips <- stats::na.omit(data$tooltips)
  urls <- data.frame(box = data[!duplicated(data$box), ]$box, url = data[!duplicated(data$box), ]$url)
  
  #set text - if text >33 characters, 
  previous_text <- data[grep('prevstud', data[,3]),]$boxtext
  newstud_text <- data[grep('newstud', data[,3]),]$boxtext
  other_text <- data[grep('othstud', data[,3]),]$boxtext
  previous_studies_text <- data[grep('previous_studies', data[,1]),]$boxtext
  previous_reports_text <- data[grep('previous_reports', data[,1]),]$boxtext
  register_results_text <- data[grep('register_results', data[,1]),]$boxtext
  database_results_text <- data[grep('database_results', data[,1]),]$boxtext
  website_results_text <- data[grep('website_results', data[,1]),]$boxtext
  organisation_results_text <- data[grep('organisation_results', data[,1]),]$boxtext
  citations_results_text <- data[grep('citations_results', data[,1]),]$boxtext
  duplicates_text <- data[grep('duplicates', data[,1]),]$boxtext
  excluded_automatic_text <- data[grep('excluded_automatic', data[,1]),]$boxtext
  excluded_other_text <- data[grep('excluded_other', data[,1]),]$boxtext
  records_screened_text <- data[grep('records_screened', data[,1]),]$boxtext
  records_excluded_text <- data[grep('records_excluded', data[,1]),]$boxtext
  dbr_sought_reports_text <- data[grep('dbr_sought_reports', data[,1]),]$boxtext
  dbr_notretrieved_reports_text <- data[grep('dbr_notretrieved_reports', data[,1]),]$boxtext
  other_sought_reports_text <- data[grep('other_sought_reports', data[,1]),]$boxtext
  other_notretrieved_reports_text <- data[grep('other_notretrieved_reports', data[,1]),]$boxtext
  dbr_assessed_text <- data[grep('dbr_assessed', data[,1]),]$boxtext
  dbr_excluded_text <- data[grep('dbr_excluded', data[,1]),]$boxtext
  other_assessed_text <- data[grep('other_assessed', data[,1]),]$boxtext
  other_excluded_text <- data[grep('other_excluded', data[,1]),]$boxtext
  new_studies_text <- data[grep('new_studies', data[,1]),]$boxtext
  new_reports_text <- data[grep('new_reports', data[,1]),]$boxtext
  total_studies_text <- data[grep('total_studies', data[,1]),]$boxtext
  total_reports_text <- data[grep('total_reports', data[,1]),]$boxtext
  
  x <- list(previous_studies = previous_studies,
            previous_reports = previous_reports,
            register_results = register_results,
            database_results = database_results,
            website_results = website_results,
            organisation_results = organisation_results,
            citations_results = citations_results,
            duplicates = duplicates,
            excluded_automatic = excluded_automatic,
            excluded_other = excluded_other,
            records_screened = records_screened,
            records_excluded = records_excluded,
            dbr_sought_reports = dbr_sought_reports,
            dbr_notretrieved_reports = dbr_notretrieved_reports,
            other_sought_reports = other_sought_reports,
            other_notretrieved_reports = other_notretrieved_reports,
            dbr_assessed = dbr_assessed,
            dbr_excluded = dbr_excluded,
            other_assessed = other_assessed,
            other_excluded = other_excluded,
            new_studies = new_studies,
            new_reports = new_reports,
            total_studies = total_studies,
            total_reports = total_reports,
            previous_text = previous_text,
            newstud_text = newstud_text,
            other_text = other_text,
            previous_studies_text = previous_studies_text,
            previous_reports_text = previous_reports_text,
            register_results_text = register_results_text,
            database_results_text = database_results_text,
            website_results_text = website_results_text,
            organisation_results_text = organisation_results_text,
            citations_results_text = citations_results_text,
            duplicates_text = duplicates_text,
            excluded_automatic_text = excluded_automatic_text,
            excluded_other_text = excluded_other_text,
            records_screened_text = records_screened_text,
            records_excluded_text = records_excluded_text,
            dbr_sought_reports_text = dbr_sought_reports_text,
            dbr_notretrieved_reports_text = dbr_notretrieved_reports_text,
            other_sought_reports_text = other_sought_reports_text,
            other_notretrieved_reports_text = other_notretrieved_reports_text,
            dbr_assessed_text = dbr_assessed_text,
            dbr_excluded_text = dbr_excluded_text,
            other_assessed_text = other_assessed_text,
            other_excluded_text = other_excluded_text,
            new_studies_text = new_studies_text,
            new_reports_text = new_reports_text,
            total_studies_text = total_studies_text,
            total_reports_text = total_reports_text,
            tooltips = tooltips,
            urls = urls)
  
  return(x)
  
}


#' Plot interactive flow charts for systematic reviews
#' 
#' @description Converts a PRISMA systematic review flow chart into an 
#' interactive HTML plot, for embedding links from each box.
#' @param plot A plot object from sr_flow().
#' @param urls A dataframe consisting of two columns: nodes and urls. The first
#' column should contain 19 rows for the nodes from node1 to node19. The second 
#' column should contain a corresponding URL for each node.
#' @return An interactive flow diagram plot.
#' @param previous Logical argument (TRUE or FALSE) (supplied through 
#' PRISMA_flowchart()) specifying whether previous studies were sought.
#' @param other Logical argument (TRUE or FALSE) (supplied through 
#' PRISMA_flowchart()) specifying whether other studies were sought.
#' @examples 
#' \dontrun{
#' urls <- data.frame(
#'     box = c('box1', 'box2', 'box3', 'box4', 'box5', 'box6', 'box7', 'box8', 
#'             'box9', 'box10', 'box11', 'box12', 'box13', 'box14', 'box15', 'box16'), 
#'     url = c('page1.html', 'page2.html', 'page3.html', 'page4.html', 'page5.html', 
#'             'page6.html', 'page7.html', 'page8.html', 'page9.html', 'page10.html', 
#'             'page11.html', 'page12.html', 'page13.html', 'page14.html', 'page15.html', 
#'             'page16.html'));
#' output <- sr_flow_interactive_p1o1(x, urls, previous = TRUE, other = TRUE);
#' output
#' }
#' @export
sr_flow_interactive <- function(plot, 
                                urls,
                                previous,
                                other) {
  
  if(paste0(previous, other) == 'TRUETRUE'){
    link <- data.frame(boxname = c('identification', 'screening', 'included', 'prevstud', 'box1', 'newstud', 'box2', 'box3', 'box4', 'box5', 'box6', 'box7', 
                                   'box8', 'box9', 'box10', 'othstud', 'box11', 'box12', 'box13', 'box14', 'box15', 'box16', 'A', 'B'), 
                       node = paste0('node', seq(1, 24)))
    target <- c('node1', 'node2', 'node3', 'node4', 'node5', 'node23', 'node6', 'node7', 'node8', 'node9', 'node10', 'node11', 'node12', 'node13', 'node14', 
                'node15', 'node22', 'node16', 'node17', 'node18', 'node19', 'node20', 'node21', 'node24')
  } else if(paste0(previous, other) == 'FALSETRUE'){
    link <- data.frame(boxname = c('identification', 'screening', 'included', 'newstud', 'box2', 'box3', 'box4', 'box5', 'box6', 'box7', 
                                   'box8', 'box9', 'box10', 'othstud', 'box11', 'box12', 'box13', 'box14', 'box15', 'B'), 
                       node = paste0('node', seq(1, 20)))
    target <- c('node1', 'node2', 'node3', 'node4', 'node5', 'node6', 'node7', 'node8', 'node9', 'node10', 'node11', 'node12', 'node13', 'node14', 'node15', 
                'node16', 'node17', 'node18', 'node19', 'node20')
  }
  else if(paste0(previous, other) == 'TRUEFALSE'){
    link <- data.frame(boxname = c('identification', 'screening', 'included', 'prevstud', 'box1', 'newstud', 'box2', 'box3', 'box4', 'box5', 'box6', 'box7', 
                                   'box8', 'box9', 'box10', 'box16', 'A'), 
                       node = paste0('node', seq(1, 17)))
    target <- c('node1', 'node2', 'node3', 'node4', 'node5', 'node6', 'node7', 'node8', 'node9', 'node10', 'node11', 'node12', 'node13', 'node14', 'node15', 
                'node16', 'node17')
  }
  else {
    link <- data.frame(boxname = c('identification', 'screening', 'included', 'newstud', 'box2', 'box3', 'box4', 'box5', 'box6', 'box7', 
                                   'box8', 'box9', 'box10'), 
                       node = paste0('node', seq(1, 13)))
    target <- c('node1', 'node2', 'node3', 'node4', 'node5', 'node6', 'node7', 'node8', 'node9', 'node10', 'node11', 'node12', 'node13')
  }
  
  
  link <- merge(link, urls, by.x = 'boxname', by.y = 'box', all.x = TRUE)
  link <- link[match(target, link$node),]
  node <- link$node
  url <- link$url
  
  #the following function produces three lines of JavaScript per node to add a specified hyperlink for the node, pulled in from nodes.csv
  myfun <- function(node, 
                    url){
    t <- paste0('const ', node, ' = document.getElementById("', node, '");
  var link', node, ' = "<a href=\'', url, '\' target=\'_blank\'>" + ', node, '.innerHTML + "</a>";
  ', node, '.innerHTML = link', node, ';
  ')
  }
  #the following code adds the location link for the new window
  javascript <- htmltools::HTML(paste(mapply(myfun, 
                                             node, 
                                             url), 
                                      collapse = '\n'))  
  htmlwidgets::prependContent(plot, 
                              htmlwidgets::onStaticRenderComplete(javascript))
}







prisma_pdf <- function(x, filename = "prisma.pdf") {
    utils::capture.output({
        rsvg::rsvg_pdf(svg = charToRaw(DiagrammeRsvg::export_svg(x)),
                       file = filename)
    })
    invisible()
}
prisma_png <- function(x, filename = "prisma.png") {
    utils::capture.output({
        rsvg::rsvg_png(svg = charToRaw(DiagrammeRsvg::export_svg(x)),
                       file = filename)
    })
    invisible()
}

# Define UI for application that draws a histogram
ui <- shinyUI(navbarPage("PRISMA Flow Chart",

    # Tab 1
    tabPanel("Data upload",
         fluidRow(
            column(10, offset = 1,
                   'Systematic reviews should be described in a high degree of methodological detail. ', tags$a(href="http://prisma-statement.org/", "The PRISMA Statement"), 
                   'calls for a high level of reporting detail in systematic reviews and meta-analyses. An integral part of the methodological description of a review 
                   is a flow diagram/chart.',
                   br(),
                   br(),
                   'This tool allows you to produce a flow chart for your own review that conforms to ', tags$a(href="https://osf.io/preprints/metaarxiv/v7gm2/", "the PRISMA2020 Statement."), 
                   'You can provide the numbers and texts for the boxes in the CSV template below. Upload your own version and select whether to include the "previous" and 
                   "other" studies arms, then proceed to the "Flow chart" tab to see and download your figure.',
                   br(),
                   br(),
                   "At present, this version of the tool doesn't support embedding tooltips and hyperlinks in the plot. For this functionality, please use the", 
                   tags$a(href="https://github.com/nealhaddaway/PRISMA2020", "PRISMA2020 flow chart R package on Github."),
                   br(),
                   br(),
                   'Please let us know if you have any feedback or if you encounter an error by sending an email to ', tags$a(href="mailto:neal.haddaway@sei.org", "neal.haddaway@sei.org"),
                   br(),
                   br(),
                   hr()),
               
            column(12, offset = 1,
                   tags$a(href="https://ndownloader.figshare.com/files/25593458", "Download template CSV file here"),
                   br(),
                   br()),
            
            column(3, offset = 1,
            fileInput("data", "Upload your PRISMA.csv file",
                      multiple = TRUE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")
                      ),
            ),
        fluidRow(
            column(6, offset =1,
            checkboxInput("previous", "Include 'previous' studies", TRUE),
            checkboxInput("other", "Include 'other' searches for studies", TRUE),
            verbatimTextOutput("value")
            )
        )
    ),

        # Show a plot of the generated distribution
        fluidRow(
            column(12, 
            tableOutput("contents")),
            column(10, offset = 1,
            br(),
            hr(),
            'Credits:',
            br(),
            'Neal R Haddaway (creator)', br(),
            'Matthew J Page (advisor)', br(),
            'Luke McGuiness (advisor)', br(),
            'Jack Wasey (advisor)', br(),
            br(),
            tags$a(href="https://github.com/nealhaddaway/PRISMA2020", tags$img(height = 40, width = 40, src = "https://pngimg.com/uploads/github/github_PNG40.png")), 
            'Created November 2020'
            )
        )
    ),
    
    tabPanel("Flow chart",
             shinyjs::useShinyjs(),
             DiagrammeR::grVizOutput(outputId = "plot1", width = "100%", height = "700px"),
             br(),
             br(),
             fluidRow(
                 column(12, offset = 5,
                 downloadButton('PRISMAflowchartPDF', 'Download PDF'),
                 downloadButton('PRISMAflowchartPNG', 'Download PNG')
                 ))
    )
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # Preview uploaded data
    output$contents <- renderTable({
        
        req(input$data)
        
        data <- read.csv(input$data$datapath)
        df <- data[,3:8]
        return(df)
        
    })
    
    # Settings (to be expanded)
    interactive <- renderText({ input$interactive })
    
    #reactive plot
    plot <- reactive({
        req(input$data)
        data <- read.csv(input$data$datapath)
        data <- read_PRISMAdata(data)
        attach(data)
        plot <- PRISMA_flowchart(data,
                                 interactive = FALSE,
                                 previous = input$previous,
                                 other = input$other)
    })
    
    
    # Display the plot
    output$plot1 <- DiagrammeR::renderDiagrammeR({
        plot <- plot()
    })

    output$PRISMAflowchartPDF <- downloadHandler(
        filename = "prisma.pdf",
        content = function(file){
            prisma_pdf(plot(), 
                       file)
            }
        )
    output$PRISMAflowchartPNG <- downloadHandler(
        filename = "prisma.png",
        content = function(file){
            prisma_png(plot(), 
                       file)
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)


