function show_water_exchange_core(dye,zones,count)
    arguments
        dye(:,:,:,:) double
        zones(:,:,:) double
        count(1,1) double
    end
    configs
    v=get_volumes;
    s=size(dye);
    dye(isnan(dye))=0;%将NaN转为0方便计算
    sum_dye_w=sum(dye(:,:,:,1).*v,'all'); %初始时刻的示踪剂总质量
    figure(2);
    for z=1:count
        weights=zeros(s(4),1);
        for t=1:s(4)
            dye_w=dye(:,:,:,t).*v; %当前时间，示踪剂在不同网格内的质量
            dye_sum_w_in_zone=sum(dye_w(zones==z),'all'); %当前时间当前区域内示踪剂的总质量
            weights(t)=dye_sum_w_in_zone/sum_dye_w; %该时间该区域内的示踪剂质量占初始时刻总质量的百分比
        end
        plot(weights,'LineWidth',1)
        hold on
    end
    axis([0,s(4),0,1]);
    legend(num2str((1:count).'))

end

