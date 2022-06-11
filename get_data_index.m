function [x,y,z,t]=get_data_index(fileordata,varname,condition)
arguments
    fileordata
    varname(1,1) string=""
    condition=[]
end
if isnumeric(fileordata)
    data=fileordata;
else
    data=ncread(fileordata,varname);
end
if islogical(condition)

    ids=find(condition);
else
    ids=eval(['find(',condition,')']);
end
s=size(data);

[x,y,z,t]=ind2sub(s,ids);
for i=1:numel(x)
    disp([x(i),y(i),z(i),t(i)])
end