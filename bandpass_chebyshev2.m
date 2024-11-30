function sig_out = bandpass(audio_in, f_1, f_2)
    % Input: audio_in -> audio input
    %        f_1 -> low frequency pass
    %        f_2 -> high frequency pass
    % Output: audio_out -> audio after filter
    
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency

    N      = 4;     % Order
    Fc1 = f_1;   % First Passband Frequency
    Fc2 = f_2;  % Second Passband Frequency
    Astop  = 80;    % Stopband Attenuation (dB)
    
    % Construct an FDESIGN object and call its CHEBY2 method.
    h  = fdesign.bandpass('N,Fst1,Fst2,Ast', N, Fc1, Fc2, Astop, Fs);
    Hd = design(h, 'cheby2');
    
    sig_out = filter(Hd, audio_in);
end
