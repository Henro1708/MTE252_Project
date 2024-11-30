clc;
clear;

% add input data folder path to MATLAB
addpath("Input_mp3\")

% -------------------------------------------------------------------------
% Parameters
% -------------------------------------------------------------------------
% resampling frequency
desired_Fs = 16000;

% number of bands
n = 20;

% start and end frequencies
f_start = 100;
f_end = 7999;

iteration_str = "EQUI"; % appended to output filenames to help keep track of design version

% array of input file names
filenames = ["Input_mp3/Conversation regular voice street.mp3", ...
             "Input_mp3/Convo reg voice conversation.mp3", ...
             "Input_mp3/Words regular voice street.mp3", ...
             "Input_mp3/Words reg voice conversation.mp3", ...
             "Input_mp3/Conversation low voice street.mp3", ...
             "Input_mp3/Convo high voice quiet.mp3", ...
             "Input_mp3/Convo low voice quiet.mp3", ...
             "Input_mp3/Convo regular voice quiet.mp3", ...
             "Input_mp3/Words high voice quiet.mp3", ...
             "Input_mp3/Words high voice street.mp3", ...
             "Input_mp3/Words low voice street.mp3", ...
             "Input_mp3/Words low voice quiet.mp3", ...
             "Input_mp3/Words reg voice quiet.mp3"];
num_files = length(filenames);

file_process_range = 1:4; % change this to change how many files are processed
% file_process_range = 1:num_files; % process all files

% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Main
% -------------------------------------------------------------------------

% calculate log of bounds
log_start = log10(f_start);
log_end = log10(f_end);

% calculate boundaries in log space with even spacing
log_boundaries = linspace(log_start, log_end, n+1);

% calculate central frequencies
log_central_freqs = zeros(1,n);
log_band_width = (log_end - log_start) ./ n;
for i = 1:n
    log_central_freqs(i) = log_start + log_band_width ./ 2 + (i-1) .* log_band_width;
end

% convert boundaries and central frequencies back to frequency domain
boundary_arr = 10 .^ log_boundaries;
central_freq_arr = 10 .^ log_central_freqs;

% Process files specified in the process range
for index = file_process_range
    signal_out = process_audio(filenames(index), boundary_arr, central_freq_arr, desired_Fs); % call processing function
    save_audio(filenames(index), iteration_str, signal_out, desired_Fs); % save to output folder
    % soundsc(signal_out, desired_Fs); % play output to speakers
end

% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Function Definitions
% -------------------------------------------------------------------------
function output_sig = process_audio(filename, boundary_arr, central_freq_arr, desired_Fs)
    % Read in audio file
    [y, Fs] = audioread(filename);

    % Convert from stereo to mono
    [audio, ] = stereo_to_mono(y);
    
    % Resample audio
    audio = resample(audio, desired_Fs, Fs);
    n = length(audio);
  
    % Rectify Signal
    num_bands = length(boundary_arr)-1;
    band_filtered_arr = zeros([num_bands,n]);
    am_sigs = zeros([num_bands, n]);
    output_sig = zeros([n,1]);
    for ind = 1:num_bands
        % for every bandpass
        % filter the signal in the band
        band_filtered_sig = bandpass_butterworth(audio, boundary_arr(ind), boundary_arr(ind+1));
        band_filtered_arr(ind,:) = band_filtered_sig;
        
        % envelope extraction
        abs_sig = abs(band_filtered_sig);
        lowpass_filtered_sig = lowpass(abs_sig);

        % modulate with central frequency
        t = (0:n-1) / desired_Fs;
        cos_sig = cos(2*pi*central_freq_arr(ind)*t);
        cos_sig = cos_sig.'; % transpose so cos can be multiplied with rectified signal
        am_sigs(ind,:) = lowpass_filtered_sig .* cos_sig;
        output_sig = output_sig + am_sigs(ind,:)';
    end
end

function [mono, n_out] = stereo_to_mono(stereo)
    % Translate file from stereo to mono
    % Input: Stereo -> audio matrix in a nx2
    % Output: Mono -> audio array in a single array nx1
    n = size(stereo);
    n_out = n(1);
    if n(2) == 2
        mono = 0.5.*(stereo(:,1) + stereo(:,2));
        return
    end
    mono = stereo;
end

function save_audio(full_name, iteration_str, audio, Fs)
    % Save audio data to file
    % Input:
    % full_name - full name of original audio file (includes parent folder)
    % audio - actual audio data
    % Fs - sampling frequency
    
    % define save folder
    save_folder = 'Output_mp3/';
    
    % split original save folder name and file name 
    full_name_split = split(full_name, '/');

    % isolated file name
    file_name = full_name_split(length(full_name_split));

    % split file type from file name
    file_type_split = split(file_name, ".");

    % append folder name with file name
    final_name = strcat(save_folder, file_type_split(1), "_", iteration_str, ".", file_type_split(2));

    % write to file
    audiowrite(final_name, audio, Fs);
end