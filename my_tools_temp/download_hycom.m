url="http://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_93.0?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=34&west=120&east=134&south=23&horizStride=1&time=2019-09-01T00%3A00%3A00Z&vertCoord=&addLatLon=true&accept=netcdf4";

options=weboptions;
options.Timeout=100;
options.UserAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.124 Safari/537.36 Edg/102.0.1245.41";
options.HeaderFields=["Host","ncss.hycom.org";
    "Accept","text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9";
    "User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.124 Safari/537.36 Edg/102.0.1245.41"];
data=webread(url,options);