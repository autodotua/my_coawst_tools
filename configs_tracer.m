function tracer=configs_tracer(roms)
d=roms.tracer.densities{1};
for i=180:190
    for j=50:60
        d(i,j,:)=10;
    end
end
d(:)=0;
%示踪剂的密度
roms.tracer.densities={d};
tracer=roms.tracer;
end
