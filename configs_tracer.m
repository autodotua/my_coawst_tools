function tracer=configs_tracer(roms)
roms.tracer.count=5;
d1=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d2=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d3=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d4=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d5=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
s=size(d1);
h=ncread(fullfile(roms.project_dir,roms.input.grid),'mask_rho');
for x=1:s(1)
    for y=1:s(2)
        if h(x,y)
            if x<78
                d1(x,y,:)=10;
            elseif x<164
                if y>92
                    d2(x,y,:)=10;
                elseif y<42

                    d3(x,y,:)=10;
                else
                    d4(x,y,:)=10;
                end
            else
                d5(x,y,:)=10;
            end
        end
    end
    %示踪剂的密度
    roms.tracer.densities={d1;d2;d3;d4;d5};
    tracer=roms.tracer;
end
