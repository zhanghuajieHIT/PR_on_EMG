# emg features
import numpy as np
from nitime import algorithms as alg
import pywt
from scipy import stats
from numpy import linalg as LA
from scipy import signal as sig
import pylab as pl
import operator


def emg_iemg(signal):
	signal_abs = [abs(s) for s in signal]
	signal_abs = np.array(signal_abs)
	return np.sum(signal_abs)

def emg_mav(signal):
	signal_abs = [abs(s) for s in signal]
	signal_abs = np.array(signal_abs)
	return np.mean(signal_abs)

def emg_ssi(signal):
	signal_squ = [s*s for s in signal]
	signal_squ = np.array(signal_squ)
	return np.sum(signal_squ)

def emg_var(signal):
	signal = np.array(signal)
	ssi = emg_ssi(signal)
	length = signal.shape[0]
	return ssi/(length-1)

def emg_rms(signal):
	signal = np.array(signal)
	ssi = emg_ssi(signal)
	length = signal.shape[0]
	return np.sqrt(float(ssi)/length)

def emg_mavtm(signal, order):
	signal = np.array(signal)
	signal_order = [s**order for s in signal]
	return abs(np.mean(signal_order))

def emg_vorder(signal):
	signal = np.array(signal)
	signal_order = [s**2 for s in signal]
	value = np.mean(signal_order)
	return value**(float(1)/2)

def emg_log(signal):
	signal = np.array(signal)
	signal_log = [np.log(abs(s)) for s in signal]
	value = np.mean(signal_log)
	return np.exp(value)

def emg_wl(signal):
	signal = np.array(signal)
	length = signal.shape[0]
	wl = [abs(signal[i+1]-signal[i]) for i in range(length - 1)]
	return np.sum(wl)

def emg_aac(signal):
	signal = np.array(signal)
	length = signal.shape[0]
	wl = [abs(signal[i+1]-signal[i]) for i in range(length - 1)]
	return np.mean(wl)

def emg_zc(signal, zc_threshold):
	sign = [[signal[i] * signal[i-1], abs(signal[i] - signal[i-1])] for i in range(1, len(signal), 1)]
	
	sign = np.array(sign)
	sign = sign[sign[:,0] < 0]
	sign = sign[sign[:,1] >= zc_threshold]
	return sign.shape[0]

def emg_wl_dasdv(signal):
	signal = np.array(signal)
	length = signal.shape[0]
	wl = [(signal[i+1]-signal[i])**2 for i in range(length - 1)]
	sum_squ = np.sum(wl)
	return np.sqrt(sum_squ/(length-1))

def emg_afb(signal, hamming_window_length):
	hamming_window = np.hamming(hamming_window_length)
	signal_length = len(signal)
	signal_after_filter = []
	end_flag = 0

	for i in range(signal_length):
		start = i
		end = i + hamming_window_length
		if end >= signal_length:
			end = signal_length
			end_flag = 1

		signal_seg = signal[start:end]
		signal_seg = np.array(signal_seg)
		signal_after_filter.append(np.sum(signal_seg * signal_seg * hamming_window)/np.sum(hamming_window))

		if end_flag == 1:
			end_flag = 0
			break
	signal_after_filter = np.array(signal_after_filter)

	for i in range(1, len(signal_after_filter)-1, 1):
		if signal_after_filter[i]>signal_after_filter[i-1] and signal_after_filter[i]>signal_after_filter[i+1]:
			a_value = signal_after_filter[i]
			break
	return a_value

def emg_myop(signal, threshold):
	signal = np.array(signal)
	length = signal.shape[0]

	signal = signal[signal >= threshold]
	count = signal.shape[0]
	return float(count)/length

def emg_ssc(signal, threshold):
	signal = np.array(signal)
	temp = [(signal[i] - signal[i-1])*(signal[i] - signal[i+1])  for i in range(1, signal.shape[0]-1, 1)]
	temp = np.array(temp)

	temp = temp[temp >= threshold]
	return temp.shape[0]

def emg_wamp(signal, threshold):
	signal = np.array(signal)
	temp = [abs(signal[i] - signal[i-1])  for i in range(1, signal.shape[0], 1)]
	temp = np.array(temp)
	
	temp = temp[temp >= threshold]
	return temp.shape[0]

def emg_hemg(signal, bins):
	signal = np.array(signal)
	hist, bin_edge = np.histogram(signal, bins)
	return hist

def emg_mhw_energy(signal):
	signal = np.array(signal)
	window_length = signal.shape[0]
	hamming_window = np.hamming(window_length)
	# pl.plot(hamming_window)
	# pl.show()
	signal = signal * hamming_window
	signal = signal **2
	return np.sum(signal)

def emg_mtw_energy(signal, first_percent, second_percent):
	signal = np.array(signal)
	window_length = signal.shape[0]
	t_window = []
	k1 = 1/(window_length*first_percent)
	k2 = 1/(window_length*(second_percent - 1))
	b2 = 1/(1-second_percent)
	first_point = int(window_length*first_percent)
	second_point = int(window_length*second_percent)
	for i in range(window_length):
		if i >= 0 and i < first_point:
			y = k1 * i
		elif i >= second_point and i <= window_length:
			y = k2 * i + b2
		else: 
			y = 1
		t_window.append(y)
	t_window = np.array(t_window)
	# pl.plot(t_window)
	# pl.show()
	signal = signal * t_window
	signal = signal **2
	return np.sum(signal)

