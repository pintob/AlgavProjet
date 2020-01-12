from copy import deepcopy
from random import randint

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
        if maxY[(int)(p.x)] is None or p.y > maxY[(int)(p.x)].y:
            maxY[(int)(p.x)] = p
        if minY[(int)(p.x)] is None or p.y < minY[(int)(p.x)].y:
            minY[(int)(p.x)] = p

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
    cdef int i = 1
    cdef object p # @Point
    cdef object q # @Point
    cdef object r # @Point

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
    cdef list p = enveloppeConvexe(points)
    cdef int n = len(p)
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
    def randomCercle(list points):
        cdef int x = randint(0, len(points) - 1)
        cdef int y = randint(0, len(points) - 1)

        while(x == y):
            y = randint(0, len(points) - 1)

        return createCercleFromPoint(points[x], points[y])

    def extendsCercle(c, n):
        cdef float d = c.center.distance(n)
        cdef float alpha = (c.radius/d)

        cdef float x = (c.center.x - n.x)
        cdef float y = (c.center.y - n.y)

        cdef float px = c.center.x + x * alpha
        cdef float py = c.center.y + y * alpha

        cdef object nP = Point(px, py)
        return createCercleFromPoint(nP, n)

    cdef object cercle = None
    cercle = randomCercle(points)

    for point in points:
        if not cercle.contain(point):
            cercle = extendsCercle(cercle, point)

    return cercle

# def toussain(list points, isConvexe = False):
#     HorizontalVector = Point(0, 1)
#     VerticalVector = Point(1, 0)
#
#     def convertRightIntoRectangle(list rights):
#         return [intersection(rights[0], rights[1]), intersection(rights[1], rights[2]),
#                       intersection(rights[2], rights[3]), intersection(rights[3], rights[0])]
#
#     def getExtremPoints(list points):
#         def getExtremPoint(list points, compar):
#             cdef int extrem = 0
#             for i in range(1, len(points)):
#                 if compar(points[extrem], points[i]):
#                     extrem = i
#
#             return extrem
#          # East, North, Ouest, South
#         return [
#             getExtremPoint(points, lambda p1, p2: p1.x < p2.x),
#             getExtremPoint(points, lambda p1, p2: p1.y < p2.y),
#             getExtremPoint(points, lambda p1, p2: p1.x > p2.x),
#             getExtremPoint(points, lambda p1, p2: p1.y > p2.y)
#         ]
#
#     def convertIndexIntoPoint(list index, list points):
#         return [points[i] for i in index]
#
#     def createInitaleRectangeFromExtremPoint(list points, list extrem):
#         cdef list rights = [
#             Right(points[extrem[0]], points[extrem[0]] + HorizontalVector),
#             Right(points[extrem[1]], points[extrem[1]] + VerticalVector),
#             Right(points[extrem[2]], points[extrem[2]] + HorizontalVector),
#             Right(points[extrem[3]], points[extrem[3]] + VerticalVector)
#         ]
#         return  convertRightIntoRectangle(rights), rights
#
#     def incArrayForIndex(list array, int n):
#         return list(map(lambda x: (x+1)%n, array))
#
#     def boxing(lst1, lst2):
#         assert (len(lst1) == len(lst2))
#         return [(lst1[i], lst2[i]) for i in range(len(lst1))]
#
#     def rotateRights(list rigths, float theta):
#         for r in rigths:
#             r.rotate(theta)
#
#     def getMinAngle(list r1, list r2):
#         assert (len(r1) == len(r2))
#         minimum = angle(r1[0], r2[0])
#         print("0:", minimum)
#         for i in range(1, len(r1)):
#             tmp = angle(r1[i], r2[i])
#             print(i,":",tmp)
#             if tmp < minimum:
#                 minimum = tmp
#         return minimum
#
#     def rightsFromPoints(list p1, list p2):
#         cdef list acc = list()
#         for a, b in boxing(p1, p2):
#             acc.append(Right(a, b))
#
#         return acc
#
#     if not isConvexe:
#         points = enveloppeConvexe(points)
#
#     e = getExtremPoints(points)
#     p, right = createInitaleRectangeFromExtremPoint(points, e)
#
#     for _ in range(5):
#         e1 = incArrayForIndex(e, len(points))
#         env = convertIndexIntoPoint(e, points)
#         env1 = convertIndexIntoPoint(e1, points)
#         alpha = getMinAngle(right, rightsFromPoints(env, env1))
#         print(alpha)
#
#         newRight = [r.clone() for r in right] #deepcopy
#         rotateRights(newRight, alpha)
#         np = convertRightIntoRectangle(newRight)
#
#         print(p, np)
#         e = e1 #inc index
#         right = newRight #rotation
#         if polygonArea(p) > polygonArea(np):
#             p = np
#
#     return p



