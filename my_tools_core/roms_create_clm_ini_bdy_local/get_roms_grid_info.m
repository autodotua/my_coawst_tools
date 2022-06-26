function roms_grid_info=get_roms_grid_info(gridinfo,gridfile)
    % 获取ROMS网格信息
    arguments
        gridinfo
        gridfile(1,1) string
    end
    if (gridinfo.Vtransform==1)
        h=ncread(gridfile,'h');
        hmin=min(h(:));
        hc=min(max(hmin,0),gridinfo.Tcline);
    elseif (gridinfo.Vtransform==2)
        hc=gridinfo.Tcline;
    end
    gridinfo.hc=hc;
    roms_grid_info=get_roms_grid(gridfile,gridinfo);
    %翻转z
    roms_grid_info.z_r=shiftdim(roms_grid_info.z_r,2);
    roms_grid_info.z_u=shiftdim(roms_grid_info.z_u,2);
    roms_grid_info.z_v=shiftdim(roms_grid_info.z_v,2);
    roms_grid_info.z_w=shiftdim(roms_grid_info.z_w,2);
end