This JAVA program implements a neat and yet efficient algorithm to search for an optimal index replication sub-portfolio from the index constituent stocks. The index tracking is completed through two optimization procedures. Firstly, a Parallel Genetic Algorithm is used to find an optimal combinatorial subset out of the index constituent stocks that gives an global minimal tracking error to the index. Secondly, a Quadratic Programming routine is used to determine optimal allocation weights in the subset of the stocks that minimize the tracking error. A parallel mechanism has been developed for the Genetic Algorithm to allow it running on multi-processors and accelerate the search process. It is achieved through the support of JAVA multithreading techniques. The source code package includes 4 files:
						
	1. IndexReplication.java:
		The JAVA source code for the algorithm.
	2. QuadProg.java:
		A Quadratic Programming JAVA routine that implements Goldfarb and Idnani's 1983's paper: "A numerically stable dual method for solving strictly convex quadratic programs". 
	3. data.csv:
		An input file of sample data, which consists of time series of a stock index (HS300) and its 300 constituent stocks daily returns. 
	4. IndexReplication.py:
		As a comparison, a neat and concise Python implementation of the algorithm is also included for your reference. Note that this script cannot run in parallel.



