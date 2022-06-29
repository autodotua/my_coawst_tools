function r=show_value_change_core(options)
arguments
    options.file(1,1) string=""
    options.varname(1,1) string=""
    options.data(:,:,:,:) double=[]
    options.step_per_day(1,1) double {mustBePositive}=1,
    options.position='all'
    options.type(1,1) string {mustBeMember(options.type,["sum","ave"])}="sum"
    options.to_volumes logical=false
    options.show_graph logical=true
    options.smooth(1,1) double {mustBeInteger}=0
    options.timerange(1,:) double {mustBeInteger,mustBePositive}=[]
    options.legend_name(1,1) string='',
end

if isempty(options.data)
    try
        nc=netcdf.open(options.file);
        if string(options.varname)=="uv"
            u=netcdf.getVar(nc,netcdf.inqVarID(nc,'u'));
            u=0.5*(u(:,1:end-1,:,:)+u(:,2:end,:,:));
            u=u.^2;
            v=netcdf.getVar(nc,netcdf.inqVarID(nc,'v'));
            v=0.5*(v(1:end-1,:,:,:)+v(2:end,:,:,:));
            v=v.^2;
            data=u+v;
            clear u v
            data=sqrt(data);
        else
            data=netcdf.getVar(nc,netcdf.inqVarID(nc,options.varname));
        end

        netcdf.close(nc);
    catch
        try
            netcdf.close(nc);
        catch
        end
    end
else
    data=options.data;
end

disp("数据加载完成")
whos data

if ~isempty(options.timerange)
    data=data(:,:,:,options.timerange);
end
s=size(data);


if options.to_volumes
    v=roms_get_volumes;
    for i=1:s(4)
        data(:,:,:,i)=data(:,:,:,i).*v;
    end
end

if isequal(options.position,'all')
    r=squeeze(sum(data,[1,2,3],'omitnan'));
    if options.type=="ave"
        r=r/(s(1)*s(2)*s(3));
    end

elseif isnumeric(options.position)
    if numel(options.position)==2
        r=squeeze(sum(data(options.position(1),options.position(2),:,:),3,'omitnan'));
        if options.type=="ave"
            r=r/s(3);
        end
    elseif numel(options.position)==3
        r=squeeze(data(options.position(1),options.position(2),options.position(3),:));
    else
        error('未知位置格式');
    end
else
    error('未知位置格式');
end
if options.smooth>0
    r=smoothdata(r,'gaussian',options.smooth);
end
disp("数据处理完成")

if options.show_graph
    x=0:1/options.step_per_day:numel(r)/options.step_per_day;
    x=x(2:end)';        
    figure(1)
    hold on
    plot(x,r,'-',"DisplayName",options.legend_name);

    xlabel('时间（天）')
    ylabel('值')
    legend
    hold off
end
end