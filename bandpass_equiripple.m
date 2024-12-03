function sig_out = bandpass_equiripple(audio_in, f1, f2)
    % BANDPASS_EQUIRIPPLE Applies a bandpass equiripple FIR filter to audio_in.
    % audio_in: Input audio signal
    % f1: Lower passband frequency
    % f2: Upper passband frequency
    % sig_out: Filtered output signal

    % Sampling Frequency
    Fs = 16000;  % Adjust this to match your actual sampling rate

    % Order of the filter
    N = 20;

    % Frequency specifications (normalized to Nyquist frequency)
    Fstop1 = f1 - 1;  % First Stopband Frequency
    Fpass1 = f1;        % First Passband Frequency
    Fpass2 = f2;        % Second Passband Frequency
    Fstop2 = f2 + 1;  % Second Stopband Frequency

    % Ensure frequencies are within valid range
    if Fstop1 < 0 || Fstop2 > Fs/2
        error('Frequencies must be within the range [0, Fs/2].');
    end

    % Design the equiripple FIR filter
    b = firpm(N, [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2] / (Fs/2), [0 0 1 1 0 0]);

    % Filter the audio signal
    sig_out = filter(b, 1, audio_in);
end
