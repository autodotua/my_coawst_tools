function roms_create_force_NCEP

    tic
    configs
    cd(roms.project_dir)

    time_start = datenum(roms.time.start);
    time_end   = datenum(roms.time.stop);

    %确定网格
    if roms.res.force_ncep_resolution==0
        model_grid = roms.input.grid;
        lon_rho = ncread(model_grid,'lon_rho');
        lat_rho = ncread(model_grid,'lat_rho');
        angle_rho = ncread(model_grid,'angle');
    else
        d=roms.res.force_ncep_resolution;
        roms_lon=ncread(roms.input.grid,'lon_rho');
        rom_lat=ncread(roms.input.grid,'lat_rho');
        lon_rho=[min(roms_lon(:)):d:max(roms_lon(:))];
        lat_rho=[min(rom_lat(:)):d:max(rom_lat(:))];
        lon_rho=[lon_rho,lon_rho(end)*2-lon_rho(end-1)];
        lat_rho=[lat_rho,lat_rho(end)*2-lat_rho(end-1)];
        lon_rho = repmat(lon_rho,size(lat_rho,2),1)';
        lat_rho = repmat(lat_rho',1,size(lon_rho,1))';
        angle_rho = lon_rho*0;
    end

    level=1; %用师兄的代码跑不了，发现部分变量好像有好几层，所以加了一个选第一层的代码。

    [Lp,Mp] = size(lon_rho);

    times = [time_start:roms.res.force_ncep_step/24:time_end] - datenum(roms.time.base);
    ntimes = length(times);

    %创建nc
    nc = netcdf.create(roms.input.force,'nc_clobber');

    netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'type', 'bulk fluxes forcing file');
    netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'gridid','combined grid');
    netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'history',['Created by "' mfilename '" on ' datestr(now)]);

    lon_dimID = netcdf.defDim(nc,'xr',Lp);
    lat_dimID = netcdf.defDim(nc,'er',Mp);
    t_dimID = netcdf.defDim(nc,'time',ntimes);

    tID = netcdf.defVar(nc,'time','double',t_dimID);
    netcdf.putAtt(nc,tID,'long_name','atmospheric forcing time');
    netcdf.putAtt(nc,tID,'units','days');
    netcdf.putAtt(nc,tID,'field','time, scalar, series');

    lonID = netcdf.defVar(nc,'lon','double',[lon_dimID lat_dimID]);
    netcdf.putAtt(nc,lonID,'long_name','longitude');
    netcdf.putAtt(nc,lonID,'units','degrees_east');
    netcdf.putAtt(nc,lonID,'field','xp, scalar, series');

    latID = netcdf.defVar(nc,'lat','double',[lon_dimID lat_dimID]);
    netcdf.putAtt(nc,latID,'long_name','latitude');
    netcdf.putAtt(nc,latID,'units','degrees_north');
    netcdf.putAtt(nc,latID,'field','yp, scalar, series');


    UwindID = netcdf.defVar(nc,'Uwind','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,UwindID,'long_name','surface u-wind component');
    netcdf.putAtt(nc,UwindID,'units','meter second-1');
    netcdf.putAtt(nc,UwindID,'field','Uwind, scalar, series');
    netcdf.putAtt(nc,UwindID,'coordinates','lon lat');
    netcdf.putAtt(nc,UwindID,'time','time');

    VwindID = netcdf.defVar(nc,'Vwind','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,VwindID,'long_name','surface v-wind component');
    netcdf.putAtt(nc,VwindID,'units','meter second-1');
    netcdf.putAtt(nc,VwindID,'field','Vwind, scalar, series');
    netcdf.putAtt(nc,VwindID,'coordinates','lon lat');
    netcdf.putAtt(nc,VwindID,'time','time');


    PairID = netcdf.defVar(nc,'Pair','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,PairID,'long_name','surface air pressure');
    netcdf.putAtt(nc,PairID,'units','millibar');
    netcdf.putAtt(nc,PairID,'field','Pair, scalar, series');
    netcdf.putAtt(nc,PairID,'coordinates','lon lat');
    netcdf.putAtt(nc,PairID,'time','time');

    TairID = netcdf.defVar(nc,'Tair','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,TairID,'long_name','surface air temperature');
    netcdf.putAtt(nc,TairID,'units','Celsius');
    netcdf.putAtt(nc,TairID,'field','Tair, scalar, series');
    netcdf.putAtt(nc,TairID,'coordinates','lon lat');
    netcdf.putAtt(nc,TairID,'time','time');

    QairID = netcdf.defVar(nc,'Qair','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,QairID,'long_name','surface air relative humidity');
    netcdf.putAtt(nc,QairID,'units','percentage');
    netcdf.putAtt(nc,QairID,'field','Qair, scalar, series');
    netcdf.putAtt(nc,QairID,'coordinates','lon lat');
    netcdf.putAtt(nc,QairID,'time','time');

    rainID = netcdf.defVar(nc,'rain','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,rainID,'long_name','rain fall rate');
    netcdf.putAtt(nc,rainID,'units','kilogram meter-2 second-1');
    netcdf.putAtt(nc,rainID,'field','rain, scalar, series');
    netcdf.putAtt(nc,rainID,'coordinates','lon lat');
    netcdf.putAtt(nc,rainID,'time','time');

    swradID = netcdf.defVar(nc,'swrad','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,swradID,'long_name','net solar shortwave radiation');
    netcdf.putAtt(nc,swradID,'units','Watts meter-2');
    netcdf.putAtt(nc,swradID,'positive_value','downward flux, heating');
    netcdf.putAtt(nc,swradID,'negative_value','upward flux, cooling');
    netcdf.putAtt(nc,swradID,'field','swrad, scalar, series');
    netcdf.putAtt(nc,swradID,'coordinates','lon lat');
    netcdf.putAtt(nc,swradID,'time','time');

    lwradID = netcdf.defVar(nc,'lwrad','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,lwradID,'long_name','net downward solar longwave radiation');
    netcdf.putAtt(nc,lwradID,'units','Watts meter-2');
    netcdf.putAtt(nc,lwradID,'positive_value','downward flux, heating');
    netcdf.putAtt(nc,lwradID,'negative_value','upward flux, cooling');
    netcdf.putAtt(nc,lwradID,'field','lwrad, scalar, series');
    netcdf.putAtt(nc,lwradID,'coordinates','lon lat');
    netcdf.putAtt(nc,lwradID,'time','time');

    lwradID = netcdf.defVar(nc,'lwrad_down','double',[lon_dimID lat_dimID t_dimID]);
    netcdf.putAtt(nc,lwradID,'long_name','downward solar longwave radiation');
    netcdf.putAtt(nc,lwradID,'units','Watts meter-2');
    netcdf.putAtt(nc,lwradID,'positive_value','downward flux, heating');
    netcdf.putAtt(nc,lwradID,'negative_value','upward flux, cooling');
    netcdf.putAtt(nc,lwradID,'field','lwrad_down, scalar, series');
    netcdf.putAtt(nc,lwradID,'coordinates','lon lat');
    netcdf.putAtt(nc,lwradID,'time','time');
    netcdf.close(nc)

    %预分配
    fill = zeros([size(lon_rho),ntimes]);
    lwrad = fill;
    lwrad_down = fill;
    swrad = fill;
    rain = fill;
    Tair = fill;
    Pair = fill;
    Qair = fill;
    Uwind = fill;
    Vwind = fill;

    %生成网格
    time = datestr(times(1) + datenum(roms.time.base),'yyyymmddTHHMMSS');
    file = fullfile(roms.res.force_ncep_dir, "fnl_"+string(time(1:8))+"_"+string(time(10:11))+"_"+string(time(12:13))+".grib2");
    geo = ncgeodataset(char(file));
    [nlon,nlat] = meshgrid(double(geo{'lon'}(:)),double(geo{'lat'}(:)));
    nlon=rot90(nlon,-1) ;
    nlat=rot90(nlat,-1);
    close(geo);

    %开始处理
    for t = 1:ntimes
        time = datestr(times(t) + datenum(roms.time.base),'yyyymmddTHHMMSS');
        file = fullfile(roms.res.force_ncep_dir, "fnl_"+string(time(1:8))+"_"+string(time(10:11))+"_"+string(time(12:13))+".grib2");
        disp(['正在处理：',time])
        geo = ncgeodataset(char(file));

        %插值
        Tair(:,:,t)=get_value(geo,'Temperature_height_above_ground',nlon,nlat,lon_rho,lat_rho, ...
            {@(var) var - 273.15,@(var) var(:,level,:)});
        Pair(:,:,t)=get_value(geo,'Pressure_surface',nlon,nlat,lon_rho,lat_rho, ...
            {@(var) var*0.01});
        Qair(:,:,t)=get_value(geo,'Relative_humidity_height_above_ground',nlon,nlat,lon_rho,lat_rho,{});
        Uwind(:,:,t)=get_value(geo,'U-component_of_wind_height_above_ground',nlon,nlat,lon_rho,lat_rho, ...
            {@(var) var(:,level,:)});
        Vwind(:,:,t)=get_value(geo,'V-component_of_wind_height_above_ground',nlon,nlat,lon_rho,lat_rho, ...
            {@(var) var(:,level,:)});
        %注意，由于rain变量Precipitable_water有问题，因此没有处理，直接赋值为0。

        %因为考虑到ROMS网格可能是那种不规则网格，所以需要进行旋转
        u = Uwind(:,:,t).*cos(angle_rho) + Vwind(:,:,t).*sin(angle_rho);
        v = Vwind(:,:,t).*cos(angle_rho) - Uwind(:,:,t).*sin(angle_rho);
        Uwind(:,:,t) = u;
        Vwind(:,:,t) = v;
        close(geo);
    end
    %异常值处理
    Tair(Tair<-100) = 0;
    Pair(Pair<0) = 0;
    Qair(Qair<0) = 0;
    Uwind(Uwind<-100) = 0;
    Vwind(Vwind<-100) = 0;
    rain(rain<0) = 0;
    rain(:)=0;
    %写入数据
    nc = roms.input.force;
    ncwrite(roms.input.force,'lon',lon_rho);
    ncwrite(roms.input.force,'lat',lat_rho);
    ncwrite(roms.input.force,'time',times);
    ncwrite(nc,'lwrad',lwrad);
    ncwrite(nc,'lwrad_down',lwrad_down);
    ncwrite(nc,'swrad',swrad);
    ncwrite(nc,'rain',rain);
    ncwrite(nc,'Tair',Tair);
    ncwrite(nc,'Pair',Pair);
    ncwrite(nc,'Qair',Qair);
    ncwrite(nc,'Uwind',Uwind);
    ncwrite(nc,'Vwind',Vwind);

    %删除临时文件
    %d=cd(roms.res.force_ncep_dir);
    %!del *.gbx8
    %cd(d);
    toc
end

function result=get_value(geo,var_name,nlon,nlat,lon_rho,lat_rho,var_funcs)
    %插值
    var = double(squeeze(geo{var_name}(:)));
    var = rot90(var,-1);
    for func=var_funcs
        var=func{1}(var);
    end
    F = scatteredInterpolant(nlon(:),nlat(:),var(:));
    result = F(lon_rho,lat_rho);
    result(isnan(result)) = 0;
end
