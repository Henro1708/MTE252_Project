clc
clear

% adds input data folder path to MATLAB
addpath("Input_mp3\")

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

function save_audio(full_name, audio, Fs)
    % Save audio data to file
    % Input:
    % full_name - full name of original audio file (includes parent folder)
    % audio - actual audio data
    % Fs - sampling frequency
    
    % define save folder
    save_folder = 'Resampled_files/';
    
    % split original save folder name and file name 
    full_name_split = split(full_name, '/');

    % isolated file name
    file_name = full_name_split(length(full_name_split));

    % append folder name with file name
    final_name = strcat(save_folder, file_name);

    % write to file
    audiowrite(final_name, audio, Fs);
end

function play_and_plot_cos(n, Fs, figure_num)
    % Plays a 1 kHz cosine wave and then plots it as a function of time
    % over 2 cycles
    % Input:
    % n - number of samples
    % Fs - sampling frequency
    cos_freq = 1000; % in Hz
    
    % Cosine as a function of sample number
    s = 0:1:n;
    cos_s = cos(2 * pi * cos_freq / Fs * s); % cosine as a function of sample number
    
    % Cosine as a function of sample time
    t = (0:n-1) / Fs;
    cos_t = cos(2 * pi * cos_freq * t); % cosine as a function of time
    
    % Plot cosine function as a function of time
    figure(abs(figure_num+1));
    plot(t,cos_t);
    xlabel('Time (s)');
    xlim([0, 0.002])
    ylabel('Amplitude');
    title('Plot of 1kHz Cosine Wave');
    hold on;
    soundsc(cos_s, Fs);
end

function output_sig = process_audio(filename, boundary_arr)
    % Read in audio file
    [y, Fs] = audioread(filename);

    % Convert from stereo to mono
    [audio, n] = stereo_to_mono(y);
    
    % Resample audio to 16000 kHz
    desired_Fs = 16000;
    audio = resample(audio, desired_Fs, Fs);
    n = length(audio);
    
    % Phase 1
    % % Save audio to file
    % save_audio(filename, audio, desired_Fs);
    
    % % Play audio file
    % soundsc(audio, desired_Fs);

    % % Plot audio waveform as a function of sample number
    % figure(abs(figure_num));
    % plot(audio);
    % xlabel('Sample Number')
    % ylabel('Amplitude')
    % title('Plot of Recording Resampled to 16kHz')
    % hold on;

    % % Plot and play cosine function
    % play_and_plot_cos(n, desired_Fs, figure_num)

    % Phase 2
    num_bands = length(boundary_arr)-1;
    band_filtered_arr = zeros([num_bands,n]);
    enveloped_arr = zeros([num_bands,n]);
    for ind = 1:num_bands
        % for every bandpass
        % filter the signal in the band
        band_filtered_sig = bandpass(audio, boundary_arr(ind), boundary_arr(ind+1));
        band_filtered_arr(ind,:) = band_filtered_sig;
        
        % envelope extraction
        abs_sig = abs(band_filtered_sig);
        lowpass_filtered_sig = lowpass(abs_sig);
        enveloped_arr(ind,:) = lowpass_filtered_sig;
    end
    
    % % separate plots
    % % plot first and last passband filtered signals
    % figure(1);
    % plot(band_filtered_arr(1,:));
    % title("First Passband Signal");
    % xlabel("Sample Number");
    % ylabel("Amplitude");
    % hold on;
    % 
    % figure(2);
    % plot(band_filtered_arr(end,:));
    % title("Last Passband Signal");
    % xlabel("Sample Number");
    % ylabel("Amplitude");
    % hold on;
    % 
    % % plot envelopes of first and last passbands
    % figure(3);
    % plot(enveloped_arr(1,:));
    % title("First Passband Signal Envelope");
    % xlabel("Sample Number");
    % ylabel("Amplitude");
    % hold on;
    % 
    % figure(4);
    % plot(enveloped_arr(end,:));
    % title("Last Passband Signal Envelope");
    % xlabel("Sample Number");
    % ylabel("Amplitude");
    % hold on;

    % combined plots
    % first passband signal
    figure(1);
    subplot(2,1,1);
    plot(band_filtered_arr(1,:));
    title("First Passband Signal");
    xlabel("Sample Number");
    ylabel("Amplitude");
    % enveloped
    subplot(2,1,2);
    plot(enveloped_arr(1,:));
    title("First Passband Signal Envelope");
    xlabel("Sample Number");
    ylabel("Amplitude");
    hold on;
    
    % last passband signal
    figure(2);
    subplot(2,1,1);
    plot(band_filtered_arr(end,:));
    title("Last Passband Signal");
    xlabel("Sample Number");
    ylabel("Amplitude");
    % enveloped
    subplot(2,1,2);
    plot(enveloped_arr(end,:));
    title("Last Passband Signal Envelope");
    xlabel("Sample Number");
    ylabel("Amplitude");
    hold on;

end

% Get an array of frequency boundaries that will be used to bounds in the
% bandpass filters

% start and end frequencies
f_start = 100;
f_end = 7999;

% number of bands to be evenly spaced
n = 20;

% get log of bounds
log_start = log10(f_start);
log_end = log10(f_end);

% calculate boundaries in log space with even spacing
log_boundaries = linspace(log_start, log_end, n+1);

% get frequency values of boundaries
boundary_arr = 10 .^ log_boundaries;

% % Process all files
% % array of input file names
% filenames = ["Input_mp3/Conversation low voice street.mp3", ...
%              "Input_mp3/Conversation regular voice street.mp3", ...
%              "Input_mp3/Convo high voice quiet.mp3", ...
%              "Input_mp3/Convo low voice quiet.mp3", ...
%              "Input_mp3/Convo regular voice quiet.mp3", ...
%              "Input_mp3/Convo reg voice conversation.mp3", ...
%              "Input_mp3/Words high voice quiet.mp3", ...
%              "Input_mp3/Words high voice street.mp3", ...
%              "Input_mp3/Words low voice street.mp3", ...
%              "Input_mp3/Words low voice quiet.mp3", ...
%              "Input_mp3/Words regular voice street.mp3", ...
%              "Input_mp3/Words reg voice conversation.mp3", ...
%              "Input_mp3/Words reg voice quiet.mp3"];
% num_files = length(filenames);
% figure_num = 1;
% for i = 1:num_files
%     process_audio(filenames(i), figure_num);
%     figure_num = figure_num + 2;
% end

% Process one file
process_audio("Input_mp3/Conversation low voice street.mp3", boundary_arr);

