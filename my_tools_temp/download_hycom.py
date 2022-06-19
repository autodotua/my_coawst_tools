import requests 
from datetime import datetime
from datetime import timedelta
start=datetime(2019,9,1,0)
end=datetime(2019,9,6,0)
span=timedelta(hours=3)
xmin=120; xmax=134
ymin=23; ymax=34
# proxies = {
#   "http": "http://192.168.1.100:7890",
#   "https": "http://192.168.1.100:7890",
# }

time=start
while time<=end:
    print("开始下载："+str(time))
    url=f"http://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_93.0?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&"+\
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
        with open(f"{time.year}{'%02d' % time.month}{'%02d' % time.day}{'%02d' % time.hour}.nc", "wb") as code:
            code.write(nc.content)
    time=time+span
    print("")
