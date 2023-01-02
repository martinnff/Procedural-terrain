b1 = function() c('F','+','[','.','[','.','X',']','-','X',']','-','F','[','.','-','F','X',']','+','X')
b2 = function() c('F','F')
plant = list(axiom='X',
              rules=list(r1=list(a='X',
                                 b=b1),
                         r2=list(a='F',
                                 b=b2)))

b3 = function() c('F')
b4 = function() c('F','.','[','.','+','r','x',']','/','F','.','b')
b5 = function() c('F','.','[','.','-','r','y',']','\\','F','.','a')
b6 = function() sample(c('a','b'),1,prob=c('0.9','0.1'))
b7 = function() sample(c('b','a'),1,prob=c('0.9','0.1'))
leaf = list(axiom='a',
               rules=list(r1=list(a='F',
                                  b=b3),
                          r1=list(a='a',
                                  b=b4),
                          r1=list(a='b',
                                  b=b5),
                          r1=list(a='x',
                                  b=b6),
                          r1=list(a='y',
                                  b=b7)))

b8 = function() c('X','.','[','-','F','.','F','.','F',']','.','[','+','F','.','F','.','F',']','.','F','.','X')
b9 = function() c('Y','.','F','X','.','[','+','Y',']','.','[','-','Y',']')
bush = list(axiom='Y',
             rules=list(r1=list(a='X',
                                b=b8),
                        r2=list(a='Y',
                                b=b9)))

b10 = function() c('F','[','+','X',']','[','-','X',']','F','X')
b11 = function() {
  o=data.frame(a=c('.','F','F'),
               b=c('F'))
  ind=sample(c(1,2),1,prob=c(0.3,0.7))
  o[,ind]
}
conifer = list(axiom='X',
               rules=list(r1=list(a='X',
                                  b=b10),
                          r2=list(a='F',
                                  b=b11)))

b12 = function() {
  o=data.frame(a=c('X','[','+','F',']','F'),
               b=c('X','[','-','F',']','F'))
  ind=sample(c(1,2),1)
  o[,ind]
}
plant2 = list(axiom='F',
              rules=list(r1=list(a='F',
                                 b=b12),
                         r2=list(a='X',
                                 b=b12)))

b13 = function() c('F','.','F','-','.','[','-','F','+','F','+','F',']','+','.','[','+','F','-','F','-','F',']')
plant3 = list(axiom='F',
               rules=list(r1=list(a='F',
                                  b=b13)))

b14 = function() c('F','[','+','.','F','+','F',']','[','.','-','F','-','F',']','.','F')

plant4 = list(axiom='F',
             rules=list(r1=list(a='F',
                                b=b14)))

b15 = function() c('F','[','&','.','B',']','/','.','A')
b16 = function() c('F','[','-2','.','r','C',']','.','C')
b17 = function() {o=data.frame(a=c('F','r','[','+2','.','r','B',']','.','B'),
                               b=c('0'))
                  ind = sample(c(1,2),1,prob=c(0.9,0.1))
                  o[,ind]}


plant5 = list(axiom='A',
              rules=list(r1=list(a='A',
                                 b=b15),
                         r2=list(a='B',
                                 b=b16),
                         r2=list(a='C',
                                 b=b17)))


evolve = function(Lsystem,n,terminal.leafs=3){
  state=c(Lsystem$axiom)
  for(i in seq_len(n)){
    last_size=length(state)
    mod=0
    for(j in seq_len(length(state))){
      j=j+mod
      for(r in seq_len(length(Lsystem$rules))){
        if(state[j]==Lsystem$rules[[r]]$a){
          if(length(state)==1){
            state=Lsystem$rules[[r]]$b()
            mod=mod+length(state)-last_size
            last_size=length(state)
            {break}
          }else{
            if(j==1){
              state=c(Lsystem$rules[[r]]$b(),state[(j+1):last_size])
              mod=mod+length(state)-last_size
              last_size=length(state)
              {break}
            }
            if(j>1 & j < length(state)){
                state=c(state[1:(j-1)],Lsystem$rules[[r]]$b(),state[(j+1):last_size])
                mod=mod+length(state)-last_size
                last_size=length(state)
                {break}
            }
            if(j == last_size){
              state=c(state[1:(j-1)],Lsystem$rules[[r]]$b())
              mod=mod+length(state)-last_size
              last_size=length(state)
              {break}
            }
          }
        }
      }
    }
  }
  for(i in seq_len(terminal.leafs)){
    last_size=length(state)
    mod=0
    for(j in seq_len(length(state))){
      j=j+mod
        if(state[j]==']'){
          if(j>1 & j < length(state)){
              state=c(state[1:(j-1)],'0',state[(j):last_size])
              mod=mod+length(state)-last_size
              last_size=length(state)
            }
            if(j == last_size){
              state=c(state[1:(j-1)],'0',state[j])
              mod=mod+length(state)-last_size
              last_size=length(state)
            }
        }
      }
    }
  return(state)
}

