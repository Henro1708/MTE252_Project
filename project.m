filename = 'Input_mp3/Words regular voice street.mp3';

[y,Fs] = audioread(filename);
plot(y);
soundsc(y,Fs);

