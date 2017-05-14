function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help untitled
 
% Last Modified by GUIDE v2.5 06-May-2017 13:58:51
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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
 
 
% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)
 
% Choose default command line output for untitled
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
 
% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% Creating by AlpYuktug
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
varargout{1} = handles.output;
 
 
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
%Choose for save image and convert to binary image
 
global im
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end
im=imread(path);
a = im2bw(im);
axes(handles.axes1);
imshow(a);
 
%Thinning Process
 
J=im(:,:,1)>160;
K=bwmorph(~J,'thin',Inf);
axes(handles.axes3);
imshow(K);
 
%Minutiae Process
 
s=size(K);
N=3;%window size
n=(N-1)/2;
r=s(1)+2*n;
c=s(2)+2*n;
double temp(r,c);   
temp=zeros(r,c);bifurcation=zeros(r,c);ridge=zeros(r,c);
temp((n+1):(end-n),(n+1):(end-n))=K(:,:);
outImg=zeros(r,c,3);%For Display
outImg(:,:,1) = temp .* 255;
outImg(:,:,2) = temp .* 255;
outImg(:,:,3) = temp .* 255;
for x=(n+1+10):(s(1)+n-10)
    for y=(n+1+10):(s(2)+n-10)
        e=1;
        for k=x-n:x+n
            f=1;
            for l=y-n:y+n
                mat(e,f)=temp(k,l);
                f=f+1;
            end
            e=e+1;
        end;
         if(mat(2,2)==0)
            ridge(x,y)=sum(sum(~mat));
            bifurcation(x,y)=sum(sum(~mat));
         end
    end;
end;
 
% RIDGE END FINDING
[ridge_x ridge_y]=find(ridge==2);
len=length(ridge_x);
%For Display
for i=1:len
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)-3),2:3)=0;
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)+3),2:3)=0;
    outImg((ridge_x(i)-3),(ridge_y(i)-3):(ridge_y(i)+3),2:3)=0;
    outImg((ridge_x(i)+3),(ridge_y(i)-3):(ridge_y(i)+3),2:3)=0;
    
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)-3),1)=255;
    outImg((ridge_x(i)-3):(ridge_x(i)+3),(ridge_y(i)+3),1)=255;
    outImg((ridge_x(i)-3),(ridge_y(i)-3):(ridge_y(i)+3),1)=255;
    outImg((ridge_x(i)+3),(ridge_y(i)-3):(ridge_y(i)+3),1)=255;
end
 
%BIFURCATION FINDING
[bifurcation_x bifurcation_y]=find(bifurcation==4);
len=length(bifurcation_x);
%For Display
for i=1:len
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)-3),1:2)=0;
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)+3),1:2)=0;
    outImg((bifurcation_x(i)-3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),1:2)=0;
    outImg((bifurcation_x(i)+3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),1:2)=0;
    
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)-3),3)=255;
    outImg((bifurcation_x(i)-3):(bifurcation_x(i)+3),(bifurcation_y(i)+3),3)=255;
    outImg((bifurcation_x(i)-3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),3)=255;
    outImg((bifurcation_x(i)+3),(bifurcation_y(i)-3):(bifurcation_y(i)+3),3)=255;
end
axes(handles.axes4);
imshow(outImg);
 
 
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Show the ýmage on axes
 
 
  F = getframe(handles.axes4);
  Image = frame2im(F);
  imwrite(Image, 'Test.jpg');
  
 
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
%Finally, recognition process starting!

a = imread('Test.jpg');
b = imread('1.jpg'); 
c = imread('4.jpg');
d = imread('5.jpg'); 
e = imread('2.jpg');
f = imread('3.jpg'); 
 
[ssimval, ssimmap] = ssim(a,b);
if ssimval==1.000    
     fprintf('Ratio of Recognition: %0.4f\n',ssimval);
     a ='1';
    set(handles.text12,'String',a);
 
else [ssimval, ssimmap] = ssim(a,c);
if ssimval==1.000    
    fprintf('Ratio of Recognition: %0.4f\n',ssimval);   
    a ='4';
    set(handles.text12,'String',a);
    
else [ssimval, ssimmap] = ssim(a,d);
if ssimval==1.000    
    fprintf('Ratio of Recognition: %0.4f\n',ssimval);   
    a ='5';
    set(handles.text12,'String',a);
    
    else [ssimval, ssimmap] = ssim(a,e);
if ssimval==1.000    
    fprintf('Ratio of Recognition: %0.4f\n',ssimval);   
    a ='2';
    set(handles.text12,'String',a);
    
    else [ssimval, ssimmap] = ssim(a,f);
if ssimval==1.000    
    fprintf('Ratio of Recognition: %0.4f\n',ssimval);   
    a ='3';
    set(handles.text12,'String',a);
end       
end 
end   
end
end
 
if ssimval<1.000
    a ='Not Found';
    set(handles.text12,'String',a);
end

