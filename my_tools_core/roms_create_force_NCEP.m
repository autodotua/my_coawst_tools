function roms_create_force_NCEP
    %   script ncep_fnl_2roms.m
    %
    %   input choices-  3hour NAM 12km data grib files
    %                   3hour NARR 32 km grib files
    %                   3hour GFS  0.5 deg grib files
    %                   can combine and interpolate to a common grid
    %                   all data is read thru THREDDs from:
    %                   https://www.ncei.noaa.gov/thredds/model/model.html
    %
    %   user selects:   - time interval
    %                   - spatial interval [roms grid or generic grid]
    %                   - variables to include
    %                   - to get 1) NAM and/or NARR, -- or -- 2) GFS
    %                   NAM seems to be from  2017 to present
    %                   NARR and GFS seem to be for longer time periods.
    %                   Please check the data is available for your time period!
    %
    %                   - use of 1) matlab native ncread -- or -- 2) nctoolbox
    %
    %   output-     ROMS netcdf forcing file
    %
    %   needs-      - native matlab netcdf to create a forcing file for ROMS.
    %               - native matlab to read opendap
    %               - optional: nctoolbox to read opendap
    %                 see: https://github.com/nctoolbox/nctoolbox for
    %                 installation and setup instructions
    %
    %   Example of options to be used in project.h
    %   # define BULK_FLUXES
    %   # define ANA_BTFLUX
    %   # define ANA_BSFLUX
    %   # define ATM_PRESS
    %   # define EMINUSP
    %   # define SOLAR_SOURCE
    % 1858-11-17: Modified JD简化儒略日
    % 24Sept2014 - jcwarner convert from Alfredo's + several others.
    % 19Sept2016 - jcwarner add GFS read option
    %                       add rotation of NAM and NARR from Lamb Conf to Lat Lon.
    %
    % 1Nov2017 - chegermiller update base url at lines to reflect use of NCEI server
    %            instead of NOMADS server
    % 2Nov2017 - chegermiller notes would be good to add try catch statement at urls to account for
    %            the potential for .grb or .grb2
    %            For newer files, slight change of variable names, might fail
    %            there too
    % 9Nov2017 - chegermiller adds nctoolbox option based on Maitane's edits
    %
    % 2Nov2017 - chegermiller NOTE: for older matlab versions, this still might fail because
    % ncread is looking for http: to indicate an OPeNDAP file. Here, the server
    % is now https:

    %%%%%%%%%%%%%%%%%%%%%%%%%%  START OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%
    configs
    cd(roms.project_dir)
    % (1) 选择想要输出到ROMS强迫场的变量.
    % put a '1' if you want to include it, '0' otherwise.
    % 1/0              Var description (Units)
    get_lwrad = 1;    % gets downward and upward longwave and computes net flux of down-up (W/m2)
    % this will also store lwrad_down so you can use LONGWAVE option.
    get_swrad = 1;    % gets downward and updward shortwave and computes net down-up flux (W/m2)
    get_rain  = 1;    % precipitation rate (kg/m2/s) at surface
    get_Tair  = 1;    % surface air temperature (C) at 2m
    get_Pair  = 1;    % pressure reduce to MSL (Pa)
    get_Qair  = 1;    % relative_humidity (percent) at 2m
    get_Wind  = 1;    % surface u- and v- winds (m/s) at 10m


    % (3) 风场强迫文件的开始时间和结束时间
    time_start = datenum(roms.time.start);
    time_end   = datenum(roms.time.stop);

    % (4) Select which data to obtain: NAM, NARR, both NAM+NARR -- or -- GFS.
    % ONLY ——NCEP fnl grb2 !!!!
    % NCEP is 6 hr data
    get_NCEP = 1;

    % (5) Select to interpolate to a roms grid or a user defined grid.
    % Set one of these to a 1, the other to a 0.
    interpto_roms_grid = 0;
    interpto_user_grid = 1;

    % The code has been written so that longitude is in -deg E.
    if interpto_roms_grid
        model_grid = 'C:\models\grids\USEast_grd31.nc';
    elseif interpto_user_grid
        if (get_NCEP);  offset=0;    end

        % 如果你想要更精细的分辨率从0.2可以调到0.1，单位是度.
        d=0.1;
        lon_rho=ncread(roms.input.grid,'lon_rho');
        lat_rho=ncread(roms.input.grid,'lat_rho');
        lon_rho=[min(lon_rho(:)):d:max(lon_rho(:))];
        lat_rho=[min(lat_rho(:)):d:max(lat_rho(:))];
        lon_rho=[lon_rho,lon_rho(end)*2-lon_rho(end-1)];
        lat_rho=[lat_rho,lat_rho(end)*2-lat_rho(end-1)];
        %lon_rho = [roms.grid.longitude(1):d:roms.grid.longitude(2)]+offset;
        %lat_rho = [ roms.grid.latitude(1):d:roms.grid.latitude(2) ];
        lon_rho = repmat(lon_rho,size(lat_rho,2),1)';
        lat_rho = repmat(lat_rho',1,size(lon_rho,1))';
        angle_rho = lon_rho*0;
    else
        disp('你还没有选择网格，请选择网格');
    end

    % (6) Select which method to use: ncread or nctoolbox
    %你没得选，要读取grib2文件只能使用nctoolbox
    % use_matlab = 0;
    use_nctoolbox = 1;

    level=1; %用师兄的代码跑不了，发现部分变量好像有好几层，所以加了一个选第一层的代码。

    %%%%%%%%%%%%%%%%%%%%%%%%%%%  END OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%%

    if use_nctoolbox

        %用nctoolbox别忘了，先setup_nctoolbox
    end

    % determine the grid to interpolate to
    if interpto_roms_grid
        lon_rho = ncread(model_grid,'lon_rho');
        lat_rho = ncread(model_grid,'lat_rho');
        angle_rho = ncread(model_grid,'angle');
    end

    [Lp,Mp] = size(lon_rho);

    % determine date range（确定强迫场time的时间基准，时间步长，时间范围）
    time = [time_start:6/24:time_end] - datenum(1858,11,17,0,0,0);
    ntimes = length(time);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create NetCDF file for forcing data
    disp([' ## 正在创建 ' roms.input.force '...'])
    nc = netcdf.create(roms.input.force,'nc_clobber');

    % global variables
    netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'type', 'bulk fluxes forcing file');
    netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'gridid','combined grid');
    netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'history',['Created by "' mfilename '" on ' datestr(now)]);

    % dimensions
    disp(' ## Defining Dimensions...')
    lon_dimID = netcdf.defDim(nc,'xr',Lp);
    lat_dimID = netcdf.defDim(nc,'er',Mp);
    t_dimID = netcdf.defDim(nc,'time',ntimes);

    % variables and attributes
    disp(' ## Defining Variables and Attributes...')

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

    if get_Wind
