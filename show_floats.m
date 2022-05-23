groups=ones(6)*20;
configs
netcdf_load(roms.input.grid);
netcdf_load(fullfile(roms.build_dir,roms.output.floats));
figure
pcolorjw(lon_rho,lat_rho,h);
hold
n=size(lon);
colors=['y','m','c','r','g','b','w','k'];

index=1;
group_index=0;
for g=groups

    color=colors(mod(group_index,numel(colors)) + 1);
    for i=index:index+g
        plot(lon(i,:),lat(i,:),color=color);
    end
    index=index+g;
    group_index=group_index+1;
end
