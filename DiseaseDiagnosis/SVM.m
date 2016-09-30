function varargout = SVM(varargin)
% SVM MATLAB code for svm.fig
%      SVM, by itself, creates a new SVM or raises the existing
%      singleton*.
%
%      H = SVM returns the handle to a new SVM or the handle to
%      the existing singleton*.
%
%      SVM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SVM.M with the given input arguments.
%
%      SVM('Property','Value',...) creates a new SVM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before svm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to svm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help svm

% Last Modified by GUIDE v2.5 30-Sep-2016 12:15:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @svm_OpeningFcn, ...
    'gui_OutputFcn',  @svm_OutputFcn, ...
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


% --- Executes just before svm is made visible.
function svm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to svm (see VARARGIN)

% Choose default command line output for svm
handles.output = hObject;

% Update handles structurej
guidata(hObject, handles);

% UIWAIT makes svm wait for user response (see UIRESUME)
% uiwait(handles.svm);


% --- Outputs from this function are returned to the command line.
function varargout = svm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ����Ԥ�������
% --- Executes on button press in loadDataButton.
function loadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global predict_samples
global exper_predict_bak
global info
% ���ļ�ѡ��ѡ������Դ
% FilterIndex is the index of the filter selected in the dialog box. Indexing starts at 1. If you click Cancel or the window's close box, the function sets FilterIndex to 0.
[filename, pathname, filterindex] = uigetfile({'*.xls'}, 'ѡ������Դ');
if filterindex % ����Ѿ�ѡ���ļ�
    file = strcat(pathname, filename);
    predict_samples = xlsread(file);
    exper_predict_bak = predict_samples;
    set(handles.dataUitable, 'Data', predict_samples);
    
    % ���õ�Ԫ��ɱ༭
    data_size = size(predict_samples);
    edit_bool = logical(ones(1, data_size(2)));
    set(handles.dataUitable, 'ColumnEditable', edit_bool);

    % ������
    info = [[datestr(now), '  ', 'Ԥ������ݼ������', 10], info];
    set(handles.info, 'String', info);
end


% ѵ��ģ��
% --- Executes on button press in trainButton.
function trainButton_Callback(hObject, eventdata, handles)
% hObject    handle to trainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global info
global predict_samples
global samples_name
global svmModel
global samples
%��ȡ����������
maxgen = get(handles.maxgenEdit, 'String');
%��ȡ�����Ⱥ��
sizepop = get(handles.sizepopEdit, 'String');

if isempty(predict_samples)
    info = [datestr(now), '  ', ['*** �����Ԥ������� ***', 10], info];
    set(handles.info, 'String', info);
elseif isempty(samples_name)
    info = [datestr(now), '  ', ['*** ��ѡ�񼲲����� ***', 10], info];
    set(handles.info, 'String', info);
elseif isempty(svmModel)
    info = [datestr(now), '  ', ['*** ��ѡ�����ģ�� ***', 10], info];
    set(handles.info, 'String', info);
elseif isempty(samples)
    info = [datestr(now), '  ', ['*** ��ѡ���һ����Χ ***', 10], info];
    set(handles.info, 'String', info);
elseif isempty(maxgen)
    info = [datestr(now), '  ', ['*** ������������� ***', 10], info];
    set(handles.info, 'String', info);
elseif isempty(sizepop)
    info = [datestr(now), '  ', ['*** ��������Ⱥ��ģ ***', 10], info];
    set(handles.info, 'String', info);
else
    info = [datestr(now), '  ', ['ģ�Ϳ�ʼѵ���С������벻Ҫ��������������', 10], info];
    set(handles.info, 'String', info);
    foaModel(hObject, eventdata, handles);
    info = [[datestr(now), '  ', '��ģ��ѵ����ϣ����Խ�����ϡ�', 10], info];
    set(handles.info, 'String', info);
    set(handles.diagnosisButton, 'Enable', 'on'); % ѵ����ϣ���ϰ�ť��ʹ��
end

% FOA-SVMʮ�۽�����֤
function foaModel(hObject, eventdata, handles)
global bestc
global bestg
global foa_svm_model
global samples

% ����SVM���߰�
addpath([pwd '\libsvm-mat-2.9-1']);

