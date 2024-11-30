function sig_out = lowpass_MaxFlat
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    Nb   = 4;    % Numerator Order
    Na   = 4;    % Denominator Order
    F3dB = 350;  % 3-dB Frequency
    
    h  = fdesign.lowpass('Nb,Na,F3dB', Nb, Na, F3dB, Fs);
    Hd = design(h, 'butter');

    sig_out = filter(Hd, audio_in);

end