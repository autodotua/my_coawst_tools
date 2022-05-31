configs
s=size(dye);
z=zeros(s(1:3));
h=ncread(fullfile(roms.project_dir,roms.input.grid),'mask_rho');
for x=1:s(1)
    for y=1:s(2)
        if h(x,y)
            if x>160
                continue
            elseif x>70
                z(x,y,:)=4;
            else
                if y<116
                    z(x,y,:)=3;
                elseif x>37 && y<125 || x>55 && y<145
                    z(x,y,:)=2;
                else
                    z(x,y,:)=1;
                end
            end
        end
    end
end
show_water_exchange_core(dye,z,4)
