function show_dye_cross_sectional_concentration(dye,normalize)
arguments
    dye(:,:,:,:) double=[]
    normalize(1,1) double {mustBeNumericOrLogical}=0

end

configs
if numel(dye)==0
    dye=ncread(fullfile(roms.build_dir,roms.output.hisotry),'dye_01');
end
s=size(dye); %x,y,s,t
z=zeros(s(3),s(4));
for t=[1:s(4)]
    dye_t=dye(:,:,:,t);
    y=squeeze( sum(sum(dye_t,1,"omitnan"),2)).';
    if normalize
        y=y/sum(y);
    end
    z(:,t)=flip(y);
end
[X,Y]=meshgrid([1:s(4)],[s(3):-1:1]);
surf(X,Y,z)
xlabel('时间步');
ylabel('深度')
zlabel('含量')
colorbar