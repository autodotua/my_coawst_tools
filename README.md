# my_coawst_tools
基于COAWST模式附带的工具包，根据自己所需做出相应修改。

mfiles目录下是一组Matlab的预处理/后处理工具

> 自 2012 年 2 月 8 日发布 567 起，我们已重写 m 文件以使用本机 matlab netcdf 接口。这将允许用户之间更统一的做法。需要注意的是，matlab 接口使用 fortran 约定，即变量被读取和写入为 var(x,y,z,t)。许多以前的工具箱都使用了 var(t,z,y,x) 的 c 约定。使用本机 matlab 时请小心。您可以使用 tools/mfiles/mtools/netcdf_load 使用本机 matlab 将 netcdf 文件加载到工作区中。

> 另一个可能需要的可选工具箱是 nctoolbox，位于：http://code.google.com/p/nctoolbox/
> 按照该网站上的说明安装该工具箱。这些 nctools 可选地用于 roms_clm 例程以通过 opendap 读取 hycom 数据，并且它们可选地用于 swan_forc m 文件以读取 grib2 ww3 数据。这个 nctoolbox 不是运行 coawst 系统所必需的，但它提供了额外的功能。

| 目录名       | 内容                                                         |
| ------------ | ------------------------------------------------------------ |
| inwave_tools | 正在开发                                                     |
| m_map        | 转换经纬度到米，支持不同的投影，用于网格生成                 |
| mtools       | ROMS创建网格、加载NC文件、将网格转为scrip、从ROMS网格创建WRF网格等工具 |
| roms_clm     | 创建边界、初始文件、气候文件等。主驱动文件是roms_master_climatology_coawst_mw.m |
| rutgers      | 来自Rutgers的水深测量、边界、海岸线、强迫、网格、陆地掩膜、 netcdf、海水、和实用文件夹 |
| swan_forc    | 读取WW3 Grib2文件并创建SWAN Trap强迫文件，主驱动文件是ww3_swan_input.m |
| tides        | 为ROMS创建潮汐强迫                                           |



## WRF

使用WPS即可完成预处理。

## ROMS

使用WRF网格来建立ROMS网格，但使用不同的分辨率。

### 创建网格
首先执行`roms_create_grid_step1`，在弹出的窗口中根据海岸线编辑水陆点。然后执行`roms_create_grid_step2`完成网格的创建。


### 三维边界场、初始场、气候场

执行`roms_create_clm_bdy_ini`。会生成：

> 初始场文件：`roms_ini.nc `
> 边界文件：`roms_bdy.nc`
> 气象文件：`roms_clm.nc`

对于子区域，需要创建初始场和气象文件。可以和上面进行相同的步骤，也可以：

```matlab
create_roms_child_init( roms_grid, roms_child_grid, 'Sandy_ini.nc',  'Sandy_ini_ref3.nc') 
create_roms_child_clm( roms_grid, roms_child_grid,  'Sandy_clm.nc', 'Sandy_clm_ref3.nc')
```
这一部分还未进行修改。


### 潮汐场



执行`roms_create_tides`，需要一点时间，结束以后会绘制很多图。

### 表面强迫

可以使用`create_roms_forcings.m`将mat数据转为nc文件，用`narrnc2roms.m`将来自[MARR](ftp.cdc.noaa.gov/Datasets/NARR/monolevel)的数据转为nc文件，用`ftp.cdc.noaa.gov/Datasets/NARR/monolevel`在`THREDDS`获取数据并转为nc文件

第472行的网址`url=['http://www.ncei.noaa.gov/thredds/dodsC/narr-a-files/'...`访问不了了，改为`url=['http://www.ncei.noaa.gov/thredds/dodsC/model-narr-a-files/'`，但还是会报错

### 大气强迫场

下载NCEP的FNL数据，不要重命名，放在指定目录下。

执行`roms_create_ncep_force`

### 最终所需要的文件（非嵌套）

- 网格文件：`roms_grid.nc`

- 初始场文件：`roms_ini.nc `

- 边界文件：`roms_bdy.nc`

- 气象文件：`roms_clm.nc`

- 潮汐强迫文件：`roms_tides.nc`



## SWAN

### 创建网格和水深

基于ROMS的网格进行创建：`roms2swan('roms_grid.nc')`

嵌套网格同理：`roms2swan('roms_grid_ref3.nc')`

生成的文件包括：

- `swan_coord.grd`提供了每一个网格的坐标，先全是经度，然后全是纬度

