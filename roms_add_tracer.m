configs;
nc=netcdf.open(roms_initialization_name,'WRITE');
xrho_id=netcdf.inqDimID(nc,'xrho');
erho_id=netcdf.inqDimID(nc,'erho');
sc_r_id=netcdf.inqDimID(nc,'sc_r');
time_id=netcdf.inqDimID(nc,'time');
var_name='dye_01';
dye_01_id=netcdf.defVar(nc,var_name,'double',[xrho_id,erho_id,sc_r_id,time_id]);


netcdf.putAtt(nc,dye_01_id,'long_name','dye_01');
netcdf.putAtt(nc,dye_01_id,'units','kilogram meter-3');
netcdf.putAtt(nc,dye_01_id,'time','ocean_time');
netcdf.putAtt(nc,dye_01_id,'field',[var_name,', scalar, series']);

netcdf.close(nc)
data=zeros(grid_size(1)+1,grid_size(2)+1,N,1);
for i=144:146
    for j=74:76
        data(i,j,:)=1;
    end
end

ncwrite(roms_initialization_name,var_name,data)
