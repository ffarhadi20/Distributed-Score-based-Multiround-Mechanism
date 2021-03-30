# Distributed-Score-based-Multiround-Mechanism

This code implements a negotiation based on the DSM mechanism proposed in the following paper:

Farhadi, F., Jennings, N.R.: A Faithful Mechanism for Incremental Multi-Agent Agreement Problems with Self-Interested and Privacy-Preserving Agents.

To get started, save the Matlab files in a folder. Change Matlab's current directory to the folder that contains all the saved files. The main program is DSM_mechanism.m. This function simulates a DSM negotiation for fixed reward $r(s,A,F,L)$ and belief $P(s,A,F,L)$ functions. Therefore, before running this program, a pair of reward and belief functions that are consistent with each other and satisfy conditions (a)-(d) stated in Section 5.2.4, should be derived.

To do this, run function Calculate_t_p_three_levels.m. This function has two inputs and two outputs.

 - Input arguments:

        Lmax:   Maximum number of agreements the initiator is allowed to offer at each round
        dist_N: Responders' belief about the number participants
 
 - Output arguments:

        t_matrix: Reward function, a 3-D matrix of size (Lmax+2)*(Lmax+1)/2  \times 1 \times Lmax
        prob:     Belief function, a 3-D matrix of size (Lmax+2)*(Lmax+1)/2  \times 2 \times Lmax
        
The outputs of function Calculate_t_p_three_levels.m, are among the inputs of the main program DSM_mechanism.m. This program has ten inputs and six outputs.

 - Input arguments:

        N_ag:     Number of available outcomes 
        N:        Number of participants
        V:        Value function, a matrix of size N \times N_ag
        L_min:    Minimum number of agreements the initiator is allowed to offer at each round
        L_max:    Maximum number of agreements the initiator is allowed to offer at each round
        density:  Strictness coefficients of all agents, a vector of size N
        beta:     Bargaining costs of all agents, a vector of size N
        theta:    Privacy sensitivities of all agents, a vector of size N
        t_matrix: Reward function, a 3-D matrix that is derived by running function Calculate_t_p_three_levels
        prob:     Belief function, a 3-D matrix that is derived by running function Calculate_t_p_three_levels
 
 - Output arguments:

        agreement_set:        This variable is 1 if agents reach an agreement, 0 otherwise
        selected_agreement:   This shows the index of the agreement that has been selected
        no_round:             Length of the negotiation
        no_discussed:         Number of discussed agreements before reaching an agreement
        eff:                  Outcome efficiency