%         wt_dimID = netcdf.defDim(nc,'wind_time',ntimes);
%         wtID = netcdf.defVar(nc,'wind_time','double',wt_dimID);
%         netcdf.putAtt(nc,wtID,'long_name','wind_time');
%         netcdf.putAtt(nc,wtID,'units','days');
%         %改为你的ROMS时间基准，下面的都要注意
%         netcdf.putAtt(nc,wtID,'field','wind_time, scalar, series');

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
    end

    if get_Pair
%         Pat_dimID = netcdf.defDim(nc,'pair_time',ntimes);
%         PatID = netcdf.defVar(nc,'pair_time','double',Pat_dimID);
%         netcdf.putAtt(nc,PatID,'long_name','pair_time');
%         netcdf.putAtt(nc,PatID,'units','days since 1858-11-17 00:00:00 UTC');
%         netcdf.putAtt(nc,PatID,'field','pair_time, scalar, series');

        PairID = netcdf.defVar(nc,'Pair','double',[lon_dimID lat_dimID t_dimID]);
        netcdf.putAtt(nc,PairID,'long_name','surface air pressure');
        netcdf.putAtt(nc,PairID,'units','millibar');
        netcdf.putAtt(nc,PairID,'field','Pair, scalar, series');
        netcdf.putAtt(nc,PairID,'coordinates','lon lat');
        netcdf.putAtt(nc,PairID,'time','time');
    end

    if get_Tair
