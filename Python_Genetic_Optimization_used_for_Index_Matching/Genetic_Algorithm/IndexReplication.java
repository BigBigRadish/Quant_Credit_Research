import java.io.*;
import java.util.*;
import java.util.concurrent.CountDownLatch;
import java.lang.Math;
import cern.colt.matrix.*;
import cern.colt.matrix.impl.*;


/*
 *  Created on: June 07, 2010
 *  Last modified on: Jan 12, 2011
 *  Author: Changwei Xiong
 *  
 *  Copyright (C) 2011, Changwei Xiong, 
 *  axcw@hotmail.com, <http://www.cs.utah.edu/~cxiong/>
 *
 *  Licence: Revised BSD License
 *
 *
 * Stock Index Replication
 * 
 * This program implements a multi-threaded parallel algorithm for Stock Index 
 * Replication using Genetic Algorithm and Quadratic Programming. The basic idea 
 * is to find an optimal portfolio of the subset of the stocks in the Index 
 * Composition such that the portfolio's tracking error with respect to the 
 * Stock Index is minimized. * 
 * 
 *    Tracking Error = (Rw-S)'(Rw-S) = w'R'Rw + 2(-R'S)'w + S'S
 *               G = R'R
 *               a = -R'S
 *               
 *    The quadratic programming problem is: 
 *      minimize  (1/2)*w'*G*x + a'*w 
 *      subject to:  Ci * w <= bi      
 *                   Ce * w =  be
 * 
 * The input is a ".csv" file that contains the daily return time series of the 
 * Stock Index and all the composition stocks.
 * 
 * The program is running in Parallel, which increases the efficiency dramatically.
 * User should manually specify the number of threads to be running and the number 
 * of the mutations to be achieved.  
 * 
 * Open-source CERN/COLT Java Package can be found here:
 * http://acs.lbl.gov/software/colt/
 *
 * Flanagan's Scientific Java Package can be found here:
 * http://www.ee.ucl.ac.uk/~mflanaga/java/ 
 * 
 * (C) Copyright 2010, Changwei Xiong (axcw@hotmail.com)
 * 
 */

public class IndexReplication {
	private Integer[] GROUP = null;// genetic group
	private int K = 0; // # of stock used to replicate the index
	private int THR = 0; // # of running threads
	private int GEN = 0; // # of mutating generations

	private final double MF = 0.02; // mutating factor
	private final int G = 100;// size of mutating groups
	private int N; // size of cross section
	private int T; // length of time series
	private double S2; // stock index daily return series dot product
	private int ITER = 0; // # of iterations

	final private cern.jet.math.Functions FN = cern.jet.math.Functions.functions;
	final private DoubleFactory1D Fv = DoubleFactory1D.dense;
	final private DoubleFactory2D Fm = DoubleFactory2D.dense;

	private DoubleMatrix2D GM, Ce, Ci;
	private DoubleMatrix1D avec, be, bi;

	// Synchronized Sorted red black tree map for storing groups
	private SortedMap<Double, Integer[]> Groups = Collections
			.synchronizedSortedMap(new TreeMap<Double, Integer[]>());
	private Random RNG = new Random();

