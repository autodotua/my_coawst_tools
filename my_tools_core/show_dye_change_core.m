function r=show_dye_change_core(fileordye,varname,position,type,tovolume,show)
arguments
    fileordye
    varname(1,1) string=""
    position='all'
    type(1,1) string {mustBeMember(type,["sum","ave"])}="sum"
    tovolume logical=false
    show logical=true
end

if isnumeric(fileordye)
    data=fileordye;
else
    data=ncread(fileordye,varname);
end
s=size(data);
if tovolume
    v=roms_get_volumes;
    for i=1:s(4)
        data(:,:,:,i)=data(:,:,:,i).*v;
    end
end
if isequal(position,'all')
    r=squeeze(sum(data,[1,2,3],'omitnan'));
    if type=="ave"
        r=r/(s(1)*s(2)*s(3));
    end

elseif isnumeric(position)
    if numel(position)==2
        r=squeeze(sum(data(position(1),position(2),:,:),3,'omitnan'));
        if type=="ave"
            r=r/s(3);
        end
    elseif numel(position)==3
        r=squeeze(data(position(1),position(2),position(3),:));
    else
        error('未知位置格式');
    end
else
    error('未知位置格式');
end
if show
    figure(1)
    hold on
    plot(r);
    plot(smoothdata(r,'gaussian',10),'-')
    hold off
end