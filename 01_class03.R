## ------------------------------------------------------
## 01_CLASS03.R - R Script for Lecture 03 (GIS course).

# version: 1.0
# Author: Bruno Conte Leite @2023-24
# b.conte@unibo.it

## ------------------------------------------------------

library(sf) # simple features' library
library(spData) # library of spatial datasets
library(tidyverse) # dplyr, ggplot, ...

# 1. SF ATTRIBUTE OPERATIONS ----

# Let us use the world dataset for that:
sf.world <- world

# 1.1. Basic operations:

# Slicing (choosing rows):
sf.world[1:3,] # basic R 'vector' syntax
sf.world %>% # tidyverse syntax 
  slice(1:3)

# Selecting (choosing columns
# /variables):
sf.world[,1:3]
sf.world %>% 
  select(1:3) # or by names, as we already did

# Filtering: countries whose area>200.000 km2
sf.world %>% 
  filter(area_km2>200000) # select variables

# Filtering: note that there is an underlying
# logical vector (TRUE/FALSE):
sf.world$area_km2>200000
logical.vector <- sf.world$area_km2>200000
sf.world[logical.vector,]


# 1.2. Aggregating

# Let us start with a simple data.frame 
# example (no geometry):
df.world <- st_drop_geometry(sf.world) # it is just a data set

# Aggregating (collapsing, in Stata) total
# area in each continent:

df.world %>% 
  group_by(continent) %>% 
  summarise(total_area = sum(area_km2))

# Multiple variables:
df.world %>% 
  group_by(continent) %>% 
  summarise(total_area = sum(area_km2), average_pop = mean(pop))
# Watch out for missing data (NA)!!!

df.world %>% 
  group_by(continent) %>% 
  summarise(total_area = sum(area_km2), average_pop = mean(pop,na.rm=T))
# NaN: average of zeros/NA; that is missing data in
# all observations of the group (continent)

rm(df.world)

# Aggregating SF: also aggregate geometries
# (if polygons, make them multipolygon AND
# join the polygons that touch one another)

sf.world.agg <- world %>% 
  group_by(continent) %>% 
  summarize(pop = sum(pop))

# Likely error: how to solve it?
# https://stackoverflow.com/questions/68478179/how-to-resolve-spherical-geometry-failures-when-joining-spatial-data
sf_use_s2(F)
# be careful with this: it is happening because this
# geometry has low precision! Not reccomended!

sf.world.agg <- sf.world %>% 
  group_by(continent) %>% 
  summarize(pop = sum(pop,na.rm=T))

ggplot(sf.world.agg) +
  geom_sf(aes(fill=pop))

# Using factors inside aesthetics
# (transform continuous scale into
# discrete):
ggplot(sf.world.agg) +
  geom_sf(aes(fill=as.factor(pop)))

# Multiple aggregation:
sf.world.agg <- sf.world %>% 
  group_by(continent) %>% 
  summarise(pop = sum(pop,na.rm = T), area = sum(area_km2,na.rm = T))

ggplot(sf.world.agg) +
  geom_sf(aes(fill=as.factor(round(area/1e6,0)))) +
  scale_fill_discrete(name = 'Total area\n(million km2')
  # what is scale_*()?

ggplot(sf.world.agg) +
  geom_sf(aes(fill=round(area/1e6,0))) +
  scale_fill_binned()
# what is scale_*()?

rm(sf.world.agg)

# 3.3. Vector merging (joining):

# Suppose we have an additional dataset
df.coffe <- coffee_data
df.coffe

# Merging (joining it) to the sf:

sf.world.merged <-sf.world %>% 
  left_join(df.coffe)
# all variables from sf.world linked to
# coffe production from df.coffee!

sf.world.merged %>% 
  select(name_long,continent,coffee_production_2017)

ggplot(sf.world.merged) +
  geom_sf(aes(fill=coffee_production_2017)) +
  scale_fill_distiller(palette = 'Greens')

ggplot(sf.world.merged) +
  geom_sf(aes(fill=coffee_production_2017)) +
  scale_fill_distiller(name = 'Coffee', palette = 'Spectral', na.value = NA) +
  theme_bw()

# What if the "merging variables" between datasets
# do not have the same names?

# Here I artificially change names in the coffe data:
df.coffe <- df.coffe %>% 
  rename(country.name = name_long)

# Try to merge:
sf.world %>% 
  left_join(df.coffe)

# Telling which variables link the two datasets:
sf.world %>% 
  left_join(df.coffe,by = c(name_long =  'country.name'))

# Generating variables (mutating):

# Coffe per capita:
sf.world.merged <- sf.world.merged %>% 
  mutate(coffee_capita = coffee_production_2016/pop)

ggplot(sf.world.merged) +
  geom_sf(aes(fill=coffee_capita))

# You can calculate the new variable directly
# inside the aes(). Example with coffee/area

ggplot(sf.world.merged) +
  geom_sf(aes(fill=(coffee_production_2016/area_km2))) +
  scale_fill_distiller(name = NULL)


# ----

# 2. SF SPATIAL OPERATIONS: ----

