## ------------------------------------------------------
## 01_CLASS04.R - R Script for Lecture 04 (GIS course).

# version: 1.0
# Author: Bruno Conte Leite @2023-24
# b.conte@unibo.it

## ------------------------------------------------------

library(sf) # simple features' library
library(spData) # library of spatial datasets
library(tidyverse) # dplyr, ggplot, ...

# 1. UNARY GEOMETRY OPERATIONS ----

# 1.1. Simplification
sf.river <- seine
# Rivers in France:
ggplot() + 
  geom_sf(data = world %>% filter(iso_a2=='FR')) +
  geom_sf(data = sf.river)

# Simplifying (reducing resolution)
sf.river.simple <- st_simplify(
  sf.river,
  dTolerance = 2000 # tolerance (in meters): the largest, the lower the resol
  )
rm(sf.river.simple)

# 1.2. Centroids

sf.usstates <- us_states
sf.usstates
sf.us.centroids <- st_centroid(sf.usstates)
sf.us.centroids

# Fields (variables) are kept:
names(sf.usstates)
names(sf.us.centroids)

# Visualizing
ggplot() +
  geom_sf(data = sf.usstates) +
  geom_sf(data = sf.us.centroids, aes(color = 'Centroids'), shape = 16)

# Important: centroids might not overlap
# with the geometry!

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = st_centroid(sf.river), shape = 3)

# Use st_point_on_surface():

sf.river.centroid.surface <- st_point_on_surface(sf.river)

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = st_centroid(sf.river), shape = 3) +
  geom_sf(data = sf.river.centroid.surface, shape = 3, color='red')


# 1.3. Buffers:

# Use st_buffer()

sf.river.buffer <- st_buffer(
  sf.river,
  dist = 5000 # 5 km (distance is in meters!)
  )

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = sf.river.buffer, aes(fill=name), alpha=.5) +
  theme_bw()

# 1.4. Type transformations (casting)

sf.river <- seine
sf.cast <- st_cast(x = sf.river, to = 'MULTIPOINT')

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = sf.cast, aes(color = name),shape = 1)

# 1.5. Affine transformations: shifting, scaling, 
# rotating; see Chapter 5.2.4 of
# https://r.geocompx.org/geometry-operations.html

# ----

# 2. BINARY GEOMETRY OPERATIONS: ----

# 2.1. Clipping:

sf.circles <- st_centroid(seine) %>% 
  st_buffer(dist=100000)

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  theme_bw()

# Clipping: must use unitary geometries!

sf.circle.1 <- sf.circles[1,]
sf.circle.2 <- sf.circles[2,]

sf.intersection <- st_intersection(
  sf.circle.1,
  sf.circle.2
  )
# look at the name of the fields (variables)
sf.intersection

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  geom_sf(data = sf.intersection, aes(fill='Intersection'),alpha=.95) +
  theme_bw()

# Trying other clipping topological
# relationship (difference)
sf.difference <- st_difference(
  sf.circle.1,
  sf.circle.2
)

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  geom_sf(data = sf.difference, aes(fill='Difference'),alpha=.95) +
  theme_bw()

# 2.2. Unions:

# Recall: attribute (or spatial) aggregation
# do unite (dissolve) touching geometries (i.e.
# polygons).

# However, if one wants to unite two TOUCHING
# polygons, use st_union():

sf.union <- st_union(
  sf.circle.1,
  sf.circle.2
)

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  geom_sf(data = sf.union, aes(fill='Union'),alpha=.95) +
  theme_bw()

# 2.3. Distances:

# Use st_distance() - calculates MINIMUM 
# DISTANCES.

sf.river <- seine
sf.centr <- st_centroid(sf.river)

st_distance(sf.river)
st_distance(sf.centr)
st_distance(sf.centr,sf.river)
st_distance(sf.centr,sf.river,by_element = T)

# ----





























# 
# 