%         Tat_dimID = netcdf.defDim(nc,'tair_time',ntimes);
%         TatID = netcdf.defVar(nc,'tair_time','double',Tat_dimID);
%         netcdf.putAtt(nc,TatID,'long_name','tair_time');
%         netcdf.putAtt(nc,TatID,'units','days since 1858-11-17 00:00:00 UTC');
%         netcdf.putAtt(nc,TatID,'field','tair_time, scalar, series');

        TairID = netcdf.defVar(nc,'Tair','double',[lon_dimID lat_dimID t_dimID]);
        netcdf.putAtt(nc,TairID,'long_name','surface air temperature');
        netcdf.putAtt(nc,TairID,'units','Celsius');
        netcdf.putAtt(nc,TairID,'field','Tair, scalar, series');
        netcdf.putAtt(nc,TairID,'coordinates','lon lat');
        netcdf.putAtt(nc,TairID,'time','time');
    end

    if get_Qair
%         Qat_dimID = netcdf.defDim(nc,'qair_time',ntimes);
%         QatID = netcdf.defVar(nc,'qair_time','double',Qat_dimID);
%         netcdf.putAtt(nc,QatID,'long_name','qair_time');
%         netcdf.putAtt(nc,QatID,'units','days since 1858-11-17 00:00:00 UTC');
%         netcdf.putAtt(nc,QatID,'field','qair_time, scalar, series');

        QairID = netcdf.defVar(nc,'Qair','double',[lon_dimID lat_dimID t_dimID]);
        netcdf.putAtt(nc,QairID,'long_name','surface air relative humidity');
        netcdf.putAtt(nc,QairID,'units','percentage');
        netcdf.putAtt(nc,QairID,'field','Qair, scalar, series');
        netcdf.putAtt(nc,QairID,'coordinates','lon lat');
        netcdf.putAtt(nc,QairID,'time','time');
    end

    if get_rain
%         rt_dimID = netcdf.defDim(nc,'rain_time',ntimes);
%         rtID = netcdf.defVar(nc,'rain_time','double',rt_dimID);
%         netcdf.putAtt(nc,rtID,'long_name','rain_time');
%         netcdf.putAtt(nc,rtID,'units','days since 1858-11-17 00:00:00 UTC');
%         netcdf.putAtt(nc,rtID,'field','rain_time, scalar, series');

        rainID = netcdf.defVar(nc,'rain','double',[lon_dimID lat_dimID t_dimID]);
        netcdf.putAtt(nc,rainID,'long_name','rain fall rate');
        netcdf.putAtt(nc,rainID,'units','kilogram meter-2 second-1');
        netcdf.putAtt(nc,rainID,'field','rain, scalar, series');
        netcdf.putAtt(nc,rainID,'coordinates','lon lat');
        netcdf.putAtt(nc,rainID,'time','time');
    end

    if get_swrad
