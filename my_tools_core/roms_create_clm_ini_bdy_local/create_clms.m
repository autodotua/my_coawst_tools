configs
start=datetime(roms.time.start)+hours(roms.res.hycom_local_step_hour);
stop=datetime(roms.time.stop);
step=hours(roms.res.hycom_local_step_hour);
times=start:step:stop;
filenames=fullfile(roms.res.hycom_local, string(times,"yyyyMMddHH")+".nc");
for in=filenames
    if ~isfile(in)
        error("文件不存在："+in)
    end
end
for time=times
    disp("正在处理："+string(time,'yyyyMMddHH'))
    roms_create_single(time);
end
merge_clms(times);