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
function play_audio(audio, Fs)
    % Plays audio
    % Inputs: 
    % audio -> audio to play
    % Fs -> Factor scale 

    %plot(audio);
    soundsc(audio,Fs);
end

function plot_audio(audio)
    % plots audio
    % Inputs: 
    % audio -> audio to be plotted
    
    plot(audio);
    xlabel('Sample Rate')
    ylabel('Audio Waveform')
    title('Plot of Recording')
end

function save_audio(name, audio, Fs)
    name_start = 'Saved_files/';
    name_end = '.mp3'
    name_total = strcat(name_start, name, name_end);
    audiowrite(name_total,audio,Fs)
end

function play_plot_cos(n, Fs)  % Needs to be finished to be 1Khz
    t = linspace(0,n,1000); ''
    cos_out = cos(t);
    play_audio(cos_out,Fs);
end

function main_audio(filename)
    [y,Fs] = audioread(filename);
    expected_Fs = 16000;
    [audio,n] = stereo_to_mono(y);
    play_plot_cos(n, expected_Fs);
    audio = resample(audio,expected_Fs,Fs);
    plot_audio(audio);

    %play_audio(audio,expected_Fs)
    save_audio(filename, audio, expected_Fs);
end

% input file
filenames = ["Input_mp3/Words regular voice street.mp3","Input_mp3/Conversation low voice street.mp3","Input_mp3/Conversation Regular voice street.mp3","Input_mp3/Convo high voice quiet.mp3","Input_mp3/Convo low voice quiet.mp3","Input_mp3/Convo regular voice quiet.mp3","Input_mp3/Convo reg voice conversation.mp3","Input_mp3/Words high voice quiet.mp3","Input_mp3/Words high voice street.mp3","Input_mp3/Words low voice street.mp3","Input_mp3/Words low voice quiet.mp3","Input_mp3/Words regular voice street.mp3","Input_mp3/Words reg voice conversation.mp3","Input_mp3/Words reg voice quiet.mp3"]
n_of_files = length(filenames);
for i = 1:n_of_files
    filenames(i)
    main_audio(filenames(i))
end



