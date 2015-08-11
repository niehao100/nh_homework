clear;clc;format long;
base=196;f=8000;s=zeros(f*0.05,1);
s=[s;m_note_3(12,0.5,base,f)];
s=[s;m_note_3(12,0.25,base,f)];
s=[s;m_note_3(14,0.25,base,f)];
s=[s;m_note_3(7,1,base,f)];
s=[s;m_note_3(5,0.5,base,f)];
s=[s;m_note_3(5,0.25,base,f)];
s=[s;m_note_3(2,0.25,base,f)];
s=[s;m_note_3(7,1,base,f)];
sound(s,f);

