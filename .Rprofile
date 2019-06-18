# setwd('~/projects/R')

local({r <- getOption("repos")
      r["CRAN"] <- "https://cran.stat.auckland.ac.nz"
      options(repos=r)})


.First <- function(){
  if(interactive()){
    options(editor="vim")
    options(width="170")
    #library(tidyverse)
    #library(lubridate)
    Sys.setenv(TZ="Pacific/Auckland")
    Sys.setenv("DISPLAY" = "")
    message("--------------------")
    message("Using LOCAL Rprofile")
    message("--------------------")
    message("Loaded profile - your width is 170, you are in the Pacific and you have no DISPLAY")
    message("source('~/projects/R/ll.R')")
    message(Sys.getenv("JAVA_HOME"))
    # message(.Library)
  }
}

qs <- function(save="no") {
  savehistory()
  q(save=save)
}

.Last <- function(){
  if(interactive()){
    savehistory()
  }
}
