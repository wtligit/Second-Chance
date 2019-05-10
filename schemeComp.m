function [baselineTmp,BidTmp,RTTmp,BidGLBTmp]=schemeComp(Workload)
global Price_rt_test;
global Price_rt_train;
global Price_da_test;
global C;
global N;
workload=Workload;
sumC=0;
for t=1:length(C)
    sumC=sumC+C{t};
end

Price_rt_cur=zeros(1,length(Price_rt_train));
[cost_Bid_buffer,cost_RT_buffer,cost_BidGLB_buffer]=deal(zeros(1,length(workload)));
% Baseline purchases electricity in real-time markets and routes the workload to the data centers proportional to their capacities
cost_Baseline=0;
% Bid places a bid which the bidding price is local expected real-time
% price and the bidding quantity is the distributed workload which proportional to their capacities
cost_Bid=0;
% RT purchases electricity in real-time markets and the workload is balanced according to the price expectations
cost_RT=0;
% BidGLB places a bid which the bidding price is local expected real-time
% price and the bidding quantity is balanced according to the price expectations
cost_BidGLB=0;

for test_hour=1:length(workload)
    s=workload(test_hour);
    if s>sumC
        s=sumC;
    end
    for pos=1:length(Price_rt_train)
        Price_rt_cur(pos)=Price_rt_train{pos}(hour_calc(test_hour,24));
    end
    [lower_price,lower_position]=sort(Price_rt_cur);
    % Baseline
    cost_Baseline_buffer=0;
    for t=1:length(C)
        cost_Baseline_buffer=cost_Baseline_buffer+C{t}*Price_rt_test{t}(test_hour);
    end
    cost_Baseline=cost_Baseline+s*cost_Baseline_buffer/sumC;
    % Bid
    for t=1:length(Price_da_test)
        if(Price_da_test{t}(test_hour)<=Price_rt_cur(t))
            cost_Bid_buffer(test_hour)=cost_Bid_buffer(test_hour)+s*Price_da_test{t}(test_hour)*C{t}/sumC;
        end
        if(Price_da_test{t}(test_hour)>Price_rt_cur(t))
            cost_Bid_buffer(test_hour)=cost_Bid_buffer(test_hour)+s*Price_rt_test{t}(test_hour)*C{t}/sumC;
        end
    end
    cost_Bid=cost_Bid+cost_Bid_buffer(test_hour);    
    for i=1:N
        if((s<=C{lower_position(i)})&&(s>0))
            % RT
            cost_RT_buffer(test_hour)=cost_RT_buffer(test_hour)+s*Price_rt_test{lower_position(i)}(test_hour);
            % BidGLB
            if(Price_da_test{lower_position(i)}(test_hour)<=lower_price(i))
                cost_BidGLB_buffer(test_hour)=cost_BidGLB_buffer(test_hour)+s*Price_da_test{lower_position(i)}(test_hour);
            end
            if(Price_da_test{lower_position(i)}(test_hour)>lower_price(i))
                cost_BidGLB_buffer(test_hour)=cost_BidGLB_buffer(test_hour)+s*Price_rt_test{lower_position(i)}(test_hour);
            end
            s=s-s;
        end
        if((s>C{lower_position(i)})&&(s>0))
            % RT
            cost_RT_buffer(test_hour)=cost_RT_buffer(test_hour)+C{lower_position(i)}*Price_rt_test{lower_position(i)}(test_hour);
            % BidGLB
            if(Price_da_test{lower_position(i)}(test_hour)<=lower_price(i))
                cost_BidGLB_buffer(test_hour)=cost_BidGLB_buffer(test_hour)+C{lower_position(i)}*Price_da_test{lower_position(i)}(test_hour);
            end
            if(Price_da_test{lower_position(i)}(test_hour)>lower_price(i))
                cost_BidGLB_buffer(test_hour)=cost_BidGLB_buffer(test_hour)+C{lower_position(i)}*Price_rt_test{lower_position(i)}(test_hour);
            end
            s=s-C{lower_position(i)};
        end
    end    
    cost_RT=cost_RT+cost_RT_buffer(test_hour);
    cost_BidGLB=cost_BidGLB+cost_BidGLB_buffer(test_hour);
end
baselineTmp=cost_Baseline/length(workload);
BidTmp=cost_Bid/length(workload);
RTTmp=cost_RT/length(workload);
BidGLBTmp=cost_BidGLB/length(workload);
