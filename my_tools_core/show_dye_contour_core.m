function show_dye_contour_core(dye,xrange,yrange,depth,tstart,tstep,levels)
    arguments
        dye(:,:,:,:) double =[]
        xrange(1,:) double {mustBeInteger,mustBePositive}=0
        yrange(1,:) double {mustBeInteger,mustBePositive}=0
        depth(1,1) double {mustBeInteger} =0
        tstart(1,1) double {mustBeInteger,mustBePositive}=2
        tstep(1,1) double {mustBeInteger,mustBePositive}=10
        levels(1,:) double {mustBePositive}=10
    end
    configs
    if numel(dye)==0
        dye=ncread(fullfile(roms.build_dir,roms.output.hisotry),'dye_01');
    end
    s=size(dye); %x,y,s,t
    f=figure(1);
    i=0;
    if ~isequal(xrange,0) && ~isequal(yrange,0)
        [x,y]=meshgrid(xrange,yrange);
    end
    for t=tstart:tstep:s(4)
        i=i+1 ;
        dye_t=dye(:,:,:,t);
        if depth==0
            z=squeeze(sum(dye_t,3,"omitnan")); %全部深度
        elseif depth<0
            z=squeeze(dye_t(:,:,end,:));
        else
            z=squeeze(dye_t(:,:,depth,:));
        end
        subplot(3,4,i)
        %h=ncread(fullfile(roms.project_dir,roms.input.grid),'h');
        %pcolorjw(x,y,h(xrange,yrange).')
        colormap winter
        hold
        if exist("xrange","var")
            z=z(xrange,yrange);
        end
        z=z.';
        if ~isequal(xrange,0) && ~isequal(yrange,0)
            contourf(x,y,z,levels)
        else
            contourf(z,levels)
        end
        colormap hsv
        %colormap(hot)
        %title(['t=',num2str(t/2),'d'])
        title(['t=',num2str(i)])
        %colorbar
    end

    saveas(f,'graph.png');
    savefig(f,'graph.fig')
    %set(f,'visible','off');
end