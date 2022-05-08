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

%% ROMS输入文件
%项目文件目录
roms.project_dir='C:\Users\autod\Desktop\bh';
%网格文件
roms.nc.grid='roms_grid.nc';
%气象场强迫文件
roms.nc.force = 'roms_frc.nc';
%气候文件
roms.nc.climatology = 'roms_clm.nc';
%初始场文件
roms.nc.initialization = 'roms_ini.nc';
%边界场文件
roms.nc.boundary = 'roms_bdy.nc';
%潮汐强迫文件
roms.nc.tides = 'roms_tides.nc';
%河流定义文件
roms.nc.rivers='roms_rivers.nc';

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

%% 河流
%河流数量
roms.rivers.count=2;
%河流的位置，每一行为一条河流的水平坐标值
roms.rivers.location=[142,64;90,80];
%河流的流向，0为u方向，1为v方向，2为w方向
roms.rivers.direction=[0,0];
%定义时间，开始时间为0时刻。
roms.rivers.time=[0:roms.time.days];
temp=ones(roms.rivers.count,numel(roms.rivers.time));
temp(:,:)=20000;
%不同时间的河流流量，每一行一条河流，列数为时间数。
roms.rivers.transport=temp;
%不同垂直层之间的流量分配，每一行为一条河流，每条河流流量总和为1。
roms.rivers.v_shape=ones(roms.rivers.count,roms.grid.N)/roms.grid.N;
temp=ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
temp(:,:,:)=10;
%温度数据
roms.rivers.temp=temp;
%盐度数据
roms.rivers.salt=temp;
temp(:,:,:)=100;

temp(:,:,10:20)=0;
%被动示踪剂数据，数量应和roms.tracer.count相同。
roms.rivers.dye={temp};

%% 被动示踪剂
%示踪剂数量（变量的数量）
roms.tracer.count=2;
data1=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N,1);
for i=144:146
    for j=74:76
        data1(i,j,:)=1;
    end
end

data2=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N,1);
for i=95:98
    for j=70:74
        data2(i,j,:)=1;
    end
end
data1=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N,1);
%示踪剂的密度
roms.tracer.densities={data1,data2};

clear data1
clear data2