% ���õ�������Ⱥ��ģ
maxgen = get(handles.maxgenEdit, 'String');
sizepop = get(handles.sizepopEdit, 'String');
foa_option.maxgen = str2num(maxgen); % ���õ�������
foa_option.sizepop = str2num(sizepop); % ������Ⱥ��

foa_option.sx = 1;
foa_option.sy = 1;
foa_option.ax = 20;
foa_option.bx = 10;
foa_option.ay = 20;
foa_option.by = 10;

% 10�ۼ���
k = 10;  % how many folds do you want?

% ����ѵ��ģ������
if isempty(samples)
    normalizedPopupmenu_Callback(hObject, eventdata, handles);
end
experiment_train = samples;  % ѵ������
% experiment_train = samples(traing_example,:); % ѵ������
exper_train = experiment_train(:,2:end); % ѵ������,������ǩ
train_label = experiment_train(:,1); % ѵ��������ǩ

for i = 1 : k
    disp(['Fold: ' num2str(i)])
        
    %% ���ù�Ӭ�Ż���֧�������� 
    tic % record start time
    [bestacc, c, g] = FOA_SVM(train_label, exper_train, foa_option, handles);
    bestc(i) = c;
    bestg(i) = g;
    toc % record end time
    elapsedTime(i) = toc; % record end time
    
    %% ��ӡ��ò���
    str = sprintf('Best Cross Validation Accuracy = %g%%   Best c = %g   Best g = %g', bestacc, c, g);
    disp(str);
    
    %% ѵ����Ԥ��
    cmd = ['-c ', num2str(c), ' -g ', num2str(g)];  % ��õ���Ѳ�����
    model(i) = svmtrain(train_label, exper_train, cmd);  % ѵ�������ģ��
    foa_svm_model = model;
end



% Ԥ�����
% --- Executes on button press in diagnosisButton.
function diagnosisButton_Callback(hObject, eventdata, handles)
% hObject    handle to diagnosisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global predict_samples
global foa_svm_model
global info

% ����Ԥ�������
experiment_test = predict_samples; % Ԥ������
exper_predict = experiment_test(:,2:end); % Ԥ������,������ǩ
predict_label = experiment_test(:,1); % ��ʼԤ��������ǩ
predict_label_result = zeros(size(predict_samples, 1), 10); % 10��Ԥ��������ǩ

for i = 1 : 10
    predict_label_result(:,i) = svmpredict(predict_label, exper_predict, foa_svm_model(i));  % ���Ԥ��
    predict_label_result
end

predict_label = analyse_predict_result(predict_label_result);
predict_label
predict_samples = [predict_label, exper_predict];
set(handles.dataUitable, 'Data', predict_samples);
info = [[datestr(now), '  ', '�������ϣ����ڱ��� Result ���в鿴�����1 ���ǵò� 2 ����������', 10], info];
set(handles.info, 'String', info);



% ���ݹ�һ������
% --- Executes on selection change in normalizedPopupmenu.
function normalizedPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to normalizedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns normalizedPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from normalizedPopupmenu
global predict_samples
global exper_predict_bak
global info
global samples_name
global samples
if isempty(predict_samples)
    info = [datestr(now), '  ', ['*** �����Ԥ������� ***', 10], info];
    set(handles.info, 'String', info);
else
    value = get(handles.normalizedPopupmenu, 'value');
    % ��һ���������� y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin;
    switch value
        case 1
            samples = '';
            info = [datestr(now), '  ', ['*** ��ѡ��Ԥ�����ݹ�һ���ַ�Χ ***', 10], info];
        case 2
            loadSamplesData(handles, -1, 1);
        case 3
            loadSamplesData(handles, 0, 1);
        case 4
            loadSamplesData(handles, -1, 0);
        case 5
            predict_samples = exper_predict_bak;
            samples = xlsread([samples_name, '.xls']);
            set(handles.dataUitable, 'Data', predict_samples);
            info = [datestr(now), '  ', ['Ԥ������ݺ��������ݻ�ԭ��ʼ״̬', 10], info];
    end
    set(handles.info, 'String', info);
end


% ����ѵ���������ݣ�����һ��
function loadSamplesData(handles, ymin, ymax)
% ��������
global samples_name
global samples
global predict_samples
global info
if isempty(samples_name)
    info = [datestr(now), '  ', ['*** ��ѡ�񼲲����� ***', 10], info];
    set(handles.info, 'String', info);
