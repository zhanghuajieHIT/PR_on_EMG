function varargout = Feature_Extraction(varargin)
% FEATURE_EXTRACTION M-file for Feature_Extraction.fig
%      FEATURE_EXTRACTION, by itself, creates a new FEATURE_EXTRACTION or raises the existing
%      singleton*.
%
%      H = FEATURE_EXTRACTION returns the handle to a new FEATURE_EXTRACTION or the handle to
%      the existing singleton*.
%
%      FEATURE_EXTRACTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATURE_EXTRACTION.M with the given input arguments.
%
%      FEATURE_EXTRACTION('Property','Value',...) creates a new FEATURE_EXTRACTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Feature_Extraction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Feature_Extraction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Feature_Extraction

% Last Modified by GUIDE v2.5 24-Aug-2012 20:35:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Feature_Extraction_OpeningFcn, ...
                   'gui_OutputFcn',  @Feature_Extraction_OutputFcn, ...
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


% --- Executes just before Feature_Extraction is made visible.
function Feature_Extraction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Feature_Extraction (see VARARGIN)

% Choose default command line output for Feature_Extraction
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Feature_Extraction wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Feature_Extraction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
[filename,pathname] = uigetfile({'*.txt;*.dat', 'files(*.txt,*dat)'; ...
    '*.m;*.fig;*.mat;*.mdl','MATLAB files(*.m,*.fig,*.mat,*.mdl)'; ...
    '*.*','All files(*.*)'}, ...
    'Pick a file');

str = [pathname filename];
RawData = load(str);
[DataRowNum DataColumnNum] = size(RawData);

RawData = RawData - repmat(mean(RawData,1),DataRowNum,1);  %subtract the mean of the load data

handles.filename = fullfile(pathname,filename);
handles.RawData = RawData;
handles.DataRowNum = DataRowNum;
handles.DataColumnNum = DataColumnNum;

guidata(hObject,handles);
set(handles.FileAddress,'String',fullfile(str));
set(handles.FileAddress,'TooltipString',fullfile(str));


% --- Executes on button press in PlotRawData.
function PlotRawData_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
DataColuN = handles.DataColumnNum;
RawData = handles.RawData;
figure(1);
% subplot(DataColuN,1,1);
% plot(RawData(:,1));
% title('Raw sEMG Signals');
for i = 1:DataColuN
    subplot(DataColuN,1,i);
    plot(RawData(:,i));
end


