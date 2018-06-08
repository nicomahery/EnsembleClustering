from itertools import cycle
import Cluster_Ensembles as CE
import numpy as np
import sys
from functools import reduce
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs
plt.interactive(False)
plt.rcParams['figure.figsize'] = (16, 9)

def generateData():
# Creating a sample dataset with 4 clusters
    X, y = make_blobs(n_samples=1000, n_features=2, centers=4)
    return X

def generateKmeans(data,clusterNumber):
    kmeans = KMeans(clusterNumber)
    kmeans = kmeans.fit(data)
    label = kmeans.predict(data)
    #center = kmeans.cluster_centers_
    return label

def ensembleClustering(nbClusterMax, labels1, labels2):
    cluster_runs = np.vstack((labels1, labels2))
    ceResult = CE.cluster_ensembles(cluster_runs, verbose=False, N_clusters_max=nbClusterMax)
    return ceResult

datas = generateData()
np.savetxt('datas.csv', datas, delimiter=',')

#with open('input.txt') as f:
#    clusterNumber = f.readline()
clusterNumber = sys.argv[1]
clusterNumber = int(clusterNumber)
km1 = generateKmeans(datas, clusterNumber-1)
np.savetxt('km1.csv', km1, delimiter=',')

km2 = generateKmeans(datas, clusterNumber+1)
np.savetxt('km2.csv', km2, delimiter=',')

ce = ensembleClustering(clusterNumber, km1, km2)
np.savetxt('ce.csv', ce, delimiter=',')

