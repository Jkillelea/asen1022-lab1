clear; close all; clc; % housekeeping
format shortG;         % sane numbers in output

files = dir('./test*'); % find files using regular expression

parfor i = 1:length(files) % can do the IO on two threads, read data into structs, load into cell array for storage
  data_sets{i} = load_file(files(i).name);
end

for i = 1:length(data_sets)
  data = data_sets{i}; % load the data

  position = data.extensometer_position; % inches delta-L
  load     = data.load; % lbf

  area = (0.5)*(0.25); % [in^2].

  stress = load ./ area; % [psi]
  strain = position/1; % initially the grips on the extensometer are exactly 1 inch apart. Devide by 1 for delta-L / L

  % zero both stress and strain to remove any offset
  stress = stress - stress(1);
  strain = strain - strain(1);

  % use polyfit to find the slope the line, only bothering with first 50 points (in linear region)
  coeffs = polyfit(strain(1:50), stress(1:50), 1);
  line   = @(x) coeffs(1)*x + coeffs(2);

  % Young's Modulus is the slope of this line
  E = coeffs(1);
  % ultimate stress is max stress?
  ultimate_stress = max(stress);
  % NEED THE YIELD STRESS STILL ...

  % get fracture stress by looking for where the stress drops by more than 50%
  j = 1;
  while stress(j+1) > 0.5 * stress(j)
    fracture_point = [strain(j), stress(j)];
    j = j + 1;
  end

  % plot data
  figure; hold on; grid on;
  title(escape(data.filepath))
  xlabel('strain, \epsilon');
  ylabel('stress, \sigma');
  scatter(strain, stress, '.')

  % plot fracture point (not a requirement)
  plot(fracture_point(1), fracture_point(2), 'ro');

  % plot fitted line
  x = linspace(0.001, 0.005);
  plot(x, line(x - (0.2/100)));

  % store results
  results{i} = struct('name', data.filepath, ...
                      'E', E, ...
                      'ultimate_stress', ultimate_stress, ...
                      'fracture_point', fracture_point ...
                    );
end

for i = 1:length(results)
  fprintf('%s | ', results{i}.name);
  fprintf('E: %8.0f psi| ', results{i}.E);
  fprintf('Ultimate Stress: %.0f psi| ', results{i}.ultimate_stress);
  fprintf('Fracture Stress: %.0f psi\n', results{i}.fracture_point(2));
end
