function [s]=m_note_2(note,time,base,f)
    %输入参数
    %note音符,
	%between -5~25,
	%-10 means an empty beat 
    %time持续时间
    %base基调
    %f采样频率
    %s声音信号
    n=-5:19;
    freq=base*2.^kron(1/12,n);
    t=((1:(time)*f)/f)';
    if note==-10
        s=0*t;
    else
        e=(t<0.1*time).*(t-0.1*time)*80+(t>=0.1*time&t<0.15*time).*(0.1*time-t)*4.46/time-(t>=0.15*time&t<0.95*time)*0.223+(t>=0.9*time).*((0.9*time-t)*40-0.223);
        %exp(e)为指数序�?        
        s=exp(e).*(cos(2*pi*freq(6+note)*t));
    end
    return 
