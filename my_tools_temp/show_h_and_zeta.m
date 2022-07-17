nc="C:\Users\autod\Desktop\ocean_rst.nc";
netcdf_load(nc);
[xi,eta]=size(h);
y=59 ;
clf
figure(1);
hold on
h2=-h(:,y);
h2(mask_rho(:,y)==0)=0;
zeta2=zeta(:,y,end);
zeta2(mask_rho(:,y)==0)=0;
u2=u(:,y,end,end);
x=[lon_rho(:,y)',lon_rho(end,y),lon_rho(1,y)];
fill(x,[h2',min(h2)-2,min(h2)-2],'b')
fill(x,[zeta2',0,0],'r')
x=lon_u(:,y);
plot(x,u2);
xlim([lon_rho(1,y),lon_rho(end,y)])
ylim([min(h2)-2,max(zeta2)+2])
legend("地形","海面高度","东西方向速度")



figure(2);
clf
hold on
zeta2=zeta(:,:,end)';
zeta2(mask_rho'==0)=nan;
h2=-h';
h2(mask_rho'==0)=nan;
surface(lon_rho',lat_rho',zeta2);
surface(lon_rho',lat_rho',h2)
xlim([min(lon_rho(:)),max(lon_rho(:))])
ylim([min(lat_rho(:)),max(lat_rho(:))])
legend("地形","海面高度")