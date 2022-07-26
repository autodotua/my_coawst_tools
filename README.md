# 介绍

## 原版COAWST_ TOOLS

基于COAWST模式附带的工具包，用于制作ROMS、SWAN等模式的预处理文件，以及提供了一些其他的功能，根据自己所需做出相应修改。

mfiles目录下是一组Matlab的预处理/后处理工具

> 自 2012 年 2 月 8 日发布 567 起，我们已重写 m 文件以使用本机 matlab netcdf 接口。这将允许用户之间更统一的做法。需要注意的是，matlab 接口使用 fortran 约定，即变量被读取和写入为 var(x,y,z,t)。许多以前的工具箱都使用了 var(t,z,y,x) 的 c 约定。使用本机 matlab 时请小心。您可以使用 tools/mfiles/mtools/netcdf_load 使用本机 matlab 将 netcdf 文件加载到工作区中。

> 另一个可能需要的可选工具箱是 nctoolbox，位于：http://code.google.com/p/nctoolbox/
> 按照该网站上的说明安装该工具箱。这些 nctools 可选地用于 roms_clm 例程以通过 opendap 读取 hycom 数据，并且它们可选地用于 swan_forc m 文件以读取 grib2 ww3 数据。这个 nctoolbox 不是运行 coawst 系统所必需的，但它提供了额外的功能。

## 更改

- 本项目将多个文件中分散的配置进行了综合，使用`config.m`文件进行统一管理
- 增加或修复了部分ROMS和SWAN工具，例如添加河流文件、增加初始场示踪剂等。
- 增加了一些通用型工具

# 目录和文件

## 原版目录

| 目录名         | 内容                                                         |
| -------------- | ------------------------------------------------------------ |
| `inwave_tools` | 正在开发                                                     |
| `m_map`        | 地图的绘制等                                                 |
| `mtools`       | ROMS创建网格、加载NC文件、将网格转为scrip、从ROMS网格创建WRF网格等工具 |
| `roms_clm`     | 创建边界、初始文件、气候文件等。主驱动文件是roms_master_climatology_coawst_mw.m |
| `rutgers`      | 来自Rutgers的水深测量、边界、海岸线、强迫、网格、陆地掩膜、 netcdf、海水、和实用文件夹 |
| `swan_forc`    | 读取WW3 Grib2文件并创建SWAN Trap强迫文件，主驱动文件是ww3_swan_input.m |
| `tides`        | 为ROMS创建潮汐强迫                                           |

## 基本

| 文件名      | 内容                                        |
| ----------- | ------------------------------------------- |
| `add_paths` | 将当前目录注册到MATLAB中，并注册`nctoolbox` |
| `configs`   | 集合的配置文件                              |

## 输入文件制作

| 文件名                       | 内容                                 |
| ---------------------------- | ------------------------------------ |
| `roms_add_tracer`            | 为ROMS初始场文件中添加示踪剂         |
| `roms_create_clm_bdy_ini`    | 创建ROMS的初始场、气象场、边界场文件 |
| `roms_create_force`          | 创建ROMS大气强迫文件                 |
| `roms_create_rivers`         | 创建ROMS河流文件                     |
| `roms_create_tides`          | 创建ROMS潮汐文件                     |
| `swan_create_boundary`       | 创建SWAN的边界场                     |
| `swan_create_grid_from_roms` | 根据ROMS的网格创建相同的SWAN网格     |

## 通用工具

| 文件名                  | 内容                           |
| ----------------------- | ------------------------------ |
| `roms_get_xy_by_lonlat` | 根据经纬度获取ROMS网格的XY位置 |

## 后处理工具

| 文件名                                   | 内容                                                         |
| ---------------------------------------- | ------------------------------------------------------------ |
| `show_dye_contour`                       | 显示ROMS示踪剂的等值线图                                     |
| `show_dye_cross_sectional_concentration` | 显示ROMS示踪剂的横截面浓度图                                 |
| `show_value_change`                      | 显示ROMS输出中某一点、某一柱、某一面或全部的某个变量值的变化曲线 |
| `show_water_exchange`                    | 显示ROMS的水交换折线图                                       |
| `show_floats`                            | 显示ROMS漂浮子的轨迹                                         |

## 核心代码：`my_tools_core`

