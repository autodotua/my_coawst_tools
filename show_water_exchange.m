function show_water_exchange(dye,zones,count)
    % arguments
    %     dye(:,:) cell
    %     zones(:,:) double
    %     count(1,1) double
    % end
    configs
    v=get_volumes;
    s=size(dye);



    r=zeros(count,s(4));
    for t=1:s(4)

    end
end

function r=get_volumes %获取每一个网格的水的体积
    configs
    sc_w=ncread(fullfile(roms.project_dir,roms.input.initialization),'sc_w');
    h=ncread(fullfile(roms.project_dir,roms.input.grid),'h');
    mask=ncread(fullfile(roms.project_dir,roms.input.grid),'mask_rho');
    lons=ncread(fullfile(roms.project_dir,roms.input.grid),'lon_rho');
    lats=ncread(fullfile(roms.project_dir,roms.input.grid),'lat_rho');

    size_xy=size(mask);
    size_z=size(sc_w);
    size_z=size_z(1)-1;

    %以下是求面积的近似方法
    r1=6378.140*pi*2/360; %赤道经度之间的距离
    r2=6356.755*pi*2/360; %纬度之间的距离
    area=zeros(size_xy(1),size_xy(2),size_z);
    for x=1:size_xy(1)
        for y=1:size_xy(2)
            lon1=lons(x,y);
            lat1=lats(x,y);
            x1=2*((x>1)-0.5); %如果x>1，那么x1=1，否则=-1，下同
            y1=2*((y>1)-0.5);
            lon2=lons(x-x1,y-y1); %用于计算长度的第二个经度值
            lat2=lats(x-x1,y-y1);
            dist_lon=abs(lon1-lon2)*r1*cosd(lat1)*1000; %经度之间的距离
            dist_lat=abs(lat1-lat2)*r2*1000;
            area(x,y,:)=dist_lon*dist_lat;
        end
    end


    r=zeros(size_xy(1),size_xy(2),size_z);
    for i=1:size_z
        real_height=h*(sc_w(i+1)-sc_w(i));
        real_height(~mask)=0;
        r(:,:,i)=real_height;
    end
r=r.*area;
end