import os

from matplotlib import pyplot

from Algo import enveloppeConvexe, quality, ritter
from Parsing import parsePoint
from Point import polygonArea


def drawnPlot(name, lst):
    absc = list(range(len(lst)))
    pyplot.plot(absc, lst, label = name)
    pyplot.legend(loc="upper right")
    pyplot.show()


def createListOfArea(list, algo):
    """

    :param list: list of point
    :param algo: algo to compare to enveloppeConvexe
    :return:
    """

    lstAlgo = [algo(list[i]).area() for i in range(len(list))]
    lstConvex = [polygonArea(enveloppeConvexe(list[i])) for i in range(len(list))]

    return [quality(lstConvex[i], lstAlgo[i]) for i in range(len(lstAlgo))]


def parseAllFileFromRep(rep):
    list = os.listdir(rep)
    for i in range(len(list)):
        list[i] = parsePoint(rep + "/" + list[i])

    return list

lst = parseAllFileFromRep("samples")
lstQ = createListOfArea(lst, ritter)

drawnPlot("quality of ritter on samples test", lstQ)
