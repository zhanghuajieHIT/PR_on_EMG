function [filter] = Filter_Build(F_low,F_high)
%%base configuration
filter.Rp = 3; filter.Rs = 40;

%% bandpass filter
filter.bandpass.Wp = [F_low F_high]/1000; 
filter.bandpass.Ws = [5 800]/1000;
[filter.bandpass.n,filter.bandpass.Wn] = buttord(filter.bandpass.Wp, ...
    filter.bandpass.Ws,filter.Rp,filter.Rs);
[filter.bandpass.b,filter.bandpass.a] = butter(filter.bandpass.n, ...
    filter.bandpass.Wn,'bandpass');
filter.bandpass.len = 2 * filter.bandpass.n;
filter.bandpass.fa = fliplr(filter.bandpass.a(2:end));
filter.bandpass.fb = fliplr(filter.bandpass.b);


%% bandstop filter

filter.bandstop.Wp = [46 54]/1000;
filter.bandstop.Ws = [49 51]/1000;
[filter.bandstop.n,filter.bandstop.Wn] = buttord(filter.bandstop.Wp, ...
    filter.bandstop.Ws,filter.Rp,filter.Rs);
[filter.bandstop.b,filter.bandstop.a] = butter(filter.bandstop.n, ...
    filter.bandstop.Wn,'stop');

filter.bandstop.len = 2 * filter.bandstop.n;
filter.bandstop.fa = fliplr(filter.bandstop.a(2:end));
filter.bandstop.fb = fliplr(filter.bandstop.b);

end

