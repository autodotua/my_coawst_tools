configs
roms_fix_h
try
    p=parcluster('local');
    p.NumWorkers=12;
    saveProfile(p);
    delete(gcp('nocreate'))
    p=parpool('local',12);
catch
end
d=cd(roms.project_dir);
start=datetime(roms.time.start);%+hours(roms.res.hycom_local_step_hour);
stop=datetime(roms.time.stop);
step=hours(roms.res.hycom_local_step_hour);
skip_existed=0;
roms_grid_info=get_roms_grid_info(roms.grid,roms.input.grid);
create_clms(start,stop,step,skip_existed);
create_bdy(roms.input.climatology,roms.input.boundary,roms_grid_info);
updatinit_coawst_mw("clm_"+string(start,'yyyyMMddHH')+".nc", roms_grid_info, ...
    roms.input.initialization, roms.project_dir, datenum(roms.time.start));
roms_add_tracer
cd(d)