cone = function(density=0.5,size1=1,size2=0.8,size3=30,center=c(0,0,0),angle=c(0,0,0)){
  
  origin=data.frame(x=center[1],
                    y=center[2],
                    z=center[3])
  n=max(density*(((size1+size2)/2)*size3*2*pi),1)
  a1=angle[1];a2=angle[2];a3=angle[3]
  a=runif(n,0,2*pi)
  z=runif(n,origin[1,3],origin[1,3]+size3)
  
  pts = data.frame(x=origin[1,1]-(size1-((size1-size2)*z/(origin[1,3]+size3)))*sin(a),
                   y=origin[1,2]-(size1-((size1-size2)*z/(origin[1,3]+size3)))*cos(a),
                   z=z)
  
  Rm1 = matrix(data=c(cos(a1),-sin(a1),0,
                      sin(a1),cos(a1),0,
                      0,0,1),ncol=3,byrow=T)
  
  Rm2 = matrix(data=c(cos(a2),0,-sin(a2),
                      0,1,0,
                      sin(a2),0,cos(a2)),ncol=3,byrow=T)
  
  Rm3 = matrix(data=c(1,0,0,
                      0,cos(a3),-sin(a3),
                      0,sin(a3),cos(a3)),ncol=3,byrow=T)
  
  Rm=Rm3%*%Rm2%*%Rm1
  
  pts=cbind(pts[,1]-origin[1,1],
            pts[,2]-origin[1,2],
            pts[,3]-origin[1,3])
  
  pts=as.matrix(pts)%*%Rm
  
  pts=data.frame(x=pts[,1]+origin[1,1],
                 y=pts[,2]+origin[1,2],
                 z=pts[,3]+origin[1,3],
                 class=rep(1,nrow(pts)))
  
  center=matrix(data=c(0,0,size3),ncol=3)%*%Rm+origin
  list(pts,center)
}

term_leaf = function(density=40,size1=0.2,size2=0.4,center=c(0,0,0),angle=c(0,0,0)){
  n=max(round(density*size1*size2),2)
  origin=data.frame(x=center[1]+rnorm(1,0,size2*3),
                    y=center[2]+rnorm(1,0,size1*2),
                    z=center[3]+rnorm(1,0,size1*2))
  a1=angle[1]+runif(1,-1,1)
  a2=angle[2]+runif(1,-1,1)
  a3=angle[3]+runif(1,-1,1)
  pts = data.frame(x=rep(origin[1,1],n),
                   y=rnorm(n,origin[1,2]+size1/4,size1/2),
                   z=rnorm(n,origin[1,3]+size2/4,size1/2))
  Rm1 = matrix(data=c(cos(a1),-sin(a1),0,
                      sin(a1),cos(a1),0,
                      0,0,1),ncol=3,byrow=T)
  Rm2 = matrix(data=c(cos(a2),0,-sin(a2),
                      0,1,0,
                      sin(a2),0,cos(a2)),ncol=3,byrow=T)
  Rm3 = matrix(data=c(1,0,0,
                      0,cos(a3),-sin(a3),
                      0,sin(a3),cos(a3)),ncol=3,byrow=T)
  Rm=Rm1%*%Rm2%*%Rm3
  pts=cbind(pts[,1]-origin[1,1],
            pts[,2]-origin[1,2],
            pts[,3]-origin[1,3])
  pts=as.matrix(pts)%*%Rm
  pts=data.frame(x=pts[,1]+origin[1,1],
                 y=pts[,2]+origin[1,2],
                 z=pts[,3]+origin[1,3],
                 class=rep(2,nrow(pts)))
  return(pts)
}

