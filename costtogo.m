function [AlphaTmp,BetaTmp,GamaTmp]=costtogo(log)

global Price_da_train;
global Pro_da_train;
global Price_rt_train;
global DC_choose;
global C;
global N;
i=N;

global Price_da;
global P_da;
global Cost;
global s;
global Alpha;
global Gama;

[Price_rt,Alpha,Beta,Gama,Alpha_h,Beta_h,Gama_h,Cost]=deal(cell(1,N));
fid=fopen('Costtogo_Log.txt','wt');

    vernier=1;
for hour_times=1:24
    count=1; 
    Price_rt{DC_choose(1)}=Price_rt_train{DC_choose(1)}(hour_times);
    Price_rt{DC_choose(2)}=Price_rt_train{DC_choose(2)}(hour_times);
    Price_rt{DC_choose(3)}=Price_rt_train{DC_choose(3)}(hour_times);
    for hour_choose=vernier:vernier+399
        Price_da{DC_choose(1)}(count)=Price_da_train{DC_choose(1)}(hour_choose);
        P_da{DC_choose(1)}(count)=Pro_da_train{DC_choose(1)}(hour_choose);
        Price_da{DC_choose(2)}(count)=Price_da_train{DC_choose(2)}(hour_choose);
        P_da{DC_choose(2)}(count)=Pro_da_train{DC_choose(2)}(hour_choose);
        Price_da{DC_choose(3)}(count)=Price_da_train{DC_choose(3)}(hour_choose);
        P_da{DC_choose(3)}(count)=Pro_da_train{DC_choose(3)}(hour_choose);
        count=count+1;
    end
    vernier=vernier+400;

Alpha{i}(1)=Integral(i,-inf,Price_rt{i},'cost')+Price_rt{i}*Integral(i,Price_rt{i},inf,'pro');
Beta{i}(1)=0;
Gama{i}(1)=C{i};
Alpha_h{i}{hour_times}(1)=Alpha{i}(1);
Beta_h{i}{hour_times}(1)=Beta{i}(1);
Gama_h{i}{hour_times}(1)=Gama{i}(1);
Cache=[0,Gama{i}(1)];
if(strcmp(log,'Log=true')||strcmp(log,'Log=True'))
    fprintf(fid,'Hour: %d\nData Center %d: \n                Cost=%f * s ( %d<s<=%d )\n',hour_times,i,Alpha{i}(1),Cache(1),Cache(2));
end
for s=1:C{i}
    if(s>=0&&s<=C{i})
        Cost{i}(s)=Alpha{i}(1)*s;
    end
end

