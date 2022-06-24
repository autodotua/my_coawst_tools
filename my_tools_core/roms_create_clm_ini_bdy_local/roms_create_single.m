function roms_create_single
    configs
    d=cd(roms.project_dir);
    time=datetime(roms.time.start);
    file=fullfile( roms.res.hycom_local, string(time,'yyyyMMddHH')+".nc");
    [roms_grid_info,hycom_info]=get_hycom_info( ...
        file,roms.input.grid,roms.grid, ...
        roms.res.hycom_longitude,roms.res.hycom_latitude,roms.res.hycom_depth);

    hycom_time=ncread(file,roms.res.hycom_time);
    hycom_time=hycom_time/roms.res.hycom_tunit+roms.res.hycom_t0dt;
    if ~isequal(hycom_time,time)
        warning("文件名与实际的HYCOM时间不符，前者为"+string(time,'yyyy-MM-dd-HH')...
            +"，后者为"+string(hycom_time))
    end
    rawu=interpolate_hycom_to_roms(file,roms.res.hycom_u,roms_grid_info,hycom_info,'u',3);
    rawv=interpolate_hycom_to_roms(file,roms.res.hycom_v,roms_grid_info,hycom_info,'v',3);
    [u,v,theta]=rotate_uv(roms_grid_info, rawu, rawv);
    [ubar,vbar]=get_bar(roms_grid_info, rawu,rawv,theta);
    zeta=interpolate_hycom_to_roms(file,roms.res.hycom_surface_elevation,roms_grid_info,hycom_info,'',2);
    temp=interpolate_hycom_to_roms(file,roms.res.hycom_temp,roms_grid_info,hycom_info,'rho',3);
    salt=interpolate_hycom_to_roms(file,roms.res.hycom_salt,roms_grid_info,hycom_info,'rho',3);
    create_clm_nc("hycom_"+string(time,'yyyyMMddHH')+".nc",time,roms_grid_info, ...
        u,v,ubar,vbar,temp,salt,zeta);
    cd(d);
    disp('完成')
end


