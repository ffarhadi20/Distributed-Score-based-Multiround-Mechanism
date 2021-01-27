function [prob]=calculate_prob_three_levels(No_offer,t_matrix,dist_N)
D=3;
no_states=(No_offer+2)*(No_offer+1)/2;
no_sample=10^6;
prob=zeros(no_states,2);
t_matrix=[Inf*ones(no_states,1),t_matrix,zeros(no_states,1)];
base_vec=D.^(No_offer-1:-1:0);
clear response
for n1=0:No_offer
    for n2=0:No_offer-n1
        ind=give_index(n1,n2,No_offer);
        response(ind,:)=[2*ones(1,n2), ones(1,n1), zeros(1,No_offer-n1-n2)];
    end
end
for N=1:size(dist_N,2)
    if(dist_N(N)>0)
        if(N==1)
            for n1=0:No_offer
                for n2=0:No_offer-n1
                    ind=give_index(n1,n2,No_offer);
                    if(n2==0)
                        if(n1>0)
                            prob(ind,1)=prob(ind,1)+dist_N(N);
                        end
                    else
                        prob(ind,2)=prob(ind,2)+dist_N(N);
                    end
                end
            end
        else
            
            if(D^(N*No_offer)*N*No_offer<=215233605)
                no_state_other=D^((N-1)*No_offer);
                report_oth=dec2base(0:1:no_state_other-1,D,(N-1)*No_offer)-'0';
                report_oth_ind=(reshape(report_oth',[No_offer,no_state_other*(N-1)]))';
                n1_vec=sum(report_oth_ind==1,2);
                n2_vec=sum(report_oth_ind==2,2);
                report_oth_ind_dec=give_index(n1_vec,n2_vec,No_offer);
                
                temp=t_matrix( sub2ind( [no_states,D], report_oth_ind_dec*ones(1,No_offer), report_oth_ind+1 ) );
                
                temp1 = reshape(temp',No_offer,N-1,no_state_other);
                temp2 = sum(temp1,2);
                cost_1= reshape(temp2,No_offer,no_state_other)';
                for ii=1:no_states
                    cost_first_agent= t_matrix( sub2ind( [no_states,3], ii*ones(1,No_offer), response(ii,:)+1 ) );
                    cost=cost_1+cost_first_agent;
                    
                    [mi_cost]=min(cost,[],2);
                    
                    indx=(cost<Inf).*(cost<=mi_cost+0.0001);
                    indx=indx./max(1,sum(indx,2));
                    
                    temp_prob= sum(indx,1)/no_state_other;
                    temp_prob_short(1)=sum(temp_prob.*(response(ii,:)==1),2);
                    temp_prob_short(2)=sum(temp_prob.*(response(ii,:)==2),2);
                    prob(ii,:)=prob(ii,:)+temp_prob_short*dist_N(N);
                end
            else
                report_oth_ind=dec2base(randi([0 D^(No_offer)-1],1,no_sample*(N-1)),D,No_offer)-'0';
                n1_vec=sum(report_oth_ind==1,2);
                n2_vec=sum(report_oth_ind==2,2);
                report_oth_ind_dec=give_index(n1_vec,n2_vec,No_offer);
                
                temp=t_matrix( sub2ind( [no_states,D], report_oth_ind_dec*ones(1,No_offer), report_oth_ind+1 ) );
                
                temp1 = reshape(temp',No_offer,N-1,no_sample);
                temp2 = sum(temp1,2);
                cost_1= reshape(temp2,No_offer,no_sample)';
                for ii=1:no_states
                    cost_first_agent= t_matrix( sub2ind( [no_states,3], ii*ones(1,No_offer), response(ii,:)+1 ) );
                    cost=cost_1+cost_first_agent;
                    
                    [mi_cost]=min(cost,[],2);
                    
                    indx=(cost<Inf).*(cost<=mi_cost+0.0001);
                    indx=indx./max(1,sum(indx,2));
                    
                    temp_prob= sum(indx,1)/no_sample;
                    temp_prob_short(1)=sum(temp_prob.*(response(ii,:)==1),2);
                    temp_prob_short(2)=sum(temp_prob.*(response(ii,:)==2),2);
                    prob(ii,:)=prob(ii,:)+temp_prob_short*dist_N(N);
                end
            end
        end
    end
end


