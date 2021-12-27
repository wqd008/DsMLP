# DsTNet-A-Learning-based-Twinning-Network-for-MIMO-Detection-Implemented-by-Dynamic-Stochastic-Computing
This part of code aims to support the research of our paper named "DsTNet: A Learning-based Twinning Network for MIMO Detection Implemented by Dynamic Stochastic Computing".
## The introduction of DsTNet
DsTNet is a designed network with a twinning relationship between network parameters and signals. Such a twinning relationship decides the simple structure of DsTNet compared with other network.
## The main structure of our code
The code of DsTNet algorithm is comprised of two parts corresponding to two experiments (experiment one for BER performance, experiment two for channel sensetivity) repectively.
## The user guideline of our code
### Experiment.1: BER performance for DsTNet, MMSE, and Richardson method
In this experiment, we simulate the above three algorithms for a 32x4 MIMO system of QPSK, 16QAM, and 64QAM. The structure of code is listed as:
*data_generator.m (The function uesd for generating 3GPP channels and datasets, which is in the folder "data_generation". The generated datas are stored in the folder "input".)

*DsTNet_main.m (The main function for DsTNet algorithm)
