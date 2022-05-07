configs

nc = netcdf.create(roms_rivers_name,'nc_clobber');

% global variables
netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'type', 'ROMS FORCING file');
netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'grd_file',roms_grid_name );
netcdf.putAtt(nc,netcdf.getConstant('NC_GLOBAL'),'title','rivers');

% dimensions
s_rho_id = netcdf.defDim(nc,'s_rho',N);
river_id = netcdf.defDim(nc,'river',river_count);
river_time_id = netcdf.defDim(nc,'river_time',netcdf.getConstant('NC_UNLIMITED'));

% variables and attributes
disp(' ## Defining Variables and Attributes...')

id = netcdf.defVar(nc,'river_time','double',river_time_id);
netcdf.putAtt(nc,id,'long_name','river runoff time');
netcdf.putAtt(nc,id,'units','days since 1858-11-17 00:00:00 UTC');

id = netcdf.defVar(nc,'river','double',river_id);
netcdf.putAtt(nc,id,'long_name','river runoff identification number');


id = netcdf.defVar(nc,'river_Xposition','double',river_id);
netcdf.putAtt(nc,id,'long_name','river XI-position at RHO-points');
netcdf.putAtt(nc,id,'valid_min',0);
netcdf.putAtt(nc,id,'valid_max',grid_size(1));


id = netcdf.defVar(nc,'river_Eposition','double',river_id);
netcdf.putAtt(nc,id,'long_name','river ETA-position at RHO-points');
netcdf.putAtt(nc,id,'valid_min',0);
netcdf.putAtt(nc,id,'valid_max',grid_size(2));

id = netcdf.defVar(nc,'river_direction','double',river_id);
netcdf.putAtt(nc,id,'long_name','river runoff direction');


id = netcdf.defVar(nc,'river_Vshape','double',[river_id,s_rho_id]);
netcdf.putAtt(nc,id,'long_name','river runoff mass transport vertical profile');


id = netcdf.defVar(nc,'river_transport','double',[river_id,river_time_id]);
netcdf.putAtt(nc,id,'long_name','river runoff vertically integrated mass transport');
netcdf.putAtt(nc,id,'units','meter3 second-1');
netcdf.putAtt(nc,id,'time','river_time');

id = netcdf.defVar(nc,'river_temp','double',[river_id,s_rho_id,river_time_id]);
netcdf.putAtt(nc,id,'long_name','river runoff potential temperature');
netcdf.putAtt(nc,id,'units','Celsius');
netcdf.putAtt(nc,id,'time','river_time');

id = netcdf.defVar(nc,'river_salt','double',[river_id,s_rho_id,river_time_id]);
netcdf.putAtt(nc,id,'long_name','river runoff salinity');
netcdf.putAtt(nc,id,'time','river_time');

id = netcdf.defVar(nc,'river_dye_01','double',[river_id,s_rho_id,river_time_id]);
netcdf.putAtt(nc,id,'long_name','river_dye_01');
netcdf.putAtt(nc,id,'time','river_time');

netcdf.close(nc)


roms.river.locations={[81,87]};
data=[1];
ncwrite(roms_rivers_name,'river',data);
data=[0];
ncwrite(roms_rivers_name,'river_direction',data);
data=zeros(1,N);
data(1,:)=1/N;
ncwrite(roms_rivers_name,'river_Vshape',data)
ncwrite(roms_rivers_name,'river_Xposition',81)
ncwrite(roms_rivers_name,'river_Eposition',87)
time_count=2;
data=[58119,58119+10];
ncwrite(roms_rivers_name,'river_time',data);
data=zeros(1,time_count);
data(1,:)=[10000,20000];
ncwrite(roms_rivers_name,'river_transport',data);
data=zeros(1,N,time_count);
data(1,:,1)=10;
data(1,:,2)=20;

ncwrite(roms_rivers_name,'river_salt',data);
ncwrite(roms_rivers_name,'river_dye_01',data);