- ``swan_bathy.bot`提供了每一个网格点的水深

### 风强迫

在与WRF耦合时，这一步不需要，因此没有尝试。

### 边界场文件

在用户手册（3.4/3.7）中，提供了两种方法：TPAR (parametric foring files)或2D Spec files (spectral foring files)。但是由于数据源的格式和地址发生了改变，因此两种方法全部失效。在COAWST3.7中，更新了相关的Matlab工具，但是手册尚未更新。因此最新的工具进行介绍自己摸索出来的方法。

目前此处数据源来自于：[NCEP WAVEWATCH III Hindcast and Reanalysis Archives](https://polar.ncep.noaa.gov/waves/hindcasts/multi_1/) 。数据介绍见 [README.txt](COAWST.assets\README.txt) 。

打开`Tools/mfiles/swan_forc/create_swanTpar_from_WW3.m`，编辑：

```matlab
working_dir='C:\Users\autod\Desktop\maria' %工作路径
yearww3='2018' %年份
mmww3='07' %月份
modelgrid='C:\Users\autod\Desktop\maria\roms_grid.nc'; %SWAN（未测试）或者ROMS网格的路径
specres=20; %每一条边界的长度，这个数值越大，生成的文件越少。
ww3_grid='glo_30m' %数据源。这里选的glo_30m是全球30m数据。
```

~~可以直接执行，但是程序会下载整个月的数据，分辨率为3小时，每个小时的数据大约需要1分钟。目前不知道为什么要下载整个月的数据。~~

~~对同目录下的`readww3_2TPAR.m`进行修改，找到`timeww3=ncread(hsurl,'time'); timeww3=timeww3(1:end-1);`这两行，这两行取了全部的月份。在这两行下面添加一行：`timeww3=[(<起始日>-1)*8:<结束日>*8];`（经查看，数据分辨率为3小时）~~

~~这样就只会生成所需要的日期的边界数据了。~~

~~生成的数据包括`Bound_spec_command`和一系列的`TPAR*.txt`。前者中的命令需要复制到SWAN的配置文件中。~~

在[NCEI网站](https://www.ncei.noaa.gov/thredds-ocean/catalog/ncep/nww3/catalog.html)下载所需要的数据，进入所需要的年份和月份，进入`gribs`，打开`multi_1.glo_30m.tp|hs|dp.*.grb2`三个文件，选择其中的HTTPServer进行下载。也可以直接在[NCEP网站](https://polar.ncep.noaa.gov/waves/hindcasts/multi_1/)中下载。

下载完之后是3个grib2文件，使用`wgrib2.exe <输入grib2文件> -netcdf <输出nc文件>`转换为nc文件。

由于OPeNDAP提供的变量名等与进入`create_swanTpar_from_WW3`，修改：

1. 重新指定`tpurl`、`hsurl`、`dpurl`的链接为三个nc文件的路径

2. 修改变量：

   1. `ncread(hsurl,'lon')`→`ncread(hsurl,'longitude')`
   2. ``ncread(hsurl,'lat')`→`ncread(hsurl,'latitude')`
   3. `Significant_height_of_combined_wind_waves_and_swell_surface`→`HTSGW_surface`
   4. `Primary_wave_mean_period_surface`→`PERPW_surface`
   5. `Primary_wave_direction_surface`→`DIRPW_surface`

3. 由于从OPeNDAP获取的数据和转成nc以后的数据存在左右的翻转，因此需要去掉几个`fliplr`函数：

   1. `griddedInterpolant(daplon,fliplr(daplat),fliplr(hs),method)`→`griddedInterpolant(daplon,daplat,hs,method)`
   2. `FCr.Values=fliplr(tp)`→`FCr.Values=tp`
   3. `FCr.Values=fliplr(Dwave_Ax)`→`FCr.Values=Dwave_Ax`
   4. `FCr.Values=fliplr(Dwave_Ay)`→`FCr.Values=Dwave_Ay`

4. 在`timeww3`的定义后修改循环为：

   ```matlab
   for mm=1:length(timeww3)
       timeww3(mm)=index; %手动提供时间索引
       index=index+1;
       time(mm)=datenum(str2num(yearww3),str2num(mmww3),1,timeww3(mm)*3,0,0); %3是指分辨率为3x
   end
   ```

   

### 初始场文件

修改SWAN的配置文件（ [SWAN.md](SWAN.md) ）：

- 将`INITIAL HOTSTART SINGLE...`改为`INIT`
- 将`COMPUTE NONSTAT...`改为`COMPUTE STAT <yyyyMMdd.HHmmss>`
- 确保`STOP`前有`HOTFILE 'swan_init.hot'`
- 确保存在`OFF QUAD`

然后编译一个新的仅SWAN的COAWST：

