function [costTmp]=schemeSC(Alpha,Gama,Workload)
global Price_rt_train;
global Price_da_test;
global Price_rt_test;
global C;
global N;
Alpha_h=Alpha;
Gama_h=Gama;
workload=Workload;
sumC=0;
for t=1:length(C)
    sumC=sumC+C{t};
end

cost_sum=0;
Prn=zeros(1,length(Price_rt_train));
for slot=1:length(workload)
    cost_calc=0;
    s=workload(slot);
    for pos=1:length(Price_rt_train)
        Prn(pos)=Price_rt_train{pos}(hour_calc(slot,24));
    end
    for i=1:N
        sigmaC=0;
        for t=i+1:N
            sigmaC=sigmaC+C{t};
        end
        Pda=Price_da_test{i};
        Prt=Price_rt_test{i};
        if(i<N)
            alpha=Alpha_h{i+1}{hour_calc(slot,24)};
            gama=Gama_h{i+1}{hour_calc(slot,24)};
            if(s<=min(sigmaC,C{i})&&s>0)
                k=Find(s,gama,'k');
                if(Pda(slot)>alpha(1)&&Pda(slot)<=min(Prn(i),alpha(k)))
                    m_p=Find(Pda(slot),alpha,'m');
                    cost_calc=cost_calc+(s-gama(m_p))*Pda(slot);                            
                    s=s-(s-gama(m_p));
                end
                if(Prn(i)>alpha(1)&&Prn(i)<alpha(k))
                    m=Find(Prn(i),alpha,'m');
                    if(Pda(slot)>Prn(i))
                        cost_calc=cost_calc+(s-gama(m))*Prt(slot);                        
                        s=s-(s-gama(m));
                    end
                end
            end
            if((s<=min(sigmaC,C{i})||(s>sigmaC&&s<=C{i}))&&s>0)
                if(Pda(slot)<=min(Prn(i),alpha(1)))
                    cost_calc=cost_calc+s*Pda(slot);                            
                    s=s-s;
                end
                if(Prn(i)<=alpha(1))
                    cost_calc=cost_calc+s*Prt(slot)*(Pda(slot)>Prn(i));
                    s=s-s*(Pda(slot)>Prn(i));
                end                
            end
            if(s>C{i}&&s<=sigmaC)
                k=Find(s,gama,'k');
                k_1=Find(s-C{i},gama,'k');
                if(Pda(slot)>alpha(k_1)&&Pda(slot)<=min(Prn(i),alpha(k)))
                    m_p=Find(Pda(slot),alpha,'m');
                    cost_calc=cost_calc+(s-gama(m_p))*Pda(slot);                           
                    s=s-(s-gama(m_p));
                end
                if(Prn(i)>alpha(k_1)&&Prn(i)<alpha(k))
                    m=Find(Prn(i),alpha,'m');
                    if(Pda(slot)>Prn(i))
                        cost_calc=cost_calc+(s-gama(m))*Prt(slot);                       
                        s=s-(s-gama(m));
                    end
                end
            end
            if(s>sigmaC&&s<=C{i})
                Ki=power(2,N-i)-1;
                if(Pda(slot)<=Prn(i)&&Pda(slot)>alpha(1))
                    m_p=Find(Pda(slot),alpha,'m');
                    cost_calc=cost_calc+(s-gama(m_p))*Pda(slot);                            
                    s=s-(s-gama(m_p));
                end
                if(Prn(i)>alpha(1)&&Prn(i)<alpha(Ki))
                    m=Find(Prn(i),alpha,'m');
                    if(Pda(slot)>Prn(i))
                        cost_calc=cost_calc+(s-gama(m))*Prt(slot);                        
                        s=s-(s-gama(m));
                    end                     
                end
                if(Prn(i)>=alpha(Ki))
                    if(Pda(slot)>Prn(i))
                        cost_calc=cost_calc+(s-gama(Ki))*Prt(slot);                       
                        s=s-(s-gama(Ki));
                    end
                end
            end
            if(s>max(C{i},sigmaC)||(s>C{i}&&s<=sigmaC))
                k_1=Find(s-C{i},gama,'k');
                if(Pda(slot)<=min(Prn(i),alpha(k_1)))
                    cost_calc=cost_calc+C{i}*Pda(slot);                            
                    s=s-C{i};
                end
                if(Prn(i)<=alpha(k_1))
                    cost_calc=cost_calc+C{i}*Prt(slot)*(Pda(slot)>Prn(i));
                    s=s-C{i}*(Pda(slot)>Prn(i));
                end
            end
            if(s>max(C{i},sigmaC))
                k_1=Find(s-C{i},gama,'k');
                Ki=power(2,N-i)-1;
                if(Pda(slot)<=Prn(i)&&Pda(slot)>alpha(k_1))
                    m_p=Find(Pda(slot),alpha,'m');
                    cost_calc=cost_calc+(s-gama(m_p))*Pda(slot);                            
                    s=s-(s-gama(m_p));
                end
                if(Prn(i)>alpha(k_1)&&Prn(i)<alpha(Ki))
                    m=Find(Prn(i),alpha,'m');
                    if(Pda(slot)>Prn(i))
                        cost_calc=cost_calc+(s-gama(m))*Prt(slot);                        
                        s=s-(s-gama(m));
                    end
                end
                if(Prn(i)>=alpha(Ki))
                    if(Pda(slot)>Prn(i))
                        cost_calc=cost_calc+(s-gama(Ki))*Prt(slot);                       
                        s=s-(s-gama(Ki));
                    end
                end
            end
        end
        if(i==N)
            cost_calc=cost_calc+s*(Pda(slot)*(Pda(slot)<=Prn(i))+Prt(slot)*(Pda(slot)>Prn(i)));
            s=s-s;
        end
    end
    cost_sum=cost_sum+cost_calc;
end
costTmp=cost_sum/length(workload);