%         swrt_dimID = netcdf.defDim(nc,'srf_time',ntimes);
%         swrtID = netcdf.defVar(nc,'srf_time','double',swrt_dimID);
%         netcdf.putAtt(nc,swrtID,'long_name','srf_time');
%         netcdf.putAtt(nc,swrtID,'units','days since 1858-11-17 00:00:00 UTC');
%         netcdf.putAtt(nc,swrtID,'field','srf_time, scalar, series');

        swradID = netcdf.defVar(nc,'swrad','double',[lon_dimID lat_dimID t_dimID]);
        netcdf.putAtt(nc,swradID,'long_name','net solar shortwave radiation');
        netcdf.putAtt(nc,swradID,'units','Watts meter-2');
        netcdf.putAtt(nc,swradID,'positive_value','downward flux, heating');
        netcdf.putAtt(nc,swradID,'negative_value','upward flux, cooling');
        netcdf.putAtt(nc,swradID,'field','swrad, scalar, series');
        netcdf.putAtt(nc,swradID,'coordinates','lon lat');
        netcdf.putAtt(nc,swradID,'time','time');
    end

    if get_lwrad
%         lwrt_dimID = netcdf.defDim(nc,'lrf_time',ntimes);
%         lwrtID = netcdf.defVar(nc,'lrf_time','double',lwrt_dimID);
%         netcdf.putAtt(nc,lwrtID,'long_name','lrf_time');
%         netcdf.putAtt(nc,lwrtID,'units','days since 1858-11-17 00:00:00 UTC');
%         netcdf.putAtt(nc,lwrtID,'field','lrf_time, scalar, series');

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
    end
    netcdf.close(nc)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % write lon and lat
    ncwrite(roms.input.force,'lon',lon_rho);
    ncwrite(roms.input.force,'lat',lat_rho);
    ncwrite(roms.input.force,'time',time);

    % pre allocate some arrays
    fill = zeros([size(lon_rho) ntimes]);

    if get_lwrad
        lwrad = fill;
        lwrad_down = fill;
    end
    if get_swrad
        swrad = fill;
    end
    if get_rain
        rain = fill;
    end
    if get_Tair
        Tair = fill;
    end
    if get_Pair
        Pair = fill;
    end
    if get_Qair
        Qair = fill;
    end
    if get_Wind
        Uwind = fill;
        Vwind = fill;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('getting NCEP fnl grib2 data');

    for mm = 1:ntimes
        dd = datestr(time(mm) + datenum(1858,11,17,0,0,0),'yyyymmddTHHMMSS');
        url = fullfile(roms.res.force_ncep_dir, ['fnl_',dd(1:8),'_',dd(10:11),'_',dd(12:13),'.grib2']);
        url=char(url);
        disp(['正在处理：',dd,])

        if use_nctoolbox
            geo = ncgeodataset(url);
        end


        if mm == 1
            x = double(geo{'lon'}(:));
            y = double(geo{'lat'}(:));
            [nlon,nlat] = meshgrid(x,y);
            %nlon=nlon.'; nlat=nlat.';
            nlon=rot90(nlon,-1) ; nlat=rot90(nlat,-1);
        end
        if get_lwrad && mm == 1
            % down = double(ncread(url,'Downward_Long-Wave_Rad_Flux')).';
            % up   = double(ncread(url,'Upward_Long-Wave_Rad_Flux_surface')).';
            % var  = down-up;
            % F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            % cff = F(lon_rho,lat_rho);
            % cff(isnan(cff)) = 0;
            % lwrad(:,:,mm) = cff;

            % F = scatteredInterpolant(nlon(:),nlat(:),down(:));
            % cff = F(lon_rho,lat_rho);
            % cff(isnan(cff)) = 0;
            % lwrad_down(:,:,mm) = cff;
            disp('lwrad is not available for NCEP_fnl,I can,t find it!');
        end
        if get_swrad && mm == 1
            % down = double(ncread(url,'Downward_Short-Wave_Rad_Flux')).';
            % up   = double(ncread(url,'Upward_Short-Wave_Rad_Flux_surface')).';
            % var  = down-up;
            % F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            % cff = F(lon_rho,lat_rho);
            % cff(isnan(cff)) = 0;
            % swrad(:,:,mm) = cff;
            disp('swrad is not available for NCEP_fnl,I can,t find it!');
        end
        if get_rain && mm == 1
            var = double(geo{'Precipitable_water'}(:));
            var = squeeze(var);
            var = rot90(var,-1);

            F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            cff = F(lon_rho,lat_rho);
            cff(isnan(cff)) = 0;
            rain(:,:,mm) = cff;
        end
        if get_Tair
            var = double(squeeze(geo{'Temperature_height_above_ground'}(:)));
            var = rot90(var,-1);

            var = var - 273.15; % K to ℃
            var=var(:,level,:);
            F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            cff = F(lon_rho,lat_rho);
            cff(isnan(cff)) = 0;
            Tair(:,:,mm) = cff;
        end
        if get_Pair

            var = double(squeeze(geo{'Pressure_surface'}(:)));
            var = rot90(var,-1);

            var = var*0.01;
            F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            cff = F(lon_rho,lat_rho);
            cff(isnan(cff)) = 0;
            Pair(:,:,mm) = cff;
        end
        if get_Qair
            var = double(squeeze(geo{'Relative_humidity_height_above_ground'}(:)));
            var = rot90(var,-1);

            F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            cff = F(lon_rho,lat_rho);
            cff(isnan(cff)) = 0;
            Qair(:,:,mm) = cff;
        end
        if get_Wind

            var = double(squeeze(geo{'U-component_of_wind_height_above_ground'}(:)));
            var = rot90(var,-1);
            var=var(:,level,:);
            F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            cff = F(lon_rho,lat_rho);
            cff(isnan(cff)) = 0;
            Uwind_ll = cff;

            var = double(squeeze(geo{'V-component_of_wind_height_above_ground'}(:)));
            var = rot90(var,-1);

            var=var(:,level,:);
            F = scatteredInterpolant(nlon(:),nlat(:),var(:));
            cff = F(lon_rho,lat_rho);
            cff(isnan(cff)) = 0;
            Vwind_ll = cff;

            % rotate winds to ROMS or user grid
            %因为考虑到ROMS网格可能是那种不规则网格，所以需要进行这一步，不赘述
            cffx = Uwind_ll.*cos(angle_rho) + Vwind_ll.*sin(angle_rho);
            cffy = Vwind_ll.*cos(angle_rho) - Uwind_ll.*sin(angle_rho);
            Uwind(:,:,mm) = cffx;
            Vwind(:,:,mm) = cffy;
        end
        close(geo);

    end
    save NCEP_data.mat


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nc = roms.input.force;
    if get_lwrad
        %ncwrite(nc,'lrf_time',time);
        ncwrite(nc,'lwrad',lwrad);
        ncwrite(nc,'lwrad_down',lwrad_down);
    end
    if get_swrad
        %ncwrite(nc,'srf_time',time);
        ncwrite(nc,'swrad',swrad);
    end
    if get_rain
        %ncwrite(nc,'rain_time',time);
        rain(rain<0) = 0;
        ncwrite(nc,'rain',rain);
    end
    if get_Tair
        %ncwrite(nc,'tair_time',time);
        Tair(Tair<-100) = 0;
        ncwrite(nc,'Tair',Tair);
    end
    if get_Pair
        %ncwrite(nc,'pair_time',time);
        Pair(Pair<0) = 0;
        ncwrite(nc,'Pair',Pair);
    end
    if get_Qair
        %ncwrite(nc,'qair_time',time);
        Qair(Qair<0) = 0;
        ncwrite(nc,'Qair',Qair);
    end
    if get_Wind
        %ncwrite(nc,'wind_time',time);
        Uwind(Uwind<-100) = 0;
        Vwind(Vwind<-100) = 0;
        ncwrite(nc,'Uwind',Uwind);
        ncwrite(nc,'Vwind',Vwind);
    end
    cd(roms.res.force_ncep_dir)
    !del *.gbx8
    disp(['------------ 已写入到 ',roms.input.force,' ------------']);
end
