from matplotlib import pyplot

from Algo import enveloppeConvexe, quality, ritter
from ListOfPointGenerator import parseAllFileFromRep
from Point import polygonArea

def analyseQuality(lst):
    """
    :param lst: list of quality
    :return: (average, standard deviation)
    """
    aver = sum(lst)/len(lst)
    stdDev = 0
    for e in lst:
        stdDev += abs(e - aver)

    return aver, stdDev/len(lst)

def analyse2Str(tuples):
    aver, stdDev = tuples

    return "average: {0:.5f} | standard deviation: {1:.7f}".format(aver, stdDev)

def drawnPlot(name, lst):
    absc = list(range(len(lst)))
    pyplot.plot(absc, lst, label = name)
    pyplot.legend(loc="upper right")
    pyplot.show()
    print(analyse2Str(analyseQuality(lst)))


def createListOfArea(list, algo):
    """

    :param list: list of point
    :param algo: algo to compare to enveloppeConvexe
    :return:
    """

    lstAlgo = [algo(list[i]).area() for i in range(len(list))]
    lstConvex = [polygonArea(enveloppeConvexe(list[i])) for i in range(len(list))]

    return [quality(lstConvex[i], lstAlgo[i]) for i in range(len(lstAlgo))]



lst = parseAllFileFromRep("randomRectangle")
lstQ = createListOfArea(lst, ritter)
print(lstQ)
drawnPlot("quality of ritter on samples test", lstQ)
