function r=show_dye_sum_core(fileordye,varname,show)
    arguments
        fileordye
        varname(1,1) string=""
        show=true
    end
    if isnumeric(fileordye)
        data=fileordye;
    else
        data=ncread(fileordye,varname);
    end
    dyes=sum(data,[1,2,3],'omitnan');
    r=squeeze(dyes);
    if show
        plot(r);
    end