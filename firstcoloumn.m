clc;
clear;

% Connect to Arduino
a = arduino('COM5', 'MKR1010');  % Adjust COM port if needed

% Read voltages corresponding to pixels 1, 5, 9, and 13
v1  = readVoltage(a, 'A0');  % Pixel 1
v5  = readVoltage(a, 'A1');  % Pixel 5
v9  = readVoltage(a, 'A2');  % Pixel 9
v13 = readVoltage(a, 'A3');  % Pixel 13

% Convert voltages to grayscale (0–255)
voltages = [v1, v5, v9, v13];
gray_values = floor((voltages / 3.3) * 255);  % scale to 0–255
gray_values = min(gray_values, 255);          % ensure upper bound

% Create 4×4 grayscale matrix and fill the left column
gray_matrix = zeros(4, 4);
gray_matrix(:, 1) = gray_values';  % Fill column 1 with values

%% Detect Screens
monitors = get(0, 'MonitorPositions');
primary_pos = monitors(1, :);
if size(monitors, 1) >= 2
    second_pos = monitors(2, :);
else
    second_pos = monitors(1, :);
end

%% Primary Screen: Display Voltages
fig1 = figure('Name', 'Left Column Pixels (1,5,9,13)', ...
              'NumberTitle', 'off', ...
              'MenuBar', 'none', ...
              'ToolBar', 'none', ...
              'Units', 'pixels', ...
              'Position', [primary_pos(1)+100, primary_pos(2)+100, 500, 400]);

pixel_labels = [1, 5, 9, 13];
for i = 1:4
    uicontrol('Style', 'text', 'Units', 'normalized', ...
        'Position', [0.1, 0.85 - (i-1)*0.2, 0.8, 0.15], ...
        'FontSize', 16, ...
        'String', sprintf('Pixel %d (A%d): %.2f V → %d', ...
        pixel_labels(i), i-1, voltages(i), gray_values(i)));
end

drawnow;

%% Second Screen: Display Image
screenW = second_pos(3);
screenH = second_pos(4);
big_img = imresize(gray_matrix, [screenH, screenW], 'nearest');

fig2 = figure('MenuBar', 'none', 'ToolBar', 'none', ...
              'NumberTitle', 'off', 'Color', 'black', ...
              'Units', 'pixels', ...
              'Position', second_pos);

try
    set(fig2, 'WindowState', 'fullscreen');
catch
    % Fallback for older MATLAB versions
end

ax = axes('Parent', fig2, 'Units', 'normalized', 'Position', [0 0 1 1]);
imshow(uint8(big_img), 'Parent', ax);
axis off;

% Save image
imwrite(uint8(big_img), 'gray_left_column_pixels_1_5_9_13.jpeg', 'JPEG');
