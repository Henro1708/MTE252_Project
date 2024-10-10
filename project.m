clc
clear

function [mono,n_out] = stereo_to_mono(stereo)
    % Translate file from stereo to mono
    % Input: Stereo -> audio matrix in a nx2
    % Output: Mono -> audio array in a single array nx1

    n = size(stereo);
    n_out = n(1);
    if n(2) == 2  
        mono = stereo(:,1) + stereo(:,2);
        return
    end
    mono = stereo;
end

% input file
filename = 'Input_mp3/Words regular voice street.mp3';

% read audio from file
[y,Fs] = audioread(filename);
% combine stereo (2D array) to mono (1D array)
[audio,n] = stereo_to_mono(y);

% resample audio
desired_Fs = 16000;
audio = resample(audio,desired_Fs,Fs);

% plot and play audio
figure(1)
soundsc(audio,desired_Fs);
plot(audio)
hold on

% calculate cosine function
t = linspace(1,n/3,desired_Fs);
y_cos = cos(2*pi/1000*t);

% plot and play cosine function
figure(2)
soundsc(y_cos, desired_Fs)
plot(t, y_cos);
xlim([0 2000])
hold on


% TODO:
% - consolidate into one function that can be run on multiple files
% - add capability to write sound to a new file