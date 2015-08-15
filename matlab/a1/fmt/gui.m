function varargout = gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
%guitar不同音调
handles.guitar=[0.0295583566761820	0.0410941345134757	0.0456155248168245	0.0501369151201733	0.0150942327948900	0.0506918143957047	0.0411115638971236	0.0315313133985425	0.0306018188528348	0.0326034060041743	0.0346049931555137	0.0304438595623305	0.0262827259691473	0.0347713477835479	0.0413905767692186	0.0480098057548894	0.0457266497451795	0.0434434937354695;
0.0482126003883897	0.0125374140745269	0.00716059137425992	0.00178376867399290	0.00495078360762451	0.00666430595013039	0.00550363690446728	0.00434296785880417	0.00246330674711421	0.0188350822355054	0.0352068577238966	0.0365342250971077	0.0378615924703188	0.00857053773470121	0.0164106182936462	0.0242506988525912	0.0206351382394561	0.0170195776263210;
0.0206558500193487	0.00152760756396231	0.00219890018041650	0.00287019279687068	0.00349294202926450	0.00793580678314517	0.00585318846766221	0.00377057015217924	0.00338667456050978	0.00490771858196665	0.00642876260342353	0.0162190114081411	0.0260092602128588	0.00117258606592246	0.00307346918072569	0.00497435229552892	0.00925582041626151	0.0135372885369941;
0.00285336304856058	0.00453640669792585	0.00263949648145414	0.000742586264982436	6.68401761333680e-05	0.000814065440693232	0.00190609132895165	0.00299811721721007	0.000628637998314440	0.00189444843869244	0.00316025887907043	0.00440233177136729	0.00564440466366414	0.00403417874801128	0.00340693225315865	0.00277968575830602	0.00221847975503006	0.00165727375175410;
0.0150876502796980	0.00414709484646134	0.00233614670375124	0.000525198561041149	4.20504657581285e-05	0.000291684580679916	0.000283492071550838	0.000275299562421759	0.000309384394071862	0.00115327671849602	0.00199716904292017	0.00132983323130851	0.000662497419696851	0.00194061187195759	0.00186164673013615	0.00178268158831472	0.00191739094342452	0.00205210029853432;
0.00702799658954647	0.00272518393583796	0.00155648685901399	0.000387789782190024	3.17892339543552e-05	0.00240451218998288	0.00160935705722773	0.000814201924472573	0.000248809480213054	0.000996328456682373	0.00174384743315169	0.00120906410397970	0.000674280774807711	0.000872029083003068	0.000729265978417851	0.000586502873832633	0.00151829881512565	0.00245009475641867];
handles.guitar=[handles.guitar repmat(handles.guitar(:,18),1,7)];
%organ
handles.organ=kron([1 0.2 0.3 0 0 0]',ones(1,25));
%基本
handles.basic=zeros(6,25);handles.basic(1,:)=1;
handles.custom=handles.basic;
handles.A=handles.guitar;
handles.tone=[];
handles.time=[];

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on selection change in ch_tone.
function ch_tone_Callback(hObject, eventdata, handles)
switch get(hObject,'Value')
    case 1
        handles.A=handles.guitar;
    case 2
        handles.A=handles.organ;
    case 3
        handles.A=handles.basic;
    case 4
        handles.A=handles.custom;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ch_tone_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ch_tone_ButtonDownFcn(hObject, eventdata, handles)


function get_rhy_Callback(hObject, eventdata, handles)
 handles.tone=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function get_rhy_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in anay_file.
function anay_file_Callback(hObject, eventdata, handles)
[Filename,Pathname,~]=uigetfile('*.wav');
A=[];freq=[];time=[];
[~,~,A]=f_f(freq,time,[Pathname Filename],A);
handles.custom=repmat(A,1,25);
guidata(hObject, handles);


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
switch get(handles.get_rhy,'Value')
    case 1
        handles.A=handles.guitar;
    case 2
        handles.A=handles.organ;
    case 3
        handles.A=handles.basic;
    case 4
        handles.A=handles.custom;
end

switch get(handles.get_demo,'Value')
    case 1%用户输入
        handles.tone=str2num(get(handles.get_rhy,'String'));
        handles.time=str2num(get(handles.get_time,'String'));
    case 2%东方红      
        handles.tone=[5 5 6 2 1 1 -6 2];
        handles.time=[0.5 0.25 0.25 1 0.5 0.25 0.25 1 ];
    case 3%茉莉花  
        handles.tone=[3 3 5 6 11 11 6 5 5 6 5 3 3 5 6 11 11 6 5 5 6 5 5 5 5 3 5 6 6 5 3 2 3 5 3 2 1 1 2 1];
        handles.time=[0.5 0.25 0.25 0.25 0.25 0.25 0.25 0.5 0.25 0.25 1 0.5 0.25 0.25 0.25 0.25 0.25 0.25 0.5 0.25 0.25 1 0.5 0.5 0.5 0.25 0.25 0.5 0.5 1 0.5 0.25 0.25 0.5 0.25 0.25 0.5 0.25 0.25 1];
    case 4%致爱丽丝
        handles.tone=[13 12.5 13 12.5 13 7 12 11 6 -10 1 3 6 7 -10 3 11 7 6];
        handles.time=[0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.25 0.5 0.25 0.25 0.25 0.25 0.5 0.25 0.25 0.25 0.25 0.5];
    end

msheet2tone=[-3 -4 -4.5 -5 -5.5 -6 -6.5 -7 1 1.5 2 2.5 3 4 4.5 5 5.5 6 6.5 7 11 11.5 12 12.5 13 14 14.5 15];
for i=1:length(handles.tone)
    if (handles.tone(i)~=-10)&&((handles.tone(i)<0&&handles.tone(i)>(-1-get(handles.get_base,'Value')*2))||handles.tone(i)>(11+get(handles.get_base,'Value')*2))
        warning('wrong input');
    end
    [~,num]=find(msheet2tone==handles.tone(i));
     if isempty(num)
        num=-4;
     end
    handles.tone(i)=num;
end
switch get(handles.get_base,'Value')
    case 2
        if handles.tone~=-4
            handles.tone=handles.tone-3;
        end
        handles.A(:,(4:25))=handles.A(:,(1:22));
        handles.A(:,(1:3))=repmat(handles.A(:,4),1,3); 
end
s=[];
%220Hz为基准音
for i=1:length(handles.tone)
    s=[s;m_note_guitar(handles.tone(i)-6,handles.time(i),220,8000,handles.A(:,abs(handles.tone(i))))];
    %由于空音出现了索引为负数的情况，所以加上abs
end
sound(s,8000);

function get_time_Callback(hObject, eventdata, handles)
handles.time=str2num(get(hObject,'String'));
guidata(hObject, handles);

function get_time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function get_demo_Callback(hObject, eventdata, handles)
function get_demo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in get_base.
function get_base_Callback(hObject, eventdata, handles)
function get_base_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
