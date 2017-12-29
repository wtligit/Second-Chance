function integ = Integral(i,lower,upper,flag)
global Price_da;
global P_da;
global Cost;
global s;
global Alpha;
global Gama;
Price=Price_da{i};
Probability=P_da{i};
if(strcmp(flag,'cost')==1)
        integ=0;
    for t=1:length(Price)
        if(Price(t)>lower&&Price(t)<=upper)
            integ=integ+Price(t)*Probability(t);
        end    
    end
end

if(strcmp(flag,'pro')==1)
        integ=0;
    for t=1:length(Price)
        if(Price(t)>lower&&Price(t)<=upper)
            integ=integ+Probability(t);
        end    
    end
end

if(strcmp(flag,'middle')==1)
        cost=Cost{i+1};
        alpha=Alpha{i+1};
        gama=Gama{i+1};
        integ=0;
    if(lower<upper)
        for t=lower:upper-1
            integTmp=0;
            integ_pro=0;
            for tmp=1:length(Price)
                if(Price(tmp)>alpha(t)&&Price(tmp)<=alpha(t+1))
                    integTmp=integTmp+Price(tmp)*Probability(tmp);
                    integ_pro=integ_pro+Probability(tmp);
                end 
            end
            integ=integ+integTmp*(s-gama(t))+integ_pro*cost(gama(t));
        end
    end
end
