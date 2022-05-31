roms.rivers.count=1;
roms.rivers.time=[0:roms.time.days];
roms.rivers.direction=ones(roms.rivers.count,1)*2;
roms.rivers.location= [
    130 130
    %160 50
    ];
roms.rivers.transport=1000*ones(roms.rivers.count,numel(roms.rivers.time));
roms.rivers.v_shape=ones(roms.rivers.count,roms.grid.N)/roms.grid.N;
roms.rivers.temp=4*ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
roms.rivers.salt=30*ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
dyes=cell(roms.tracer.count,1);
for i=1:numel(roms.tracer.count)
    dye=zeros(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
    dye(:)=100;
    %dye(:,:,10:20)=0;
    dyes{i}=dye;
end
roms.rivers.dye=dyes;

roms_create_rivers_core