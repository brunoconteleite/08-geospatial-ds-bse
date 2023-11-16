## ------------------------------------------------------
## 01_CLASS05.R - R Script for Lecture 04 (GIS course).

# version: 1.0
# Author: Bruno Conte Leite @2023-24
# b.conte@unibo.it

## ------------------------------------------------------

library(sf) # simple features' library
library(spData) # library of spatial datasets
library(tidyverse) # dplyr, ggplot, ...
library(terra)

# 1. RASTER BASICS ----

# We will work mostly with SpatRaster 
# objects from the terra package

# 1.1 Creating and manipulating a raster:

# Empty raster:
raster <- rast()
raster
plot(raster)

# Assigning values to it:
values(raster) <- 1:ncell(raster) # sequential
plot(raster)
values(raster) <- runif(ncell(raster)) # random
plot(raster)

# Assigning resolutions:
raster <- rast()
res(raster) <- 10
values(raster) <- 1:ncell(raster) # sequential
plot(raster)

# Assigining extent:
raster <- rast()
ext(raster) <- c(-74, -34, -35, 6)
raster # note the adjustment of resolution
res(raster) <- 1
raster

values(raster) <- 1:ncell(raster)
plot(raster)
plot(world %>% filter(name_long=='Brazil'),add=T)

# Changing projection/CRS:
r.reprojected <- project(raster, "EPSG:2169")
r.reprojected

# 1.2. Loading external files:

# Most usual: *.tif files
# Download from NOAA VIIS here:
# https://www.ngdc.noaa.gov/eog/dmsp/downloadV4composites.html
r.nightlights <- rast('../../Research/Data/gis data/NL NOAA Version 4 DMSP-OLS/F101992.v4/F101992.v4b_web.stable_lights.avg_vis.tif')
r.nightlights
inMemory(r.nightlights) # note: not loaded in memory!

# Plotting it:
plot(r.nightlights)
plot(st_geometry(world),add=T)

# Also normal: NetCDF files (*.nc):
# Download here:
# https://digital.csic.es/handle/10261/268088
r.spei <- rast('../../Research/Data/gis data/spei/spei01.nc')
r.spei # note the multilayer!

# Calling specific layers:
r.spei[[1]] # double bracket!

r.spei.layer <- r.spei[[1200]]
plot(r.spei.layer)
plot(st_geometry(world),add=T)

rm(list = ls())

# ----

# 2. RASTER OPERATIONS: ----

# 2.1. Cropping:

raster <- rast(elev)

# Creating a sf polygon:
pol <- rbind(c(-1,1), c(-1,-.5), c(1,-1), c(0.5,1), c(-1,1))
pol <-st_polygon(list(pol))
pol <- st_sfc(pol,crs = 'EPSG:4326')
pol <- st_sf(geometry = pol)

# plotting
plot(raster)
plot(pol,add=T)

# Cropping:
r.crop <- crop(raster, pol)

# Compare them:
raster
r.crop

plot(r.crop)
plot(pol,add=T)

# 2.2. Vectorization:

# Raster to points:
r.points <- as.points(raster) %>% 
  st_as_sf()
r.points # watch out with the 'layer' column!

r.points <- as.points(raster) %>% 
  st_as_sf() %>% 
  select(-layer)

# Plotting it:
plot(raster)
plot(r.points,add=T)

# Raster to polygons:
# VERY USEFUL FOR CREATING A GRID!

r.pol <- as.polygons(raster) %>% 
  st_as_sf() %>% 
  select(-layer)
r.pol

# Visualize:
plot(raster)
plot(r.pol,add=T)

# ----

# 3. VECTOR-RASTER OPERATIONS ----

# 3.1. Extracting:

# Works only between SpatRasters and
# SpatVectors (vector data on terra format)

# Getting all points from the polygon:
r.points <- st_cast(pol,'POINT')

plot(raster)
plot(r.points,add=T)

# Extracting:
extract(raster,r.points) # must be SpatVector: vect()

r.points.vec <- vect(r.points)
r.points.vec

r.extract <- extract(raster,r.points.vec)
r.extract # it is a dataframe!

r.points <- r.points %>% 
  mutate(elevation = r.extract$layer)

ggplot() +
  geom_sf(data = r.points, aes(color=elevation)) +
  scale_color_distiller(palette = 'Spectral') +
  theme_bw()

# What if the sf is a line or polygon?
# Check 6.3 (Figure 6.B)

# 3.2. Zonal statistics:

# Efficiently done with exactextractr package!
library(exactextractr)

r.zonal <- exact_extract(
  x = raster,
  y = pol,
  fun = 'mean')
r.zonal # a number: the average elevation within pol!

# Multi-statitics:
r.zonal <- exact_extract(
  x = raster,
  y = pol,
  fun = c('mean', 'min','max'))
r.zonal

# What if multi-feature?

pol.2 <- rast() %>%
  crop(raster) %>% 
  as.polygons() %>% 
  st_as_sf() %>%
  st_filter(pol)

plot(pol.2)
plot(raster,add=T)

r.zonal <- exact_extract(
  x = raster,
  y = pol.2,
  fun = c('mean', 'min','max'))
