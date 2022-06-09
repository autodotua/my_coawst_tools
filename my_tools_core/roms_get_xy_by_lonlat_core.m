function r=roms_get_xy_by_lonlat_core(locations,type)
    arguments
        locations
        type (1,1) string {mustBeMember(type,{'rho','u','v','psi'})} = 'rho'
    end

    configs
    lonlats=get_lonlat(locations);
    r=zeros(size(lonlats));
    cd(roms.project_dir);
    lon_grid=ncread(roms.input.grid,"lon_"+type);
    lat_grid=ncread(roms.input.grid,"lat_"+type);
    mask=ncread(roms.input.grid,"mask_"+type);
    pcolorjw(lon_grid,lat_grid,mask);
    hold on
    s=size(lon_grid);
    i=0;
    for location=lonlats'
        i=i+1;
        min_distance=1e100;
        min_x=-1;
        min_y=-1;
        for x=1:s(1)
            for y=1:s(2)
                lon=lon_grid(x,y);
                lat=lat_grid(x,y);
                distance=sqrt((lon-location(1))^2+(lat-location(2))^2);
                if distance<min_distance
                    min_distance=distance;
                    min_x=x;
                    min_y=y;
                end
            end
        end
        r(i,:)=[min_x,min_y];
        if min_distance>0.05
            warning(['第',num2str(i),'个位置',char(strjoin(string( num2str(location)),',')),'可能位于网格以外，距离为',num2str(min_distance)]);
            plot(lon_grid(min_x,min_y),lat_grid(min_x,min_y),'xr','MarkerSize',16);   
            text(lon_grid(min_x,min_y),lat_grid(min_x,min_y),num2str(i),'Color','g')
        else
            plot(lon_grid(min_x,min_y),lat_grid(min_x,min_y),'xg','MarkerSize',16);
            text(lon_grid(min_x,min_y),lat_grid(min_x,min_y),num2str(i),'Color','r')
        end
        
    end

    disp(r);
end

    function lonlat=get_lonlat(locations)
        size_loc=size(locations);
        if isstring(locations)
            locations=reshape(locations,1,[]);
            n=numel(locations);
            lonlat=zeros(n,2);
            i=0;
            for location=locations
                i=i+1;
                parts=strsplit(location,',');
                if numel(parts)~=2
                    error("无法解析位置字符串："+location)
                end
                lon=parts(1); lon=str2double(lon);
                lat=parts(2); lat=str2double(lat);
                lonlat(i,:)=[lon,lat];
            end
        elseif isnumeric(locations)
            if size_loc(2)~=2
                error("位置矩阵错误，需要有2列，每一行一个经纬度");
            end
        end
    end


