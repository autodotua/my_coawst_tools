function create_single_clm(time,output)
    % 创建单个时间的水文数据快照
    arguments
        time(1,1) datetime
        output(1,1) string ="clm_"+string(time,'yyyyMMddHH')+".nc"
    end

    configs
    time=datetime(time);
    file=fullfile( roms.res.hycom_local, string(time,'yyyyMMddHH')+".nc"); %HYCOM文件
    roms_grid_info=get_roms_grid_info(roms.grid,roms.input.grid); %获取ROMS网格信息
    hycom_info=get_hycom_info(file,roms_grid_info, ...
        roms.res.hycom_longitude,roms.res.hycom_latitude,roms.res.hycom_depth); %获取HYCOM信息

    %检测时间匹配
    hycom_time=ncread(file,roms.res.hycom_time);
    hycom_time=hycom_time/roms.res.hycom_tunit+roms.res.hycom_t0dt;
    if ~isequal(hycom_time,time)
        warning("文件名与实际的HYCOM时间不符，前者为"+string(time,'yyyy-MM-dd-HH')...
            +"，后者为"+string(hycom_time))
    end


    rawu=interpolate_hycom_to_roms(file,roms.res.hycom_u,roms_grid_info,hycom_info,'u',3);
    rawv=interpolate_hycom_to_roms(file,roms.res.hycom_v,roms_grid_info,hycom_info,'v',3);
    [u,v,theta]=rotate_uv(roms_grid_info, rawu, rawv); %旋转UV。对于横平竖直网格，这一步做了和没做没什么区别。
    [ubar,vbar]=get_bar(roms_grid_info, rawu,rawv,theta); %获取UV压力
    zeta=interpolate_hycom_to_roms(file,roms.res.hycom_surface_elevation,roms_grid_info,hycom_info,'',2);
    temp=interpolate_hycom_to_roms(file,roms.res.hycom_temp,roms_grid_info,hycom_info,'rho',3);
    salt=interpolate_hycom_to_roms(file,roms.res.hycom_salt,roms_grid_info,hycom_info,'rho',3);
    temp(temp<0)=0; %不考虑海冰
    salt(salt<0)=0;
    create_clm_nc(output,time,roms_grid_info,u,v,ubar,vbar,temp,salt,zeta); %创建文件
    disp("完成创建："+output)
end