# Same idea that attribute data, but
# based on the relationship between two
# geometries

# The following is inspired on Chapter 4.2
#  https://r.geocompx.org/spatial-operations.html

# 2.1. Spatial subsetting (e.g. filtering)

sf.cant <- nz  %>%  filter(Name == "Canterbury")
sf.nzpeaks <- nz_height

# Visualizing:
ggplot() +
  geom_sf(data = nz,fill='white') + # whole New Zealand
  geom_sf(data = sf.cant, aes(fill='Canterbury')) + # Only Canterbury
  geom_sf(data = sf.nzpeaks,shape = 2)

# What if we want to filter peaks in Canterbury?

sf.cant.peaks <- sf.nzpeaks[sf.cant,] # slicing
# Equivalent (in intuition) to:
# sf.cant.peaks <- sf.nzpeaks[sf.nzpeaks inside sf.cant,]

ggplot() +
  geom_sf(data = nz,fill='white') + # whole New Zealand
  geom_sf(data = sf.cant, aes(fill='Canterbury')) + # Only Canterbury
  geom_sf(data = sf.nzpeaks,shape = 2) +
  geom_sf(data = sf.cant.peaks,shape = 2,color='blue')

# Note: underlying the spatial filtering, there is
# TOPOLOGICAL RELATIONSHIP of INTERSECTION (TRUE/FALSE)
st_intersects(x = sf.nzpeaks, y = sf.cant)
st_intersects(x = sf.nzpeaks, y = sf.cant,sparse = F)

# Using sf's spatial filtering function:
sf.nzpeaks %>% 
  st_filter(sf.cant) # much nicer!

# If interested in another Topological
# relationship (e.g. touches):
sf.nzpeaks %>% 
  st_filter(sf.cant, .predicate = st_within)
  # should not change the result

# Note: the dot '.' before the predicate and
# that the spatial function (st_touches) is
# written without the (): st_touches

# 2.2. Spatial joining

# Idea: similar to merging, but based on
# topological relations. As before, standard is
# st_intersects()

# Generating a random SF points:
set.seed(2018) # set seed for reproducibility
bb <- st_bbox(world) # the world's bounds
#>   xmin   ymin   xmax   ymax 
#> -180.0  -89.9  180.0   83.6
random_df <- data.frame(
  x = runif(n = 10, min = bb[1], max = bb[3]),
  y = runif(n = 10, min = bb[2], max = bb[4])
)
rm(bb)
sf.random_points <- random_df %>% 
  st_as_sf(coords = c("x", "y"))  %>%  # set coordinates
  st_set_crs("EPSG:4326") # set geographic CRS
rm(random_df)

# Visualizing:
ggplot() +
  geom_sf(data = world) +
  geom_sf(data = sf.random_points)

# What if we want to merge the country data
# into the SF random points based on intersection?

sf.points.merged <- sf.random_points %>% 
  st_join(world)

ggplot() +
  geom_sf(data = world) +
  geom_sf(data = sf.points.merged, aes(color=name_long))

# As with filtering, st_join() allows for other
# topological relationships:

sf.random_points %>% 
  st_join(world,join = st_covers)
# all missing: points do not cover polygons

# WATCH OUT: ALWAYS CHECKE WHETHER THERE ARE
# FIELDS (VARIABLES) WITH THE SAME NAME!

# Joining based on distance (disjoint
# geometries):

sf.disj.1 <- cycle_hire
sf.disj.2 <- cycle_hire_osm

ggplot() +
  geom_sf(data = sf.disj.1) +
  geom_sf(data = sf.disj.2,color='red', alpha=.5)

# Do they touch?
st_touches(sf.disj.1,sf.disj.2,sparse = F)
any(st_touches(sf.disj.1,sf.disj.2,sparse = F))

# Joining them based on 20 meters distance:
logical.dist <- st_is_within_distance(sf.disj.1, sf.disj.2, 
                        dist = units::set_units(20, "m"))
logical.dist
logical.dist[100:150]

logical.dist <- st_is_within_distance(
  sf.disj.1, 
  sf.disj.2, 
  dist = units::set_units(20, "m"),
  sparse = F
  )
dim(logical.dist)

sf.disjoint.joined <- st_join(
  sf.disj.1, 
  sf.disj.2, 
  st_is_within_distance, 
  dist = units::set_units(20, "m")
  )

# BE CAREFUL: this can be consume a lot of
# CPU time depending on the size of the
# features you are merging!

# 2.3. Spatial join of incongruent layers
# check Chapter 4.2.7 of
# https://r.geocompx.org/spatial-operations.html

# ----

# 3. HANDS-IN EXERCISE ----

# 3.1. Merging and aggregating the
# world's data (attribute operations)

sf.world <- world %>% filter(!is.na(iso_a2))
df.wb <- worldbank_df %>% filter(!is.na(iso_a2))

# 3.2. Spatial operations:

sf.great.london <- lnd
sf.bikes <- cycle_hire

# Spatial filtering:

# Spatial join:

# Spatial join + aggregation:




# ----




























# 
# 
