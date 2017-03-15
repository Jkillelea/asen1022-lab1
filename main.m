% ASEN 1022 - Spring 2017
% This code is for the first and only lab in this class
% Group 6: Monday 3PM-4PM
% ===================================
% Firth, Samuel (Group Leader)
% Stetz, Hugo
% Haugland, Amelia
% Killelea, Jacob
% Hanson, Sean

% There are two files in this program:
% main.m      -> this one, handles analyzing all the data
% load_file.m -> loads data from a specified filename
% by default, this program looks for files in the same directory as the code using the regexp 'test*'

% This lab asked several different questions about the data. I've answered them below
% 1) Identify and remove erroneous data, if there is any, for each data set. If so, can you explain the
% sources of the errors?
%  -> I did not find any errors in the data and consequently did nothing.

% 2) Compute the nominal stress and strain from truncated data. Then “re-zero” the strain data using
% interpolation and off-setting as explained in class.
%  -> Done.

% 3) Create a scatter plot of strain (x-axis) vs. stress (y-axis) for each specimen type (2 separate plots).
% What assumptions did you make about the cross-sectional areas?
% -> Done. I assumed that the area was a perfect 1/2 inch by 1/4 inch. In reality, we found them all
%    to be of slightly different areas. However, this number was given to us on the lab description (section 2.1)

% 4) Estimate the modulus of elasticity (Young’s modulus) for each specimen type. Is it the same for
% the different materials? Why or why not? Look up and compare your modulus of elasticity values
% to a reference source. Does it make sense?
%  -> Done. They are substantially different from each other but I have not looked them up.

% 5) Extract the yield strength, the ultimate tensile strength and the fracture stress for each specimen
% type. Calculate each value of strength. How do these compare with reference values?
%  -> Calculated, but not looked up.

% 6) Discuss the difference in test results (values of Young’s modulus and strength, and mode of
% failure) between the two materials.
% -> There seems to be a relationship here between ductility and stiffness (E).
%    The more ductile matrial had a lower E and a more prolonged failure, since it stretched more.

clear; close all; clc; % housekeeping
format shortG;         % sane numbers in output

files = dir('./test*'); % find files using regular expression

for i = 1:length(files) % read data into structs, load into array for storage
  data_sets(i) = load_file(files(i).name);
end


for i = 1:length(data_sets)

  data = data_sets(i); % load the data

  position = data.extensometer_position; % inches delta-L (always starts at zero)
  load     = data.load; % lbf

  area = (0.5)*(0.25); % [in^2].

  stress = load ./ area; % [psi]
  strain = position / 1;   % initially the grips on the extensometer are exactly 1 inch apart. Devide by 1 for delta-L / L

  % zero both stress and strain to remove any offset
  stress = stress - stress(1);
  strain = strain - strain(1);

  % use polyfit to find the slope the line, only bothering with first 50 points (in linear region)
  coeffs = polyfit(strain(1:50), stress(1:50), 1);
  line   = @(x) coeffs(1)*x + coeffs(2);

  % Young's Modulus is the slope of this line
  E = coeffs(1);
  % ultimate stress is max stress
  [ultimate_stress, idx] = max(stress);
  ultimate_strain        = strain(idx);
  % find yield stress by minimum difference between shifted line and data
  diff     = abs(stress - line(strain - 0.2/100)); % shifted by 0.2%
  [~, idx] = min(diff);
  YS       = stress(idx);
  yield_strain = strain(idx);

  % get fracture stress by looking for where the stress drops by more than 50%
  j = 1;
  while stress(j+1) > 0.5 * stress(j)
    fracture_strain = strain(j);
    fracture_stress = stress(j);
    j = j + 1;
  end

  % plot data
  subplot(2, 1, i)
  hold on; grid on;
  title(escape(data.filepath))
  xlabel('strain, \epsilon');
  ylabel('stress, \sigma [psi]');
  scatter(strain, stress, '.')

  % plot fracture point, ultimate stress, and yield stress (not a requirement)
  plot(fracture_strain, fracture_stress, 'ro');
  plot(ultimate_strain, ultimate_stress, 'go');
  plot(yield_strain,    YS,              'bo');

  % plot fitted line, shifted right by 0.2%
  x = linspace(0.001, 0.005);
  plot(x, line(x - (0.2/100)));

  % store results
  results(i) = struct('name', data.filepath, ...
                      'E', E, ...
                      'ultimate_stress', ultimate_stress, ...
                      'fracture_strain', fracture_strain, ...
                      'fracture_stress', fracture_stress, ...
                      'YS', YS ...
                    );
end

% print results
for i = 1:length(results)
  fprintf('%s | ', results(i).name);
  fprintf('E: %8.0f psi| ', results(i).E);
  fprintf('Ultimate Stress: %.0f psi| ', results(i).ultimate_stress);
  fprintf('YS: %.0f psi| ', results(i).YS);
  fprintf('Fracture Stress: %.0f psi\n', results(i).fracture_stress);
end