for times=1:N-1
    sigmaC=0;
    for t=i:N
        sigmaC=sigmaC+C{t};
    end
    for s=1:sigmaC+C{i-1}
        if(s<=min(C{i-1},sigmaC))
            k=Find(s,Gama{i},'k');
            if(Price_rt{i-1}<=Alpha{i}(1))
                Cost{i-1}(s)=(Integral(i-1,-inf,Price_rt{i-1},'cost')+Price_rt{i-1}*Integral(i-1,Price_rt{i-1},inf,'pro'))*s;
            end
            if(Price_rt{i-1}>Alpha{i}(1)&&Price_rt{i-1}<Alpha{i}(k))
                m=Find(Price_rt{i-1},Alpha{i},'m');
                Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(1),'cost')*s+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'cost')*(s-Gama{i}(m))+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'pro')*Cost{i}(Gama{i}(m))+Integral(i-1,Price_rt{i-1},inf,'pro')*(Price_rt{i-1}*(s-Gama{i}(m))+Cost{i}(Gama{i}(m)));
                Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,1,m,'middle');
            end
            if(Price_rt{i-1}>=Alpha{i}(k))
                Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(1),'cost')*s+Integral(i-1,Alpha{i}(k),inf,'pro')*Cost{i}(s);
                Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,1,k,'middle');
            end
        end
        if(C{i-1}<=sigmaC)   
            if(s>C{i-1}&&s<=sigmaC)
                k_1=Find(s-C{i-1},Gama{i},'k');
                k=Find(s,Gama{i},'k');
                if(Price_rt{i-1}<=Alpha{i}(k_1))
                    Cost{i-1}(s)=Integral(i-1,-inf,Price_rt{i-1},'cost')*C{i-1}+Integral(i-1,-inf,Price_rt{i-1},'pro')*Cost{i}(s-C{i-1})+Price_rt{i-1}*Integral(i-1,Price_rt{i-1},inf,'pro')*C{i-1}+Integral(i-1,Price_rt{i-1},inf,'pro')*Cost{i}(s-C{i-1});
                end
                if(Price_rt{i-1}>Alpha{i}(k_1)&&Price_rt{i-1}<Alpha{i}(k))
                    m=Find(Price_rt{i-1},Alpha{i},'m');
                    Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(k_1),'cost')*C{i-1}+Integral(i-1,-inf,Alpha{i}(k_1),'pro')*Cost{i}(s-C{i-1})+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'cost')*(s-Gama{i}(m))+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'cost')*Cost{i}(Gama{i}(m))+Integral(i-1,Price_rt{i-1},inf,'pro')*(Price_rt{i-1}*(s-Gama{i}(m))+Cost{i}(Gama{i}(m)));
                    Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,k_1,m,'middle');
                end
                if(Price_rt{i-1}>=Alpha{i}(k))
                    Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(k_1),'cost')*C{i-1}+Integral(i-1,-inf,Alpha{i}(k_1),'pro')*Cost{i}(s-C{i-1})+Integral(i-1,Alpha{i}(k),inf,'pro')*Cost{i}(s);
                    Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,k_1,k,'middle');
                end
            end
        end
        if(C{i-1}>sigmaC)
            if(s>sigmaC&&s<=C{i-1})
                if(sigmaC==1)
                    Alpha_K=Cost{i}(sigmaC);
                end
                if(sigmaC>1)
                    Alpha_K=Cost{i}(sigmaC)-Cost{i}(sigmaC-1);
                end
                if(Price_rt{i-1}<=Alpha{i}(1))
                    Cost{i-1}(s)=(Integral(i-1,-inf,Price_rt{i-1},'cost')+Price_rt{i-1}*Integral(i-1,Price_rt{i-1},inf,'pro'))*s;
                end
                if(Price_rt{i-1}>Alpha{i}(1)&&Price_rt{i-1}<Alpha_K)
                    m=Find(Price_rt{i-1},Alpha{i},'m');
                    Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(1),'cost')*s+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'cost')*(s-Gama{i}(m))+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'pro')*Cost{i}(Gama{i}(m))+Integral(i-1,Price_rt{i-1},inf,'pro')*(Price_rt{i-1}*(s-Gama{i}(m))+Cost{i}(Gama{i}(m)));
                    Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,1,m,'middle');
                end
                if(Price_rt{i-1}>=Alpha_K)
                    Ki=power(2,N-i+1)-1;
                    Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(1),'cost')*s+Integral(i-1,Alpha{i}(Ki),Price_rt{i-1},'cost')*(s-Gama{i}(Ki))+Integral(i-1,Alpha{i}(Ki),Price_rt{i-1},'pro')*Cost{i}(Gama{i}(Ki))+Integral(i-1,Price_rt{i-1},inf,'pro')*(Price_rt{i-1}*(s-Gama{i}(Ki))+Cost{i}(Gama{i}(Ki)));
                    Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,1,Ki,'middle');
                end
            end
        end
        if(s>max(C{i-1},sigmaC))
            k_1=Find(s-C{i-1},Gama{i},'k');
            if(sigmaC==1)
                Alpha_K=Cost{i}(sigmaC);
            end
            if(sigmaC>1)
                Alpha_K=Cost{i}(sigmaC)-Cost{i}(sigmaC-1);
            end
            if(Price_rt{i-1}<=Alpha{i}(k_1))
                Cost{i-1}(s)=Integral(i-1,-inf,Price_rt{i-1},'cost')*C{i-1}+Integral(i-1,-inf,Price_rt{i-1},'pro')*Cost{i}(s-C{i-1})+Price_rt{i-1}*Integral(i-1,Price_rt{i-1},inf,'pro')*C{i-1}+Integral(i-1,Price_rt{i-1},inf,'pro')*Cost{i}(s-C{i-1});
            end
            if(Price_rt{i-1}>Alpha{i}(k_1)&&Price_rt{i-1}<Alpha_K)
                m=Find(Price_rt{i-1},Alpha{i},'m');
                Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(k_1),'cost')*C{i-1}+Integral(i-1,-inf,Alpha{i}(k_1),'pro')*Cost{i}(s-C{i-1})+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'cost')*(s-Gama{i}(m))+Integral(i-1,Alpha{i}(m),Price_rt{i-1},'pro')*Cost{i}(Gama{i}(m))+Integral(i-1,Price_rt{i-1},inf,'pro')*Price_rt{i-1}*(s-Gama{i}(m))+Integral(i-1,Price_rt{i-1},inf,'pro')*Cost{i}(Gama{i}(m));
                Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,k_1,m,'middle');
            end
            if(Price_rt{i-1}>=Alpha_K)
                Ki=power(2,N-i+1)-1;
                Cost{i-1}(s)=Integral(i-1,-inf,Alpha{i}(k_1),'cost')*C{i-1}+Integral(i-1,-inf,Alpha{i}(k_1),'pro')*Cost{i}(s-C{i-1})+Integral(i-1,Alpha{i}(Ki),Price_rt{i-1},'cost')*(s-Gama{i}(Ki))+Integral(i-1,Alpha{i}(Ki),Price_rt{i-1},'pro')*Cost{i}(Gama{i}(Ki))+Integral(i-1,Price_rt{i-1},inf,'pro')*Price_rt{i-1}*(s-Gama{i}(Ki))+Integral(i-1,Price_rt{i-1},inf,'pro')*Cost{i}(Gama{i}(Ki));
                Cost{i-1}(s)=Cost{i-1}(s)+Integral(i-1,k_1,Ki,'middle');
            end
        end
    end
        Cache=[Cache,Cache+C{i-1}];
        Cache=sort(Cache,'ascend');
        if(strcmp(log,'Log=true')||strcmp(log,'Log=True'))
            fprintf(fid,'Data Center %d: \n',i-1);
        end
        for ordinal=1:power(2,N-i+2)-1
            Gama{i-1}(ordinal)=Cache(ordinal+1);
            if(Gama{i-1}(ordinal)==1)
                Alpha{i-1}(ordinal)=Cost{i-1}(Gama{i-1}(ordinal));
            end
            if(Gama{i-1}(ordinal)>1)
                Alpha{i-1}(ordinal)=Cost{i-1}(Gama{i-1}(ordinal))-Cost{i-1}(Gama{i-1}(ordinal)-1);
            end
            Beta{i-1}(ordinal)=Cost{i-1}(Gama{i-1}(ordinal))-Alpha{i-1}(ordinal)*Gama{i-1}(ordinal);
            Alpha_h{i-1}{hour_times}(ordinal)=Alpha{i-1}(ordinal);
            Beta_h{i-1}{hour_times}(ordinal)=Beta{i-1}(ordinal);
            Gama_h{i-1}{hour_times}(ordinal)=Gama{i-1}(ordinal);
            if(strcmp(log,'Log=true')||strcmp(log,'Log=True'))
                fprintf(fid,'                Cost=%f * s + %f (%f <s<= %f)\n',Alpha{i-1}(ordinal),Beta{i-1}(ordinal),Cache(ordinal),Cache(ordinal+1));
            end
        end
    i=i-1;
end
i=N;
end
AlphaTmp=Alpha_h;
BetaTmp=Beta_h;
GamaTmp=Gama_h;
