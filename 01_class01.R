## ------------------------------------------------------
## 01_CLASS01.R - R Script for Lecture 01 (GIS course).

# version: 1.0
# Author: Bruno Conte Leite @2023-24
# b.conte@unibo.it

## ------------------------------------------------------


# 1. R BASICS: ENVIRONMENT AND PACKAGES ----

# 1.1. Working directory:

getwd() # learn which is the current working directory
setwd("~/Desktop/")

# 1.2. Basic R elements:

# creating vectors:
1:10
c("a", "b", "c", "abc", "def")
vector <- c("a", "b", "c", "abc", "def")
vector[2]
vector[-2]
vector <- rep(vector, 2)

# creating datasets - data.frame function:
dset <- data.frame(a = 1:10, b = 101:110, words = vector, stringsAsFactors=T)
class(dset)
# be careful with factors in R!
class(dset$words)
as.numeric(dset$words)

dset <- data.frame(a = 1:10, b = 101:110, words = vector, stringsAsFactors=F)
class(dset$words)
as.numeric(dset$words)

dset[1,2]
dset[1, 'b']

dset[,2]
dset[,'b']
dset$b

# Hint: NEVER use the number (for columns/variables)!

# plotting:
plot(dset$a, dset$b)

# appending data:
dset <- rbind(dset, c(3,6, "bruno"))
# the same for cbind (over columns)

# creating lists (sets):
dlist <- list(a = c("a", "b", "c", "abc", "def"), b = dset)
dlist[[1]]
dlist$a

# removing elements from environment:

ls() # list of elements in the environment
rm(dset)
rm(dlist)
rm(list = ls()) # cleaning environment

# character(0) = empty environment!

# 1.3. Working with packages/libraries:

# Example 1: data.table (package for high-dimension, fast
# data computations):

# install library (only once for each computer):
# install.packages('data.table')

# load library (its functions will become available):
library(data.table)

# data.table::year(as.Date('10-01-1959'))
# once the library is loaded, no need of data.table::
year(as.Date('10-01-1959'))

# Datasets library: contains several datasets
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html

datasets::AirPassengers
df.airqual <- data.table(airquality)

# Example of data operations: merging datasets

df.months <- data.table(Month = 1:12, month.text = month.name)

merge.data.table(df.airqual,df.months)

df.merged <- merge.data.table(df.airqual,df.months)

# Example 2: tidyverse library

# This is the most comprehensive, complete library
# of data sciences tools in R:

# https://www.tidyverse.org/

library(dplyr)

# Uses the "pipe" syntax (%>%)
# https://style.tidyverse.org/pipes.html

# Merging:
df.merged <- df.airqual %>% 
  left_join(df.months)

# Tibbles - class of tidyverse data frames:
df.merged <- tibble(df.merged)
df.merged # Better way of visualizing data frames.

# Selecting specific variables:
df.merged %>% 
  select(month.text, Day, Wind)

# Filtering a dataset:
df.merged %>% 
  filter(Month==5)

# Combining operations:
df.merged %>% 
  filter(month.text=='August') %>% 
  select(Month,Day,Ozone)

# There are several data operations (check them
# out: https://dplyr.tidyverse.org/)

# Saving/exporting data:

# Rdata files: optimized storage (wrt disk space):
save(df.merged,file = 'merged_dataset.rdata')

# My advise: always export data in csv with 'tab' separator:
fwrite(x = df.merged,file = 'merged_dataset.csv', sep = '\t')

# if you like Stata files:
library(haven)

# Importantly: Stata does not allow for '.' or other
# symbols in the column names. Replace them with '_':
setnames(df.merged, gsub('\\.', '_',tolower(names(df.merged))))
# Exporting it:
write_dta(data = df.merged, path = 'merged_dataset.dta')

# Example 3: plotting data with ggplot2 (part of tidyverse)
# https://ggplot2.tidyverse.org/index.html

library(ggplot2)

# Bar plot:
p <- ggplot(df.merged) +
  geom_bar(aes(x = month.text))
p
# Histogram:
p <- ggplot(df.merged) +
  geom_histogram(aes(x = Temp))
p
# Importance of aesthetics:
p <- ggplot(df.merged) +
  geom_histogram(aes(x = Temp, fill = month.text))
p
# Scatter plots (point):
ggplot(df.merged) + 
  geom_point(aes(Month,Temp, color = month.text))
# Importance of aesthetics:
ggplot(df.merged) + 
  geom_point(aes(Month,Temp, color = month.text))
# Correlation wind vs. temperature:
ggplot(df.merged) + 
  geom_point(aes(Wind,Temp))
ggplot(df.merged) + 
  geom_point(aes(Wind,Temp,color = month.text))
# Adding a layer (in this case, functional format):
ggplot(df.merged) + 
  geom_point(aes(Wind,Temp)) +
  geom_smooth(aes(Wind,Temp))
# Linear relation:
ggplot(df.merged) + 
  geom_point(aes(Wind,Temp)) +
  geom_smooth(aes(Wind,Temp),method = 'lm')

# For hands-in exercises:
df.ex.1 <- data.table(datasets::CO2)
df.ex.2 <- data.table(datasets::state.x77)


# ----






































































































# 
# 
