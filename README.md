# Procedural-terrain

In my master's thesis I worked on lidar point cloud classification models in a forestry context. One of the problems I encountered was to get labelled datasets with the characteristics I wanted (leaves, branches and soil labelled with mixtures of tree species) and a sufficient size to be able to train. for this reason I decided to implement tools that allow me to procedurally model synthesised point clouds.

To build the trees I implemented a Lindenmayer system interpreter (https://en.wikipedia.org/wiki/L-system) and a function that translates these instructions into point clouds sampled on the branches (cylinders) and leaves (flat surfaces) with the desired density.

For ground modelling a tool is available that uses perlin noise to generate noisy artefacts mimicking the irregularities of the terrain.

![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image1.png "procedural landscape")

The perlin_noise.R file contains the functions dedicated to terrain simulation using perlin noise and the lSystem.R file contains the implementations for tree creation.

An example of how to use this tool can be found in the simulation.R file. The landscape in the image is a capture of the point cloud generated with this script.

This repository is in prototyping phase. In the near future I intend to add rules to generate trees with various base phenotypes of real trees and rewrite these functions in c++ to parallelise and speed up the computation time.

