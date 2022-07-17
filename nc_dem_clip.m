input="C:\Users\autod\Desktop\gebco_2022_sub_ice_topo\GEBCO_2022_sub_ice_topo.nc";
output="C:\Users\autod\Desktop\gebco_2022_sub_ice_topo\GEBCO_2022_sub_ice_topo_clip.nc";

nc_dem_clip_core(input,output,'lon','lat','elevation',[120,124],[29,32])