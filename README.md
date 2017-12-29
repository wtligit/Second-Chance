# Second-Chance
An algorithm which can save more for data center operator in open energy market
## What is Second-Chance
**Second-Chance** is an _broker-assisted GLB_-based optimization method which can reduce cost of the sequential bidding in sequential geographical markets. We formulate the optimal sequential bidding and GLB problem as a Markov Decision Process (MDP) problem. To solve the problem, we further establish an optimality criterion for the problem and derive the structure of cost-to-go function. The Real-world trace-driven evaluation shows that the electricity cost can be reduced by more than 10% compared with existing related methods.


## What is Included
| Filename        | Main function   |
| --------   | --------  |
| Data | Source data, including _train_ and _test_, which are used to calculate cost-to-go and simulation  |
| main     | Data input and output |
| costtogo        |    Calculating alpha,beta,gama and generating cost-to-go function  |
| schemeSC        |    Calculating the average cost of Second-Chance    |
| schemeComp | Calculating the average cost of four schemes for comparison |
| Integral | Custom integral function, which is mainly used n the calculation of cost-to-go |
| Find | Custom function, which is mainly used to find the boundary value in the calculation |
| hour_calc | Calculating which moment the workload belongs to |
| Costtogo_Log | Storing the detail of the cost-to-go function |

## How to Start
In this project, we provide a simple sample to calculate the average cost of our Second-Chance and four schemes for comparison. Running the _main.m_ directly, you will see these results in the command line window. The detail of the cost-to-go function is shown in Costtogo_Log.

If you have interest, you can change the bidding sequence ( via _DC\_choose_ ), the capacity ( via _C_ ), and the amount of data centers ( via _N_ ),etc. **It should be noted that we only provide data for three data centers, if you want to increase the number of data centers, you also need to increase the corresponding amount of data in _Price\_da\_train_, _Price\_rt\_train_, _Pro\_da\_train_, _Price\_da\_test_ and _Price\_rt\_test_.**

If you want to know more about the algorithm, you can visit at https://github.com/wtligit/Second-Chance, or read [our paper](http://ieeexplore.ieee.org/abstract/document/7460532/?reload=true).


