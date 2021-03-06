import requests 
import os
from datetime import datetime
from datetime import timedelta
start=datetime(2020,1,1,0)
end=datetime(2020,1,31,0)
span=timedelta(hours=24)
xmin=120; xmax=123
ymin=29; ymax=32
baseUrl="http://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_93.0"
# proxies = {
#   "http": "http://192.168.1.100:7890",
#   "https": "http://192.168.1.100:7890",
# }

time=start
while time<=end:
    filename=f"{time.year}{'%02d' % time.month}{'%02d' % time.day}{'%02d' % time.hour}.nc"
    if os.path.exists(filename):
        print('文件'+filename+'已存在，跳过')
    else:
        print("开始下载："+str(time))
        url=f"{baseUrl}?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&"+\
            f"north={ymax}&west={xmin}&east={xmax}&south={ymin}&horizStride=1&"+\
                f"time={time.year}-{'%02d' % time.month}-{'%02d' % time.day}T{'%02d' % time.hour}%3A00%3A00Z"+\
                "&vertCoord=&addLatLon=true&accept=netcdf4"
        print("链接为："+url)
        host='ncss.hycom.org'
        ua='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.124 Safari/537.36 Edg/102.0.1245.41'
        # nc=requests.get(url,headers={'Host':host,'UserAgent':ua},proxies=proxies)
        nc=requests.get(url,headers={'Host':host,'UserAgent':ua})
        if not nc.ok:
            print("下载失败："+str(time)+"，代码："+str(nc.status_code))
        else:
            print("下载完成："+str(time))
            with open(filename, "wb") as code:
                code.write(nc.content)
    time=time+span
    print("")