| 文件名                                                    | 内容                                                         |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| `roms_create_clm_ini_bdy_local`                           | 通过离线下载的hycom数据，创建初始场、边界场、全域强迫文件    |
| `roms_create_clm_ini_bdy_local/create_bdy`                | 根据已有的clm文件创建边界文件                                |
| `roms_create_clm_ini_bdy_local/create_clm_nc`             | 根据给定的变量创建clm的nc文件                                |
| `roms_create_clm_ini_bdy_local/create_clms`               | 创建指定时间的合并的clm文件                                  |
| `roms_create_clm_ini_bdy_local/create_single_clm`         | 创建单个clm文件                                              |
| `roms_create_clm_ini_bdy_local/download_hycom`            | 下载指定时间和区域的HYCOM数据                                |
| `roms_create_clm_ini_bdy_local/get_bar`                   | 根据UV计算Ubar和Vbar                                         |
| `roms_create_clm_ini_bdy_local/get_hycom_info`            | 获取HYCOM数据的信息                                          |
| `roms_create_clm_ini_bdy_local/get_roms_grid_info`        | 获取ROMS网格信息                                             |
| `roms_create_clm_ini_bdy_local/interpolate_hycom_to_roms` | 从HYCOM数据插值到ROMS网格                                    |
| `roms_create_clm_ini_bdy_local/merge_clms`                | 合并一个时间一个的clm文件                                    |
| `roms_create_clm_ini_bdy_local/rotate_uv`                 | 将横平竖直的UV进行旋转以符合ROMS网格                         |
| `nc_dem_clip_core`                                        | 将DEM的nc文件进行裁剪，减小文件体积便于处理和导入GridBuilder |
| `nc_extract_variables`                                    | 将nc文件中的变量导出为mat文件                                |
| `roms_add_tracer_core`                                    | 为ROMS初始场文件中添加示踪剂                                 |
| `roms_create_clm_bdy_ini_HYCOM`                           | 通过在线的hycom数据，创建初始场、边界场、全域强迫文件        |
| `roms_create_force_NCEP`                                  | 通过ncep的fnl数据，创建大气强迫文件                          |
| `roms_create_grid_core`                                   | 创建ROMS网格                                                 |
| `roms_create_grid_from_wrfinput`                          | 从WRF的`wrfinput`文件创建ROMS网格                            |
| `roms_create_rivers_core`                                 | 创建ROMS河流文件                                             |
| `roms_create_tides_tpx`                                   | 创建ROMS潮汐文件                                             |
| `roms_fill_grid_h_core`                                   | 向ROMS网格文件中填充深度信息                                 |
| `roms_fix_h`                                              | 修复GridBuilder导出的网格文件深度问题                        |
| `roms_get_grid_details`                                   | 获取ROMS网格的详细信息                                       |
| `roms_get_volumes`                                        | 获取ROMS网格中每个单元格的体积                               |
| `roms_get_xy_by_lonlat_core`                              | 根据经纬度获取ROMS网格的XY位置                               |
| `show_dye_contour_core`                                   | 显示ROMS示踪剂的等值线图                                     |
| `show_dye_cross_sectional_concentration_core`             | 显示ROMS示踪剂的横截面浓度图                                 |
| `show_value_change_core`                                  | 显示ROMS输出中某一点、某一柱、某一面或全部的某个变量值的变化曲线 |
| `show_water_exchange_core`                                | 显示ROMS的水交换折线图                                       |
| `swan_create_boundary_core`                               | 创建SWAN的边界场                                             |

## 临时代码：`my_tools_temp`

| 文件名                | 内容                             |
| --------------------- | -------------------------------- |
| `ocean_interpolation` | 将实测值插值为面                 |
| `show_floats`         | 显示ROMS漂浮子的轨迹             |
| `show_h_and_zeta`     | 显示海底地形和海面高度的三维图形 |
| `show_tide`           | 潮汐验证                         |

# 配置文件

在进行一切操作之前，首先需要编辑配置文件`configs.m`。

## 路径

| 用户输入 | 子配置项      | 含义                                            | 格式     |
| -------- | ------------- | ----------------------------------------------- | -------- |
| √        | `project_dir` | 项目目录，进行预处理的目录                      | `char[]` |
| √        | `build_dir`   | 模拟文件的输出目录，仅在Linux下直接后处理时指定 | `char[]` |

## time：时间

| 用户输入 | 子配置项       | 含义                 | 格式                         |
| -------- | -------------- | -------------------- | ---------------------------- |
| √        | `start`        | 开始时间             | `int[6]`，分别为年月日时分秒 |
| √        | `stop`         | 结束时间             | `int[6]`，分别为年月日时分秒 |
|          | `start_julian` | 开始时刻的简化儒略日 |                              |
|          | `stop_julian`  | 结束时刻的简化儒略日 |                              |
|          | `days`         | 总天数               |                              |

