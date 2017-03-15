function out = escape(in_str)
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
  % main.m      -> handles analyzing all the data
  % load_file.m -> loads data from a specified filename
  % escape.m    -> used to ensure proper formatting in plot titles% prepends any char from the escape_symbols string with a '\' so it displays properly in a plot title
  escape_symbols = '_';

  out = ''; % output string

  for i = 1:length(in_str)
    char = in_str(i);

    if any(char == escape_symbols)
      out = strcat(out, '\', char);
    else
      out = strcat(out, char);
    end
  end
end
