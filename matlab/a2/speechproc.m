%# -*- coding: gb2312 -*-
function speechproc()

    % ���峣��
    FL = 80;                % ֡��
    FL_v=2*FL;
    WL = 240;               % ����
    P = 10;                 % Ԥ��ϵ������
    s = readspeech('voice.pcm',100000);             % ��������s
    L = length(s);          % ������������
    FN = floor(L/FL)-2;     % ����֡��
    % Ԥ����ؽ��˲���
    exc = zeros(L,1);       % �����źţ�Ԥ����
    zi_pre = zeros(P,1);    % Ԥ���˲�����״̬
    s_rec = zeros(L,1);     % �ؽ�����
    zi_rec = zeros(P,1);
    % �ϳ��˲���
    exc_syn = zeros(L,1);   % �ϳɵļ����źţ����崮��
    s_syn = zeros(L,1);     % �ϳ�����
    zi_syn = zeros(P,1);
    % ����������˲���
    exc_syn_t = zeros(L,1);   % �ϳɵļ����źţ����崮��
    s_syn_t = zeros(L,1);     % 
    zi_syn_t = zeros(P,1);
    % ���ٲ�����˲����������ٶȼ���һ����
    exc_syn_v = zeros(2*L,1);   % �ϳɵļ����źţ����崮��
    s_syn_v = zeros(2*L,1);     % �ϳ�����
    zi_syn_v = zeros(P,1);
    hw = hamming(WL);       % ������
    
    % ���δ���ÿ֡����
    for n = 3:FN

        % ����Ԥ��ϵ��������Ҫ���գ�
        s_w = s(n*FL-WL+1:n*FL).*hw;    %��������Ȩ�������
        [A,E] = lpc(s_w, P);            %������Ԥ�ⷨ����P��Ԥ��ϵ��
                                        % A��Ԥ��ϵ����E�ᱻ��������ϳɼ���������

        if n == 27
        % (3) �ڴ�λ��д���򣬹۲�Ԥ��ϵͳ���㼫��ͼ
            zplane(A)
            title('zero/pole'); 
        end
        
        s_f = s((n-1)*FL+1:n*FL);       % ��֡�����������Ҫ����������

        % (4) �ڴ�λ��д������filter ����s_f ���㼤����ע�Ᵽ���˲���״̬
        % exc((n-1)*FL+1:n*FL) = ... �������õ��ļ���д������
        [exc((n-1)*FL+1:n*FL),zi_pre]=filter(A,1,s_f,zi_pre);
        
        % (5) �ڴ�λ��д������filter ������exc �ؽ�������ע�Ᵽ���˲���״̬

        [s_rec((n-1)*FL+1:n*FL),zi_rec]=filter(1,A,exc((n-1)*FL+1:n*FL),zi_rec);
        % s_rec((n-1)*FL+1:n*FL) = ... �������õ����ؽ�����д������

        % ע������ֻ���ڵõ�exc ��Ż������ȷ
        s_Pitch = exc(n*FL-222:n*FL);
        PT = findpitch(s_Pitch);    % �����������PT����Ҫ�����գ�
        G = sqrt(E*PT);           % ����ϳɼ���������G����Ҫ�����գ�

        
        % (10) �ڴ�λ��д�������ɺϳɼ��������ü�����filter ���������ϳ�����

        % exc_syn((n-1)*FL+1:n*FL) = ... �������õ��ĺϳɼ���д������
        tmp=(n-1)*FL+1:n*FL;
        exc_syn((n-1)*FL+1:n*FL)= G*(mod(tmp,PT)==0);
        
        % s_syn((n-1)*FL+1:n*FL) = ...   �������õ��ĺϳ�����д������
        [s_syn((n-1)*FL+1:n*FL),zi_syn]=filter(1,A,exc_syn((n-1)*FL+1:n*FL),zi_syn);
        % (11) ���ı�������ں�Ԥ��ϵ�������ϳɼ����ĳ�������һ��������Ϊfilter
        % ������õ��µĺϳ���������һ���ǲ����ٶȱ����ˣ�������û�б䡣
        
       
        tmp_syn_v=(n-1)*FL_v+1:n*FL_v;
      
        % exc_syn_v((n-1)*FL_v+1:n*FL_v) = ... �������õ��ļӳ��ϳɼ���д������
         exc_syn_v((n-1)*FL_v+1:n*FL_v)= G*(mod(tmp_syn_v,PT)==0);
        % s_syn_v((n-1)*FL_v+1:n*FL_v) = ...   �������õ��ļӳ��ϳ�����д������
         [s_syn_v((n-1)*FL_v+1:n*FL_v),zi_syn_v]=filter(1,A,exc_syn_v((n-1)*FL_v+1:n*FL_v),zi_syn_v);
        % (13) ���������ڼ�Сһ�룬�������Ƶ������150Hz �����ºϳ�������������ɶ���ܡ�
        PT=fix(PT/2);
        [z,p,k]=tf2zp(1,A);
        %�Ƕ�Ϊ��Ƶ�ʼ�155
        %Ϊ����155
        p=abs(p).*exp((  angle(p)+2*pi/8000*150*  (2* (angle(p)>0) -1)  )*1j);
        [B,A]=zp2tf(z,p,k);
        tmp_t=(n-1)*FL+1:n*FL;
        % exc_syn_t((n-1)*FL+1:n*FL) = ... �������õ��ı���ϳɼ���д������
        exc_syn_t((n-1)*FL+1:n*FL)= G*(mod(tmp_t,PT)==0);
        % s_syn_t((n-1)*FL+1:n*FL) = ...   �������õ��ı���ϳ�����д������
        [s_syn_t((n-1)*FL+1:n*FL),zi_syn_t]=filter(B,A,exc_syn_t((n-1)*FL+1:n*FL),zi_syn_t);
