# Procedural-terrain

In my master's degree project I worked on lidar point cloud classification models in a forestry context. One of the problems I encountered was to get labelled datasets with the characteristics I wanted (leaves, branches and soil labelled with mixtures of tree species) and a sufficient size to be able to train. While playing elder ring I realised that the synthetic trees used to create the map could be the solution to my lack of real quality data so I decided to employ the methods used in game development to generate my own point clouds.

To build the synthetic trees was implemented a Lindenmayer system generator (https://en.wikipedia.org/wiki/L-system) and a function to translate L-system the instructions into point clouds sampled on the branches (cylinders) and leaves (flat surfaces) with the desired density.

The componets of a L-system are an afabet or set of characters with asociated production meanings, an axiom or initial state and the rules to modify the initial axiom in an iterative way. The alfabet used has the folowing actions:

- F Move forward
- [ Save last state
- ] Pop last state
- $+$ Positive rotation in z axis with angle_1
- $-$ Negative rotation in z axis with angle_1
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
- d Rotate main branch with angle_3
- X Do nothing
- 0 Terminal branch
- . Decrease length and width with f1 and f2 factors
- r Random rotation

The following is an example of a set of rules and an axiom for generating a plant.

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
Once the rule set is defined, we can use the evolve() function to transform the axiom with these rules and obtain the final instruction set. The produce() function uses this instructions set to sample the resulting point cloud. This function requires specifying the origin, the initial length and width of the branches, the branching angles and the decrement factor.

```R
instructions = evolve(plant1, # lsystem rules
                      n=4,    # number of iterations
                      terminal.leafs = 10 # number of leafs in each terminal branch
                      )
                      
out=produce(instructions,
            alfabet,           # dictionary of functions to interpretate the instructions
                               # given in the lSystem.R file
            origin=c(0,0,0),
            size1=2,           # initial width 
            size2=20,          # initial lenght
            factor1=0.707,     # decreasing width factor
            factor2=0.9,       # decreasing length factor
            density=1,
            angle=(pi/6),      # z axis branching angle
            angle2=(pi/6),     # y axis branching angle
            angle3=(pi/6)      # main branch rotation angle
            )                       
```


A terrain modelling tool is available, these tool uses perlin noise (https://en.wikipedia.org/wiki/Perlin_noise) to create noise artefacts that mimic the irregularities of the terrain.

![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image1.png "procedural landscape")

![Alt text](https://github.com/martinnff/Procedural-terrain/blob/main/image2.png "tree detail")

The perlin_noise.R file contains the functions dedicated to terrain simulation using perlin noise and the lSystem.R file contains the implementations for tree creation. An example of how to use these tools can be found in the simulation.R file. The landscape in the previous image is a snapshot of the point cloud generated with this script.

This repository is curently in a prototype phase. In the near future I intend to add rules to generate trees with various base phenotypes of real trees and rewrite these functions in c++ to parallelise and speed up the computation time.