def emg_arc(signal, order):
	arc, ars = alg.AR_est_YW(signal, order)
	arc = np.array(arc)
	return arc

def emg_cc(signal, order):
	arc = emg_arc(signal, order)
	cc=[]
	cc.append(-arc[0])
	cc = np.array(cc)
	for i in range(1, arc.shape[0], 1):
		cp = cc[0:i]
		cp = cp[::-1]
		num = range(1, i+1, 1)
		num = np.array(num)
		num = -num/float(i+1) + 1
		cp = cp * num
		cp = np.sum(cp)
		cc = np.append(cc, -arc[i]*(1+cp))
	return cc

def emg_fft(signal, fs):
	timestep = 0.00005*fs
	ff = np.fft.fft(signal)
	cc = np.sqrt(ff.real*ff.real+ff.imag*ff.imag)
	freq = np.fft.fftfreq(ff.shape[0], d=timestep)
	cc = cc[0:cc.shape[0]/2]
	freq = freq[0:freq.shape[0]/2]
	return cc, freq

def emg_fft_power(signal, fs):
	cc, freq = emg_fft(signal, fs)
	cc = cc*cc
	cc = cc/cc.shape[0]
	return cc, freq

def emg_mdf(signal, fs, type):
	
	if type == 'MEDIAN_POWER':
		cc, freq = emg_fft_power(signal, fs)
	else:
		cc, freq = emg_fft(signal, fs)
	csum = 0
	pre_csum = 0
	index = 0
	ccsum = np.sum(cc)
	for i in range(cc.shape[0]):
		pre_csum = csum
		csum = csum + cc[i]
		if csum >= ccsum/2:
			if (ccsum/2-pre_csum) < (csum-ccsum/2):
				index = i - 1
			else:
				index = i
			break
	return freq[index]


def emg_mnf(signal, fs, type):
	if type == 'MEDIAN_POWER':
		cc, freq = emg_fft_power(signal, fs)
	else:
		cc, freq = emg_fft(signal, fs)
	
	ccsum = np.sum(cc)
	fp = cc*freq
	return np.sum(fp)/np.sum(cc)


def emg_pkf(signal, fs):
	cc, freq = emg_fft_power(signal, fs)
	max_index, max_power = max(enumerate(cc), key=operator.itemgetter(1))
	return cc[max_index], freq[max_index]

def emg_mnp(signal, fs):
	cc, freq = emg_fft_power(signal, fs)
	return np.mean(cc)

def emg_ttp(signal, fs):
	cc, freq = emg_fft_power(signal, fs)
	return np.sum(cc)

def emg_smn(signal, fs, order):
	cc, freq = emg_fft_power(signal, fs)
	freq = freq ** order
	cc = cc * freq
	return np.sum(cc)

def emg_fr(signal, fs, low_down, low_up, high_down, high_up):
	cc, freq = emg_fft_power(signal, fs)
	low = cc[(freq>=low_down) & (freq <= low_up)]

	high = cc[(freq>=high_down) & (freq <= high_up)]

	return np.sum(low)/np.sum(high)

def emg_psr(signal, fs, prange):
	cc, freq = emg_fft_power(signal, fs)
	max_index, max_power = max(enumerate(cc), key=operator.itemgetter(1))
	range_value = cc[max_index-prange:max_index+prange]
	range_value = np.sum(range_value)
	sum_value = np.sum(cc)
	return range_value/sum_value
	

def emg_vcf(signal, fs):
	sm2 = emg_smn(signal, fs, 2)
	sm1 = emg_smn(signal, fs, 1)
	sm0 = emg_smn(signal, fs, 0)
	return sm2/sm0-(sm1/sm0)**2

def emg_hos2(signal, t1):
	signal = np.array(signal)
	signalt = np.zeros(signal.shape[0])
	length = signal.shape[0]
	signalt[0:(length-t1)] = signal[t1:]
	signalt = signal * signalt
	return np.mean(signalt)

def emg_hos3(signal, t1, t2):
	signal = np.array(signal)
	length = signal.shape[0]
	signalt1 = np.zeros(length)
	signalt2 = np.zeros(length)
	signalt1[0:(length-t1)] = signal[t1:]
	signalt2[0:(length-t2)] = signal[t2:]
	signalt = signal * signalt1 * signalt2
	return np.mean(signalt)

def emg_hos4(signal, t1, t2, t3):
	signal = np.array(signal)
	length = signal.shape[0]
	signalt1 = np.zeros(length)
	signalt2 = np.zeros(length)
	signalt3 = np.zeros(length)
	signalt1[0:(length-t1)] = signal[t1:]
	signalt2[0:(length-t2)] = signal[t2:]
	signalt3[0:(length-t3)] = signal[t3:]

	signalt = signal * signalt1 * signalt2 * signalt3
	mean4 = np.mean(signalt)
	result = mean4 - emg_hos2(signal, t1)*emg_hos2(signal, t2-t3) - emg_hos2(signal, t2)*emg_hos2(signal, t3-t1) - emg_hos2(signal, t3)*emg_hos2(signal, t1-t2)
	return result

