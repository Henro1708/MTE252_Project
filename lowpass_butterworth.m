function sig_out = lowpass_butterworth(audio_in)
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency

    N  = 4;   % Order
    Fc = 350;  % Cutoff Frequency

    
    % Construct an FDESIGN object and call its BUTTER method.
    h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
    Hd = design(h, 'butter');

    sig_out = filter(Hd, audio_in);

end