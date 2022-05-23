function rivers=configs_rivers(roms)
roms.rivers.count=2;
roms.rivers.time=[0:roms.time.days];
roms.rivers.direction=get_rivers_direction(roms);
roms.rivers.location=get_rivers_location(roms);
roms.rivers.transport=get_rivers_transport(roms);
roms.rivers.v_shape=get_rivers_vshape(roms);
roms.rivers.temp=get_rivers_temp(roms);
roms.rivers.salt=get_rivers_salt(roms);
roms.rivers.dye=get_rivers_dye(roms);
rivers=roms.rivers;
end

function r=get_rivers_direction(roms)
r=ones(roms.rivers.count,1)*2;
end

function r= get_rivers_location(roms)
r= [
    81 88
    160 50
    ];
end

function r= get_rivers_transport(roms)
r=1000*ones(roms.rivers.count,numel(roms.rivers.time));
r(1,:)=0;
end

function r= get_rivers_vshape(roms)
r=ones(roms.rivers.count,roms.grid.N)/roms.grid.N;
end

function r= get_rivers_temp(roms)
r= zeros(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
end

function r= get_rivers_salt(roms)
r= zeros(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
end

function r= get_rivers_dye(roms)
dyes=cell(roms.tracer.count,1);
for i=1:numel(roms.tracer.count)
    dye=zeros(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
    dye(:)=100;
    %dye(:,:,10:20)=0;
    dyes{i}=dye;
end
r= dyes;
end


