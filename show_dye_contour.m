function show_dye_contour(dye,xrange,yrange,level,tstart,tstep)
arguments
    dye(:,:,:,:) double =[]
    xrange(1,:) double {mustBeInteger,mustBePositive}=0
    yrange(1,:) double {mustBeInteger,mustBePositive}=0
    level(1,1) double {mustBeInteger} =0
    tstart(1,1) double {mustBeInteger,mustBePositive}=2
    tstep(1,1) double {mustBeInteger,mustBePositive}=10
end
configs
if numel(dye)==0
    dye=ncread(fullfile(roms.build_dir,roms.output.hisotry),'dye_01');
end
s=size(dye); %x,y,s,t
f=figure;
i=0;
if ~isequal(xrange,0) && ~isequal(yrange,0)
[x,y]=meshgrid(xrange,yrange);
end
for t=[tstart:tstep:s(4)]
    i=i+1 ;
    dye_t=dye(:,:,:,t);
    if level==0
        z=squeeze(sum(dye_t,3,"omitnan")); %全部深度
    elseif level<0
        z=squeeze( dye_t(:,:,end,:));
    else
        z=squeeze( dye_t(:,:,level,:));
    end
    subplot(3,4,i)
    if exist("xrange","var")
        z=z(xrange,yrange);
    end
    z=z.';
    if ~isequal(xrange,0) && ~isequal(yrange,0)
        contour(x,y,z,10)
    else
        contour(z,10)
    end
    title(['t=',num2str(t/2),'d'])
    colorbar
end

saveas(f,'graph.png');
savefig(f,'graph.fig')
%set(f,'visible','off');
end