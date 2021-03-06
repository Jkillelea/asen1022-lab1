function data = load_file(filepath)
  % ASEN 1022 - Spring 2017
  % This code is for the first and only lab in this class
  % Group 6: Monday 3PM-4PM
  % ===================================
  % Firth, Samuel (Group Leader)
  % Stetz, Hugo
  % Haugland, Amelia
  % Killelea, Jacob
  % Hanson, Sean

  % There are three files in this program:
  % main.m      -> this one, handles analyzing all the data
  % load_file.m -> loads data from a specified filename
  % escape.m    -> used to ensure proper formatting in plot titles

  data = struct('crosshead_position', [], ...
  'load', [], ...
  'extensometer_position', [], ...
  'filepath', filepath ...
  );

  raw_data = load(filepath);
  data.crosshead_position    = raw_data(:, 1);
  data.load                  = raw_data(:, 2);
  data.extensometer_position = raw_data(:, 3);
  return
end
