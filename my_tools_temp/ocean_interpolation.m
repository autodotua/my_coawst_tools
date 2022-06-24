file="C:\Users\autod\OneDrive\大学\海洋污染物监测.xlsx";
xmin=120.7; xmax=123;
ymin=29.8; ymax=31.2;
var="化学需氧量";
year=2021; month=10;
range=[0,5];

table=readtable(file,"VariableNamingRule","preserve");
s=size(table);
result=zeros(0,4);
for i=1:s(1)
    line=table(i,:);
    lon=line.("经度");
    lat=line.("纬度");
    y=line.("年份");
    m=line.("月份");
    id=line.("站点号");
   id=str2double(id{1}(4:end));
    if lon>xmin && lon<xmax && lat>ymin && lat<ymax ...
        && y==year && m==month ...
        && ~ismember(id, result)
        value=line.(var);
        result(end+1,:)=[lon,lat,value,id];
    end
end

if isempty(result)
    error("没有找到符合要求的数据")
end

F=scatteredInterpolant(result(:,1),result(:,2),result(:,3),'natural');
configs;

d=cd(roms.project_dir);
lon=ncread(roms.input.grid,'lon_rho');
lat=ncread(roms.input.grid,'lat_rho');
mask=ncread(roms.input.grid,'mask_rho');
value=F(lon,lat);
value(mask==0)=nan;
hold on;
pcolorjw(lon,lat,value);
plot(result(:,1),result(:,2),'.');
caxis([0,max(value(:))]); 
caxis(range);
colorbar
cd(d);
