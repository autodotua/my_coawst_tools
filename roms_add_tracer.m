configs
roms.tracer.count=3;
d1=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d2=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d3=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d4=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
d5=zeros(roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N);
s=size(d1);
mask=ncread(fullfile(roms.project_dir,roms.input.grid),'mask_rho');
d=ones(roms.grid.size(1)+2,roms.grid.size(2)+2);
d(mask==0)=0;
d(136:end,:)=0;
dd=ones(roms.grid.size(1)+2,roms.grid.size(2)+2,roms.grid.N);
for i=1:roms.grid.N
    dd(:,:,i)=d;
end
%d1(130:150,100:120,:)=10;
%     for x=1:s(1)
%         for y=1:s(2)
%             if h(x,y)
%                 if x>160
%                     continue
%                 elseif x>70
%                     d4(x,y,:)=10;
%                 else
%                     if y<116
%                         d3(x,y,:)=10;
%                     elseif x>37 && y<125 || x>55 && y<145
%                         d2(x,y,:)=10;
%                     else
%                         d1(x,y,:)=10;
%                     end
%                 end
%             end
%         end
%     end

%示踪剂的密度
% roms.tracer.densities={d1;d2;d3;d4;d5};

roms.tracer.densities={dd,dd,dd};
d=1e-3;
for i=1:roms.tracer.count
    roms.tracer.east{i}(:)=d;
    roms.tracer.north{i}(:)=d;
    roms.tracer.south{i}(:)=d;
end
roms_add_tracer_core(roms);