def emg_dwt(signal, wavelet_name, wavelet_level):
	coeffs = pywt.wavedec(signal, wavelet_name, wavelet_level)
	return coeffs

# return all the energy of dwt coeffs
def emg_dwt_energy(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwt(signal, wavelet_name, wavelet_level)
	energys = []
	for c in coeffs:
		c_squ = [cc**2 for cc in c]
		c_squ = np.array(c_squ)
		energys.append(np.sum(c_squ))
	energys = np.array(energys)
	return energys

def emg_dwpt(signal, wavelet_name, wavelet_level):
	wp = pywt.WaveletPacket(signal, wavelet_name, mode='sym')
	coeffs = []
	level_coeff = wp.get_level(wavelet_level)
	for i in range(len(level_coeff)):
		coeffs.append(level_coeff[i].data)
	coeffs = np.array(coeffs)
	return coeffs


def emg_dwpt_energy(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	coeffs = coeffs**2
	return np.sum(coeffs)

def emg_mdwt(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	mdwt = []
	for detail_coeff in coeffs:
		coeff_abs = [abs(c) for c in detail_coeff]
		coeff_abs = np.array(coeff_abs)
		mdwt.append(np.sum(coeff_abs))
	mdwt = np.array(mdwt)
	return mdwt

def emg_mrwa(signal, wavelet_name):
	coeffs = pywt.wavedec(signal, wavelet_name)
	coeffs = np.array(coeffs)
	mrwa = []
	mrwa.append(LA.norm(coeffs[0]))
	for i in range(1, coeffs.shape[0], 1):
		detail = coeffs[i]
		detail_squ = [d*d for d in detail]
		detail_squ = np.array(detail_squ)
		mrwa.append(np.sum(detail_squ)/detail_squ.shape[0])
	mrwa = np.array(mrwa)
	return mrwa

def emg_dwpt_mean(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	return np.mean(coeffs)

def emg_dwpt_sd(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	return np.std(coeffs)

def emg_dwpt_skewness(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	coeffs = np.array(coeffs)
	coeffs = coeffs.flatten()
	skew = stats.skew(coeffs)
	return skew

def emg_dwpt_kurtosis(signal, wavelet_name, wavelet_level):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	coeffs = np.array(coeffs)
	coeffs = coeffs.flatten()
	kurtosis = stats.kurtosis(coeffs)
	return kurtosis

def emg_dwpt_m(signal, wavelet_name, wavelet_level, order):
	coeffs = emg_dwpt(signal, wavelet_name, wavelet_level)
	coeffs = np.array(coeffs)
	coeffs = coeffs.flatten()
	length = coeffs.shape[0]
	a = range(1, length+1, 1)
	a = np.array(a)
	a = (a/float(length))**order
	coeffs = coeffs * a
	return np.sum(coeffs)

def emg_apen(signal, sub_length, threshold):
	return fai(signal, sub_length, threshold) - fai(signal, sub_length+1, threshold)

def fai(signal, sub_length, threshold):
	dist = []
	signal = np.array(signal)
	N = signal.shape[0]

	for i in range(0, N - sub_length +1, 1):
		sub1 = signal[i:(i+sub_length)]
		row_dist = []
		for j in range(0, N - sub_length + 1, 1):
			sub2 = signal[j:(j+sub_length)]
			dist_value = abs(sub1 - sub2)
			dist_value = np.max(dist_value)
			row_dist.append(dist_value)
		row_dist = np.array(row_dist)
		dist.append(row_dist)
	dist = np.array(dist)
	cmr = [d[d>=threshold].shape[0] for d in dist]
	cmr = np.array(cmr)
	cmr = cmr/float(N - sub_length + 1)
	cmr = np.log(cmr)
	cmr = np.sum(cmr)
	cmr = cmr/(N - sub_length + 1)
	return cmr

def emg_wte(signal, width):
	wavelet = sig.ricker
	widths = np.arange(1, width+1)
	cwt = sig.cwt(signal, wavelet, widths)
	wte = []
	for i in range(cwt.shape[1]):
		col = cwt[:,i]
		col = col * col
		col_energy = np.sum(col)
		col = col / col_energy
		col = -(col*np.log(col))
		wte.append(np.sum(col))
	wte = np.array(wte)
	return wte


def emg_wfe(signal, width):
	wavelet = sig.ricker
	widths = np.arange(1, width+1)
	cwt = sig.cwt(signal, wavelet, widths)
	wfe = []
	for i in range(cwt.shape[0]):
		row = cwt[i,:]
		row = row * row
		row_energy = np.sum(row)
		row = row / row_energy
		row = -(row*np.log(row))
		wfe.append(np.sum(row))
	wfe = np.array(wfe)
	return wfe


























































