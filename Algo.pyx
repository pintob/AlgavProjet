from Crypto.Random.random import randint

from Cercle import createCercleFromPoint
from Point import *

cpdef float quality(float polygonArea, float sndArea):
    """
    :param polygonArea: area of the convex polygone
    :param sndArea: area of the other algorithm
    :return: float: a positive float representing the quality of the sndArea: 0 is perfect 
    """
    return (sndArea / polygonArea) - 1


cpdef list pixelSort(points):
    if len(points) < 4:
        return points
    cdef int maxX = points[0].x
    for p in points:
        if p.x > maxX:
            maxX = p.x
    maxY = [None] * (1 + maxX)
    minY = [None] * (1 + maxX)
    for p in points:
        if maxY[p.x] is None or p.y > maxY[p.x].y:
            maxY[p.x] = p
        if minY[p.x] is None or p.y < minY[p.x].y:
            minY[p.x] = p

    cdef list result = list()
    for i in range(maxX+1):
        if maxY[i] is not None:
            result.append(maxY[i])
    for i in range(maxX, -1, -1):
        if (minY[i] is not None) and (result[len(result) - 1] != minY[i]):
            result.append(minY[i])

    if result[-1] == result[0]:
        result.pop()

    return result

cpdef list enveloppeConvexe(points):
    if len(points) < 4:
        return points

    cdef list result = pixelSort(points)
    i = 1
    while i < len(result) + 2:
        p = result[(i - 1)%len(result)]
        q = result[i%len(result)]
        r = result[(i+1)%len(result)]
        if crossProduct(p, q, p, r) > 0:
            result.pop(i % len(result))
            if i == 2:
                i = 1
            if i > 2:
                i-=2
        i+=1

    return result

cpdef float distance(p, a, b):
    return abs(crossProduct(a, b, a, p))

cpdef list calculPairesAntipodales(points):
    p = enveloppeConvexe(points)
    n = len(p)
    cdef list antipodales = list()
    cdef k = 1
    while (distance(p[k], p[n - 1], p[0]) < distance(p[(k + 1) % n], p[n - 1], p[0])):
        k+=1

    cdef int i = 0
    cdef int j = k

    while (i <= k and j < n):
        while (distance(p[j], p[i], p[i + 1]) < distance(p[(j + 1) % n], p[i], p[i + 1])) and j < n - 1:
            antipodales.append([p[i], p[j]])
            j+=1

        antipodales.append([p[i], p[j]])
        i+=1
    return antipodales

def ritter(list points):
    def get2RandomPoint(list points):
        cdef int x = randint(0, len(points) - 1)
        cdef int y = randint(0, len(points) - 1)
        while(x == y):
            y = randint(0, len(points))

        return (points[x], points[y])

    def extendsCercle(p1, p2, n):
        c = centerPoint(p1, p2)
        d = c.distance(n)
        alpha = ((c.distance(p2))/d)

        x = (c.x - n.x)
        y = (c.y - n.y)

        px = c.x + x * alpha
        py = c.y + y * alpha

        nP = Point(px, py)
        return createCercleFromPoint(nP, n), nP, n

    cdef object cercle = None
    cdef object p1 = None
    cdef object p2 = None

    p1, p2 = get2RandomPoint(points)
    cercle = createCercleFromPoint(p1,  p2)

    for point in points:
        if not cercle.contain(point):
            cercle, p1, p2 = extendsCercle(p1, p2, point)

    return cercle