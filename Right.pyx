import math

from Point import Point, dotProduct

cdef class Right(object):
    cpdef public zero
    cpdef public vector

    def __init__(self, p1, p2):
        self.zero = p1.clone()
        self.vector = Point(p2.x - p1.x, p2.y - p1.y)

    cpdef void rotate(self, float theta):
        self.vector.rotate(theta)

    def __repr__(self):
        return self.zero.__repr__() + '(' + str(self.vector.x) + ", " + str(self.vector.y) + ')'

    def __str__(self):
        return self.__repr__()

    cpdef clone(self):
        return Right(self.zero, self.vector + self.zero)


# cpdef intersection(Right r1, Right r2):
#     cdef object pRes = Point(r2.zero.x-r1.zero.x,r2.zero.y-r1.zero.y)
#     cdef float uvRes = (r1.vector.x*r2.vector.y)-(r2.vector.x*r1.vector.y)
#     cdef float qp_vRes =(pRes.x*r2.vector.y)-(pRes.y*r2.vector.x)
#     cdef object intersc = Point((r1.zero.x+((qp_vRes/uvRes)*r1.vector.x)),
#     (r1.zero.y+((qp_vRes/uvRes)*r1.vector.y)))
#
#     return intersc

cpdef float angle(p, q, s, t):

    if (p == q or s == t):
        return float("infinity")
    cdef cosTheta = dotProduct(p, q, s, t) /  (p.distance(q) * s.distance(t));
    return math.acos(cosTheta)



