from random import randint

from Cercle import createCercleFromPoint
from Point import *
from Right import intersection, Right

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

def toussain(list points):
  def calculAirRectangle(list rights):
    """trouve les intersection des  droites """

    cdef object p1 = intersection(rights[0],rights[1])
    cdef object p2 = intersection(rights[1],rights[2])
    cdef object p3 = intersection(rights[2],rights[3])
    cdef object p4 = intersection(rights [3],rights[0])
    """calcul de  l'air """
    return p1.distance(p2)*p3.distance(p4)

  def creeRectangleBase(list points):
    """ on chercher les points d'abssice et ordonné extréme """
    cdef object abmin = points[0]
    cdef object ormin = points[0]
    cdef object abmax = points[0]
    cdef object ormax = points[0]
    for point in points :
      if abmin.x>point.x :
        abmin = point
      else :
        if abmax.x<point.x:
          abmax = point
      if ormin.y> point.y:
        ormin = point
      else :
        if ormax.y<point.y :
          ormax = point

    return[Right(ormin,Point(ormin.x+1,ormin.y)),
		Right(abmax,Point(abmax.x,abmax.y+1)),
		Right(ormax,Point(ormax.x+1,ormax.y)),
		Right(abmin,Point(abmin.x,abmin.y+1))]

  def trouverAngleMin(list pointsConv,list pointsRec):
    cdef float alpha = -10
    """ pour chaque point de la liste pointConv """
    cdef float delta = -10
    for i in (range(len(pointsConv)-1)):
      """ on itere sur la list pointRec """

      for id in range(len(pointsRec)):
        delta =angle(pointsConv[i],pointsConv[(i+1)%(len(pointsConv))],Point(1,1),(pointsRec[id].vector))

        """ On test si alpha doit être actualiser """
        if (alpha>delta or alpha==-10) :
          alpha = delta

    return alpha

  def rotationRectangle(list rights,alpha):
    cdef object temp = [None] * 4

    for i in range(len(rights)):
      rights[i].rotate(alpha)
      temp[i]=rights[i]

    return temp

  cdef object rec = None
  cdef object recTempo = None
  rec = creeRectangleBase(points)
  for i in (range(len(points))):

    recTempo =rotationRectangle(rec,(trouverAngleMin([points[i],points[(i+1)%len(points)]],rec)))
    if calculAirRectangle(rec)>calculAirRectangle(recTempo):
      rec=recTempo

  print(rec)
  rec = [intersection(rec[0], rec[1]), intersection(rec[1], rec[2]),
         intersection(rec[2], rec[3]), intersection(rec[3], rec[0])]
  return rec