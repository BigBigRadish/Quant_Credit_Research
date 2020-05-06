import cern.colt.matrix.DoubleFactory1D;
import cern.colt.matrix.DoubleFactory2D;
import cern.colt.matrix.DoubleMatrix1D;
import cern.colt.matrix.DoubleMatrix2D;
import cern.colt.matrix.linalg.Algebra;
import cern.colt.matrix.linalg.CholeskyDecomposition;
import cern.colt.matrix.linalg.QRDecomposition;

/*
 ***************************************
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
 * An Active-Set Solver for Convex Quadratic Programming
 * 
 * This is a Quadratic Programming solver for strictly convex minimization problems.
 * It is originally adapted from Junjie Sun and Leigh Tesfatsion's Java code
 * (http://www.econ.iastate.edu/tesfatsi/DCOPFJHome.htm)
 * 
 * This class implements Goldfarb and Idnani's 1983's paper:
 * Goldfarb, D. and Idnani, A. (1983). "A numerically stable dual method for solving
 * strictly convex quadratic programs". Mathematical Programming 27, 1-33.
 * 
 * Substantial improvements have been made to enhance the efficiency and robustness 
 * of the code and increase the speed by a factor of 3.
 * 
 * Open-source CERN/COLT Java Package can be found here:
 * http://acs.lbl.gov/software/colt/ 
 * 
 ***************************************
 */

class QuadProg {
	final private cern.jet.math.Functions FN = cern.jet.math.Functions.functions;
	final private DoubleFactory1D Fv = DoubleFactory1D.dense;
	final private DoubleFactory2D Fm = DoubleFactory2D.dense;
	final private Algebra alg = new Algebra();

	final private static double INF = 1e100; // positive infinite
	final private static double TOL = 1e-12; // tolerance
	final private int n; // # of decision variables, x's
	final private int m; // # of total constraints (m = me + mi)
	final private int me; // # of equality constraints
	final private int mi; // # of inequality constraints

	final private DoubleMatrix2D G; // n by n
	final private DoubleMatrix1D a; // n by 1
	final private DoubleMatrix2D C; // n by m, C = [Ce Ci]
	final private DoubleMatrix1D b; // m by 1, b = [be' bi']'
	final private DoubleMatrix2D Ce; // n by me
	final private DoubleMatrix1D be; // me by 1
	final private DoubleMatrix2D Ci; // n by mi
	final private DoubleMatrix1D bi; // mi by 1

	final private DoubleMatrix2D L; // Inverse of Cholesky decompsition of G, n
									// by n
	final private DoubleMatrix2D U; // transpose of L, n by n

	private int[] A;// active set
	private int q; // # of effective constraints in A
	private int p; // # of currently violated constraints
	private int k; // # of constraints to be removed

	private boolean isFullStep = true;
	private boolean isInfeasible = false;
	private boolean isFeaAndOpt = false;

	private double ofv; // min objective function value
	private DoubleMatrix1D x; // minimizer, nx1
	private DoubleMatrix2D N; // active constraint matrix, n by q => n by m
	private DoubleMatrix2D H; // reduced inverse Hessian, n by n
	private DoubleMatrix1D np; // current chosen violated constr., n by 1
	private DoubleMatrix2D Ns; // pseudo-inverse of N, q by n
	private DoubleMatrix1D z; // step direction in primal space, n by 1
	private DoubleMatrix1D r; // neg. step direction in dual space, (q-1) by 1
	private DoubleMatrix1D u; // Lagrangian multiplier, q by 1
	private DoubleMatrix1D up; // transitional Lagrangian mult., (q+1) by 1

	private int numIter = 0; // # of total iterations

