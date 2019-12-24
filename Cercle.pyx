from Point import Point, centerPoint

cdef class Cercle(object):
    cpdef public center
    cpdef public float radius

    def __init__(self, center, radius):
        self.center = center.clone()
        self.radius = radius

    cpdef contain(self, point):
        return self.center.distance(point) < self.radius

    def __repr__(self):
        return str(self.center) + ', ' + str(self.radius)

    def __str__(self):
        return self.__repr__()

cpdef createCercleFromPoint(p1, p2):
    return Cercle(centerPoint(p1, p2), (p1.distance(p2))/2)


