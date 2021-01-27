function [agreement_set,selected_agreement,avg_privacy_loss,no_round,no_discussed,eff]=DSM_mechanism(N_ag,N,V,L_min,L_max,density,beta,theta,t_matrix,prob)

% Inputs
% N_ag: Number of available outcomes 
% N:       Number of participants
% V:      Value function, a matrix of size N \times N_ag
% L_min:   Minimum number of agreements the initiator is allowed to offer at each round 
% L_max:  Maximum number of agreements the initiator is allowed to offer at each round 
% density:  Strictness coefficients of all agents, a vector of size N 
% beta:      Bargaining costs of all agents, a vector of size N
% theta:     Privacy sensitivities of all agents, a vector of size N
% t_matrix:  Reward function, a 3-D matrix that is derived by running function Calculate_t_p_three_levels
% prob:       Probability that an offer with an specific score will be selected, a 3-D matrix that is derived by runninf function Calculate_t_p_three_levels

% Outputs
% agreement_set:            This variable is 1 if the agents reach an agreement, 0 otherwise.
% selected_agreement:   This shows the index of the agreement has been selected.
% avg_privacy_loss:         Average privacy loss of the agents during the negotiation
% no_round:                       Length of negotiation
% no_discussed:              Number of discussed agreements
% eff:                                  Outcome efficiency


N_resp=N-1;
d_init=density(1);
d_resp=density(2:N);
privacy_loss=0;
no_discussed=0;
D=3;                           % Satisfaction level is considered to be 3 to reduce complexity.

[V_init_sort,indx]=sort(V(1,:),'descend');  % Sort initiator's value function
[~,~,~,opt]=find_prob_reward_approx_asymmetric(N_ag,V_init_sort,N,L_min,L_max,d_resp,d_init,beta(1),theta(1)); % Initiator's optimal strategy

agreement_set=0;
selected_agreement=0;
no_remain=N_ag;
no_round=0;
while (agreement_set==0 && no_remain>0)
    no_round=no_round+1;
    No_offer=opt(no_remain);
    no_discussed=no_discussed+No_offer;
    offer=indx(N_ag-no_remain+1:N_ag-no_remain+No_offer); %Offers at this round
    no_remain=no_remain-No_offer;
    report=zeros(N-1,No_offer);
    for i=2:N
        report(i-1,:)=attendees_response_three_levels(No_offer,V(i,offer),prob(:,:,No_offer)); %Responder's response
    end
    priv_ind(1)=(N-1)*No_offer*min(1-d_init,d_init);  % Initiator's privacy loss
    for k=1:N_resp
        priv_ind(k+1)=No_offer*min(1-d_resp(k),d_resp(k)); % Responders' privacy loss
    end
    privacy_loss=sum(priv_ind,2);
    
    n1=sum(report==1,2);
    n2=sum(report==2,2);
    report_indx=give_index(n1,n2,No_offer);
    cost=zeros(1,No_offer);     % The cost of choosing each offer will be computed.
    for j=1:No_offer
        if(ismember(0,report(:,j))==1)
            cost(j)=inf;
        else
            for k=1:N-1
                if(report(k,j)==1)
                    cost(j)=cost(j)+t_matrix(report_indx(k)+1,1,No_offer);
                end
            end
        end
    end

    val=V(1,offer)-cost;
    [max_val]=max(val);
    indx_val=[];
    if(max_val>-Inf)
        indx_val=find(val>=max_val-0.0001);
        if(size(indx_val,2)==1)
            selected_agreement=offer(indx_val);
        else
            r=randi([1,size(indx_val,2)]);
            selected_agreement=offer(indx_val(r));    % Initiator selects the agreement that brings it the maximum benefit
        end
        agreement_set=1;
    end
end
avg_privacy_loss=privacy_loss/N;
if(agreement_set==1)
    SW=sum(V,1);
    SW_agreement=SW(selected_agreement);
    [max_SW,indx_SW]=max(SW);
    eff=SW_agreement/max_SW;
else
    fail=fail+1;
    eff=1;
end
