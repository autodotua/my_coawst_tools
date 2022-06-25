function hycom_info=get_hycom_info(file,roms_grid_info,xvar,yvar,zvar)
    lon=ncread(file,xvar);
    lat=ncread(file,yvar);
    lat=lat';
    depth=ncread(file,zvar);
    lon(lon>=180)=(lon(lon>=180)-360);
    xl=min(min(roms_grid_info.lon_rho));xr=max(max(roms_grid_info.lon_rho));
    yb=min(min(roms_grid_info.lat_rho));yt=max(max(roms_grid_info.lat_rho));


    lon_indexs = find(lon>=xl & lon<=xr);
    lat_indexs = find(lat>=yb & lat<=yt);
    %
    % Now just take one more to the left and right
    %
    lon_index1=min(lon_indexs)-1;
    lon_index2=max(lon_indexs)+1;
    lat_index1=min(lat_indexs)-1;
    lat_index2=max(lat_indexs)+1;

    lon_index1 = max(lon_index1, 1);
    lat_index1 = max(lat_index1, 1);
    lon_index2 = min(lon_index2, length(lat));
    lat_index2 = min(lat_index2, length(lon));

    hycom_info.lons=double(lon(lon_index1:lon_index2));
    hycom_info.lats=double(lat(lat_index1:lat_index2));
    hycom_info.depths=double(depth);
    hycom_info.lon_index1=lon_index1;
    hycom_info.lon_index2=lon_index2;
    hycom_info.lat_index1=lat_index1;
    hycom_info.lat_index2=lat_index2;
end
