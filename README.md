# DsMLP: A Learning-based Multi-Layer-Perception for MIMO Detection Implemented by Dynamic Stochastic Computing
This part of code aims to support the research of our paper named "DsMLP: A Learning-based Multi-Layer Perception for MIMO Detection Implemented by Dynamic Stochastic Computing" accepted by the journal IEEE Transactions on Signal Processing.

**Notice: This version of DsMLP code is implemented in a traditional MLP without Stochastic Computing due to the project privacy requirement. If you require the stochastic computing version for research, please contact my email: wuqd22@mails.tsinghua.edu.cn.**

## The introduction of DsMLP
DsMLP is a simple MLP with a mapping relationship between MLP parameters and MIMO signals. Such a mapping relationship decides the simple structure of DsMLP compared with other network. The main idea of DsMLP is converting the high-complexity complex-value matrix operation in MMSE to the weight matrix training in DsMLP (using Stochastic Computing). Therefore, DsMLP is able to decrease the complexity of MIMO detection significantly. Moreover, we design the correspoding Stochastic Computing Circuit to further verify our design, please refer to our paper. 
## Run DsMLP
Open the main function "DsMLP_main.m" and run the DsMLP simulation
## The user guideline of our code
The structure of code is listed as:

- data_generator.m (The function uesd for generating 3GPP channels and datasets, which is in the folder "data_generation". The generated datas are stored in the folder "datasets".)

- DsMLP_main.m (The main function for DsMLP algorithm)
    - trandn_matrix.m (Initialization Function)
        - trandn.m
    - GradientDescent.m (GD Algorithm)
    - evaluatemnist.m (MSE Loss Calculation Function)
    - ber_test.m (Testing the BER Performance)
    - ber_test_Richard.m (Testing the BER for Richardson Method)
        - Richardson_decoder.m (Richardson Algorithm)

The use steps are introduced as:
1. Run the function "data_generator.m" to generate and store datasets in the folder "datasets". Specifically, the seed is a random number from 1 to 100, thus 100 3GPP channels will be generated.
2. Run the function "DsMLP_main.m" to start the DsMLP.

The algorithm and code about the Richardson method are available in the paper:

[1]  X. Gao, L. Dai, C. Yuen, and Y. Zhang, “Low-complexity MMSE signal detection based on Richardson method for large-scale MIMO systems,” in Proc. IEEE 80th Veh. Technol. Conf. (IEEE VTC'14 Fall), Vancouver, Canada, Sep. 2014.
