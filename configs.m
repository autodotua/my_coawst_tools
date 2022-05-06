%时间
start=[2018,1,1,0,0,0];
stop=[2018,3,1,0,0,0];

%网格
lng_range=[117,122.5];
lat_range=[37,41];
grid_size=[220,160];
theta_s     =  1.0;
theta_b     =  0.4;
Tcline      = 1.0;
N           = 16;
Vtransform  =  1;
Vstretching =  1;

%输出
roms_force_ncep_source_dir="ncep";
roms_grid_name='roms_grid.nc';
roms_force_name = 'roms_frc.nc';
roms_climatology_name = 'roms_clm.nc';
roms_initialization_name = 'roms_ini.nc';
roms_boundary_name = 'roms_bdy.nc';
roms_tides_name = 'roms_tides.nc';
roms_rivers_name='roms_rivers.nc';

%数据文件路径
project_dir='C:\Users\autod\Desktop\bh';
path_ETOPO1_Bed_c_gmt4='data/ETOPO1_Bed_c_gmt4.grd';
path_gshhs_f='data/gshhs_f.b';
path_tpx_uv='data/tpx_uv.mat';
path_tpx_h='data/tpx_h.mat';
url_hycom='http://tds.hycom.org/thredds/dodsC/GLBa0.08/expt_91.2';