	public QuadProg(DoubleMatrix2D G, DoubleMatrix1D a, DoubleMatrix2D Ce,
			DoubleMatrix1D be, DoubleMatrix2D Ci, DoubleMatrix1D bi) {
		n = a.size();
		me = be.size();
		mi = bi.size();
		m = me + mi;

		this.G = G; // n by n
		this.a = a; // n by 1
		this.Ce = Ce; // n by me
		this.be = be; // me by 1
		this.Ci = Ci; // n by mi
		this.bi = bi; // mi by 1

		C = Fm.appendColumns(Ce, Ci); // C = [Ce,Ci] (n by m)
		b = Fv.append(be, bi); // b = [be',bi']' (m by 1)

		L = alg.inverse(new CholeskyDecomposition(G).getL());// n by n
		U = L.viewDice();// n by n
		// N = Fm.sparse.make(n, Math.min(m, n));
		N = Fm.make(n, Math.min(m, n));
		dualActiveSetSolver(); // the real solver
		correct(x);
	}

	private void dualActiveSetSolver() {
		if (me == 0) {
			calcUnconstrMin();
		} else {
			calcEqConstrMin();
		}

		if (mi > 0) {
			while (true) {
				chooseViolatedConstraint();// Step 1
				if (isFeaAndOpt || isInfeasible) {
					break;
				}
				determineStepDirection();// Step 2(a)
				double t1 = computePartialStepLength();// Step 2(b)
				double t2 = computeFullStepLength();// Step 2(b)
				determineNewSpairAndTakeStep(t1, t2);// Step 2(c)
			}
		}
	}

	@SuppressWarnings("static-access")
	private void update_H_Ns() {
		DoubleMatrix2D B = L.zMult(N.viewPart(0, 0, n, q), null);
		QRDecomposition QR = new QRDecomposition(B);
		DoubleMatrix2D Q = QR.getQ(); // n by q
		DoubleMatrix2D R = QR.getR(); // q by q
		DoubleMatrix2D J = U.zMult(Q, null);// n by q

		DoubleMatrix2D IQQ = Fm.identity(n).assign(Q.zMult(Q.viewDice(), null),
				FN.minus);
		// IQQ = I - Q*Q', n by n
		H = U.zMult(IQQ, null).zMult(L, null);// n by n
		Ns = alg.solve(R, J.viewDice()); // q by n
	}

	@SuppressWarnings("static-access")
	private void calcUnconstrMin() {
		H = U.zMult(L, null);// H = G^-1, n by n
		x = H.zMult(a, null).assign(FN.neg); // x = -H*a
		ofv = 0.5 * a.zDotProduct(x);// f = 1/2*a'*x
		if (getMostViolatedConstr() == -1) {
			isFeaAndOpt = true;
		} else {
			A = new int[Math.min(m, n)];
			q = 0;
		}
	}

	@SuppressWarnings("static-access")
	private void calcEqConstrMin() {
		DoubleMatrix2D NCe = Ce.copy().assign(FN.neg);
		DoubleMatrix2D[][] parts = { { G, NCe }, { NCe.viewDice(), null } };
		DoubleMatrix2D GCe = Fm.compose(parts);
		DoubleMatrix1D abe = Fv.append(a, be).assign(FN.neg);
		DoubleMatrix1D kkt = correct(alg.inverse(GCe).zMult(abe, null));

		x = kkt.viewPart(0, n);
		//ofv = 1/2*x'*G*x + a'*x
		ofv = 0.5 * x.zDotProduct(G.zMult(x, null)) + a.zDotProduct(x);
		if (getMostViolatedConstr() == -1) {
			isFeaAndOpt = true;
		} else {
			u = kkt.viewPart(n, me);
			A = new int[Math.min(m, n)];
			for (int i = 0; i < me; i++) {
				A[i] = i;
			}
			q = me;
			N.viewPart(0, 0, n, me).assign(Ce);
			update_H_Ns();
		}
	}

	@SuppressWarnings("static-access")
	private int getMostViolatedConstr() {
		DoubleMatrix1D siq = correct(Ci.viewDice().zMult(x, null)
				.assign(bi, FN.minus));// siq = Ci' * x - bi
		int idx = -1;
		double val = INF;
		int sz = siq.size();
		for (int i = 0; i < sz; i++) {// choose the most violated ineq. constr.
			double tmp = siq.getQuick(i);
			if (tmp < 0 && val > tmp) {// i.e. the smallest negative value.
				val = tmp;
				idx = i;
			}
		}
		return idx;// val >= 0 means no active constr.
	}

