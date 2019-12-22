from matplotlib import pyplot

def drawnPlot(name, lst):
    absc = list(range(len(lst)))
    pyplot.plot(absc, lst, label = name)
    pyplot.legend(loc="upper right")
    pyplot.show()

