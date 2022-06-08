function roms_fill_grid_h_core
    configs
    netcdf_load(roms.input.grid)
    [~,~,dem_lon2,dem_lat2,dem_alt]=roms_get_grid_details(roms);

    z2=-dem_alt; %高度变为深度
    z2(z2<roms.grid.Tcline)=roms.grid.Tcline; %设置最小深度
    h=griddata(dem_lon2,dem_lat2,z2,lon_rho,lat_rho); %将DEM插值到ROMS网格
    h(2:end-1,2:end-1)= ...
        0.2*(h(1:end-2,2:end-1) ...
        +h(2:end-1,2:end-1) ...
        +h(3:end,2:end-1) ...
        +h(2:end-1,1:end-2) ...
        +h(2:end-1,3:end)); %进行一定的平滑
    h(mask_rho==0)=roms.grid.Tcline; %将陆地点高程设置为Tcline
    ncwrite(roms.input.grid,'h',h);
    %下面都是画图
    figure
    pcolorjw(lon_rho,lat_rho,h)
    hold on
    caxis([0,max(h(:))]); colorbar
end