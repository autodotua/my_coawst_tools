function create_clm_nc(file,time,roms_grid_info,u,v,ubar,vbar,temp,salt,zeta)
    [LP,MP]=size(roms_grid_info.lon_rho);
    nc=netcdf.create(file,bitor(0,4096));   %JBZ update for NC4 files, equivalent to 'clobber' + 'NETCDF4'
    if isempty(nc), retunc, end
    try
        netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'history', ['Created on ' datestr(now)]);
        L=LP-1;
        M=MP-1;

        %定义维度
        xrhodimID = netcdf.defDim(nc,'xrho',LP);
        xudimID = netcdf.defDim(nc,'xu',L);
        xvdimID = netcdf.defDim(nc,'xv',LP);
        erhodimID = netcdf.defDim(nc,'erho',MP);
        eudimID = netcdf.defDim(nc,'eu',MP);
        evdimID = netcdf.defDim(nc,'ev',M);
        s_rhodimID = netcdf.defDim(nc,'s_rho',roms_grid_info.N);
        octdimID = netcdf.defDim(nc,'ocean_time',length(time));

        %定义变量
        ocID = netcdf.defVar(nc,'ocean_time','double',octdimID);
        netcdf.putAtt(nc,ocID,'long_name','wind field time');
        netcdf.putAtt(nc,ocID,'units','days');
        netcdf.putAtt(nc,ocID,'field','wave_time, scalar, series');

        lonID = netcdf.defVar(nc,'lon_rho','float',[xrhodimID erhodimID]);
        netcdf.putAtt(nc,lonID,'long_name','lon_rho');
        netcdf.putAtt(nc,lonID,'units','degrees');
        netcdf.putAtt(nc,lonID,'FillValue_',100000.);
        netcdf.putAtt(nc,lonID,'missing_value',100000.);
        netcdf.putAtt(nc,lonID,'field','xp, scalar, series');

        latID = netcdf.defVar(nc,'lat_rho','float',[xrhodimID erhodimID]);
        netcdf.putAtt(nc,latID,'long_name','lon_rho');
        netcdf.putAtt(nc,latID,'units','degrees');
        netcdf.putAtt(nc,latID,'FillValue_',100000.);
        netcdf.putAtt(nc,latID,'missing_value',100000.);
        netcdf.putAtt(nc,latID,'field','yp, scalar, series');

        zetID = netcdf.defVar(nc,'zeta','double',[xrhodimID erhodimID octdimID]);
        netcdf.putAtt(nc,zetID,'long_name','zeta');
        netcdf.putAtt(nc,zetID,'units','meter');
        netcdf.putAtt(nc,zetID,'field','zeta, scalar, series');

        salID = netcdf.defVar(nc,'salt','float',[xrhodimID erhodimID s_rhodimID octdimID]);
        netcdf.putAtt(nc,salID,'long_name','salt');
        netcdf.putAtt(nc,salID,'units','psu');
        netcdf.putAtt(nc,salID,'field','salt, scalar, series');

        tmpID = netcdf.defVar(nc,'temp','float',[xrhodimID erhodimID s_rhodimID octdimID]);
        netcdf.putAtt(nc,tmpID,'long_name','temp');
        netcdf.putAtt(nc,tmpID,'units','C');
        netcdf.putAtt(nc,tmpID,'field','temp, scalar, series');

        uID = netcdf.defVar(nc,'u','float',[xudimID eudimID s_rhodimID octdimID]);
        netcdf.putAtt(nc,uID,'long_name','velx');
        netcdf.putAtt(nc,uID,'units','meter second-1');
        netcdf.putAtt(nc,uID,'field','velx, scalar, series');

        vID = netcdf.defVar(nc,'v','float',[xvdimID evdimID s_rhodimID octdimID]);
        netcdf.putAtt(nc,vID,'long_name','vely');
        netcdf.putAtt(nc,vID,'units','meter second-1');
        netcdf.putAtt(nc,vID,'field','vely, scalar, series');

        ubID = netcdf.defVar(nc,'ubar','float',[xudimID eudimID octdimID]);
        netcdf.putAtt(nc,ubID,'long_name','mean velx');
        netcdf.putAtt(nc,ubID,'units','meter second-1');
        netcdf.putAtt(nc,ubID,'field','mean velx, scalar, series');

        vbID = netcdf.defVar(nc,'vbar','float',[xvdimID evdimID octdimID]);
        netcdf.putAtt(nc,vbID,'long_name','mean vely');
        netcdf.putAtt(nc,vbID,'units','meter second-1');
        netcdf.putAtt(nc,vbID,'field','mean vely, scalar, series');

        %写入数据
        if length(time)==1
            jtime=juliandate(time,'modifiedjuliandate');
            lonid=netcdf.inqVarID(nc,'lon_rho');
            netcdf.putVar(nc,lonid,roms_grid_info.lon_rho);
            latid=netcdf.inqVarID(nc,'lat_rho');
            netcdf.putVar(nc,latid,roms_grid_info.lat_rho);
            tempid=netcdf.inqVarID(nc,'u');
            netcdf.putVar(nc,tempid,shiftdim(u,1));
            tempid=netcdf.inqVarID(nc,'v');
            netcdf.putVar(nc,tempid,shiftdim(v,1));
            tempid=netcdf.inqVarID(nc,'ocean_time');
            netcdf.putVar(nc,tempid,jtime);
            tempid=netcdf.inqVarID(nc,'ubar');
            netcdf.putVar(nc,tempid,ubar);
            tempid=netcdf.inqVarID(nc,'vbar');
            netcdf.putVar(nc,tempid,vbar);
            tempid=netcdf.inqVarID(nc,'temp');
            netcdf.putVar(nc,tempid,shiftdim(temp,1));
            tempid=netcdf.inqVarID(nc,'salt');
            netcdf.putVar(nc,tempid,shiftdim(salt,1));
            tempid=netcdf.inqVarID(nc,'zeta');
            netcdf.putVar(nc,tempid,zeta);
        end
        netcdf.close(nc);
    catch ex
        netcdf.close(nc);
        error(ex)
    end
end
