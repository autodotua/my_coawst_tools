function roms_create_clm_bdy_ini_HYCOM
    % roms_master_climatology_coawst_mw
    %
    % This routine :
    %  - creates climatology, boundary, and initial condition files for ROMS:
    %    coawst_clm.nc ; coawst_bdy.nc ; coawst_ini.nc
    %    on a user-defined grid for a user-defined date.
    %
    % This is currently set up to use opendap calls to acquire data
    % from HYCOM + NCODA Global 1/12 Degree Analysis and interp to roms grid.
    %
    % based on efforts by:
    % written by Mingkui Li, May 2008
    % Modified by Brandy Armstrong March 2009
    % jcwarner April 20, 2009
    % Ilgar Safak modified on June 27, 2012 such that now:
    % - HYCOM url is a user-definition
    % - "hc" is called from the structure "gn".(still needs to be tested with wet/dry).
    % - updatinit_coawst_mw.m modified to get desired time (T1) as a variable;
    %    ocean_time=T1-datenum(1858,11,17,0,0,0)
    % Updates from Christie Hegermiller, Feb 2019
    %

    %%%%%%%%%%%%%%%%%%%%%   START OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%
    configs

    % (1) Enter start date (T1) and number of days to get climatology data
    T1 = datenum(roms.time.start); %start date
    T2 = datenum(roms.time.stop);
    %number of days and frequency to create climatology files for
    numdays = ceil(T2-T1);
    dayFrequency = 1;

    % (2) Enter URL of the HYCOM catalog for the requested time, T1
    %     see http://tds.hycom.org/thredds/catalog.html
    url = roms.res.hycom;      % 2011-01 to 2013-08

    % (3) Enter working directory (wdr)
    wdr = roms.project_dir;

    % (4) Enter path and name of the ROMS grid
    modelgrid = roms.input.grid;

    % (5) Enter grid vertical coordinate parameters --These need to be consistent with the ROMS setup.
    theta_s=roms.grid.theta_s;
    theta_b=roms.grid.theta_b;
    Tcline=roms.grid.Tcline;
    N=roms.grid.N;
    Vtransform=roms.grid.Vtransform ;
    Vstretching=roms.grid.Vstretching;

    %%%%%%%%%%%%%%%%%%%%%   END OF USER INPUT  %%%%%%%%%%%%%%%%%%%%%%%%%%
    eval(['cd ',wdr])

    tic

    % Call to get HYCOM indices for the defined ROMS grid
    disp('正在获取网格，HYCOM网格和索引')
    [gn, clm]=get_ijrg(url, modelgrid, theta_s, theta_b, Tcline, N, Vtransform, Vstretching);

    % Call to create the climatology (clm) file
    disp('正在创建气候文件')
    fn=updatclim_coawst_mw(T1, gn, clm, roms.input.climatology, wdr, url);

    % Call to create the boundary (bdy) file
    disp('正在创建边界文件')
    updatbdry_coawst_mw(fn, gn, roms.input.boundary, wdr);

    % Call to create the initial (ini) file
    disp('正在创建初始场文件')
    updatinit_coawst_mw(fn, gn, roms.input.initialization, wdr, T1);

    toc


    %% Call to create the long climatology (clm) file
    if numdays>1
        disp('正在创建剩余日的气候、边界文件')
        if (ispc)
            eval(['!copy roms_clm.nc roms_clm_',datestr(T1,'yyyymmdd'),'.nc'])
            eval(['!copy roms_bdy.nc roms_bdy_',datestr(T1,'yyyymmdd'),'.nc'])
        else
            eval(['!cp roms_clm.nc roms_clm_',datestr(T1,'yyyymmdd'),'.nc'])
            eval(['!cp roms_bdy.nc roms_bdy_',datestr(T1,'yyyymmdd'),'.nc'])
        end
        for it=dayFrequency:dayFrequency:numdays-1      %1st day already created, NEED to set number of days at top!
            fname=['roms_clm_',datestr(T1+it,'yyyymmdd'),'.nc'];
            fn=updatclim_coawst_mw(T1+it,gn,clm,fname,wdr,url);
            fname=['roms_bdy_',datestr(T1+it,'yyyymmdd'),'.nc'];
            updatbdry_coawst_mw(fn,gn,fname,wdr)
        end
        %% get an organized list of dated files
        Dclm=dirsort('roms_clm_*.nc');
        Dbdy=dirsort('roms_bdy_*.nc');
        %names for merged climatology/boundary files
        fout=roms.input.climatology;
        foutb=roms.input.boundary;
        %create netcdf files to merge climatology into
        create_roms_netcdf_clm_mwUL(fout,gn,length(Dclm));% converted to BI functions
        create_roms_netcdf_bndry_mwUL(foutb,gn,length(Dbdy));% converted to BI functions
        %% fill merged climatology files with data from each clm file
        % each file must contain only ONE time step
        %get variable names
        vinfo=ncinfo(fout);
        for nf=1:length(Dclm)
            fin=Dclm(nf).name;
            for nv=1:length({vinfo.Variables.Name})
                if length({vinfo.Variables(nv).Dimensions.Name})==4
                    eval(['ncwrite(fout,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[1 1 1 nf]);']);
                elseif length({vinfo.Variables(nv).Dimensions.Name})==3
                    eval(['ncwrite(fout,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[1 1 nf]);']);
                elseif length({vinfo.Variables(nv).Dimensions.Name})==2
                    try
                        eval(['ncwrite(fout,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[1 nf]);']);
                    catch
                        disp([vinfo.Variables(nv).Name ' is a dimension and has already been written to the file.'])
                    end
                elseif length({vinfo.Variables(nv).Dimensions.Name})==1;
                    try
                        eval(['ncwrite(fout,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[nf]);']);
                    catch
                        disp([vinfo.Variables(nv).Name ' is a dimension and has already been written to the file.'])
                    end
                end
            end
        end

        vinfo=ncinfo(foutb);
        for nf=1:length(Dbdy)
            for nv=1:length({vinfo.Variables.Name})
                fin=Dbdy(nf).name;
                if length({vinfo.Variables(nv).Dimensions.Name})==4;
                    eval(['ncwrite(foutb,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[1 1 1 nf]);']);
                elseif length({vinfo.Variables(nv).Dimensions.Name})==3;
                    eval(['ncwrite(foutb,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[1 1 nf]);']);
                elseif length({vinfo.Variables(nv).Dimensions.Name})==2;
                    try
                        eval(['ncwrite(foutb,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[1 nf]);']);
                    catch
                        disp([vinfo.Variables(nv).Name ' is a dimension and has already been written to the file.'])
                    end

                elseif length({vinfo.Variables(nv).Dimensions.Name})==1;
                    try
                        eval(['ncwrite(foutb,''',vinfo.Variables(nv).Name,''',ncread(fin,''',vinfo.Variables(nv).Name,'''),[nf]);']);
                    catch
                        disp([vinfo.Variables(nv).Name ' is a dimension and has already been written to the file.'])
                    end
                end
            end
        end
    end

    !del roms_clm_*.nc
    !del roms_bdy_*.nc
    toc
end