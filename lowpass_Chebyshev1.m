function sig_out = lowpass_chebyshev1(audio_in)
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    N     = 4;    % Order
    Fpass = 350;  % Passband Frequency
    Apass = 1;    % Passband Ripple (dB)
    
    % Construct an FDESIGN object and call its CHEBY1 method.
    h  = fdesign.lowpass('N,Fp,Ap', N, Fpass, Apass, Fs);
    Hd = design(h, 'cheby1');

    sig_out = filter(Hd, audio_in);

end