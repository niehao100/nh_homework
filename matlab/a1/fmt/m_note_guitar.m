function [s]=m_note_guitar(note,time,base,f,A)
    %输入参数
    %note音符
	%between -5~25,-10 means an empty beat 
    %time持续时间
    %base基调
    %f采样频率
    %s声音信号
    %A谐波强度


    A=A/A(1);
    n=-5:19;
    freq=base(1)*2.^kron(1/12,n);
    t=((1:(time)*f)/f)';
    if note==-10 
        s=0*t;
    else
        s=zeros(time*f,1);
        for i=1:6
            s=s+A(i)*cos(2*pi*freq(note+6)*i*t);
        end
        %包络
        e=(t<0.05*time).*(t-0.05*time)*80/time+(t>=0.05*time&t<0.3*time).*(0.05*time-t)*4.43/time+(t>=0.3*time).*(2.7*(0.3*time-t)/time-1.10);
        s=s.*exp(e);
    end
    return 
