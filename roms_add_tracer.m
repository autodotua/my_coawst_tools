configs;
info=ncinfo(roms.nc.initialization);
nc=netcdf.open(roms.nc.initialization,'WRITE');
xrho_id=netcdf.inqDimID(nc,'xrho');
erho_id=netcdf.inqDimID(nc,'erho');
sc_r_id=netcdf.inqDimID(nc,'sc_r');
time_id=netcdf.inqDimID(nc,'time');
for i=1:roms.tracer.count
    var_name=['dye_',num2str(i,'%02d')];
    if(any(ismember( {info.Variables.Name},var_name)))
        disp(['变量',var_name,'已存在'])
        continue
    end
    dye_id=netcdf.defVar(nc,var_name,'double',[xrho_id,erho_id,sc_r_id,time_id]);


    netcdf.putAtt(nc,dye_id,'long_name',var_name);
    netcdf.putAtt(nc,dye_id,'units','kilogram meter-3');
    netcdf.putAtt(nc,dye_id,'time','ocean_time');
    netcdf.putAtt(nc,dye_id,'field',[var_name,', scalar, series']);
end

netcdf.close(nc)

for i=1:roms.tracer.count
    ncwrite(roms.nc.initialization,var_name,roms.tracer.densities{i})
end