% --- Executes on button press in AR_lpc_CEP with the least square algorithm.
% Calculate the AR and CEP coefficients (Cepstrum coefficients)
function AR_lpc_CEP_Callback(hObject, eventdata, handles)
% hObject    handle to AR_lpc_CEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置AR模型阶数
Order = str2num(get(handles.Ar_lpc_Order,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

ar = zeros(Nn*Order,ChannelNumber);

cep = zeros(Nn*Order,ChannelNumber);
cep_temp = zeros(Order,1);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        ar(((j-1)*Order+1):j*Order,i) = getar_lpcfeat(datatemp,Order);
        
        ar_temp = ar(((j-1)*Order+1):j*Order,i);      %calculate the cepstrum coefficients with the AR coefficients [a1;a2;a3;a4]
        
        cep_temp(1,:) = -ar_temp(1,:);
        
         for k = 2:Order
             sum = 0;
             for l = 1:k-1
                 sum = sum + (1-l/k)*ar_temp(l,:)*cep_temp(k-l,:);
             end
             cep_temp(k,:) = -ar_temp(k,:) - sum;          
         end
        
        cep(((j-1)*Order+1):j*Order,i) = cep_temp;
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

%plot the results
for i = 1:ChannelNumber
    figure(i),
    for j = 1:Order
        subplot(Order,2,2*j-1), plot(ar(j:Order:end,i));
        subplot(Order,2,2*j), plot(cep(j:Order:end,i));
    end
end

handles.ProcessedData = [ar, cep];
guidata(hObject,handles);


% --- Executes on button press in AR_lpc_CEP with the recurrent algorithm.
function AR_rc_CEP_Callback(hObject, eventdata, handles)
% hObject    handle to AR_lpc_CEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置AR模型阶数
Order = str2num(get(handles.Ar_rc_Order,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

ar = zeros(Nn*Order,ChannelNumber);

cep = zeros(Nn*Order,ChannelNumber);
cep_temp = zeros(Order,1);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        ar(((j-1)*Order+1):j*Order,i) = getar_rcfeat(datatemp,Order);
        
        ar_temp = ar(((j-1)*Order+1):j*Order,i);      %calculate the cepstrum coefficients with the AR coefficients
        
        cep_temp(1,:) = -ar_temp(1,:);
        
        for k = 2:Order
            sum = 0;
            for l = 1:k-1
                sum = sum + (1-l/k)*ar_temp(l,:)*cep_temp(k-l,:);
            end
            cep_temp(k,:) = -ar_temp(k,:) - sum;
        end
        
        cep(((j-1)*Order+1):j*Order,i) = cep_temp;
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

%plot the results
for i = 1:ChannelNumber
    figure(i),
    for j = 1:Order
        subplot(Order,2,2*j-1), plot(ar(j:Order:end,i));
        subplot(Order,2,2*j), plot(cep(j:Order:end,i));
    end
end

handles.ProcessedData = [ar,cep];
guidata(hObject,handles);


% --- Executes on button press in SSC.
function SSC_Callback(hObject, eventdata, handles)
% hObject    handle to SSC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置SSC的穿越区间
SscZone = str2double(get(handles.SscZone,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

ssc = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        ssc(j,i) = getsscfeat(datatemp,SscZone);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(ssc(:,i));
end

handles.ProcessedData = ssc;
guidata(hObject,handles);


% --- Executes on button press in ZC.
function ZC_Callback(hObject, eventdata, handles)
% hObject    handle to ZC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置ZC的穿越区间
ZcZone = str2double(get(handles.ZcZone,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

zc = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        zc(j,i) = getzcfeat(datatemp,ZcZone);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(zc(:,i));
end

handles.ProcessedData = zc;
guidata(hObject,handles);


%Calculate the v_order parameters
function V_Ord_Callback(hObject, eventdata, handles)
% hObject    handle to V_Order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置v阶
Order = str2num(get(handles.V_Order,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

v_ord = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        v_ord(j,i) = getv_ordfeat(datatemp,Order);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(v_ord(:,i));
end

handles.ProcessedData = v_ord;
guidata(hObject,handles);


% --- Executes on button press in WAMP.
function WAMP_Callback(hObject, eventdata, handles)
% hObject    handle to WAMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置Wamp的阈值区间
WampZone = str2double(get(handles.WampZone,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

wamp = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        wamp(j,i) = getwampfeat(datatemp,WampZone);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(wamp(:,i));
end

handles.ProcessedData = wamp;
guidata(hObject,handles);


% --- Executes on button press in IAV.
function IAV_Callback(hObject, eventdata, handles)
% hObject    handle to IAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

iav = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        iav(j,i) = getiavfeat(datatemp);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(iav(:,i));
end

handles.ProcessedData = iav;
guidata(hObject,handles);

% --- Executes on button press in MAV.
function MAV_Callback(hObject, eventdata, handles)
% hObject    handle to MAV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

mav = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        mav(j,i) = getmavfeat(datatemp);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(mav(:,i));
end

handles.ProcessedData = mav;
guidata(hObject,handles);


% --- Executes on button press in RMS.
function RMS_Callback(hObject, eventdata, handles)
% hObject    handle to RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

rms = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        rms(j,i) = getrmsfeat(datatemp);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(rms(:,i));
end

handles.ProcessedData = rms;
guidata(hObject,handles);


% --- Executes on button press in WL.
function WL_Callback(hObject, eventdata, handles)
% hObject    handle to WL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

wl = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        wl(j,i) = getwlfeat(datatemp);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(wl(:,i));
end

handles.ProcessedData = wl;
guidata(hObject,handles);


% --- Executes on button press in LogDetect.
function LogDetect_Callback(hObject, eventdata, handles)
% hObject    handle to LogDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

logdetect = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        logdetect(j,i) = getlogdetectfeat(datatemp);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(logdetect(:,i));
end

handles.ProcessedData = logdetect;
guidata(hObject,handles);


% --- Executes on button press in FourierTransf. 对采集的数据离线全处理
function FourierTransf_Callback(hObject, eventdata, handles)
% hObject    handle to FourierTransf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence,'String'));

NFFT = 2^nextpow2(DataRowN); % Next power of 2 from length of signal

FFTData = zeros((NFFT/2 + 1),ChannelNumber+1);
f = RawDataFrequence/2*linspace(0,1,NFFT/2+1);         %多少点就产生多少个频率间隔
FFTData(:,1) = f';

for i = 1:ChannelNumber
    Y = fft(RawData(:,StartChannel+i-1),NFFT)/DataRowN;
    FFTData(:,i+1) = 2*abs(Y(1:NFFT/2+1));
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(f,FFTData(:,i+1));
end

handles.ProcessedData = FFTData;  %数据的第一列是频率，后面几列是傅里叶变换的幅值
guidata(hObject,handles);

%使用周期法计算功率谱密度，用于数据离线批处理
% --- Executes on button press in PSD_Peri.
function PSD_Peri_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_Peri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence,'String'));

NFFT = 2^nextpow2(DataRowN); % Next power of 2 from length of signal

PSDData = zeros((NFFT/2 + 1),ChannelNumber+1);
f = RawDataFrequence/2*linspace(0,1,NFFT/2+1);         %多少点就产生多少个频率间隔
PSDData(:,1) = f';

for i = 1:ChannelNumber
    Y = abs(fft(RawData(:,StartChannel+i-1),NFFT).^2)/NFFT;
    PSDData(:,i+1)=10*log10(Y(1:NFFT/2+1));
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(f,PSDData(:,i+1));
end

handles.ProcessedData = PSDData;  %数据的第一列是频率，后面几列是功率谱密度
guidata(hObject,handles);


% --- Executes on button press in PSD_Welch.
%使用Welch方法计算功率谱密度，实时处理
function PSD_Welch_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_Welch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率
%设置每次处理的数据点数（时间窗），函数中自带实时处理
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
Noverlap = str2num(get(handles.IncreaseWindow,'String'));

nfft = 2^nextpow2(DataRowN);

PSDData = zeros((nfft/2+1), (ChannelNumber+1));

for i = 1:ChannelNumber
    [Y,f] = pwelch(RawData(:,StartChannel+i-1),TimeWindow,Noverlap,nfft,RawDataFrequence,'onesided');
    PSDData(:,i+1)=10*log10(Y);
end
PSDData(:,1) = f;

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(f,PSDData(:,i+1));
end

handles.ProcessedData = PSDData;  %数据的第一列是频率，后面几列是功率谱密度结果
guidata(hObject,handles);


% --- Executes on button press in PSD_Burg.
function PSD_Burg_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_Burg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 使用AR模型法计算功率谱密度
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率
% %设置每次处理的数据点数（时间窗）  离线批处理，没有用到滑动窗
% TimeWindow = str2num(get(handles.TimeWindow,'String'));     
% %设置数据增量窗
% Noverlap = str2num(get(handles.IncreaseWindow,'String'));
%获取AR阶数，以进行近似
Order = str2num(get(handles.PSD_Order,'String'));

nfft = 2^nextpow2(DataRowN);

PSDData = zeros((nfft/2+1), (ChannelNumber+1));

for i = 1:ChannelNumber
    [Y,f] = pburg(RawData(:,StartChannel+i-1),Order,nfft,RawDataFrequence,'onesided');
    PSDData(:,i+1)=10*log10(Y);
end
PSDData(:,1) = f;

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(f,PSDData(:,i+1));
end

handles.ProcessedData = PSDData;  %数据的第一列是频率，后面几列是功率谱密度结果
guidata(hObject,handles);


%计算平均功率
% --- Executes on button press in AP_Welch.
function AP_Welch_Callback(hObject, eventdata, handles)
% hObject    handle to AP_Welch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率
%设置每次处理的数据点数（时间窗），函数中自带实时处理
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

nfft = 2^nextpow2(TimeWindow);
% 海明窗
hamwin = hamming(32);
% 数据无重叠
noverlap=16;

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;
APData = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
         [Y,f] = pwelch(datatemp,hamwin,noverlap,nfft,RawDataFrequence,'onesided');
%          Y = 10*log10(Y);    
        APData(j,i) = sum(f.*Y)/sum(f);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(APData(:,i));
end

handles.ProcessedData = APData;
guidata(hObject,handles);


%使用周期法计算均值频率
% --- Executes on button press in MeaFq_Peri.
function MeaFq_Peri_Callback(hObject, eventdata, handles)
% hObject    handle to MeaFq_Peri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

Fs = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

meafq = zeros(Nn,ChannelNumber);


for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        Pxxtemp = abs(fft(datatemp,TimeWindow).^2)/TimeWindow;  %使用周期法求功率谱密度
        
        L = length(Pxxtemp);
        f = Fs/2*linspace(0,1,L/2)';   %给出功率谱对应的频率
        
        meafq(j,i) = meanfrequency(f,Pxxtemp(1:L/2));
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(meafq(:,i));
end

handles.ProcessedData = meafq;
guidata(hObject,handles);


%使用AR模型法计算均值频率
% --- Executes on button press in MeaFq_Peri.
function MeaFq_Burg_Callback(hObject, eventdata, handles)
% hObject    handle to MeaFq_Peri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率

%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     

%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

meafq = zeros(Nn,ChannelNumber);

Order = 50; %定义AR模型的阶数为50

nfft = 2^nextpow2(TimeWindow);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        [Y,f] = pburg(datatemp,Order,nfft,RawDataFrequence,'onesided');

        meafq(j,i)  = meanfrequency(f,Y);    
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(meafq(:,i));
end

handles.ProcessedData = meafq;
guidata(hObject,handles);

%使用周期法计算中值频率
% --- Executes on button press in MedFq_Peri.
function MedFq_Peri_Callback(hObject, eventdata, handles)
% hObject    handle to MedFq_Peri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in MedFq_Peri.

addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

Fs = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

medfq = zeros(Nn,ChannelNumber);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        Pxxtemp = abs(fft(datatemp,TimeWindow).^2)/TimeWindow;  %使用周期法求功率谱密度
        L = length(Pxxtemp);
        f = Fs/2*linspace(0,1,L/2)';   %给出功率谱对应的频率
        
        medfq(j,i) = medianfrequency(f,Pxxtemp(1:L/2));
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(medfq(:,i));
end

handles.ProcessedData = medfq;
guidata(hObject,handles);


function MedFq_Burg_Callback(hObject, eventdata, handles)
% hObject    handle to MedFq_Peri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end

RawDataFrequence = str2num(get(handles.RawDataFrequence, 'String'));  %获取数据的采样频率
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

medfq = zeros(Nn,ChannelNumber);

Order = 50; %定义AR模型的阶数为50

nfft = 2^nextpow2(TimeWindow);

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        [Y,f] = pburg(datatemp,Order,nfft,RawDataFrequence,'onesided');
        
        medfq(j,i) = medianfrequency(f,Y);
        
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

figure(1);
for i = 1:ChannelNumber
    subplot(ChannelNumber,1,i);
    plot(medfq(:,i));
end

handles.ProcessedData = medfq;
guidata(hObject,handles);

% --- Executes on button press in HIST.
function HIST_Callback(hObject, eventdata, handles)
% hObject    handle to HIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%由于需要对每个通道的EMG幅值进行限定，只能对单通道处理
addpath featurefunction;
handles = guidata(hObject);

RawData = handles.RawData;
DataRowN = handles.DataRowNum;
DataColuN = handles.DataColumnNum;

%设置数据的起始通道
StartChannel = str2num(get(handles.StartChannel,'String'));
if StartChannel > DataColuN
    msgbox('起始通道大于数据通道数！','出错','error');
     return;
end

%设置数据的通道数
ChannelNumber = str2num(get(handles.ChannelNumber,'String'));
if ChannelNumber > DataColuN
    msgbox('设置通道数大于原始数据通道数！','出错','error');
     return;
end
%设置每次处理的数据点数（时间窗）
TimeWindow = str2num(get(handles.TimeWindow,'String'));     
%设置数据增量窗
IncreaseWindow = str2num(get(handles.IncreaseWindow,'String'));
%设置EMG幅值
EMGRang = str2double(get(handles.EMGRang,'String'));
%设置Hist的底层区域
HistZone = str2double(get(handles.HistZone,'String'));

Nn = floor((DataRowN-TimeWindow)/IncreaseWindow) + 1;

BinNum = 9;
hist = zeros(Nn*BinNum,ChannelNumber);       %在Hist函数中设定了9个区间，故每次可以获得9个系数

for i = 1:ChannelNumber
    st = 1;
    en = TimeWindow;
    for j = 1:Nn
        datatemp = RawData(st:en,StartChannel+i-1);
        hist(((j-1)*BinNum+1):j*BinNum,i) = gethistfeat(datatemp,EMGRang,HistZone);
              
        st = st + IncreaseWindow;
        en = en + IncreaseWindow;
    end
end

%plot the results
for i = 1:ChannelNumber
    figure(i),
    for j = 1:BinNum
        PN = ceil(BinNum/2);
        subplot(PN,2,j), plot(hist(j:BinNum:end,i));
    end
end

handles.ProcessedData = hist;
guidata(hObject,handles);


% --- Executes on button press in SaveProcessedData.
function SaveProcessedData_Callback(hObject, eventdata, handles)
% hObject    handle to SaveProcessedData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
ProcessedData = handles.ProcessedData;

save 'FeatureData\ProcessedData.txt' ProcessedData -ascii;

% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