alfabet=list(
  names=list('F','[',']','+','-','&','^','\\' ,'/','+2','-2','&2','^2','\\2' ,'/','|','d','X','0','.','r'),
  actions=list(
    a1=function(tree){
      ts=length(tree$states)
      origin=tree$states[[ts]]$origin
      size1=tree$states[[ts]]$size1
      size3=tree$states[[ts]]$size2
      size2=size1
      angle0=tree$states[[ts]]$angle0
      new_branch = cone(density=tree$states[[ts]]$density,size1=size1,size2=size2,size3=size3,center=origin,angle=angle0)
      tree$out = rbind(tree$out,
                       new_branch[[1]])
      tree$states[[ts]]$origin=new_branch[[2]]


      return(tree)
    },
    a2=function(tree){
      ts=length(tree$states)
      new_state = tree$states[[ts]]
      new_state$angle=new_state$angle
      tree$states[[ts+1]]=new_state
      return(tree)
    },
    a3=function(tree){
      ts=length(tree$states)
      tree$states=tree$states[-ts]

      return(tree)
    },
    a4=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(0, 0,runif(1,tree$states[[ts]]$angle*0.7,
                                                                       tree$states[[ts]]$angle))
      return(tree)
    },
    a5=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0=tree$states[[ts]]$angle0-c(0,0,runif(1,tree$states[[ts]]$angle*0.7,tree$states[[ts]]$angle))
      return(tree)
    },
    a6=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(0,runif(1,tree$states[[ts]]$angle*0.7,tree$states[[ts]]$angle),0)
      return(tree)
    },
    a7=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0-c(0,runif(1,tree$states[[ts]]$angle*0.7,tree$states[[ts]]$angle),0)
      return(tree)
    },
    a8=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(runif(1,tree$states[[ts]]$angle*0.7,tree$states[[ts]]$angle),0,0)
      return(tree)
    },
    a9=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0-c(runif(1,tree$states[[ts]]$angle*0.7,tree$states[[ts]]$angle),0,0)
      return(tree)
    },
    a10=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(0, 0,runif(1,tree$states[[ts]]$angle2*0.7,tree$states[[ts]]$angle2))
      return(tree)
    },
    a11=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0=tree$states[[ts]]$angle0-c(0,0,runif(1,tree$states[[ts]]$angle2*0.7,tree$states[[ts]]$angle2))
      return(tree)
    },
    a12=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(0,runif(1,tree$states[[ts]]$angle2*0.7,tree$states[[ts]]$angle2),0)
      return(tree)
    },
    a13=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0-c(0,runif(1,tree$states[[ts]]$angle2*0.7,tree$states[[ts]]$angle2),0)
      return(tree)
    },
    a14=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(runif(1,tree$states[[ts]]$angle2*0.7,tree$states[[ts]]$angle2),0,0)
      return(tree)
    },
    a15=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0-c(runif(1,tree$states[[ts]]$angle2*0.7,tree$states[[ts]]$angle2),0,0)
      return(tree)
    },
    a16=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(pi,pi,pi)
      return(tree)
    },
    a17=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0+c(runif(1,tree$states[[ts]]$angle3*0.8,tree$states[[ts]]$angle3),0,0)
      return(tree)
    },
    a18=function(tree){
      return(tree)
    },
    a19=function(tree){
      ts=length(tree$states)
      origin=tree$states[[ts]]$origin
      angle=tree$states[[ts]]$angle0
      new_branch = term_leaf(density=5,size1=0.8,size2=2,center=origin,angle=angle)
      tree$out = rbind(tree$out,new_branch)
      return(tree)
    },
    a20=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$size1=tree$states[[ts]]$size1*(tree$states[[ts]]$factor1+rnorm(1,0,0.1))
      tree$states[[ts]]$size2=tree$states[[ts]]$size2*(tree$states[[ts]]$factor2+rnorm(1,0,0.1))
      return(tree)
    },
    a21=function(tree){
      ts=length(tree$states)
      tree$states[[ts]]$angle0 = tree$states[[ts]]$angle0-runif(3,-0.5,0.5)
      return(tree)
    }
  )
)


produce = function(instructions,alfabet,origin=c(0,0,0),
                   factor1=0.95,
                   factor2=0.95,
                   size1=2,
                   size2=5,
                   density=2,
                   angle=pi/6,
                   angle2=pi/8,
                   angle3=pi/2.5){
  states=list()
  angle0=c(0,0,0)
  states[[1]]=list(origin=origin,
                   size1=size1,
                   size2=size2,
                   angle=angle,
                   angle2=angle2,
                   angle3=angle3,
                   angle0=angle0,
                   factor1=factor1,
                   factor2=factor2,
                   density=density)
  
  out=data.frame(x=origin[1],
                 y=origin[2],
                 z=origin[3],
                 class=0)
  tree=list(states=states,out=out)
  for(i in seq_len(length(instructions))){
    for(j in seq_len(length(alfabet$names))){
      if(instructions[i]==alfabet$names[[j]]){
        tree=alfabet$actions[[j]](tree)
      }
    }
  }
  return(tree)
}