def toussain(list points, isConvex=False):

    def intersection(start0, dir0, start1, dir1):
        dd = dir0.x*dir1.y-dir0.y*dir1.x
        dx = start1.x-start0.x
        dy = start1.y-start0.y
        t = (dx*dir1.y-dy*dir1.x)/dd
        return Point(start0.x+t*dir0.x, start0.y+t*dir0.y)

    def majRect(BestObb, bestObbArea, leftStart,
                leftDir, rightStart, rightDir, topStart, topDir, bottomStart, bottomDir):

        obbUpperLeft = intersection(leftStart, leftDir, topStart, topDir)
        obbUpperRight = intersection(rightStart, rightDir, topStart, topDir)
        obbBottomLeft = intersection(bottomStart, bottomDir, leftStart, leftDir)
        obbBottomRight = intersection(bottomStart, bottomDir, rightStart, rightDir)

        obbArea = polygonArea([obbUpperLeft, obbBottomLeft, obbBottomRight, obbUpperRight])

        if obbArea < bestObbArea:
            BestObb = [obbUpperLeft, obbBottomLeft, obbBottomRight, obbUpperRight]
            bestObbArea = obbArea

        return BestObb, bestObbArea

    ###################### MAIN #######################

    if not isConvex:
        points = enveloppeConvexe(points)

    cdef list edgeDirs = [None for _ in points]
    # cdef list BestObb = list()
    # cdef float bestObbArea = float("inf")

    for i in range(len(points)):
        edgeDirs[i] = points[(i+1)%len(points)] - points[i]
        edgeDirs[i].normalize()

    minPt = Point(float("Inf"), float("Inf"))
    maxPt = Point(-float("Inf"), -float("Inf"))
    cdef object leftIdx = None, rightIdx = None, topIdx = None, bottomIdx = None

    for i in range(len(points)):
        pt = points[i]
        if (pt.x < minPt.x):
            minPt.x = pt.x
            leftIdx = i

        if (pt.x > maxPt.x):
            maxPt.x = pt.x
            rightIdx = i

        if (pt.y < minPt.y):
            minPt.y = pt.y
            bottomIdx = i

        if (pt.y > maxPt.y):
            maxPt.y = pt.y
            topIdx = i

    leftDir = Point(0, -1)
    rightDir = Point(0, 1)
    topDir = Point(-1, 0)
    bottomDir = Point(1, 0)

    BestObb = [
        Point(minPt.x, minPt.y),
        Point(minPt.x, maxPt.y),
        Point(maxPt.x, maxPt.y),
        Point(maxPt.x, minPt.y)
        ]
    bestObbArea = polygonArea(BestObb)

    for i in range(len(points)):
        phis = [
            math.acos(leftDir.dot(edgeDirs[leftIdx])),
            math.acos(rightDir.dot(edgeDirs[rightIdx])),
            math.acos(topDir.dot(edgeDirs[topIdx])),
            math.acos(bottomDir.dot(edgeDirs[bottomIdx]))
        ]

        m = min(phis)

        if phis[0] == m:
            leftDir = edgeDirs[leftIdx].clone()
            rightDir = leftDir.clone()
            rightDir.negate()
            topDir = leftDir.orthogonal()
            bottomDir = topDir.clone()
            bottomDir.negate()
            leftIdx = (leftIdx+1)%len(points)
        elif phis[1] == m:
            rightDir = edgeDirs[rightIdx].clone()
            leftDir = rightDir.clone()
            leftDir.negate()
            topDir = leftDir.orthogonal()
            bottomDir = topDir.clone()
            bottomDir.negate()
            rightIdx = (rightIdx+1)%len(points)
        elif phis[2] == m:
            topDir = edgeDirs[topIdx].clone()
            bottomDir = topDir.clone()
            bottomDir.negate()
            leftDir = bottomDir.orthogonal()
            rightDir = leftDir.clone()
            rightDir.negate()
            topIdx = (topIdx+1)%len(points)
        elif phis[3] == m:
            bottomDir = edgeDirs[bottomIdx].clone()
            topDir = bottomDir.clone()
            topDir.negate()
            leftDir = bottomDir.orthogonal()
            rightDir = leftDir.clone()
            rightDir.negate()
            bottomIdx = (bottomIdx+1)%len(points)
        else:
            raise RuntimeError()


            majRect(BestObb, bestObbArea, points[leftIdx], leftDir,
                                       points[rightIdx], rightDir, points[topIdx], topDir,
                                       points[bottomIdx], bottomDir)

    return BestObb