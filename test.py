from matplotlib import pyplot

from Algo import enveloppeConvexe, quality, ritter
from ListOfPointGenerator import parseAllFileFromRep, randomCercle
from Point import polygonArea
from utils import *

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

def drawnPlotFreq(name, lst):
    _lst = [0] * (int)(100 * max(lst) + 1)
    def lstOfFreq(lst):
        for i in lst:
            _lst[(int)(100*i)] += 1

        return _lst, [0.01 * i for i in range(len(_lst))]

    _lst, absc = lstOfFreq(lst)

    pyplot.plot(absc, _lst, label = "number of element \nsorted by range of quality")
    pyplot.plot(absc, [0 for _ in _lst], label = "zero")
    pyplot.legend(loc="upper right")
    pyplot.show()

def drawnPlot(name, lst):
    absc = list(range(len(lst)))
    pyplot.plot(absc, lst, label = name)
    pyplot.legend(loc="upper right")
    pyplot.show()
    print(analyse2Str(analyseQuality(lst)))

def drawnPlotTime(generator, absc, algorithms):
    """
    :param generator: function(int)-> return a list of point
    :param absc: list<int>
    :param algorithms: list<function(list<Point>)->

    drawn a plot of time take by each algorithm to run of list of
    each element of absc size
    """

    times = list()
    names = list()
    points = generateListOfPoint(generator, absc)

    for algo in algorithms:
        times.append(generateListOfTime(points, algo))
        names.append(algo.__name__)

    for i in range(len(times)):
        pyplot.plot(absc, times[i], label=names[i])

    pyplot.legend(loc="upper left")
    pyplot.show()


def createListOfAreaQuality(list, algo):
    """

    :param list: list of point
    :param algo: algo to compare to enveloppeConvexe
    :return:
    """

    lstAlgo = [algo(list[i]).area() for i in range(len(list))]
    lstConvex = [polygonArea(enveloppeConvexe(list[i])) for i in range(len(list))]

    return [quality(lstConvex[i], lstAlgo[i]) for i in range(len(lstAlgo))]



# lst = parseAllFileFromRep("randomRectangle")
# lstQ = createListOfAreaQuality(lst, ritter)
# drawnPlotFreq("quality of ritter on samples test", lstQ)
# drawnPlot("quality of ritter on samples test", lstQ)


drawnPlotTime(randomCercle, [j*(10**i) for i in range(1, 6) for j in range(1, 10)], [enveloppeConvexe, ritter])