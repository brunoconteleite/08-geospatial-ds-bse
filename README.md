<img style="float: right;width: 25%" src="figs/bse_primary_logo.png">

# Geospatial Data Science and Economic Spatial Models
[Bruno Conte](https://brunoconteleite.github.io/) | [bruno.conte@bse.eu](mailto:bruno.conte@bse.eu) | Course GitHub repo [here](https://github.com/brunoconteleite/08-geospatial-ds-bse)<br>
Barcelona School of Economics
 
## Overview

This course introduces the basics for working with geospatial data: datasets that reflect geographical features of the reality. Using `R` (and `Rstudio`) as the main programming platform, and `sf` as the main package, students by the end of the course are expected to achieve the following objectives:

* Identify sources of (and retrieve) different types of geospatial data from standard databases or the web

* Manipulate raw spatial data (i.e. data wrangle) into the structure that fits the desired analysis/application

* Visualize geospatial data in static and interactive frameworks (i.e. maps and dashboards)

* Implement basic concepts of economic spatial models (e.g. optimal route choices, optimal transportation networks) in real applications by linking geospatial data to these models

* Document results with reproduceable markdown reports

All practical applications are taking place in ``R`` and ``RStudio``. **Please have both installed in your computer** and follow these [setup instructions](https://www.dropbox.com/scl/fi/l4xtd3rfrmai7pxl2zu0n/instructions.txt?rlkey=r5zp0q8vu1evb8b12rcgei179&raw=1) before starting the course.

## Course structure

This is a 20 hours course, divided in ten sessions of 2 hours each. Its overall structure is divided in three parts as follows:

#### Part 1: Introduction, vector data, and basic spatial analysis

* **Session 1:** Introduction to geospatial data and applications in business and research

  * Basic aspects of `R` (`tidyverse`, `ggplot2`), spatial data, and applications in economic research
  
  * Class slides **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class01.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/973hbquayt7v8jfd85qaa/01_class01.R?rlkey=85y5cbp2bkd1jrt9e2q1uynrp&st=f7frq3x7&dl=1)**

* **Session 2:** Vector spatial data (points, lines, and polygons)
  * Creating, loading, and manipulating vector data with ``sf``
  * Spatial (re)projections and basic data  visualization with ``ggplot2``
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class02.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/y5eofzitrbvr84sity8z8/01_class02.R?rlkey=xl3lcrl9mq8tg80xfk4kuw5ss&st=kjqjmw9d&dl=1)**

* **Session 3:** Attribute- and spatial-based operations with vector data
  * Operations with vector data: attribute-based (e.g. ``filter()``, ``slice()``) and spatial-based (e.g. ``st_intersects()``, ``st_overlaps()``, ``st_touches()``, ``st_join()``, ``aggregate()``)
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class03.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/y65fnibf31pizsd0mm8y0/01_class03.R?rlkey=n76yl7pf3g0wo5l28983181ui&st=hs17voyh&dl=1)**
  
  * *Assignment:* reproducing operations with proposed data and replicating results from academic papers. Instructions **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class03.html#20)**
  
* **Session 4:** Geometry-based operations with vector data
  * Unary operations (e.g., simplification, centroids, buffers, casting)
  * Binary operations (e.g., clipping, subsetting, calculating distances)
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class04.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/79bp963jvk4ou13h7zt6p/01_class04.R?rlkey=u90ul5z2uk0o96jtih3xdwlvv&st=j70nyti2&dl=1)**
  
  * *Class follow-up:* feedback on course pace, reinforcing concepts, etc.
  
  * *Assignment:* Produce maps and statistics (histograms, correlations) with real-world spatial data. Instructions **[html](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class04.html#18)**
  
#### Part 2: Raster (image) data and interactive data visualization

* **Session 5:** Raster basics
  
  * Basic differences between raster (image) and vector data

  * Creating raster data with ``terra``
  
  * Unary raster operations (e.g. ``crop`` and ``vectorize``)
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class05.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/9jt29xa0501l40g7jkz2a/01_class05.R?rlkey=k4w9r5nvtwxb82dzyygzcdmku&st=fv45n2bn&dl=1)**
  
* **Session 6:** Raster-vector operations
  
  * Basic differences between raster (image) and vector data

  * Creating raster data with ``terra``
  
  * Unary raster operations (e.g. ``crop`` and ``vectorize``)
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class06.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/qrkf6z4tc0zpfgwgmkofz/01_class06.R?rlkey=nlm9qro5s5j9dstqo9f1qj4mb&st=qsh39lun&dl=1)**
  
* **Session 7:** Interactive tools
  
  * Basic of interactive dashboards using `leaflet` + APIs
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class07.html)** and hands-on material **[here](https://www.dropbox.com/scl/fi/hvhl89opousx5um91e1br/01_class07.R?rlkey=aypx3tlji3ce7n50v4i242g1d&st=kas6zi0d&dl=1)**
  
#### Part 3: Spatial models in economics and real-world applications

* **Session 8:** Economic spatial models and real-world applications
  
  * Introduction to spatial models and applications to academic research
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class08.html)** and hands-on material **[here]()**
  
* **Session 9:** Linking models to (spatial) data
  
  * Conceptual and practical issues when linking real-world (geospatial) data to a spatial model of migration
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class09.html)** and hands-on material **[here]()**
  
* **Session 10:** Models, data, and counterfactual simulations
  
  * Applications of spatial models (combined with spatial data) when answering counterfactual questions
  
  * **Class slides** **[here](https://brunoconteleite.github.io/08-geospatial-ds-bse/00_class10.html)** and hands-on material **[here]()**

## References

* Donaldson, D. and Storeygard, A., 2016. The view from above: Applications of satellite data in economics. *Journal of Economic Perspectives*, *30(4)*, pp.171-98.

* Lovelace, R., Nowosad, J. and Muenchow, J., 2019. Geocomputation with R. Chapman and Hall/CRC.

* Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector Data. *The R Journal*, *10 (1)*, 439-446, https://doi.org/10.32614/RJ-2018-009

* Wickham, H. and Grolemund, G., 2016. R for data science: import, tidy, transform, visualize, and model data. " O'Reilly Media, Inc.".
