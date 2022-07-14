# DsMLP-A-Learning-based-Multi-Layer-Perception-for-MIMO-Detection-Implemented-by-Dynamic-Stochastic-Computing
This part of code aims to support the research of our paper named "DsMLP: A Learning-based Multi-Layer Perception for MIMO Detection Implemented by Dynamic Stochastic Computing". The code will be deleted when the paper is accepted.
## The introduction of DsMLP
DsMLP is a designed network with a twinning relationship between network parameters and signals. Such a twinning relationship decides the simple structure of DsMLPcompared with other network.
## The main structure of our code
The code of DsMLP algorithm is comprised of two parts corresponding to two experiments (The first experiment is for BER performance while the second experiment is for channel sensetivity) repectively.
## The user guideline of our code
### Experiment. 1: BER performance for DsTNet, MMSE, and Richardson method
In this experiment, we simulate the above three algorithms for a 32x4 MIMO system of QPSK, 16QAM, and 64QAM. The structure of code is listed as:

- data_generator.m (The function uesd for generating 3GPP channels and datasets, which is in the folder "data_generation". The generated datas are stored in the folder "input".)

- DsTNet_main.m (The main function for DsTNet algorithm)
    - trandn_matrix.m (Initialization Function)
        - trandn.m
    - feedforward.m (Feedforward Function for DsTNet)
    - Stochastic_SGD.m (Stochastic SGD for DsTNet by DSC)
        - dynamic_sequence_generator.m (Converting to DSC domain)
            - and_door.m
            - xor_door.m
    - evaluatemnist.m (MSE Loss Calculation Function)
    - ber_test.m (Testing the BER Performance)
    - ber_test_Richard.m (Testing the BER for Richardson Method)
        - Richardson_decoder.m (Richardson Algorithm)

The use steps are introduced as:
1. Run the function "data_generator.m" to generate and store datasets in the folder "input". Specifically, the seed is a random number from 1 to 100, thus 100 3GPP channels will be generated.
2. Run the function "DsTNet_main.m" to start the DsTNet.

The simulation results are as illustrated in "mse.pdf" and "compare_32_4.pdf".

### Experiment. 2: Channel sensitivity for DsTNet, MMSE, and Richardson method
In this experiment, we simulate the above three algorithms for a 32x4 MIMO system of QPSK with imperfect channels. The structure of code is listed as:

- data_generator.m (The function uesd for generating 3GPP channels and datasets, which is in the folder "data_generation". The generated datas are stored in the folder "input".)

- non_optimal_channel_generation.m (The function uesd for generating imperfect 3GPP channels.)

- DsTNet_main.m (The main function for DsTNet algorithm)
    - trandn_matrix.m (Initialization Function)
        - trandn.m
    - feedforward.m (Feedforward Function for DsTNet)
    - Stochastic_SGD.m (Stochastic SGD for DsTNet by DSC)
        - dynamic_sequence_generator.m (Converting to DSC domain)
            - and_door.m
            - xor_door.m
    - evaluatemnist.m (MSE Loss Calculation Function)
    - ber_test.m (Testing the BER Performance)
    - ber_test_Richard.m (Testing the BER for Richardson Method)
        - Richardson_decoder.m (Richardson Algorithm)


The simulation results are as illustrated in "robust_finish.pdf".

The algorithm and code about the Richardson method are available in the paper:

[1]  X. Gao, L. Dai, C. Yuen, and Y. Zhang, “Low-complexity MMSE signal detection based on Richardson method for large-scale MIMO systems,” in Proc. IEEE 80th Veh. Technol. Conf. (IEEE VTC'14 Fall), Vancouver, Canada, Sep. 2014.
