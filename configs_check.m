function configs_check(roms,swan,type)
    arguments
        roms,
        swan,
        type (1,:) char {mustBeMember(type,{'normal','rivers','tracer'})} = 'normal'
    end
    is_true(isfolder(roms.project_dir),"roms.project_dir指定的目录不存在")

    is_size_of(roms.time.start,6)
    is_size_of(roms.time.stop,6)
    is_true(roms.time.days>0,"停止时间应晚于开始时间")

    is_size_of(roms.grid.longitude,2)
    is_true( roms.grid.longitude(2)>roms.grid.longitude(1),"经度范围错误")
    is_size_of(roms.grid.latitude,2)
    is_true(roms.grid.latitude(2)>roms.grid.latitude(1),"纬度范围错误")
    is_size_of(roms.grid.size,2)
    is_positive( roms.grid.size)
    is_size_of(roms.grid.N,1)
    is_positive_integer(roms.grid.N)
    is_size_of(roms.grid.theta_s,1)
    is_positive(roms.grid.theta_s)
    is_size_of(roms.grid.theta_b,1)
    is_positive(roms.grid.theta_b)
    is_size_of(roms.grid.Tcline,1)
    is_positive(roms.grid.Tcline)
    is_in(roms.grid.Vtransform,[1,2])
    is_in(roms.grid.Vstretching,[1:4])

    if type=="rivers" || type=="tracer"
        is_size_of(roms.tracer.densities,[roms.tracer.count,1])
        is_all_size_of(roms.tracer.densities,[roms.grid.size(1)+1,roms.grid.size(2)+1,roms.grid.N])
    end

    if type=="rivers"
        is_size_of(roms.rivers.count,1)
        is_positive_integer(roms.rivers.count)
        is_size_of(roms.rivers.direction,[roms.rivers.count,1])
        is_in(roms.rivers.direction,[0:2])
        is_natural_integer(roms.rivers.time)
        is_size_of(roms.rivers.location,[roms.rivers.count,2])
        is_natural_integer(roms.rivers.location)
        is_size_of(roms.rivers.transport,[roms.rivers.count,numel(roms.rivers.time)])
        is_natural_integer(roms.rivers.transport)
        is_size_of(roms.rivers.v_shape,[roms.rivers.count,roms.grid.N])
        is_zero_or_positive(roms.rivers.v_shape)
        is_equal(sum(roms.rivers.v_shape,2),ones(roms.rivers.count,1),"roms.rivers.v_shape每一行的和应为1",true)
        is_size_of(roms.rivers.temp,[roms.rivers.count,roms.grid.N,numel(roms.rivers.time)])
        is_true(roms.rivers.temp>=-20,"存在低于-20℃的温度",true)
        is_true(roms.rivers.temp<=40,"存在高于40℃的温度",true)
        is_size_of(roms.rivers.salt,[roms.rivers.count,roms.grid.N,numel(roms.rivers.time)])
        is_zero_or_positive(roms.rivers.salt)
        is_size_of(roms.rivers.dye,[roms.tracer.count,1])
        is_all_size_of(roms.rivers.dye,[roms.rivers.count,roms.grid.N,numel(roms.rivers.time)])

        is_size_of(swan.forcing.specres,1)
        is_positive_integer(swan.forcing.specres)
    end
    disp("参数验证成功")
end

function is_true(state,error_msg,warn_only)
    arguments
        state
        error_msg(1,1) string
        warn_only(1,1) double = false
    end
    if numel(state)>1
        for i=reshape(state,1,numel(state))
            is_true(i,error_msg)
        end
        return
    end
    if ~state
        if warn_only
            warning(error_msg)
        else
            error(error_msg)
        end
    end
end

function is_equal(a,b,error_msg,warn_only)
    arguments
        a
        b
        error_msg(1,1) string
        warn_only(1,1) double = false
    end
    is_true(isequal(a,b),error_msg,warn_only)
end

function is_size_of(array,s)
    if numel(s)==1
        is_true(isequal(size(array),[1,s]) || isequal(size(array),[s,1]),['数组的长度应为',num2str(s)])
    else
        is_equal( size(array),s,['数组的长度应为',num2str(s)])
    end
end

function is_all_size_of(cells,s)
    for c=cells
        is_size_of(cells{1},s)
    end
end

function is_positive_integer(n)
    if numel(n)>1
        for i=reshape(n,1,numel(n))
            is_positive_integer(i)
        end
        return
    end
    is_true(rem(n,1) == 0 && n > 0,'应为正整数')
end

function is_natural_integer(n)
    if numel(n)>1
        for i=reshape(n,1,numel(n))
            is_natural_integer(i)
        end
        return
    end
    is_true(rem(n,1) == 0 && n >= 0,'应为自然数')
end

function is_positive(n)
    if numel(n)>1
        for i=reshape(n,1,numel(n))
            is_positive(i)
        end
        return
    end
    is_true(n > 0,'应为正数')
end


function is_zero_or_positive(n)
    if numel(n)>1
        for i=reshape(n,1,numel(n))
            is_zero_or_positive(i)
        end
        return
    end
    is_true(n >= 0,'应为0或正数')
end


function is_in(n,array)

    if numel(n)>1
        for i=reshape(n,1,numel(n))
            is_in(i,array)
        end
        return
    end
    is_true(ismember(n,array),['应取以下值：',num2str(array)])
end
