import time


cpdef float chrono(function, arg):
    startTime = time.time()
    res = function(arg)
    finalTime = time.time() - startTime
    finalTime *= 1000
    return finalTime

cpdef list generateListOfPoint(generator, absc):
    return [generator(i) for i in absc]

cpdef list generateListOfTime(points, algo):
    return [chrono(algo, point) for point in points]