```cpp
#undef  ROMS_MODEL
#define NESTING
#undef  WRF_MODEL
#define SWAN_MODEL
#undef  MCT_LIB
#undef  MCT_INTERP_OC2AT
#undef  MCT_INTERP_WV2AT
#undef  MCT_INTERP_OC2WV
```

之后执行`mpirun -np 1 coawstM swan.in`运行一次，生成`swan_init.hot`。

## 网格插值文件

使用之前`Lib/SCRIP_COAWST`生成的可执行文件

使用`scrip_coawst_template.in`模板建立配置文件：

```fortran
$INPUTS

OUTPUT_NCFILE='scrip_file.nc' !输出文件名

!网格数量
NGRIDS_ROMS=2,
NGRIDS_SWAN=2,
NGRIDS_WW3=0,
NGRIDS_WRF=2,

!ROMS网格文件
ROMS_GRIDS(1)='roms_grid1.nc',
ROMS_GRIDS(2)='roms_grid2.nc',

!SWAN网格文件
SWAN_COORD(1)='swan_coord1.grd',
SWAN_COORD(2)='swan_coord2.grd',
SWAN_BATH(1)='swan_bathy1.bot',
SWAN_BATH(2)='swan_bathy2.bot',
SWAN_NUMX(1)=84,
SWAN_NUMX(2)=116,
SWAN_NUMY(1)=64,
SWAN_NUMY(2)=86,
CARTESIAN(1)=0,
CARTESIAN(2)=0,

!WW3网格
WW3_XCOORD(1)=' ',
WW3_YCOORD(1)='',
WW3_BATH(1)='',
WW3_NUMX(1)=1,
WW3_NUMY(1)=1,

!WRF网格
WRF_GRIDS(1)='wrfinput_d01',
WRF_GRIDS(2)='moving',
PARENT_GRID_RATIO(1)=1,
PARENT_GRID_RATIO(2)=3,
PARENT_ID(1)=0
PARENT_ID(2)=1

$END
```

执行`./scrip_coawst ....in`即可生成网格插值文件。

## 暂存


### ROMS创建嵌套网格

由于暂时没有需求，因此没有写成工具。
查看WRF网格和ROMS父网格的位置：

```matlab
netcdf_load('wrfinput_d01') 
figure 
pcolorjw(XLONG,XLAT,double(1-LANDMASK)) 
hold on 
netcdf_load('wrfinput_d02') 
pcolorjw(XLONG,XLAT,double(1-LANDMASK)) 
plot(XLONG(1,:),XLAT(1,:),'r'); plot(XLONG(end,:),XLAT(end,:),'r') 
plot(XLONG(:,1),XLAT(:,1),'r'); plot(XLONG(:,end),XLAT(:,end),'r') 
% plot roms parent grid 
netcdf_load(roms_grid); 
plot(lon_rho(1,:),lat_rho(1,:),'k'); 
plot(lon_rho(end,:),lat_rho(end,:),'k') 
plot(lon_rho(:,1),lat_rho(:,1),'k'); 
plot(lon_rho(:,end),lat_rho(:,end),'k') 
text(-75,29,'roms parent grid') 
text(-77,27,'wrf parent grid') 
text(-77.2,34,'wrf child grid') 
```

确定ROMS子网格的位置：

```matlab
Istr=22; Iend=60; Jstr=26; Jend=54; %确定范围
plot(lon_rho(Istr,Jstr),lat_rho(Istr,Jstr),'m+') 
plot(lon_rho(Istr,Jend),lat_rho(Istr,Jend),'m+') 
plot(lon_rho(Iend,Jstr),lat_rho(Iend,Jstr),'m+') 
plot(lon_rho(Iend,Jend),lat_rho(Iend,Jend),'m+') 
ref_ratio=3; %子网格的密度是父网格的3倍。计算公式是：(60-22)*3-1,(54-26)*3-1=116,86
roms_child_grid='....nc'; 
%coarse2fine是自定义函数，用于创建分辨率更高的ROMS网格。F = coarse2fine(Ginp,Gout,Gfactor,Imin,Imax,Jmin,Jmax)
%给定一个粗分辨率nc文件(Ginp)，此函数在粗网格坐标(Imin,Jmin)和(Imax,Jmax)指定的区域中创建一个更细分辨率的网格。请注意(Imin,Jmin)和(Imax,Jmax)索引是根据psi点的，因为它实际上定义了精细网格的物理边界。网格细化系数用Gfactor指定。
F=coarse2fine(roms_grid,roms_child_grid, ref_ratio,Istr,Iend,Jstr,Jend); 
Gnames={roms_grid,roms_child_grid}; 
[S,G]=contact(Gnames,'roms_contact.nc'); %这个输出文件之后用于in文件中的NGCNAME参数
%contact是自定义函数，用于设置ROMS嵌套网格之间的接触点。contact(Gnames, Cname, Lmask, MaskInterp, Lplot)，参数分别为输入nc文件名、输出nc文件名，后面三个都有默认值。输入文件名需要按从大到小的顺序。
```

