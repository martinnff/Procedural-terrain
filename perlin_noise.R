
interpolate <- function(a0, a1, w,smoothness=3) {

  if(smoothness==1){
    out=((a1 - a0) * w + a0)
  }
  if(smoothness==2){
    out = ((a1 - a0) * (3.0 - w * 2.0) * w * w + a0)
  }
  if(smoothness==3){
    out = ((a1 - a0) * ((w * (w * 6.0 - 15.0) + 10.0) * w * w * w) + a0)
  }
  if (w < 0){
    out = a0
  } 
  if (w>1){
    out = a1
  } 
  return(out)

}

dotGridGrad <- function(grid,ix ,iy, x, y, dimx,dimy){
  dx=abs(x-(ix-1)*dimx)/dimx
  dy=abs(y-(iy-1)*dimy)/dimy
  return(dx*grid[ix,iy,1]+dy*grid[ix,iy,2])
}

gradientGrid <- function(dim=c(10,10,2)){
  out = array(data=0,dim=dim)
  for(i in 1:dim[1]){
    for(j in 1:dim[2]){
      angle = runif(1,0,2*pi)
      out[i,j,1]=cos(angle)
      out[i,j,2]=sin(angle)
    }
  }
  return(out)
}

perlin <- function(points,grid,smoothness=3) {
  stepsx = dim(grid)[1]-1
  stepsy = dim(grid)[2]-1
  dimx = 1/(stepsx)
  dimy = 1/(stepsy)
  out = 0
  for(i in seq_len(length(points[,1]))){
    x0 = ((points[i,1])%/%dimx)+1
    y0 = ((points[i,2])%/%dimy)+1
    x1 = ((points[i,1])%/%dimx)+2
    y1 = ((points[i,2])%/%dimy)+2
    
    sx = (points[i,1] - (x0-1)*dimx)/dimx
    sy = (points[i,2] - (y0-1)*dimy)/dimy
    
    # Interpolate between grid point gradients
    
    n0 = dotGridGrad(grid,x0, y0, points[i,1],
                     points[i,2],dimx,dimy)
    n1 = dotGridGrad(grid,x1, y0, points[i,1],
                     points[i,2],dimx,dimy)
    ix0 = interpolate(n0, n1, sx,smoothness)
    n0 = dotGridGrad(grid,x0, y1,points[i,1],
                     points[i,2],dimx,dimy)
    n1 = dotGridGrad(grid,x1, y1, points[i,1],
                     points[i,2],dimx,dimy)
    ix1 = interpolate(n0, n1, sx,smoothness)
    out[i] = interpolate(ix0, ix1, sy,smoothness)
  }
  return(out) 
}




