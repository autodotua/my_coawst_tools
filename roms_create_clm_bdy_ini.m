configs

d=cd(roms.project_dir);
start=datetime(roms.time.start)+hours(roms.res.hycom_local_step_hour);
stop=datetime(roms.time.stop);
step=hours(roms.res.hycom_local_step_hour);
skip_existed=1;
create_single_clm(roms.time.start,roms.input.initialization);
create_clms(start,stop,step,skip_existed);
create_bdy(roms.input.climatology,roms.input.boundary,get_roms_grid_info(roms.grid,roms.input.grid));
cd(d)