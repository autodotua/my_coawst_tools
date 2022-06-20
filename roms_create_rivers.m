configs
roms.rivers.count=5;
roms.rivers.time=[0:720];
roms.rivers.direction=ones(roms.rivers.count,1)*2;
roms.rivers.location= [
    1      115   %七堡 钱塘江
    64    94   %曹娥江大闸闸前
    106    153   %长山闸一号桥
    28    131   %上塘河排涝闸
    182    122   %四灶浦闸
    %160 50
    ]-1;
mask=ncread(roms.input.grid,'mask_rho');
for loc=roms.rivers.location'
    if mask(loc(1)+1,loc(2)+1)==0
        error(['点',num2str(loc),'在陆地上'])
    end
end
roms.rivers.transport=ones(roms.rivers.count,numel(roms.rivers.time));
roms.rivers.transport(1,:)=1403;
roms.rivers.transport(2,:)=124;
roms.rivers.transport(3,:)=113; %汛期
roms.rivers.transport(4,:)=80; %？
roms.rivers.transport(5,:)=50; %？

roms.rivers.v_shape=ones(roms.rivers.count,roms.grid.N)/roms.grid.N;
roms.rivers.temp=8*ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
roms.rivers.salt=0.1*ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));

dyes=[
    5.2   9   12   14    17 %COD
    0.065  0.05   0.148  0.192  0.059 %总磷
    2.04 2.5 3.52  2.26  0.91 %总氮
    ]/1000;

roms.rivers.dye=cell(roms.tracer.count,1);
for i=1:roms.tracer.count
    dye=zeros(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
    j=0;
    for d=dyes 
        j=j+1;
        dye(j,:,:)=dyes(i,j);
    end
    %dye(:,:,10:20)=0;
    roms.rivers.dye{i}=dye;
end

roms_create_rivers_core(roms)