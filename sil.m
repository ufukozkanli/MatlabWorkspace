load coast
axesm('eqaconic','MapLatLimit',[30 60],'MapLonLimit',[-10 10])
framem; plotm(lat,long)
lat0 = [50 39.7 0 0]; lon0 = [-5.4 2.9 0 0];
u = [5 5]; v = [3 3];
quiverm(lat0,lon0,u,v,'r')