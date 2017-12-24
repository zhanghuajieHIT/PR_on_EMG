# feature extraction tests

import numpy as np
import nose
from emg_features import emg_iemg, emg_mav, emg_ssi, emg_var, \
emg_rms, emg_mavtm, emg_vorder, emg_log, emg_wl, emg_aac, emg_wl_dasdv,\
emg_wl, emg_aac, emg_wl_dasdv, emg_zc, emg_afb, emg_myop, emg_ssc, \
emg_wamp, emg_hemg, emg_mhw_energy, emg_mtw_energy, emg_arc, emg_cc, \
emg_mdf, emg_pkf, emg_mnp, emg_ttp, emg_smn, emg_fr, emg_psr, emg_vcf, \
emg_hos2, emg_hos3, emg_hos4, emg_dwt_energy, emg_dwpt, emg_dwpt_energy, \
emg_mdwt, emg_mrwa, emg_dwpt_mean, emg_dwpt_sd, emg_dwpt_skewness, \
emg_dwpt_kurtosis, emg_dwpt_m, emg_apen, emg_wte, emg_wfe
import pylab as pl

def read_test_signal():
	dfile = open("time_signal.txt")
	data = dfile.readline()
	dfile.close()

	signal = [float(v) for v in data.split()]
	signal = np.array(signal)
	return signal

def close(left, right, eps = 1e-6):
	return abs(left - right) < eps

def test_iemg_mav():
	signal = [-1, -1, -1, -1, -1, -1]
	signal = np.array(signal)
	iemg = emg_iemg(signal)
	mav = emg_mav(signal)
	assert iemg == 6
	assert mav == 1

def test_ssi_var_rms_mavtm():
	signal = [1,-2,3]
	signal = np.array(signal)
	ssi = emg_ssi(signal)
	var = emg_var(signal)
	rms = emg_rms(signal)
	mavtm2 = emg_mavtm(signal, order=2)
	assert ssi == 14
	assert var == 7
	assert rms == np.sqrt(14/3.0)
	assert mavtm2 == 14/3.0

def test_vorder_log():
	signal = [1, -2, 3, 4, 5]
	signal = np.array(signal)
	vorder = emg_vorder(signal)
	log = emg_log(signal)
	real_log = np.exp((np.log(1)+np.log(2)+np.log(3)+np.log(4)+np.log(5))/5)
	assert vorder == np.sqrt(11)
	assert log == real_log

def test_wl_aac_dasdv():
	signal = [0.0, 0.2, 0.4, 0.6, 0.4, 0.2, 0.0]
	signal = np.array(signal)
	wl = emg_wl(signal)
	aac = emg_aac(signal)
	dasdv = emg_wl_dasdv(signal)

	eps = 1e-6
	assert wl == 1.2
	assert close(aac, 0.2, eps)
	assert close(dasdv, 0.2, eps)

def test_zc():
	signal = [-0.1, 0.1, 0, 0.6, -0.4, 0.2, 0.0]
	zc = emg_zc(signal, 0.3)
	assert zc == 2

def test_afb():
	signal = read_test_signal()
	hamming_window_length = 20
	afb = emg_afb(signal, hamming_window_length)

	result_use_matlab = 838.817
	eps = 1e-3
	assert close(afb, result_use_matlab, eps)

def test_myop_ssc_wamp():
	signal = read_test_signal()
	threshold = np.max(signal) + 1
	myop = emg_myop(signal, threshold)
	assert myop == 0
	threshold = np.min(signal) - 1
	myop = emg_myop(signal, threshold)
	assert myop == 1
	threshold = 0.00001
	ssc = emg_ssc(signal, threshold)
	assert ssc == 10
	threshold = 5.0
	wamp = emg_wamp(signal, threshold)
	assert wamp == 23

def test_hemg():
	signal = read_test_signal()
	bins = 8
	hemg = emg_hemg(signal, bins)
	test_hemg = [109, 24, 15, 38, 25, 12, 27, 5]
	test_hemg = np.array(test_hemg)
	assert np.array_equal(hemg, test_hemg)

def test_mhw_mtw():
	signal = read_test_signal()
	mhw = emg_mhw_energy(signal)
	mtw = emg_mtw_energy(signal, 0.2, 0.8)

def test_arc_cc():
	signal = read_test_signal()
	order = 5
	eps = 1e-5
	arc = emg_arc(signal, order)
	cc = emg_cc(signal, order)

	assert close(cc[0], -arc[0], eps)
	assert close(cc[1], -arc[1]*(1+0.5*cc[0]), eps)
	assert close(cc[2], -arc[2]*(1+2*cc[1]/3+cc[0]/3), eps)

def test_freq():
	signal = read_test_signal()
	mdf_p = emg_mdf(signal, 100, 'MEDIAN_POWER')
	mdf_a = emg_mdf(signal, 100, 'MEDIAN_AMP')
	pkf_p, pkf_f = emg_pkf(signal, 100)
	mnp = emg_mnp(signal, 100)
	ttp = emg_ttp(signal, 100)
	smn = emg_smn(signal, 100, 3)
	fr = emg_fr(signal, 100, 0, 50, 80, 100)
	psr = emg_psr(signal, 100, 3)
	vcf = emg_vcf(signal, 100)
	hos2 = emg_hos2(signal, 0)
	hos3 = emg_hos3(signal, 0, 1)
	hos4 = emg_hos4(signal, 0, 1, 2)
	
def test_dwt():
	signal = read_test_signal()
	wavelet_name = 'db2'
	wavelet_level = 5
	dwt_energy = emg_dwt_energy(signal, wavelet_name, wavelet_level)
	dwpt = emg_dwpt(signal, wavelet_name, wavelet_level)
	dwpt_energy = emg_dwpt_energy(signal, wavelet_name, wavelet_level)
	mdwt = emg_mdwt(signal, wavelet_name, wavelet_level)
	mrwa = emg_mrwa(signal, wavelet_name)
	dwpt_mean = emg_dwpt_mean(signal, wavelet_name, wavelet_level)
	dwpt_sd = emg_dwpt_sd(signal, wavelet_name, wavelet_level)
	dwpt_skewness = emg_dwpt_skewness(signal, wavelet_name, wavelet_level)
	dwpt_kurtosis = emg_dwpt_kurtosis(signal, wavelet_name, wavelet_level)
	dwpt_m = emg_dwpt_m(signal, wavelet_name, wavelet_level, 3)


def test_entropy():
	signal = [1, 2, 3, 4, 5, -4, -3, -2, -1]
	eps = 1e-9
	testdata = np.log(2.0/3)-np.log(1.0/2)
	apen = emg_apen(signal, 7, 5)
	assert close(apen, testdata, eps)

	signal = read_test_signal()
	wte = emg_wte(signal, 10)
	wfe = emg_wfe(signal, 10)

