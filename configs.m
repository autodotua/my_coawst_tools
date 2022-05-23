clear roms swan

%% 路径

%ROMS项目文件目录
roms.project_dir='C:\Users\autod\Desktop\bh';
roms.build_dir='/home/fangz/roms/build';
%SWAN项目文件目录
swan.project_dir=roms.project_dir;

%% 时间
%开始时间
roms.time.start=[2018,1,1,0,0,0];
%结束时间
roms.time.stop=[2018,3,1,0,0,0];
%开始时刻的简化儒略日
roms.time.start_julian=juliandate(datetime(roms.time.start),'modifiedjuliandate');
%结束时刻的简化儒略日
roms.time.stop_julian=juliandate(datetime(roms.time.stop),'modifiedjuliandate');
%总天数
roms.time.days=roms.time.stop_julian-roms.time.start_julian+1;

swan.time=roms.time;
%% 网格
%经度范围
roms.grid.longitude=[117,122.5];
%纬度范围
roms.grid.latitude=[37,41];
%网格数量，与in文件Lm和Mm的相同，比rho、xi_v、eta_u少2，比xi_u、eta_v、psi少1
roms.grid.size=[220,160];
%垂向分层
roms.grid.N           = 16;
%地形跟随坐标θs参数
roms.grid.theta_s     =  1.0;
%地形跟随坐标θb参数
roms.grid.theta_b     =  0.4;
%地形跟随坐标最小值
roms.grid.Tcline      = 1.0;
%地形跟随坐标Vtransform参数
roms.grid.Vtransform  =  1;
%地形跟随坐标Vstretching参数
roms.grid.Vstretching =  1;



%% 输入文件
%网格文件
roms.input.grid='roms_grid.nc';
%气象场强迫文件
roms.input.force = 'roms_frc.nc';
%气候文件
roms.input.climatology = 'roms_clm.nc';
%初始场文件
roms.input.initialization = 'roms_ini.nc';
%边界场文件
roms.input.boundary = 'roms_bdy.nc';
%潮汐强迫文件
roms.input.tides = 'roms_tides.nc';
%河流定义文件
roms.input.rivers='roms_rivers.nc';
%地形文件
swan.input.bot='swan_bathy.bot';
%网格文件
swan.input.grd='swan_coord.grid';

%% 输出文件
%ROMS输出历史文件
roms.output.hisotry='ocean_his.nc';
roms.output.floats='ocean_flt.nc';


%% 数据资源路径
%包含ncep的fnl气象场的目录
roms.res.force_ncep_dir="ncep";
%全球地形文件
roms.res.ETOPO1_Bed_c_gmt4='data/ETOPO1_Bed_c_gmt4.grd';
%全球海岸线文件
roms.res.gshhs_f='data/gshhs_f.b';
%潮汐水平运动文件
roms.res.tpx_uv='data/tpx_uv.mat';
%潮汐高度文件
roms.res.tpx_h='data/tpx_h.mat';
%水文数据的URL
roms.res.hycom='http://tds.hycom.org/thredds/dodsC/GLBa0.08/expt_91.2';
swan.multi_1_glo_30m='data';

%% 被动示踪剂
%示踪剂数量（变量的数量）
roms.tracer.count=1;
%示踪剂的密度
roms.tracer.densities=cell(roms.tracer.count,1); roms.tracer.densities{:}=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N,1);
%应用对示踪剂的具体设置
roms.tracer=configs_tracer(roms);
%% 河流
%河流数量
roms.rivers.count=1;
%河流的流向，0为u方向，1为v方向，2为w方向
roms.rivers.direction=ones(roms.rivers.count,1)*2;
%定义时间，开始时间为0时刻。
roms.rivers.time=[0:roms.time.days];
%河流的位置，每一行为一条河流的水平坐标值
roms.rivers.location=zeros(roms.rivers.count,2);
%不同时间的河流流量，每一行一条河流，列数为时间数。
roms.rivers.transport=ones(roms.rivers.count,numel(roms.rivers.time));
%不同垂直层之间的流量分配，每一行为一条河流，每条河流流量总和为1。
roms.rivers.v_shape=ones(roms.rivers.count,roms.grid.N)/roms.grid.N;
%温度数据
roms.rivers.temp=ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
%盐度数据
roms.rivers.salt=ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
%被动示踪剂数据，数量应和roms.tracer.count相同。
roms.rivers.dye=cell(roms.tracer.count,1); roms.rivers.dye{:}=ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
%应用对河流的具体设置
roms.rivers=configs_rivers(roms);


%% SWAN强迫
%分辨率
swan.forcing.specres=40;

%% 清理和检查
clear temp i j
configs_check(roms,swan)


