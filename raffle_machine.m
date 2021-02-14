function raffle_machine
close all
clear global
clc
global GUI txt filePath i handle1;
filePath = 'input.xlsx';

i=1;
handle1 = false;

%main window
GUI.h = figure('units', 'pixels',...
    'position', [10 300 500 250],...
    'menubar','none',...
    'name','Raffle!',...
    'numbertitle', 'off',...
    'resize', 'off',...
    'Color','white');

%machine body
body = imread('body.jpg');
fac_pic = 3.1;
axes('Parent', GUI.h,...
    'Position', [0.28, 0.05, 0.29*fac_pic, 0.28*fac_pic]);
imshow(body);

%machine: handle_1
img1 = imread('handle_1.jpg');
startH = imresize(img1, [140, 38]);
GUI.start = uicontrol('Parent', GUI.h,...
    'Style', 'pushbutton',...
    'String',' ',...
    'Position', [450, 57, 38, 140],...
    'callback', @rolling,...
    'CData', startH,...
    'visible', 'on',...
    'userdata', 0,...
    'tag', 'handle_1');

%machine: handle_2
img2 = imread('handle_2.jpg');
stopH = imresize(img2, [140, 38]);
GUI.stop = uicontrol('Parent', GUI.h,...
    'Style', 'pushbutton',...
    'String','  ',...
    'Position', [450, 57, 38, 140],...
    'callback', @rolling,...
    'CData', stopH,...
    'visible', 'off',...
    'userdata', 0,...
    'tag', 'handle_2');

%reset button
GUI.reset_btn = uicontrol('Parent', GUI.h,...
    'Style', 'pushbutton',...
    'String',"RESET",...
    'Position',[20 190 50 30],...
    'visible', 'on',...
    'Fontsize', 12,...
    'callback', @reset_on_Callback,...
    'FontWeight', 'bold');

%last result label
GUI.last_result = uicontrol('Parent', GUI.h,...
    'Style', 'Text',...
    'String','Last Result:',...
    'Position',[5 155 125 22],...
    'Fontsize', 14,...
    'FontWeight', 'bold',...
    'visible', 'on',...
    'BackgroundColor','white');

% last result display
GUI.last_result_show = uicontrol('Parent', GUI.h,...
    'Style', 'text',...
    'Position',[135 149 100 30],...
    'Fontsize', 14,...
    'FontWeight', 'bold',...
    'HorizontalAlignment', 'center',...
    'string', '',...
    'BackgroundColor','white');

% screen rolling
GUI.show = uicontrol('Parent', GUI.h,...
    'Style', 'text',...
    'Position',[295 135 133 21],...
    'Fontsize', 14,...
    'FontWeight', 'bold',...
    'HorizontalAlignment', 'center',...
    'string', 'Ready',...
    'BackgroundColor','white');

try
    [num, txt]= xlsread(filePath);
    if size(txt,1) <= 1
        msgbox("Nothing to raffle")
    end
catch
    msgbox("Please double check input.xlsx")
end

end

%By clicking the button, read in the inputs from xlsx again
function reset_on_Callback(~,~)
global GUI txt filePath;

try
    disp(["lens of items before: ", size(txt,1)]);
    [num, txt]= xlsread(filePath);
    if size(txt,1) <= 1
        msgbox("Nothing to raffle")
    end
    set(GUI.last_result_show, 'string', '');
    disp(["lens of items after: ", size(txt,1)]);
    pause(0.5)
catch
    msgbox("Please double check input.xlsx")
end

end

%main fcn for rolling the items and drawing 
function rolling(hObj, event, handles)
global GUI txt handle1 i;

if strcmp(get(hObj, 'String'), ' ')
    if size(txt,1) <= 1
        msgbox('Wanna reset?');
    end
    
    handle1 = true;
    disp("handle is pressed")
    set(GUI.start, 'visible', 'off')
    set(GUI.stop, 'visible', 'on')
    
    %while loop to keep items rolling on the screen, break when the handle
    %is pressed
    i = 1;
    while i <= size(txt,1)
        if handle1 == false
            disp("break from while loop")
            break
        end
        set(GUI.show,'string',txt(i));
        pause(0.1);
        
        if i == size(txt,1)
            i = 1;
        else
            i = i + 1;
        end
    end
else
    %draw item also remove it from the array
    handle1 = false;
    disp("handle is lifted")
    set(GUI.start, 'visible', 'on')
    set(GUI.stop, 'visible', 'off')

    n=size(txt,1);
    if n > 1 
        disp(["lens: ", n]);
        set(GUI.show,'string',txt(i));
        set(GUI.last_result_show, 'string', txt(i));
        disp(["to be removed: ", i]);
        txt(i) = [];
        disp(["current lens: ", size(txt,1)]);
    end
end
end
