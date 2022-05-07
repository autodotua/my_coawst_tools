configs;
nc=netcdf.open(roms_rivers_name,'WRITE');
river_id=netcdf.inqDimID(nc,'river');
srho_id=netcdf.inqDimID(nc,'s_rho');
time_id=netcdf.inqDimID(nc,'ocean_time');
var_name='river_dye_01';
netcdf.reDef(nc)
dye_01_id=netcdf.defVar(nc,var_name,'double',[river_id,srho_id,time_id]);


netcdf.putAtt(nc,dye_01_id,'long_name','rover_dye_01');
netcdf.putAtt(nc,dye_01_id,'units','kilogram meter-3');
netcdf.putAtt(nc,dye_01_id,'time','ocean_time');
netcdf.putAtt(nc,dye_01_id,'field',[var_name,', scalar, series']);

netcdf.close(nc)
data=zeros(1,N,58177-58119+1);
for t=1:58177-58119+1
    data(1,t)=1;
end

ncwrite(roms_rivers_name,var_name,data)
