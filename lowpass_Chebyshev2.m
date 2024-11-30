function sig_out = lowpass_Chebyshev2
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    N     = 4;    % Order
    Fstop = 350;  % Stopband Frequency
    Astop = 80;   % Stopband Attenuation (dB)
    
    % Construct an FDESIGN object and call its CHEBY2 method.
    h  = fdesign.lowpass('N,Fst,Ast', N, Fstop, Astop, Fs);
    Hd = design(h, 'cheby2');
    
    sig_out = filter(Hd, audio_in);
end
