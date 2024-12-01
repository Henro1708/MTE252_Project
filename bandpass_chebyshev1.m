function sig_out = bandpass_chebyshev1(audio_in, f_1, f_2)
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
    
    % Construct an FDESIGN object and call its CHEBY1 method.
    h  = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fc1, Fc2, Apass, Fs);
    Hd = design(h, 'cheby1');

    sig_out = filter(Hd, audio_in);
    
end
