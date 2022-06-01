function roms_add_tracer_core(roms)
    cd(roms.project_dir)
    info=ncinfo(roms.input.initialization);
    nc=netcdf.open(roms.input.initialization,'WRITE');
    xrho_id=netcdf.inqDimID(nc,'xrho');
    erho_id=netcdf.inqDimID(nc,'erho');
    sc_r_id=netcdf.inqDimID(nc,'sc_r');
    time_id=netcdf.inqDimID(nc,'time');
    for i=1:roms.tracer.count
        var_name=['dye_',num2str(i,'%02d')];
        if(any(ismember( {info.Variables.Name},var_name)))
            disp(['变量',var_name,'已存在'])
        else
            dye_id=netcdf.defVar(nc,var_name,'double',[xrho_id,erho_id,sc_r_id,time_id]);
            netcdf.putAtt(nc,dye_id,'long_name',var_name);
            netcdf.putAtt(nc,dye_id,'units','kilogram meter-3');
            netcdf.putAtt(nc,dye_id,'time','ocean_time');
            netcdf.putAtt(nc,dye_id,'field',[var_name,', scalar, series']);
            disp(['变量',var_name,'已创建'])
        end

        var_name=['dye_',num2str(i,'%02d'),'_age'];
        if(any(ismember( {info.Variables.Name},var_name)))
            disp(['变量',var_name,'已存在'])
        else
            dye_id=netcdf.defVar(nc,var_name,'double',[xrho_id,erho_id,sc_r_id,time_id]);
            netcdf.putAtt(nc,dye_id,'long_name',var_name);
            netcdf.putAtt(nc,dye_id,'units','second');
            netcdf.putAtt(nc,dye_id,'time','ocean_time');
            netcdf.putAtt(nc,dye_id,'field',[var_name,', scalar, series']);
            disp(['变量',var_name,'已创建'])
        end
    end

    netcdf.close(nc)

    for i=1:roms.tracer.count
        disp(['正在写入变量',var_name])
        var_name=['dye_',num2str(i,'%02d')];
        ncwrite(roms.input.initialization,var_name,roms.tracer.densities{i})

        var_name=['dye_',num2str(i,'%02d'),'_age'];
        temp=ones(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N,1)*1;
        ncwrite(roms.input.initialization,var_name,temp)
    end
end
