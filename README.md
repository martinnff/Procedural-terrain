# Procedural-terrain

In my master's degree project I worked on lidar point cloud classification models in a forestry context. One of the problems I encountered was to get labelled datasets with the characteristics I wanted (leaves, branches and soil labelled with mixtures of tree species) and a sufficient size to be able to train. While playing elder ring I realised that the synthetic trees used to create the map could be the solution to my lack of real quality data. So I decided to employ the methods used in game development to generate my own point clouds.

To build the trees was implemented a Lindenmayer system interpreter (https://en.wikipedia.org/wiki/L-system) and a function that translates these instructions into point clouds sampled on the branches (cylinders) and leaves (flat surfaces) with the desired density.

![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image2.png "tree detail")

A terrain modelling tool is available, these tool uses perlin noise (https://en.wikipedia.org/wiki/Perlin_noise) to create noise artefacts that mimic the irregularities of the terrain.

![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image1.png "procedural landscape")

The perlin_noise.R file contains the functions dedicated to terrain simulation using perlin noise and the lSystem.R file contains the implementations for tree creation.An example of how to use this tool can be found in the simulation.R file. The landscape in the previous image is a capture of the point cloud generated with this script.

This repository is in prototyping phase. In the near future I intend to add rules to generate trees with various base phenotypes of real trees and rewrite these functions in c++ to parallelise and speed up the computation time.

