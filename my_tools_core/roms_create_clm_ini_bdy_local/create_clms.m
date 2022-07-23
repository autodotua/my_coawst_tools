function filenames=create_clms(start,stop,step,skip_existed)
    arguments
        start(1,1) datetime
        stop(1,1) datetime
        step(1,1) duration
        skip_existed(1,1) logical
    end
    configs

    times=start:step:stop;
    filenames=fullfile(roms.res.hycom_local, string(times,"yyyyMMddHH")+".nc");
    for in=filenames
        if ~isfile(in)
            error("文件不存在："+in)
        end
    end
    for time=times
        if skip_existed
            name="clm_"+string(time,'yyyyMMddHH')+".nc";
            if isfile(name)
                disp("文件"+name+"已存在");
                continue;
            end
        end
        disp("正在处理："+string(time,'yyyyMMddHH'))
        create_single_clm(time);
    end
    filenames=merge_clms(times);