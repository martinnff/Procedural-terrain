# Procedural-terrain

In my master's degree project I worked on lidar point cloud classification models in a forestry context. One of the problems I encountered was to get labelled datasets with the characteristics I wanted (leaves, branches and soil labelled with mixtures of tree species) and a sufficient size to be able to train. While playing elder ring I realised that the synthetic trees used to create the map could be the solution to my lack of real quality data. So I decided to employ the methods used in game development to generate my own point clouds.

To build the trees was implemented a Lindenmayer system interpreter (https://en.wikipedia.org/wiki/L-system) and a function that translates these instructions into point clouds sampled on the branches (cylinders) and leaves (flat surfaces) with the desired density.

The componets of a L-system are a afabet or set of characters with asociated production meanings, a axiom or initial state and rules to modify the initial axiom in an iterative way. The alfabet used has the folowing actions:
- F Move forward
- [ Save last state
- ] Pop last state
- + Positive rotation in z axis with angle_1
- /- Negative rotation in z axis with angle_1
- & Positive rotation in y axis with angle_1
- ^ Negative rotation in y axis with angle_1
- \\ Positive rotation in x axis with angle_1
- / Negative rotation in x axis with angle_1
- +2 Positive rotation in z axis with angle_2
- -2 Negative rotation in z axis with angle_2
- &2 Positive rotation in y axis with angle_2
- ^2 Negative rotation in y axis with angle_2
- \\2 Positive rotation in x axis with angle_2 
- /2 Negative rotation in x axis with angle_2
- | Turn 180º
- d Positive rotation in x axis with angle_3
- X Do nothing
- 0 Terminal branch
- . Decrease length and width with f1 and f2 factors
- r Random rotation

```R
b1 = function() c('F','+','[','.','[','.','X',']', 
                  '-','X',']','-','F','[','.','-',
                  'F','X',']','+','X')
b2 = function() c('F','F')                         
plant1 = list(axiom='X',                           # Axiom
              rules=list(r1=list(a='X',            # First rule
                                 b=b1),
                         r2=list(a='F',            # Second rule
                                 b=b2)))
```


![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image2.png "tree detail")

A terrain modelling tool is available, these tool uses perlin noise (https://en.wikipedia.org/wiki/Perlin_noise) to create noise artefacts that mimic the irregularities of the terrain.

![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image1.png "procedural landscape")

The perlin_noise.R file contains the functions dedicated to terrain simulation using perlin noise and the lSystem.R file contains the implementations for tree creation. An example of how to use this tool can be found in the simulation.R file. The landscape in the previous image is a snapshot of the point cloud generated with this script.

This repository is curently in a prototype phase. In the near future I intend to add rules to generate trees with various base phenotypes of real trees and rewrite these functions in c++ to parallelise and speed up the computation time.

