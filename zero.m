function data_out = zero(data)
  % Move the origin point to zero
  data.load = data.load - data.load(1); % first one at zero
  data.extensometer_position = data.extensometer_position - data.extensometer_position(1); % first one at zero

  data_out = data;
  return
end