	/*
	 * filename: input data file name 
	 * K : portfolio size of subset stocks 
	 * STT: start index of time series 
	 * END: end index of time series 
	 * THR: # of running threads 
	 * GEN: # of mutating generations
	 */
	IndexReplication(String filename, int K, int STT, int END, int THR, int GEN) {
		this.K = K;
		this.THR = THR;
		this.GEN = GEN;

		String line = null;
		try {
			/*
			 * Read in the stock daily return data file. Each line is one
			 * stock's daily return time series. The first line is for the stock
			 * index and the rest lines are for the constituent stocks.
			 */
			BufferedReader in = new BufferedReader(new FileReader(filename));
			ArrayList<double[]> Data = new ArrayList<double[]>();
			while ((line = in.readLine()) != null) {
				String[] sa = line.split(",");
				double[] da = new double[END - STT];
				Data.add(da);
				for (int i = STT; i < END; i++) {
					da[i - STT] = Double.valueOf(sa[i]).doubleValue();
				}
			}

			DoubleMatrix1D SI = new DenseDoubleMatrix1D(Data.get(0));
			this.T = SI.size();
			S2 = SI.zDotProduct(SI);

			Data.remove(0);
			this.N = Data.size();
			double[][] dda = Data.toArray(new double[this.N][]);
			DoubleMatrix2D Ret = new DenseDoubleMatrix2D(dda);

			GM = Ret.zMult(Ret.viewDice(), null);
			avec = Ret.zMult(SI, null).assign(FN.neg);
			Ce = Fm.make(this.K, 1, 1.0);
			be = Fv.make(1, 1.0);

			DoubleMatrix2D Ci1 = Fm.diagonal(Fv.make(this.K, 1.0));
			DoubleMatrix2D Ci2 = Fm.diagonal(Fv.make(this.K, -1.0));
			Ci = DoubleFactory2D.dense.appendColumns(Ci1, Ci2);

			DoubleMatrix1D bi1 = Fv.make(this.K, 0.0);
			DoubleMatrix1D bi2 = Fv.make(this.K, -1.0);
			bi = DoubleFactory1D.dense.append(bi1, bi2);

			// RNG.setSeed(System.currentTimeMillis());
			RNG.setSeed(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	Integer[] GenOneGroup() {// generate one group
		Integer[] group = new Integer[this.K];
		double[] rna = new double[this.N];
		for (int i = 0; i < this.N; i++) {
			rna[i] = RNG.nextDouble();
		}
		HashMap<Double, Integer> hm = new HashMap<Double, Integer>(this.N);
		for (int i = 0; i < this.N; i++) {
			hm.put(new Double(rna[i]), new Integer(i));
		}
		Arrays.sort(rna);
		for (int i = 0; i < this.K; i++) {
			group[i] = hm.get(new Double(rna[i])).intValue();
		}
		Arrays.sort(group);
		return group;
	}

	/*
	 * calculate the minimal tracking error for a group using a quadratic
	 * programming solver
	 */
	ArrayList<double[]> FindMinVal(Integer[] group) {
		DoubleMatrix2D gm = new DenseDoubleMatrix2D(this.K, this.K);
		DoubleMatrix1D av = new DenseDoubleMatrix1D(this.K);
		for (int i = 0; i < this.K; i++) {
			for (int j = 0; j <= i; j++) {
				double tmp = GM.get(group[i], group[j]);
				gm.set(i, j, tmp);
				gm.set(j, i, tmp);
			}
			av.set(i, avec.get(group[i]));
		}

		// a quadratic programming solver
		QuadProg qp_solver = new QuadProg(gm, av, Ce, be, Ci, bi);
		if (qp_solver.isFeaAndOpt() == false) {
			System.out.println(" FALSE ");
			System.exit(0);
		}

		double[] minwgt = qp_solver.getMinX();
		DoubleMatrix1D x = new DenseDoubleMatrix1D(minwgt);
		double total = gm.zMult(x, null).zDotProduct(x) + 2 * av.zDotProduct(x) + S2;
		double[] ate = new double[1];
		ate[0] = Math.sqrt(total / this.T);
		ArrayList<double[]> al = new ArrayList<double[]>(2);
		al.add(ate);
		al.add(minwgt);
		return al;
	}

	// generate and initiate size G of the mutating groups
	void InitGroups() {
		for (int i = 0; i < this.G; i++) {
			Integer[] group = this.GenOneGroup();
			Double key = FindMinVal(group).get(0)[0];
			if (!Groups.containsKey(key)) {
				Groups.put(key, group);
			} else {
				i--;
			}
		}
	}

	/*
	 * mutate one generation by a simple genetic algorithm: 1. firstly,
	 * identical genes from both parents are inherited 2. secondly, different
	 * genes are inherited by 50% probability 3. finally, all genes mutate by a
	 * probability of MF
	 */
	Integer[] MutateOneGen() {
		Double[] keys = Groups.keySet().toArray(new Double[0]);
		int idxa = 0;
		int idxb = 0;
		while (idxa == idxb) {
			idxa = RNG.nextInt(this.G);
			idxb = RNG.nextInt(this.G);
		}
		Integer[] ga = Groups.get(keys[idxa]);
		Integer[] gb = Groups.get(keys[idxb]);

		HashSet<Integer> gas = new HashSet<Integer>();
		gas.addAll(Arrays.asList(ga));
		HashSet<Integer> gbs = new HashSet<Integer>();
		gbs.addAll(Arrays.asList(gb));

		ArrayList<Integer> gnew = new ArrayList<Integer>(this.K * 2);
		for (int i = 0; i < this.N; i++) {
			boolean ina = gas.contains(i);
			boolean inb = gbs.contains(i);

			if (ina && inb && RNG.nextDouble() > this.MF) {
				gnew.add(i);
			}
			if (!ina && !inb && RNG.nextDouble() < this.MF) {
				gnew.add(i);
			}
			if (ina ^ inb) {
				if (RNG.nextDouble() > 0.5) {
					if (RNG.nextDouble() > this.MF) {
						gnew.add(i);
					}
				} else if (RNG.nextDouble() < this.MF) {
					gnew.add(i);
				}
			}
		}

		while (gnew.size() > this.K) {
			gnew.remove(RNG.nextInt(gnew.size()));
		}
		while (gnew.size() < this.K) {
			int idx = RNG.nextInt(this.N - gnew.size());
			while (gnew.contains(idx)) {
				idx++;
			}
			int i = 0;
			for (; i < gnew.size(); i++) {
				if (gnew.get(i) > idx)
					break;
			}
			gnew.add(i, idx);
		}
		Integer[] newgroup = gnew.toArray(new Integer[this.K]);
		return newgroup;
	}

	void AddToGroupList(Double key, Integer[] newgroup) {
		if (Groups.lastKey() > key && !Groups.containsKey(key)) {
			Groups.remove(Groups.lastKey());
			Groups.put(key, newgroup);
		}
	}

	/*
	 * keep mutating to find an optimal subset of constituent stocks that gives
	 * a reasonable small tracking error.
	 */
	public void RunMutateGen() {
		final int numOfIters = this.GEN / this.THR;
		CountDownLatch threadsSignal = new CountDownLatch(this.THR);
		for (int i = 0; i < this.THR; i++) {
			new GenMutate(numOfIters, threadsSignal).start();
		}
		while (true) {
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println(
					" Threads = " + threadsSignal.getCount() +
					" : Generations = " + this.ITER + 
					" : TrackErr = " + this.Groups.firstKey()
					);
			if (threadsSignal.getCount() <= 0) {
				break;
			}
		}
	}

	class GenMutate extends Thread {
		private CountDownLatch threadsSignal;
		private int numOfGens;

		GenMutate(int numOfGens, CountDownLatch threadsSignal) {
			this.numOfGens = numOfGens;
			this.threadsSignal = threadsSignal;
		}

		public void run() {
			for (int i = 0; i < numOfGens; i++) {
				IndexReplication.this.CompleteOneGen();
				IndexReplication.this.ITER++;
			}
			threadsSignal.countDown();
		}
	}

	void CompleteOneGen() {
		Integer[] newgroup = MutateOneGen();
		AddToGroupList(FindMinVal(newgroup).get(0)[0], newgroup);
	}
	
	void solve(){
		GenOneGroup();
		InitGroups();
		RunMutateGen();

		Integer[] best = Groups.get(Groups.firstKey());
		double[] bestwgt = FindMinVal(best).get(1);
		
		System.out.println("\nOptimal Portfolio is:\n");
		for (int i = 0; i < best.length; i++) {
			System.out.println(" stock id = " + best[i] + "  :  weight = " + bestwgt[i]);
		}
	}

	public static void main(String[] args) {
		double time = System.currentTimeMillis() / 1000.0;
		System.out.println("Starting...");
		IndexReplication idxrep = new IndexReplication("data.csv", 30, 0, 243, 4, 100000);
		idxrep.solve();

		System.out.println("\n total time = " + (System.currentTimeMillis() / 1000.0 - time)
				+ " seconds");
	}
}
