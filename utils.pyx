import time
from math import sqrt

cpdef float chrono(function, arg):
    startTime = time.time()
    res = function(arg)
    finalTime = time.time() - startTime
    finalTime *= 1000
    return finalTime

cpdef list generateListOfPoint(generator, absc):
    cdef int m = absc[-1]
    cdef int x = (int)(sqrt(m))
    allElem = generator(m, x, x*2) # the last element of absc is the maximum
    return [allElem[0:i] for i in absc]

cpdef list generateListOfTime(points, algo):
    return [chrono(algo, point) for point in points]