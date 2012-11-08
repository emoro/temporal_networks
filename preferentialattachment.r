library(igraph)

#load the edges with time stamp
#there are three columns in edges: id1,id2,time
edges <- read.table("edges.csv",header=T)

#generate the full graph
g <- graph.edgelist(as.matrix(edges[,c(1,2)]),directed=F)
E(g)$time <- edges[,3]

#generate a cool palette for the graph
YlOrBr <- c("#FFFFD4", "#FED98E", "#FE9929", "#D95F0E", "#993404")
YlOrBr.Lab <- colorRampPalette(YlOrBr, space = "Lab")
#colors for the nodes are chosen from the very beginning
vcolor <- rev(YlOrBr.Lab(vcount(g)))

#time in the edges goes from 1 to 300. We kick off at time 3
ti <- 3
#weights of edges formed up to time ti is 1. Future edges are weighted 0
E(g)$weight <- ifelse(E(g)$time < ti,1,0)
#generate first layout using weights.
layout.old <- layout.fruchterman.reingold(g,params=list(weights=E(g)$weight))

#This is the time interval for the animation. In this case is taken to be 1/10 
#of the time (i.e. 10 snapshots) between adding two consecutive nodes 
dt <- 0.1
#Output for each frame will be a png with HD size 1600x900 :)
png(file="example%03d.png", width=1600,height=900)

#Time loop starts
for(ti in seq(4,npasos,dt)){
  #define weight for edges present up to time ti.
  E(g)$weight <- ifelse(E(g)$time < ti,1,0) 
  #Edges with non-zero weight are in gray. The rest are transparent
  E(g)$color <- ifelse(E(g)$time < ti,"gray",rgb(0,0,0,0))
  #Nodes with at least a non-zero weighted edge are in color. The rest are transparent
  V(g)$color <- ifelse(graph.strength(g)==0,rgb(0,0,0,0),vcolor)
  #given the new weights, we update the layout a little bit
  layout.new <- layout.fruchterman.reingold(g,params=list(niter=10,start=layout.old,weights=E(g)$weight,maxdelta=1))
  #plot the new graph
  plot(g,layout=layout.new,vertex.label="",vertex.size=1+2*log(graph.strength(g)),vertex.frame.color=V(g)$color,edge.width=1.5,asp=9/16,margin=-0.15)
  #use the new layout in the next round
  layout.old <- layout.new 
}
dev.off()