## grid：网格

| 用户输入 | 子配置项      | 含义                        | 格式                                  |
| -------- | ------------- | --------------------------- | ------------------------------------- |
| √        | `longitude`   | 经度范围                    | `double[2]`，分别为西侧经度、东侧经度 |
| √        | `latitude`    | 经度范围                    | `double[2]`，分别为南侧纬度、北侧纬度 |
| √        | `size`        | 网格大小（分辨率）          | `int[2]`，分别为Lm、Mm                |
| √        | `N`           | 垂向分层                    | `int`                                 |
| √        | `theta_s`     | 地形跟随坐标θs参数          | `double`                              |
| √        | `theta_b`     | 地形跟随坐标θb参数          | `double`                              |
| √        | `Tcline`      | 地形跟随坐标关键深度参数    | `double`                              |
| √        | `Hmin`        | 最小深度值                  | `double`                              |
| √        | `Vtransform`  | 地形跟随坐标Vtransform参数  | `int`                                 |
| √        | `Vstretching` | 地形跟随坐标Vstretching参数 | `int`                                 |

## input：输入文件

| 用户输入 | 子配置项         | 含义           | 格式     |
| -------- | ---------------- | -------------- | -------- |
| √        | `grid`           | 网格文件       | `char[]` |
| √        | `bot`            | 地形文件       | `char[]` |
| √        | `force`          | 气象强迫场文件 | `char[]` |
| √        | `climatology`    | 气候强迫场文件 | `char[]` |
| √        | `initialization` | 初始场文件     | `char[]` |
| √        | `boundary`       | 边界场文件     | `char[]` |
| √        | `tides`          | 潮汐强迫场文件 | `char[]` |
| √        | `rivers`         | 河流文件       | `char[]` |

## output：输出文件

| 用户输入 | 子配置项  | 含义       | 格式     |
| -------- | --------- | ---------- | -------- |
| √        | `hisotry` | 历史文件   | `char[]` |
| √        | `floats`  | 漂浮子文件 | `char[]` |

## roms.res：数据资源路径

