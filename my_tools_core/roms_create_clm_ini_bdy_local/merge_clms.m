function merge_clms(times)
    configs
    filenames="clm_"+string(times,"yyyyMMddHH")+".nc";

    roms_grid_info=get_roms_grid_info( roms.grid,roms.input.grid);

    create_clm_nc(roms.input.climatology,times,roms_grid_info);
    info=ncinfo(roms.input.climatology);
    out=roms.input.climatology;
    for i=1:length(filenames)
        in=filenames(i);
        disp("正在合并："+in)
        for var=info.Variables
            try
            switch length(var.Dimensions)
                case 1
                    ncwrite(out,var.Name,ncread(in,var.Name),i);
                case 2
                    try
                        ncwrite(out,var.Name,ncread(in,var.Name),[1,i]);
                    catch
                    end
                case 3
                    ncwrite(out,var.Name,ncread(in,var.Name),[1,1,i]);
                case 4
                    ncwrite(out,var.Name,ncread(in,var.Name),[1,1,1,i]);
            end
            catch ex
                warning(ex.message)
            end
        end
    end
    disp 创建clm完成
end