计算子网格的水深：

```matlab
netcdf_load(roms_child_grid) 
load USeast_bathy.mat 
h=griddata(h_lon,h_lat,h_USeast,lon_rho,lat_rho); %拟合，获得一个116*86的矩阵
%vq = griddata(x,y,v,xq,yq) 使 v = f(x,y) 形式的曲面与向量 (x,y,v) 中的散点数据拟合。griddata 函数在 (xq,yq) 指定的查询点对曲面进行插值并返回插入的值 vq。曲面始终穿过 x 和 y 定义的数据点。
h(isnan(h))=5; 
h(2:end-1,2:end-1)=0.2*(h(1:end-2,2:end-1)+h(2:end-1,2:end-1)+h(3:end,2:end-1)+h(2:end-1,1:end-2)+h(2:end-1,3:end)); 
ncwrite(roms_child_grid,'h',h)
%下面都是画图
figure 
pcolorjw(lon_rho,lat_rho,h) 
hold on 
load coastline.mat 
plot(lon,lat,'r') 
caxis([5 2500]); colorbar 
```

基于WRF的掩膜重新计算ROMS的掩膜：

```matlab
netcdf_load('wrfinput_d01'); 
%原文档中用的是TriScatteredInterp，但是MATLAB文档显示不推荐使用TriScatteredInterp，因此换成了scatteredInterpolant。这两个函数功能是相同的，不过TriScatteredInterp是老版函数
F = scatteredInterpolant(double(XLONG(:)),double(XLAT(:)),double(1-LANDMASK(:)),'nearest'); 
roms_mask=F(lon_rho,lat_rho); 

water = double(roms_mask); 
u_mask = water(1:end-1,:) & water(2:end,:); 
v_mask= water(:,1:end-1) & water(:,2:end); 
psi_mask= water(1:end-1,1:end-1) & water(1:end-1,2:end) & water(2:end,1:end-1) & water(2:end,2:end); 
ncwrite(roms_child_grid,'mask_rho',roms_mask); 
ncwrite(roms_child_grid,'mask_u',double(u_mask)); 
ncwrite(roms_child_grid,'mask_v',double(v_mask)); 
ncwrite(roms_child_grid,'mask_psi',double(psi_mask));

%下面都是画图
figure 
pcolorjw(lon_rho,lat_rho,roms_mask) 
hold on 
plot(lon,lat,'r') 
```

# 配置文件

暂存
其中有个[网址](http://tds.hycom.org/thredds/dodsC/GLBa0.08/expt_90.9)，来自于[HYCOM](http://tds.hycom.org/thredds/catalog.html)（hybrid coordinate ocean model，混合坐标海洋模型）。这里选用的是GOFS 3.0: HYCOM + NCODA Global 1/12° Analysis (NRL)-[`GLBu0.08/expt_90.9 (2012-05 to 2013-08)/`](http://tds.hycom.org/thredds/catalogs/GLBu0.08/expt_90.9.html)，选择[Hindcast Data: May-2012 to Aug-2013](http://tds.hycom.org/thredds/catalogs/GLBu0.08/expt_90.9.html?dataset=GLBu0.08-expt_90.9)，然后选择OPeNDAP：[//tds.hycom.org/thredds/dodsC/GLBu0.08/expt_90.9](http://tds.hycom.org/thredds/dodsC/GLBu0.08/expt_90.9.html)，其中有个Data URL后面就是所需要的地址。

> OPeNDAP是一个专门为本地系统透明的访问远程数据的客户端服务器系统，采用此系统客户端无需知道服务器端的存储格式、架构以及所采用的环境


进入[Revision 41](https://coawstmodel.sourcerepo.com/coawstmodel/data/)，选择[tide](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/)，下载[adcirc..](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/adcirc_ec2001v2e_fix.mat)或[tpx_h.mat](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/tpx_h.mat)和[tpx_uv.mat](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/tpx_uv.mat)。这个网站用IE才能打开，Chromium打不开，因为加密方式太老了。


编辑`Tools/mfiles/tides/create_roms_tides`。修改`Gname`到网格路径。修改`g`到模拟的开始时间。如果用adcirc，那么修改`if (adcirc)`后的路径。如果用ocu，那么修改上面到`adcirc=0;osu=1`，然后修改`if (osu)`后的路径。这里需要用ocu，用adcirc会报错。