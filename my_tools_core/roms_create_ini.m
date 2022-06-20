function roms_create_ini
    configs

    disp('正在获取ROMS网格的维度');
    Sinp.theta_s     =theta_s;      %surface control parameter
    Sinp.theta_b     =theta_b;      %bottom  control parameter
    Sinp.Tcline      =Tcline;       %surface/bottom stretching width
    Sinp.N           =N;            %number of vertical levels
    Sinp.Vtransform  =Vtransform;   %vertical transformation equation
    Sinp.Vstretching =Vstretching;  %vertical stretching function
    if (Vtransform==1)
      h=ncread(modelgrid,'h');
      hmin=min(h(:));
      hc=min(max(hmin,0),Tcline);
    elseif (Vtransform==2)
      hc=Tcline;
    end
    Sinp.hc          =hc;           %stretching width used in ROMS
    gn=get_roms_grid(modelgrid,Sinp);
    gn.h(gn.h<Tcline)=Tcline;
    gn.z_r=shiftdim(gn.z_r,2);
    gn.z_u=shiftdim(gn.z_u,2);
    gn.z_v=shiftdim(gn.z_v,2);
    gn.z_w=shiftdim(gn.z_w,2);