else
    % ������������
    samples = xlsread(strcat(samples_name, '.xls'));
    % �ϲ�Ԥ������ݺ���������
    new_data = [predict_samples; samples];
    % ��ֱ�ǩ
    gnd = new_data(:, 1);
    fea = new_data(:, 2:end);
    % ��һ������
    [fea1, ps] = mapminmax(fea', ymin, ymax);
    fea = fea1';
    % ���ºϲ�
    new_data = [gnd, fea];
    % ���Ԥ������ݺ���������
    predict_samples_count = size(predict_samples, 1);
    predict_samples = new_data(1:predict_samples_count, :);
    samples = new_data(predict_samples_count+1:end, :);
    set(handles.dataUitable, 'Data', predict_samples);
    % ��Ϣ���
    info = [[datestr(now), '  ', 'Ԥ������ݺ��������ݹ�һ���� [', num2str(ymin), ',', num2str(ymax), '] ���', 10], info];
    set(handles.info, 'String', info);
end



% ���ģ��ѡ��
% --- Executes on selection change in modelPopupmenu.
function modelPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to modelPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modelPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modelPopupmenu
global info
global svmModel

str = get(handles.modelPopupmenu, 'String');
value = get(handles.modelPopupmenu, 'Value');
set(handles.diagnosisButton, 'Enable', 'off'); % δѵ����ϣ���ϰ�ť������

if value ~= 1
    svmModel = str{value};
    info = [datestr(now), '  ', ['��ѡ�����ģ�� ', str{value}, 10], info];
    set(handles.info, 'String', info);
else
    svmModel = '';
    info = [datestr(now), '  ', ['*** ��ѡ�����ģ�� ***', 10], info];
    set(handles.info, 'String', info);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over info.
function info_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global info
info = '';
set(handles.info, 'String', '');


% ����ѡ��
% --- Executes on selection change in diseasePopupmenu.
function diseasePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to diseasePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns diseasePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from diseasePopupmenu
global samples_name
global info

% ��ȡ��������
str = get(handles.diseasePopupmenu, 'String');
value = get(handles.diseasePopupmenu, 'Value');

if value ~= 1
    samples_name = str{value};
    info = [datestr(now), '  ', ['��ѡ�񼲲� ', samples_name, 10], info];
    set(handles.info, 'String', info);
    % ��������ÿһ�б�ǩ
    switch value
        case 2
            column_name = {'Result','MDVP:Fo(Hz)','MDVP:Fhi(Hz)','MDVP:Flo(Hz)','MDVP:Jitter(%)','MDVP:Jitter(Abs)','MDVP:RAP','MDVP:PPQ','Jitter:DDP','MDVP:Shimmer','MDVP:Shimmer(dB)','Shimmer:APQ3','Shimmer:APQ5','MDVP:APQ','Shimmer:DDA','NHR','HNR','RPDE','D2','DFA','Spread1','Spread2','PPE'};
            edit_bool = logical(ones(1, 23));
        case 3
            column_name = {'Result','Clump Thickness','Uniformity of Cell Size','Uniformity of Cell Shape','Marginal Adhesion','Single Epithelial Cell Size','Bare Nuclei','Bland Chromatin','Normal Nucleoli','Mitoses'};
            edit_bool = logical(ones(1, 10));
        case 4
            column_name = {};
            edit_bool = logical(ones(1, 0));
        case 5
            column_name = {};
            edit_bool = logical(ones(1, 0));
    end
    % ���ñ�������
    set(handles.dataUitable, 'ColumnName', column_name);
    % ���õ�Ԫ��ɱ༭
    set(handles.dataUitable, 'ColumnEditable', edit_bool);
%     set(handles.dataUitable, 'ColumnFormat', [{'numeric'},{'numeric'},{'numeric'}]);
else
    samples_name = '';
    info = [datestr(now), '  ', ['*** ��ѡ�񼲲����� ***', 10], info];
    set(handles.info, 'String', info);
end



% --- Executes when entered data in editable cell(s) in dataUitable.
function dataUitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to dataUitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
t = get(handles.dataUitable, 'Data');
t



% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close;


function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of info as text
%        str2double(get(hObject,'String')) returns contents of info as a double


% --- Executes during object creation, after setting all properties.
function info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close svm.
function svm_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to svm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function axesA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesA