clc;
clear;

% Set to 0 to enable real Arduino reading
debug = 0;

if debug == 0
    % Connect to Arduino
    a = arduino('COM5', 'MKR1010');

    % Read voltages from four analog input channels
    v1 = floor((readVoltage(a, 'A0') / 3.3) * 255); % Pixel 1
    v2 = floor((readVoltage(a, 'A1') / 3.3) * 255); % Pixel 2
    v3 = floor((readVoltage(a, 'A2') / 3.3) * 255); % Pixel 3
    v4 = floor((readVoltage(a, 'A3') / 3.3) * 255); % Pixel 4
else
    % Dummy values
    v1 = 50;
    v2 = 100;
    v3 = 150;
    v4 = 250;
end

% Create 4x4 grayscale image matrix
gray_img = zeros(4, 4);
gray_img(1,1) = v1;
gray_img(1,2) = v2;
gray_img(1,3) = v3;
gray_img(1,4) = v4;

% Detect second screen if present
monitors = get(0, 'MonitorPositions');
if size(monitors, 1) >= 2
    pos = monitors(2, :); % Second screen
else
    pos = monitors(1, :); % Primary screen
end

% Resize image to match screen exactly
screenW = pos(3);
screenH = pos(4);
big_img = imresize(gray_img, [screenH, screenW], 'nearest');

% Create fullscreen figure on selected screen
fig = figure('MenuBar', 'none', ...
             'ToolBar', 'none', ...
             'NumberTitle', 'off', ...
             'Units', 'pixels', ...
             'Position', pos, ...
             'Color', 'black', ...
             'Renderer', 'painters'); % Use painters for precise rendering

% Show image with no borders
axes('Position', [0 0 1 1]); % Fill entire figure
imshow(uint8(big_img), 'InitialMagnification', 'fit');
axis off;
set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);

% Save the image (optional)
imwrite(uint8(big_img), 'gray_4x4_top_row_arduino.jpeg', 'JPEG');
