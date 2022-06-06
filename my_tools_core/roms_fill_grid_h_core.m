function roms_fill_grid_h_core
    configs
    netcdf_load(roms.input.grid)
    netcdf_load(roms.res.ETOPO1_Bed_c_gmt4)
    xl=roms.grid.longitude(1); xr=roms.grid.longitude(2);
    yb= roms.grid.latitude(1); yt= roms.grid.latitude(2);
    numx=roms.grid.size(1)+1; numy=roms.grid.size(2)+1;
    dx=(xr-xl)/numx; dy=(yt-yb)/numy; %x和y的分辨率
    [lon, lat]=meshgrid(xl:dx:xr, yb:dy:yt);

    %[x2,y2]=meshgrid(x((179+xl)*60:(181+xr)*60),y((89+yb)*60:(91+yt)*60));
    %z2=-z((179+xl)*60:(181+xr)*60,(89+yb)*60:(91+yt)*60)';hx1=find(x>xl,1)-1; hx2=find(x<xr,1,'last')+1;
    hx1=find(x>xl,1)-1; hx2=find(x<xr,1,'last')+1;
    hy1=find(y>yb,1)-1; hy2=find(y<yt,1,'last')+1;
    [x2,y2]=meshgrid(x(hx1:hx2),y(hy1:hy2));
    z2=-z(hx1:hx2,hy1:hy2)';
    z2(z2<1)=roms.grid.Tcline;
    h=griddata(x2,y2,z2,lon_rho,lat_rho);
    %vq = griddata(x,y,v,xq,yq) 使 v = f(x,y) 形式的曲面与向量 (x,y,v) 中的散点数据拟合。griddata 函数在 (xq,yq) 指定的查询点对曲面进行插值并返回插入的值 vq。曲面始终穿过 x 和 y 定义的数据点。
    %进行一定的平滑
    h(2:end-1,2:end-1)=0.2*(h(1:end-2,2:end-1)+h(2:end-1,2:end-1)+h(3:end,2:end-1)+h(2:end-1,1:end-2)+h(2:end-1,3:end));
    h(mask_rho==0)=1;
    ncwrite(roms.input.grid,'h',h);
    %下面都是画图
    figure
    pcolorjw(lon_rho,lat_rho,h)
    hold on
    plot(lon,lat,'k')
    caxis([0,max(h(:))]); colorbar
end