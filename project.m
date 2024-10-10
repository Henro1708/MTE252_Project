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

function [cos, t] = get_cos(n)
    % Plays audio
    % Input = n -> len of function
    % Outputs = Cos -> cossine function with same lenght as sample
    t = linspace(1,n,n);
    cos = t;
    return
end

% input file
filename = 'Input_mp3/Words regular voice street.mp3';
[y,Fs] = audioread(filename);
expected_Fs = 16000;
[audio,n] = stereo_to_mono(y);
[cos,t] = get_cos(n);
plot(cos,t);
audio = resample(audio,expected_Fs,Fs);

play_audio(audio,0.33*Fs)