r.zonal

# Adding it to the sf polygon:

pol.2 <- cbind(pol.2,r.zonal)

ggplot() +
  geom_sf(data = pol.2,aes(fill=mean))

# 3.3. Rasterization:

sf.river <- seine

# To rasterize, one needs a
# 'raster template':
r.template <- rast() %>% 
  crop(sf.river) # why error?

sf.river <- seine %>% 
  st_transform('EPSG:4326')
sf.river

r.template <- rast() %>% 
  crop(sf.river)
r.template

sf.river.rast <- rasterize(sf.river,r.template) # why error?

sf.river.rast <- rasterize(vect(sf.river),r.template)
plot(sf.river.rast) # what is the meaning of it?

# increase resolution:

res(r.template) <- .1
r.template

sf.river.rast <- rasterize(vect(sf.river),r.template)
plot(sf.river.rast)

# 3.4. Distance over raster (friction surface):

# Needs the gdistance package:
library(gdistance)

# Points to calculate distance from:

sf.points <- st_centroid(sf.river)

# Plotting it:
plot(st_geometry(sf.river))
plot(st_geometry(sf.points),add=T,pch=20)

# Euclidean distances - st_gistance
st_distance(sf.points)

# Distance over the (rasterized) rivers:

# First, transform the raster into a transition
# matrix. For that, replace missing values:

vv<-values(sf.river.rast)
vv[is.nan(vv)] <- 100 # 100x as costly to cross
values(sf.river.rast) <- vv
rm(vv)
plot(sf.river.rast)

tr.matrix <- transition(
  x = sf.river.rast, # why error? needs a raster() object!
  transitionFunction = mean,
  directions = 8
  )

# Using the (old) raster library for that:
sf.raster <- raster::raster(sf.river.rast)
sf.raster
rm(sf.raster)

tr.matrix <- transition(
  x = raster::raster(sf.river.rast), # why error? needs a raster() object!
  transitionFunction = mean,
  directions = 8
)

# Distance between points 1 and 2:
sp.point.1 <- as_Spatial(sf.points[1,])
sp.point.2 <- as_Spatial(sf.points[3,])

sp.distance <- shortestPath(
  x = tr.matrix,
  origin = sp.point.1,
  goal = sp.point.2,
  output = "SpatialLines"
)

# Back to sf:
sf.distance <- st_as_sf(sp.distance)

# Plotting it:
plot(sf.river.rast)
plot(st_geometry(sf.river),add=T)
plot(sf.points,add=T)
plot(sp.distance,add=T,col='red')

# Why the opposite? The transition matrix
# assigns high value as better to cross!

# Solve it with two options:
# - Reduce the values of the raster
# - Invert the function of the transition

# Choose the second: why? Replace values in # 
# rasters can be CPU/memory demanding:
tr.matrix <- transition(
  x = raster::raster(sf.river.rast), # why error? needs a raster() object!
  transitionFunction = function(x) 1/mean(x),
  directions = 8
)

sp.distance <- shortestPath(
  x = tr.matrix,
  origin = sp.point.1,
  goal = sp.point.2,
  output = "SpatialLines"
)

# Back to sf:
sf.distance <- st_as_sf(sp.distance)

# Retrieving distance with st_length():
st_length(sf.distance)
st_distance(sf.points)[1,3] # compare with Euclidean!

# # Plotting it:
# plot(sf.river.rast)
# plot(st_geometry(sf.river),add=T)
# plot(sf.points,add=T)
# plot(sp.distance,add=T,col='red')

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = sf.points) +
  geom_sf(data = sf.distance,color = 'red') +
  theme_bw()

# How to calculate a bilateral distance matrix?

# Empty matrix:
dist.mat.riv <- matrix(
  0,
  nrow = nrow(sf.points),
  ncol = nrow(sf.points)
  )

for (i in 1:nrow(sf.points)) {
  
  for (j in 1:nrow(sf.points)) {
    
    # Creating the sp points:
    sp.point.1 <- as_Spatial(sf.points[i,])
    sp.point.2 <- as_Spatial(sf.points[j,])
    
    # Caluculating path:
    sp.distance <- shortestPath(
      x = tr.matrix,
      origin = sp.point.1,
      goal = sp.point.2,
      output = "SpatialLines"
    )
    
    # Extracting length:
    sf.distance <- st_as_sf(sp.distance)
    
    dist.mat.riv[i,j] <- st_length(sf.distance)
    
  }
  
}

# How does it compare with st_distance()?

# Transform it into a data frame:

df.distances <- data.frame(dist.mat.riv) %>% 
  gather() # reshaping it

df.distances <- df.distances %>% 
  rename(origin = key, distance = value) %>% 
  mutate(destination = rep(c('X1','X2','X3'),3)) %>% 
  dplyr::select(origin,destination,distance)

# ----

# 4. HANDS-IN ----

# 4.1. Vector cropping and vectorizing:

# Create an 1x1 grid covering Italy:

# 4.2. SPEI index by year USA:

# Calculate average state SPEI for different periods

# 4.3. Distance between main towns in Spain:

# What is the shortest distance over the geography
# between Madrid and Vigo?


# ----























# 
# 
