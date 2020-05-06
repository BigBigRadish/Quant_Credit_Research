#
#  Created on: June 07, 2010
#  Last modified on: Jan 12, 2011
#  Author: Changwei Xiong
#  
#  Copyright (C) 2011, Changwei Xiong, 
#  axcw@hotmail.com, <http://www.cs.utah.edu/~cxiong/>
#
#  Licence: Revised BSD License
#
#
# This program is written in Python v2.7, libraries required are:
#     numpy, cvxopt
# 'cvxopt' is a convex optimization package, can be downloaded from here:
#  http://abel.ee.ucla.edu/cvxopt/ 
#
# This program demonstrates an application of a simple genetic algorithm
# in the stock index Index Replication such that the subset portfolio's tracking 
# error with respect to the Stock Index is minimized.
#    Tracking Error = (Rw-S)'(Rw-S) = w'R'Rw + 2(-R'S)'w + S'S
#               G = R'R
#               a = -R'S
#               
#    The quadratic programming problem is: 
#      minimize  (1/2)*w'*G*x + a'*w 
#      subject to:  Ci * w <= bi      
#                   Ce * w =  be
# 
# The input is a ".csv" file that contains the daily return time series of the 
# Stock Index and all the composition stocks.  
#
# It reads in the data from a csv file that contains the time series of
# one stock index and its constituent stocks daily returns. 
#

#from ipdb import set_trace as sett#@UnresolvedImport
import numpy as np
import numpy.random as rnd
from cvxopt import matrix
from cvxopt import blas
from cvxopt import solvers
import time

class IndexReplication(object):   
    def __init__(self):
        self.G = None # number of groups undergoes mutation
        self.K = None # number of stocks of IndexReplicationting portfolio
        self.N = None # total number of constituent stocks
        self.MF = None # mutation factor, ratio of genes being mutated
        self.GroupList = None # a dynamic list for storing the results       
        solvers.options['show_progress'] = False  # shut down the screen output of cvxopt
        
    def ReadDataFile(self, filename):
        fh = open(filename, 'r')
        data = np.array([r.strip().split(',') for r in fh]).astype('float')
        self.Rs = data[0, :].T # stock index daily return time series : T x 1
        self.RC = data[1:, :].T # constituent stocks time series : T x N 
        self.S2 = np.dot(self.Rs, self.Rs)        
        
        # G matrix
        self.GM = np.dot(self.RC.T, self.RC);
        # a vector 
        self.av = -np.dot(self.RC.T, self.Rs);
        
        #total # of constituent stocks  
        self.N = len(self.av)
        #index of stocks
        self.I = np.arange(self.N)
        
        #inequality constraints
        # w_i >= 0, long only portfolio
        self.Ci = matrix(-np.eye(self.K))
        self.bi = matrix(np.zeros([self.K, 1]))
        #eqality contraints
        # sum(w_i) = 1, weights sum to 1
        self.Ce = matrix(1.0, (1, self.K))
        self.be = matrix(1.0)
 
    def GenOneGroup(self):
        idx = zip(rnd.rand(self.N), self.I)
        idx.sort(key=lambda x:x[0])      
        idx = np.array([i[1] for i in idx[:self.K]])
        group = np.zeros(self.N).astype('bool')        
        group[idx] = True
        return group
    
    def InitGroups(self):
        groups = [self.GenOneGroup() for i in xrange(self.G)]     
        self.GroupList = [(self.FindMinTE(g)[0], g) for g in groups]
        self.GroupList.sort(key=lambda x:x[0])
    
    def FindMinTE(self, g):
        """
            Tracking Error = (Rw-S)'(Rw-S) = w'R'Rw + 2(-R'S)'w + S'S 
                     G = R'R
                     a = -R'S
            minimize    1/2*w'*G*w + a'*w 
            subject to    Ci * w <= bi      
                          Ce * w  = be
        """
        G = matrix(self.GM[:,g][g,:])
        a = matrix(self.av[g])
        output = solvers.qp(G, a, self.Ci, self.bi, self.Ce, self.be)
        w = output['x']
        #'primal objective': (1/2)*w'*G*w + a'*w.
        TrackErr = ((output['primal objective'] * 2 + self.S2) / len(self.Rs)) ** 0.5
        return [TrackErr, output['x']]
  
    def MutateOneGen(self):   
        """
            mutate one generation by a simple genetic algorithm:
            1. firstly, identical genes from both parents are inherited
            2. secondly, different genes are inherited by 50% probability
            3. finally, all genes mutate by a probability of MF
        """ 
        while 1:
            idx = rnd.random_integers(0, self.G - 1, 2)
            if idx[0] != idx[1]: break        
        ga = self.GroupList[idx[0]][1]
        gb = self.GroupList[idx[1]][1]        
        g_and = ga & gb
        g_or = ga | gb
        g_out = g_or - g_and
        for i in range(self.N):
            g_out[i] = g_out[i] and rnd.random_integers(0, 1)        
        g_new = g_and + g_out
        
        mut = rnd.rand(self.N)
        mut[mut < (1 - self.MF)] = 0
        mut.astype('bool')
        child = np.logical_xor(g_new, mut)
        
        count = len(child[child])
        while count < self.K:
            idx = rnd.random_integers(0, self.N - count - 1)
            while child[idx] == True: idx += 1
            child[idx] = True
            count += 1
        while count > self.K:
            idx = rnd.random_integers(0, count - 1)
            while child[idx] == False: idx += 1
            child[idx] = False
            count -= 1
          
        node = (self.FindMinTE(child)[0], child)
        if node[0] < self.GroupList[-1][0]:
            self.GroupList[-1] = node
        self.GroupList.sort(key=lambda x:x[0])

    def FindOptPtfl(self, datafile, G, K, MF, N):
        self.G = G
        self.K = K
        self.MF = MF
        self.ReadDataFile(datafile)
        self.InitGroups()
        n = 1;
        while n < N:# number of generations being mutated
            self.MutateOneGen()
            if n % 200 == 0:
                print 'After', n, 'mutations, Tracking_Error = %.8f' % self.GroupList[0][0]
            n += 1
        
        group = np.arange(0, self.N)[self.GroupList[0][1]]
        id = ['stock id = %3d' % i for i in group]
        wgt = ['weight = %.4f' % w for w in self.FindMinTE(group)[1]]
        id_wgt = zip(id, wgt)
        id_wgt = ['  :  '.join(i) for i in id_wgt]
        print '\nOptimal Portfolio is:\n' 
        print '\n'.join(id_wgt)
        print       
    
if __name__ == '__main__':
    st = time.time()  
    print 'Calculating ...'
    rep = IndexReplication()
    rep.FindOptPtfl('data.csv', 100, 20, 0.015, 10000)     
    print "Finished, total elapsed time %.3f seconds" % (time.time() - st)
    
