function result=interpolate_hycom_to_roms(file,var,roms_grid_info,hycom_info,type,dim)

    X=repmat(hycom_info.lons,1,length(hycom_info.lats));
    Y=repmat(hycom_info.lats,length(hycom_info.lons),1);
    if dim==3
        levels=length(hycom_info.depths);
        %获取nc文件内的数据
        data=ncread(file,var, ...
            [hycom_info.lon_index1 hycom_info.lat_index1 1 1], ...
            [hycom_info.lon_index2-hycom_info.lon_index1+1, ...
            hycom_info.lat_index2-hycom_info.lat_index1+1, ...
            levels,1 ]);
        value=zeros(levels,roms_grid_info.Lm+2,roms_grid_info.Mm+2);
        %进行z坐标上的平面插值，从HYCOM坐标转为ROMS坐标

        disp(['正在插值HYCOM的',char(var),'数据']);
        for k=1:levels
            tmp=double(squeeze(data(:,:,k)));
            F = scatteredInterpolant(X(:),Y(:),tmp(:));
            r = F(roms_grid_info.lon_rho,roms_grid_info.lat_rho);
            value(k,:,:)=maplev(r); %外插到全部位置。这个外插和scatteredInterpolant用的不太一样，效果更好
        end
        result=roms_interpolate(roms_grid_info,hycom_info.depths,value,type,0);
    elseif dim==2
        data=ncread(file,var, ...
            [hycom_info.lon_index1 hycom_info.lat_index1 1], ...
            [hycom_info.lon_index2-hycom_info.lon_index1+1, ...
            hycom_info.lat_index2-hycom_info.lat_index1+1, ...
            1 ]);
        disp(['正在插值HYCOM的',char(var),'数据']);
        tmp=double(squeeze(data(:,:)));
        F = scatteredInterpolant(X(:),Y(:),tmp(:));
        r = F(roms_grid_info.lon_rho,roms_grid_info.lat_rho);
        result=maplev(r); %外插到全部位置。这个外插和scatteredInterpolant用的不太一样，效果更好
    end
end
