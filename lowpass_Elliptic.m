function sig_out = lowpass_Elliptic
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    N     = 4;    % Order
    Fpass = 350;  % Passband Frequency
    Apass = 1;    % Passband Ripple (dB)
    Astop = 80;   % Stopband Attenuation (dB)
    
    % Construct an FDESIGN object and call its ELLIP method.
    h  = fdesign.lowpass('N,Fp,Ap,Ast', N, Fpass, Apass, Astop, Fs);
    Hd = design(h, 'ellip');
    
    sig_out = filter(Hd, audio_in);
end