	private void chooseViolatedConstraint() {
		if (isFullStep == false) {
			return;
		}
		int idx = getMostViolatedConstr();
		if (idx == -1) {
			isFeaAndOpt = true;
		} else {
			p = me + idx;
			np = C.viewColumn(p).copy();
			if (q == 0) {
				up = Fv.make(1);
				u = Fv.make(1);
			} else {
				up = Fv.append(u, Fv.make(1));
			}
		}
	}

	private void determineStepDirection() {
		z = correct(H.zMult(np, null));
		if (q > 0) {
			r = correct(Ns.zMult(np, null));
		} else {
			r = Fv.make(0);
		}
	}

	@SuppressWarnings("static-access")
	private void determineNewSpairAndTakeStep(double t1, double t2) {
		double t = Math.min(t1, t2);
		if (t >= INF) {
			isInfeasible = true;
		} else {
			DoubleMatrix1D rn = r.copy().assign(FN.neg);
			DoubleMatrix1D rp = Fv.append(rn, Fv.make(1, 1.0));
			up.assign(rp, FN.plusMult(t));// up = up + t*rp
			if (t2 == INF) {
				isFullStep = false;
				dropZeroMultiCorrespToConstrK();
				dropConstraintK();
			} else {
				x.assign(z, FN.plusMult(t)); // x <- x + t*z
				ofv += t * z.zDotProduct(np)
						* (0.5 * t + up.getQuick(up.size() - 1));
				if (t2 <= t1) {
					u = up;
					addConstraintP();
					isFullStep = true;
				} else {
					dropZeroMultiCorrespToConstrK();
					dropConstraintK();
					isFullStep = false;
				}
			}
		}
	}

	private void addConstraintP() {
		N.viewColumn(q).assign(C.viewColumn(p));
		A[q++] = p;
		update_H_Ns();
	}

	private void dropConstraintK() {
		q--;
		for (int i = me; i < A.length; i++) {
			if (A[i] == k) {
				for (int j = i; j < q; j++) {
					A[j] = A[j + 1];
					N.viewColumn(j).assign(N.viewColumn(j + 1));
				}
				break;
			}
		}
		update_H_Ns();
	}

	private void dropZeroMultiCorrespToConstrK() {
		for (int i = me, sz = up.size() - 1; i < A.length; i++) {
			if (A[i] == k) {
				for (int j = i; j < sz; j++) {
					up.set(j, up.get(j + 1));
				}
				up = up.viewPart(0, sz).copy();
				break;
			}
		}
	}

	private double computePartialStepLength() {
		if (q == 0) {
			return INF;
		} else {
			int idx = 0;
			double tmin = INF;
			for (int i = me; i < q; i++) {
				if (r.getQuick(i) > 0) {
					double tt = up.get(i) / r.get(i);
					if (tmin > tt) {
						tmin = tt;
						idx = i;
					}
				}
			}
			if (tmin < INF) {
				k = A[idx];
			}
			return tmin;
		}
	}

	private double computeFullStepLength() {
		if (z.zDotProduct(z) == 0) {
			return INF;
		} else {
			return (b.getQuick(p) - np.zDotProduct(x)) / z.zDotProduct(np);
		}
	}

	private DoubleMatrix1D correct(DoubleMatrix1D v) {
		int sz = v.size();
		for (int i = 0; i < sz; i++) {
			if (Math.abs(v.getQuick(i)) < TOL) {
				v.setQuick(i, 0.0);
			}
		}
		return v;
	}

	/************************* Get and Set Methods **************************/
	public double[] getMinX() {
		return x.toArray();
	}

	public double getMinF() {
		return ofv;
	}

	public int getNumIterations() {
		return numIter;
	}

	public boolean isFeaAndOpt() {
		return isFeaAndOpt;
	}
}