end

    % (6) �ڴ�λ��д������һ�� s ��exc �� s_rec  �к����𣬽�����������
    % ��������������ĿҲ������������д���������ر�ע��
    soundsc(s,8000);
    pause(L/8000);
    soundsc(s_rec,8000);
    pause(L/8000);
    soundsc(exc,8000);
    pause(L/8000);
    soundsc(s_syn,8000);
    pause(L/8000);
    soundsc(s_syn_v,8000);
    pause(2*L/8000);
    soundsc(s_syn_t,8000);
   t=(1:L)/8000;
    figure;
    plot(t,s/max(s),'k');
    hold on;
    plot(t,s_rec/max(s_rec),'r-.',t,exc/max(exc),'b-.');
    legend('s','s\_rec','exc');
    title('wave of s,s_rec,exc');
    % ���������ļ�
    writespeech('exc.pcm',exc);
    writespeech('rec.pcm',s_rec);
    writespeech('exc_syn.pcm',exc_syn);
    writespeech('syn.pcm',s_syn);
    writespeech('exc_syn_t.pcm',exc_syn_t);
    writespeech('syn_t.pcm',s_syn_t);
    writespeech('exc_syn_v.pcm',exc_syn_v);
    writespeech('syn_v.pcm',s_syn_v);
return

% ��PCM �ļ��ж�������
function s = readspeech(filename, L)
    fid = fopen(filename, 'r');
    s = fread(fid, L, 'int16');
    fclose(fid);
return

% д������PCM �ļ���
function writespeech(filename,s)
    fid = fopen(filename,'w');
    fwrite(fid, s, 'int16');
    fclose(fid);
return

% ����һ�������Ļ������ڣ���Ҫ������
function PT = findpitch(s)
[B, A] = butter(5, 700/4000);
s = filter(B,A,s);
R = zeros(143,1);
for k=1:143
    R(k) = s(144:223)'*s(144-k:223-k);
end
[R1,T1] = max(R(80:143));
T1 = T1 + 79;
R1 = R1/(norm(s(144-T1:223-T1))+1);
[R2,T2] = max(R(40:79));
T2 = T2 + 39;
R2 = R2/(norm(s(144-T2:223-T2))+1);
[R3,T3] = max(R(20:39));
T3 = T3 + 19;
R3 = R3/(norm(s(144-T3:223-T3))+1);
Top = T1;
Rop = R1;
if R2 >= 0.85*Rop
    Rop = R2;
    Top = T2;
end
if R3 > 0.85*Rop
    Rop = R3;
    Top = T3;
end
PT = Top;

return