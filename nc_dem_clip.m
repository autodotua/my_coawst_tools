input="C:\Users\autod\Desktop\hzw\data\SRTM15_V2.4.nc";
output="C:\Users\autod\Desktop\hzw\data\SRTM15_SUB.nc";

nc_dem_clip_core(input,output,'lon','lat','z',[120,124],[29,32])