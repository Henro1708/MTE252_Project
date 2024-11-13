function sig_out = bandpass(audio_in, f_1, f_2)
    % Input: audio_in -> audio input
    %        f_1 -> low frequency pass
    %        f_2 -> high frequency pass
    % Output: audio_out -> audio after filter

    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    N   = 40;  % Order
    Fc1 = f_1;   % First Cutoff Frequency
    Fc2 = f_2;   % Second Cutoff Frequency
    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
    Hd = design(h, 'butter');
    
    sig_out = filter(Hd, audio_in);

end