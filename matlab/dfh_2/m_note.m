function m_note(note,time,base,f)
%输入参数
%note音符
%time持续时间
%base基调
%f采样频率

if note>18||note<1
    error(message('Illegal note'));
end

n=[1:18];

freq=base*2.^kron(1/12,n);
t=[0:time*f]/f;
s=cos(2*pi*freq(note)*t);
sound(s,f);
pause(time+0.01);
return 
