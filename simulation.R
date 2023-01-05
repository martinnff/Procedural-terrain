source('./lSystem.R',local=T)
source('./perlin_noise.R',local=T)

# creation of irregular terrain with water areas
set.seed(1)

# create grids with sizes acording to the scale of the features
grid1 = gradientGrid(dim=c(2,2,2)) #big terrain artifacts
grid2 = gradientGrid(dim=c(12,12,2)) #small terrain artefacts
grid3 = gradientGrid(dim=c(20,20,2)) #water artefacts

# sample random points in a (0,1) surface 
points = data.frame(x=runif(20000,0,1),
                    y=runif(20000,0,1))

# get the height of each point as a sum of multiple perlin noise layers
noise1 = perlin(points,grid1)  # ground layer 1
noise2 = perlin(points,grid2)  # ground layer 2
noise3 = perlin(points,grid3)  # water layer

# remove the ground under water and rescale the features
threshold=-45 # water level
water = noise3*3+threshold
ground = cbind(noise1*400+noise2*50)
ind = which(ground<threshold)
water=water[ind]
ground = ground[-ind]
points = points*1600 # rescale the scene from 0-1 to 0-1600

##Add xyz and labels in the same dataframe
water = cbind(points[ind,], 
              water,
              rep(3,length(ind)))

ground=cbind(points[-ind,],
             ground,
             rep(4,length(ground))) 

colnames(ground) = c('x','y','z','class')
colnames(water) = c('x','y','z','class')

# create trees 
set.seed(1)
n=20 #number of trees
# select random origins from the ground points
origins=ground[sample(seq_len(nrow(ground)),n),1:3] 
trees=data.frame(x=0,
                 y=0,
                 z=0,
                 class=0)
trees=trees[-1,]
for(i in seq_len(n)){
  origin=origins[i,]
  # create the instructions to grow a tree with random number of iterations 
  # from 7 to 10
  instructions = evolve(plant4, #lsystem rules
                        n=round(runif(1,7,10)),# tree size
                        terminal.leafs=10)
  # Execute the growing instructions
  out=produce(instructions,
              alfabet, #dictionary of functions to interpretate the instructions
              # given in the lSystem.R file
              origin=origin,
              size1=2, # initial width 
              size2=20, # initial lenght
              factor1=0.707, # decreasing width factor
              factor2=0.9, # decreasing length factor
              density=0.8,
              angle=(pi/6), # z axis branching angle
              angle2=(pi/6), # y axis branching angle
              angle3=(pi/6)) # main branch rotation angle
  trees = rbind(trees,out)
}


myColorRamp <- function(colors, values) {
  v <- (values - min(values))/diff(range(values))
  x <- colorRamp(colors)(v)
  rgb(x[,1], x[,2], x[,3], maxColorValue = 255)
}



colnames(trees) = c('x','y','z','class') 
scene = rbind(trees,water,ground)
rgl::bg3d('black')
rgl::plot3d(scene[,1:3],col=myColorRamp(c('pink2','blue4'),scene[,4]),add=T)





