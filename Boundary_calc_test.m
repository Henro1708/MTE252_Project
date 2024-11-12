function boundary_arr = get_bands(n, f_start, f_end)
% takes in a frequency range, as well as a number of bands, and returns an
% n+1 sized 1D array, with the limits of each band

log_start = log10(f_start);
log_end = log10(f_end);

log_boundaries = linspace(log_start, log_end, n+1);

boundary_arr = 10 .^ log_boundaries;

end

boundary_arr = get_bands(20, 100, 8000);

disp(boundary_arr);