| 用户输入 | 子配置项                                                     | 含义                                                         | 格式             |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------- |
| √        | `force_ncep_dir`                                             | NCEP FNL数据的文件夹位置<br />需要下载[NCEP的FNL数据](https://rda.ucar.edu/datasets/ds083.2/)，作为气象强迫文件的插值源。 | `char[]`         |
|          | `force_ncep_resolution`                                      | 需要生产的NCEP FNL数据的分辨率                               | `double`（度）   |
|          | `force_ncep_step`                                            | 所提供的NCEP FNL数据的时间分辨率                             | `double`（小时） |
| √        | `elevation`                                                  | 全球地形文件，用于网格文件的插值<br />ETOPO1可以从[此处](https://www.ngdc.noaa.gov/mgg/global/)下载，选择Cell/pixel-registered，netCDF，...gmt4.grd.gz<br />SRTM15可以从[此处](https://topex.ucsd.edu/WWW_html/srtm15_plus.html)下载，选择[FTP SRTM15+ and source identification (SID)](https://topex.ucsd.edu/pub/srtm15_plus/)，[SRTM15_V2.4.nc](https://topex.ucsd.edu/pub/srtm15_plus/SRTM15_V2.4.nc) | `char[]`         |
| √        | `elevation_longitude`<br />`elevation_latitude`<br />`elevation_altitude` | 高程文件中经度、纬度、海拔的字段名                           | `char[]`         |
| √        | `gshhs_f`                                                    | 全球海岸线文件<br />用于编辑水陆点，可以从[此处](https://www.soest.hawaii.edu/pwessel/gshhg/)下载，选择binary files。 | `char[]`         |
| √        | `tpx_uv`<br />`tpx_h`                                        | 潮汐文件<br />用于制作抄袭文件，可以从[此处](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/)下载。 | `char[]`         |
| √        | `hycom`                                                      | 海洋数据链接<br />用于在线下载海洋数据。根据不同的时间，进入[此链接](http://tds.hycom.org/thredds/catalog.html)，寻找合适时间的子目录，选择OPENDAP，获取链接。 | `char[]`         |
| √        | `hycom_local`                                                | 本地海洋数据的位置                                           | `char[]`         |
| √        | `hycom_local_step_hour`                                      | 本地海洋数据的时间分辨率                                     | `double`（小时） |
|          | `hycom_latitude`<br />`hycom_longitude`<br />`hycom_depth`<br />`hycom_time`<br />`hycom_u`<br />`hycom_v`<br />`hycom_temp`<br />`hycom_salt`<br />`hycom_surface_elevation` | 本地海洋数据的经度、纬度、深度、时间、U速度、V速度、温度、盐度、海表高度变量名 | `char[]`         |
| √        | `hycom_t0dt`                                                 | 本地海洋数据的基准时间                                       | `datetime`       |
|          | `hycom_t0`                                                   | 以日为单位存储的本地海洋数据的基准时间                       | `double`         |
| √        | `hycom_tunit`                                                | 本地海洋数据中1个时间单位表示的时间长度                      | `double`（小时） |
| √        | `multi_1_glo_30m`                                            | SWAN数据的文件夹                                             |                  |

## tracer：示踪剂

| 用户输入 | 子配置项                                     | 含义                           | 格式                                                         |
| -------- | -------------------------------------------- | ------------------------------ | ------------------------------------------------------------ |
| √        | `count`                                      | 示踪剂图层数量                 | `int`                                                        |
| √        | `age`                                        | 是否启用平均年龄`AGE_MEAN`功能 | `logical`                                                    |
| 延迟     | `densities`                                  | 示踪剂的浓度                   | `{double[grid.size(1)+1,grid.size(2)+1,grid.N,tracer.count]}`<br />元胞数组的长度应与配置的示踪剂数量相同。 |
| 延迟     | `ages`                                       | 示踪剂的初始年龄               | `{double[grid.size(1)+1,grid.size(2)+1,grid.N,tracer.count]}`<br />元胞数组的长度应与配置的示踪剂数量相同。 |
| 延迟     | `east`<br />`west`<br />`south`<br />`north` | 边界示踪剂的浓度               | `{double[grid.size(1/2),grid.N,tracer.count]}`<br />元胞数组的长度应与配置的示踪剂数量相同。 |

## rivers：河流

| 用户输入 | 子配置项           | 含义               | 格式                                                         |
| -------- | ------------------ | ------------------ | ------------------------------------------------------------ |
| √        | `count`            | 河流数量           | `int`                                                        |
| 延迟     | `location`         | 河流所在的坐标     | `int[rivers.count,2]`<br />行数为河流数量，每一行分别为横坐标和纵坐标。<br />`LuvSrc`时，指的是U/V面的位置；`LwSrc`时，指的是ρ点的位置。 |
| 延迟     | `direction`        | 流向               | `int[rivers.count,2]`<br />`LuvSrc`时，值为0（U方向）或1（V方向）；`LwSrc`时，值为2 |
| 延迟     | `time`             | 时间               | `double[]`<br />应覆盖模拟时间段                             |
| 延迟     | `transport`        | 流量               | `double[rivers.count,grid.N,rivers.time]`<br />`LuvSrc`时，具有正负，正值代表向数值更大的方向流动；`LwSrc`时，恒为正数。<br />单位：$m ^ 3 / s$ |
| 延迟     | `v_shape`          | 垂向流量分配       | `double[rivers.count,grid.N]`<br />流量在垂直层上的分布的百分比，每一列的总和应当为1。 |
| 延迟     | `temp`<br />`salt` | 温度<br />盐度     | `double[rivers.count,grid.N,rivers.time]`<br />单位分别为摄氏度、？ |
| 延迟     | `dye`<br />`ages`  | 示踪剂及其初始年龄 | `{double[rivers.count,grid.N,rivers.time]}`<br />元胞数组的长度应与配置的示踪剂数量相同。 |

## swan.forcing：SWAN强迫场

| 用户输入 | 子配置项  | 含义           | 格式                                                      |
| -------- | --------- | -------------- | --------------------------------------------------------- |
| √        | `specres` | 边界条件分辨率 | `int`<br />每一条边界的长度，这个数值越大，生成的文件越少 |

# ROMS

## 创建网格

建议使用`GridBuilder`来创建网格，更加专业。

若不使用，则首先执行`roms_create_grid_from_wrfinput`，从`wrfinput`创建网格，在弹出的窗口中根据海岸线编辑水陆点；或执行`roms_create_grid_core`，根据高程文件来创建网格。。然后执行`roms_fill_grid_h`填充水深。

## 边界场、初始场、全域逼近场

### 下载HYCOM数据

编辑`download_hycom.py`，指定区域和时间，使用Python下载所需的HYCOM数据。

### 确认示踪剂配置

若需要示踪剂，则编辑`roms_add_tracer`文件，在需要的地方填充初始时刻的示踪剂浓度。

### 制作文件

执行`roms_create_clm_bdy_ini`。会生成：

- 初始场文件：`roms_ini.nc `
- 边界文件：`roms_bdy.nc`
- 气象文件：`roms_clm.nc`

对于嵌套中的子区域，需要创建初始场和气象文件。可以和上面进行相同的步骤，也可以：

```matlab
create_roms_child_init( roms_grid, roms_child_grid, 'Sandy_ini.nc',  'Sandy_ini_ref3.nc') 
create_roms_child_clm( roms_grid, roms_child_grid,  'Sandy_clm.nc', 'Sandy_clm_ref3.nc')
```
这一部分还未进行修改。


## 潮汐场

执行`roms_create_tides`。

## 大气强迫场

下载NCEP的FNL数据，不要重命名，放在配置中的`roms.res.force_ncep_dir`下。

执行`roms_create_ncep_force`

## 河流

编辑`roms_create_rivers`，确认河流的位置、流量等信息。如果启用了示踪剂，则设置示踪剂浓度。之后执行。

## 最终所必需的文件（非嵌套）

- 网格文件：`roms_grid.nc`
- 初始场文件：`roms_ini.nc `
- 边界文件（若需要）：`roms_bdy.nc`
- 全域逼近文件（若需要）：`roms_clm.nc`
- 潮汐强迫文件（若需要）：`roms_tides.nc`
- 河流强迫文件（若需要）：`roms_rivers.nc`

# SWAN

暂未进行优化。

## 创建网格和水深

基于ROMS的网格进行创建：`swan_create_grid_from_roms`

嵌套网格同理暂未修改，使用：`roms2swan('roms_grid_ref3.nc')`

生成的文件包括：

- `swan_coord.grd`提供了每一个网格的坐标，先全是经度，然后全是纬度

- ``swan_bathy.bot`提供了每一个网格点的水深

## 大气强迫

在与WRF耦合时，这一步不需要，因此没有尝试。

## 边界场文件

执行`swan_create_boundary`

## 初始场文件

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

# 其他

## ROMS创建嵌套网格

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

## 海洋数据下载

其中有个[网址](http://tds.hycom.org/thredds/dodsC/GLBa0.08/expt_90.9)，来自于[HYCOM](http://tds.hycom.org/thredds/catalog.html)（hybrid coordinate ocean model，混合坐标海洋模型）。这里选用的是GOFS 3.0: HYCOM + NCODA Global 1/12° Analysis (NRL)-[`GLBu0.08/expt_90.9 (2012-05 to 2013-08)/`](http://tds.hycom.org/thredds/catalogs/GLBu0.08/expt_90.9.html)，选择[Hindcast Data: May-2012 to Aug-2013](http://tds.hycom.org/thredds/catalogs/GLBu0.08/expt_90.9.html?dataset=GLBu0.08-expt_90.9)，然后选择OPeNDAP：[//tds.hycom.org/thredds/dodsC/GLBu0.08/expt_90.9](http://tds.hycom.org/thredds/dodsC/GLBu0.08/expt_90.9.html)，其中有个Data URL后面就是所需要的地址。

> OPeNDAP是一个专门为本地系统透明的访问远程数据的客户端服务器系统，采用此系统客户端无需知道服务器端的存储格式、架构以及所采用的环境


进入[Revision 41](https://coawstmodel.sourcerepo.com/coawstmodel/data/)，选择[tide](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/)，下载[adcirc..](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/adcirc_ec2001v2e_fix.mat)或[tpx_h.mat](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/tpx_h.mat)和[tpx_uv.mat](https://coawstmodel.sourcerepo.com/coawstmodel/data/tide/tpx_uv.mat)。这个网站用IE才能打开，Chromium打不开，因为加密方式太老了。


编辑`Tools/mfiles/tides/create_roms_tides`。修改`Gname`到网格路径。修改`g`到模拟的开始时间。如果用adcirc，那么修改`if (adcirc)`后的路径。如果用ocu，那么修改上面到`adcirc=0;osu=1`，然后修改`if (osu)`后的路径。这里需要用ocu，用adcirc会报错。

## SWAN生成边界场文件代码的修改

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

   

