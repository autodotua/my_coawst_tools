configs('rivers')
roms.rivers.count=5;
roms.rivers.time=[0:roms.time.days];
roms.rivers.direction=ones(roms.rivers.count,1)*2;
roms.rivers.location= [
    0      57   %七堡 钱塘江
    31    41   %曹娥江大闸闸前
    51    72   %长山闸一号桥
    12    59   %上塘河排涝闸
    91    56   %四灶浦闸
    %160 50
    ];
roms.rivers.transport=ones(roms.rivers.count,numel(roms.rivers.time));
roms.rivers.transport(1,:)=1403;
roms.rivers.transport(2,:)=124;
roms.rivers.transport(3,:)=113; %汛期
roms.rivers.transport(4,:)=80; %？
roms.rivers.transport(5,:)=50; %？

roms.rivers.v_shape=ones(roms.rivers.count,roms.grid.N)/roms.grid.N;
roms.rivers.temp=16*ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));
roms.rivers.salt=0.1*ones(roms.rivers.count,roms.grid.N,numel(roms.rivers.time));

dyes=[
    5.2   9   12   14    17 %COD
    0.065  0.05   0.148  0.192  0.059 %总磷
    2.04 2.5 3.52  2.26  0.91 %总氮
    ];

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