% script create_swanTpar_from_WW3.m
%
% This script is the main driver to create TPAR boundary files for SWAN
% from WW3 data.
%
%  !!!!   This data is only from Feb 2005 to May 2019  !!!!
%  https://www.ncei.noaa.gov/thredds-ocean/catalog.html
%

% ************* BEGIN USER INPUT   ****************************
configs
% 1) Enter WORKING DIRECTORY.
% This is the location where the forcing files to be created.
%
working_dir=swan.project_dir;

start=swan.time.start(1)*12+swan.time.start(2);
stop=swan.time.stop(1)*12+swan.time.stop(2);

for i=start:stop
    yearww3=num2str(int32(i/12),"%04d");    %input year of data yyyy
    mmww3=num2str(mod(i,12),'%02d');        %input month of data mm


    % 3) Enter path\name of SWAN grid. This is set up to use the roms grid as the same for swan.
    modelgrid=roms.input.grid;

    % 4) Enter the spacings of the forcing file locations around the perimeter
    % of the grid. One forcings file spans between the 'specres' points.
    specres=swan.forcing.specres; % spec point resolution

    % 5)
    % Enter the WW3 grid:
    % wc_4m, wc_10m, glo_30m, ep_10m, at_4m, at_10m, ao_30m, ak_4m, ak_10m
    % grid descriptions are here:  https://polar.ncep.noaa.gov/waves/implementations.php
    %
    ww3_grid='glo_30m';

    % *************END OF USER INPUT****************************

    %cd to user dir
    eval(['cd ',working_dir,';']);

    % call to get the spectral points
    [specpts]=ww3_specpoints(modelgrid,specres);
    tpurl=fullfile(swan.multi_1_glo_30m,['multi_1.glo_30m.tp.',yearww3,mmww3,'.nc']);
    hsurl=fullfile(swan.multi_1_glo_30m,['multi_1.glo_30m.hs.',yearww3,mmww3,'.nc']);
    dpurl=fullfile(swan.multi_1_glo_30m,['multi_1.glo_30m.dp.',yearww3,mmww3,'.nc']);
    % Call routine to compute TPAR files.
    readww3_2TPAR(modelgrid,yearww3,mmww3,ww3_grid,specpts,tpurl,hsurl,dpurl)

    % After creating the TPAR files, tell the user what info is needed to
    % be added to INPUT file.
    % Write out boundary file lines for INPUT file
    bdry_com(specpts) %script writes out file Bound_spec_command to working directory

    disp("边界命令行可以在Bound_spec_command中找到，请复制到SWAN输入文件中。")
    disp("按任意键继续下一个月或结束。");
    pause
end
