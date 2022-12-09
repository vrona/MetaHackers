from __future__ import division
import random

__author__ = "Denis Bzowy"
__version__ = "16nov2008"
Test = 0

#...............................................................................
class Walkerrandom:
  """ Walker's alias method for random objects with different probablities
  """

  def __init__(self, weights, keys=None):
    """ builds the Walker tables prob and inx for calls to random().
        The weights (a list or tuple or iterable) can be in any order;
        they need not sum to 1.
    """
    n = self.n = len(weights)
    self.keys = keys
    sumw = sum(weights)
    
    prob = [w * n/ sumw for w in weights]  # av 1
    
    inx = [-1] * n
    short = [j for j, p in enumerate(prob) if p < 1]
    long = [j for j, p in enumerate(prob) if p > 1]
    
    while short and long:
        
        j = short.pop()
        k = long[-1]
        
        # assert prob[j] <= 1 <= prob[k]
        inx[j] = k

        prob[k] -= (1 - prob[j])  # -= residual weight
        if prob[k] < 1:
            short.append(k)
            long.pop()
        if Test:
            print("test Walkerrandom: j k pk: %d %d %.2g" % (j, k, prob[k]))
    self.prob = prob
    self.inx = inx
    if Test:
        print("test", self)

    
  def __str__(self):
    # e.g. "Walkerrandom prob: 0.4 0.8 1 0.8  inx: 3 3 -1 2" 
    probstr = " ".join([ "%.2g" % x for x in self.prob ])
    inxstr = " ".join([ "%.2g" % x for x in self.inx ])
    
    return "Walkerrandom prob: %s  inx: %s" % (probstr, inxstr)
    


#...............................................................................
  def random(self):
    """ each call -> a random int or key with the given probability
        fast: 1 randint(), 1 random.uniform(), table lookup
    """
    u = random.uniform(0, 1)
    j = random.randint(0, self.n - 1)  # or low bits of u
    trait = []
    alias = []
    # comment made my Mike Hatchi self.prob[j] is prob of 1st Label, self.inx[j] is prob of 2nd label
    #randint = j if u <= self.prob[j] \
    #    else self.inx[j]
    if u <= self.prob[j] :
        randint = j
        trait.append(("j", randint))
    elif u >= self.prob[j]:
        alias.append((j, "self inx",self.inx[j]))
        randint = self.inx[j]
        
    #print(trait)
    #print(alias)
    return list(self.keys)[randint] if self.keys \
        else randint


#...............................................................................
    # little examples, self-contained --

def walkerMe(nofN, numRand, _randomseed) :
    N = nofN #5
    Nrand = numRand #1000
    randomseed = _randomseed #1
    try:
        import bz.util
        bz.util.scan_eq_args(globals(), __doc__)  # N=5 ...
    except ImportError:
        pass
    if randomseed:
        random.seed(randomseed)
    
    
    print(Nrand, "Walkerrandom with weights .1 .2 .3 .4:")
    
    w = range(1, N)
    wrand = Walkerrandom(w)
    nrand = [0] * (N - 1)
    
    for _ in range(Nrand):
        j = wrand.random()
        nrand[j] += 1
        
    s = str(nrand)
    
    print(s)
    """
    if N==5 and Nrand==1000 and randomseed==1:
        assert(s == "[96, 199, 334, 371]")
    """
    
    
    #print(Nrand, "Walkerrandom strings with weights .1 .2 .3 .4:")
    
    #abcd = {"General":0.0009, "Colonels":0.009, "Captains":0.09, "Privates":0.90009}
    #abcd = {"Body A":0.25, "Body B":0.25, "Body C":0.25, "Body D":0.25}
    abcd = {"Black":0.63, "Red":0.27, "Gradient Blue":0.1}
    #abcd = {"A":1}

    wrand = Walkerrandom(abcd.values(), abcd.keys())

    from collections import defaultdict
    nrand = defaultdict(int)  # init 0
    
    for _ in range(Nrand):
        j = wrand.random()
        #print(j)
        nrand[j] += 1
        
    s = str(sorted(nrand.items()))
    print(s)
    
    """
    if N==5 and Nrand==1000 and randomseed==1:
        assert (s == "[('A', 105), ('B', 181), ('C', 283), ('D', 431)]")
    """

# /\:/\:/\:/\:/\
if __name__ == "__main__":
    walkerMe(4, 1111, 1)