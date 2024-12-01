function sig_out = bandpass_Elliptic(audio_in, f_1, f_2)
    % Input: audio_in -> audio input
    %        f_1 -> low frequency pass
    %        f_2 -> high frequency pass
    % Output: audio_out -> audio after filter
    
    % All frequency values are in Hz.
    Fs = 16000;  % Sampling Frequency
    
    N      = 4;     % Order
    Fc1 = f_1;   % First Passband Frequency
    Fc2 = f_2;  % Second Passband Frequency
    Apass  = 1;     % Passband Ripple (dB)
    Astop  = 40;    % Stopband Attenuation (dB)
    
    % Construct an FDESIGN object and call its ELLIP method.
    h  = fdesign.bandpass('N,Fp1,Fp2,Ast1,Ap,Ast2', N, Fc1, Fc2, ...
                          Astop, Apass, Astop, Fs);
    Hd = design(h, 'ellip');
    
    sig_out = filter(Hd, audio_in);
end
