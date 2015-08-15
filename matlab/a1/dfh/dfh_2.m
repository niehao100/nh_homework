clear;clc;format long;
base=196;f=8000;s=zeros(f*0.05,1);
s=[s;m_note_2(12,0.5,196,8000)];
s=[s;m_note_2(12,0.25,base,f)];
s=[s;m_note_2(14,0.25,base,f)];
s=[s;m_note_2(7,1,base,f)];
s=[s;m_note_2(5,0.5,base,f)];
s=[s;m_note_2(5,0.25,base,f)];
s=[s;m_note_2(2,0.25,base,f)];
s=[s;m_note_2(7,1,base,f)];
sound(s,f);

