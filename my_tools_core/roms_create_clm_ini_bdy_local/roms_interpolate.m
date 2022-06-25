function roms_with_s_levels = roms_interpolate(roms_grid_info,hycom_z,data,type,do_interp2)
    arguments
        roms_grid_info
        hycom_z(:,:,:)
        data(:,:,:)
        type char {mustBeMember(type,{'rho','u','v'})}
        do_interp2 logical
    end
    lon=roms_grid_info.lon_rho;
    lat=roms_grid_info.lat_rho;
    roms_lon =eval(['roms_grid_info.lon_',type]);
    roms_lat =eval(['roms_grid_info.lat_',type]);
    roms_mask =eval(['roms_grid_info.mask_',type]);
    land_id = find(roms_mask==0);

    % preallocate arrays for data -> roms_stdlev([time],stdlev,lat,lon)
    % preallocate arrays for data -> roms([time],scoord,lat,lon)

    roms_with_s_levels = [];

    %     if isempty(hycom_z)
    %
    %         if ndims(data) == 3
    %             Nt = size(data,1);
    %             roms_stdlev = zeros([Nt size(roms_lon)]);
    %
    %         elseif ismatrix(data)
    %             Nt = 1;
    %             roms_stdlev = zeros([size(roms_lon)]);
    %
    %         else
    %             error('数据必须为2或3维')
    %         end
    %
    %     else

    if ndims(data) == 4
        time_step_count = size(data,1);
        hycom_z_level_count = size(data,2);
        roms_with_z_levels = zeros([time_step_count hycom_z_level_count size(roms_lon)]);
        roms_level_count = size(roms_grid_info.z_r,1);
        roms_with_s_levels = zeros([time_step_count roms_level_count size(roms_lon)]);

    elseif ndims(data) == 3
        time_step_count = 1;%number of time steps
        hycom_z_level_count = size(data,1);%number of z levels
        roms_with_z_levels = zeros([hycom_z_level_count size(roms_lon)]);
        roms_level_count = size(roms_grid_info.z_r,1);
        roms_with_s_levels = zeros([roms_level_count size(roms_lon)]);

    elseif ismatrix(data)
        time_step_count = 1;
        hycom_z_level_count = 1;
        roms_with_z_levels = zeros(size(roms_lon));

    else
        error('data的维度应为2、3或4')
    end

    % 强制zlev为从浅到深负值，以符合ROMS标准
    hycom_z = -abs(hycom_z(:));
    % 检查数据是否按照从深到浅的顺序排列
    if hycom_z_level_count>1 && any(diff(hycom_z)<0)
        % 深度是由浅到深排列的，翻转一下
        % disp('反转zlevs，使其从深到浅排列');
        hycom_z = flipud(hycom_z);
        data = flip(data,ndims(data)-2);
    end

    %     end

    % INTERPOLATE TO HORIZONTAL GRID ----------------------------------------------
    % -----------------------------------------------------------------------------
    if do_interp2
        error("无实现")
    end
    %     if do_interp2
    %
    %         disp('Interpolating to the ROMS horizontal grid at standard levels') % -----
    %         switch ndims(roms_with_z_levels)
    %
    %             case 4
    %                 for l = 1:time_step_count
    %                     disp([' Doing time ' int2str(l) ' of ' int2str(time_step_count)])
    %                     for k = 1:hycom_z_level_count
    %                         datawrk = squeeze(data(l,k,:,:));
    %                         tmp = interp2(lon,lat,datawrk,roms_lon,roms_lat,'spline');
    %                         if ~isempty(land_id),tmp(land_id)=0;end
    %                         roms_with_z_levels(l,k,:,:) = tmp;
    %                     end
    %                 end
    %
    %             case 3
    %                 for k = 1:max([time_step_count hycom_z_level_count])
    %                     datawrk = squeeze(data(k,:,:));
    %                     try
    %                         tmp = interp2(lon,lat,datawrk,roms_lon,roms_lat,'spline');
    %                         if ~isempty(land_id),tmp(land_id)=0;end
    %                         roms_with_z_levels(k,:,:) = tmp;
    %                     catch
    %                         tmp = griddata(lon,lat,datawrk,roms_lon,roms_lat);
    %                         if ~isempty(land_id),tmp(land_id)=0;end
    %                         roms_with_z_levels(k,:,:) = tmp;
    %                     end
    %                 end
    %
    %             case 2
    %                 datawrk = data;
    %                 try
    %                     tmp = interp2(lon,lat,datawrk,roms_lon,roms_lat,'spline');
    %                     if ~isempty(land_id),tmp(land_id)=0;end
    %                     roms_with_z_levels(:,:) = tmp;
    %                 catch
    %                     tmp = griddata(lon,lat,datawrk,roms_lon,roms_lat);
    %                     if ~isempty(land_id),tmp(land_id)=0;end
    %                     roms_with_z_levels(:,:) = tmp;
    %                 end
    %
    %         end
    %
    %     else

    % 将水平数据转换到合适的网格
    roms_with_z_levels = convert_rho_to_uv(type, roms_lon,roms_with_z_levels, data);

    %     end

    % INTERPOLATE TO VERTICAL GRID ------------------------------------------------
    % -----------------------------------------------------------------------------

    if isempty(roms_with_s_levels)
        disp('不需要垂直插值')
        roms_with_s_levels = roms_with_z_levels;

    else
        %disp('正在插值σ坐标')
        zr = roms_grid_info.z_r;
        switch type
            case 'u'
                s = size(zr,2);
                zr = 0.5*(zr(:,1:s-1,:)+zr(:,2:s,:));
            case 'v'
                s = size(zr,3);
                zr = 0.5*(zr(:,:,1:s-1)+zr(:,:,2:s));
        end

        switch ndims(roms_with_s_levels)

            case 4
                for l=1:time_step_count
                    %disp(['执行时间： ' int2str(l) ' / ' int2str(time_step_count)])

                    % interpolate a y-z plane each time
                    Nx = size(roms_with_s_levels,3);
                    for i=1:Nx % x index

                        if ~rem(i,20)
                            %disp(['执行中： i = ' int2str(i) ' /' int2str(Nx)])
                        end

                        z = squeeze(zr(:,i,:));
                        s = size(z,2);
                        x = repmat(1:s,[roms_level_count 1]);

                        % There may be ROMS z values outside the stdlev z range, so pad
                        % above and below before interp2 (just like in roms_zslice)
                        % (Hmmm ... there may still be a catch if there are some very
                        % deep depths with NaNs in the data)
                        [xa,za] = meshgrid(1:s,[-10000; -abs(hycom_z); 10]);

                        data = squeeze(roms_with_z_levels(l,:,i,:));
                        data = [data(1,:); data; data(hycom_z_level_count,:)];
                        roms_with_s_levels(l,:,i,:) = interp2(xa,za,data,x,z,'spline');

                    end
                end

            case 3
                clear lat lon roms_lat roms_lon roms_mask
                % interpolate a y-z plane each time
                Nx = size(roms_with_s_levels,2);
                for i=1:Nx % x index
                    z = squeeze(zr(:,i,:));
                    s = size(z,2);
                    x = repmat(1:s,[roms_level_count 1]);

                    % There may be ROMS z values outside the stdlev z range, so pad
                    % above and below before interp2 (just like in roms_zslice)
                    % (Hmmm ... there may still be a catch if there are some very
                    % deep depths with NaNs in the data)
                    [xa,za] = meshgrid(1:s,[-10000; -abs(hycom_z); 10]);

                    data = squeeze(roms_with_z_levels(:,i,:));
                    data = [data(1,:); data; data(hycom_z_level_count,:)];
                    data((isnan(data)==1))=0;
                    roms_with_s_levels(:,i,:) = interp2(xa,za,data,x,z,'spline');

                end
        end
    end
end


function roms_with_z_levels = convert_rho_to_uv(type,roms_grid, roms_with_z_levels, data)
    switch type
        case 'rho'
            roms_with_z_levels = data;
        case 'u'
            [s,~] = size(roms_grid);
            switch ndims(roms_with_z_levels)
                case 4
                    roms_with_z_levels = 0.5*(data(:,:,1:s,:)+data(:,:,2:s+1,:));
                case 3
                    roms_with_z_levels = 0.5*(squeeze(data(:,1:s,:))+squeeze(data(:,2:s+1,:)));
                case 2
                    roms_with_z_levels = 0.5*(data(1:s,:)+data(2:s+1,:));
            end

        case 'v'
            %disp('正在平均到 v 点网格')
            [~,s] = size(roms_grid);
            switch ndims(roms_with_z_levels)
                case 4
                    roms_with_z_levels = 0.5*(data(:,:,:,1:s)+data(:,:,:,2:s+1));
                case 3
                    roms_with_z_levels = 0.5*(data(:,:,1:s)+data(:,:,2:s+1));
                case 2
                    roms_with_z_levels = 0.5*(data(:,1:s)+data(:,2:s+1));
            end

    end
end

