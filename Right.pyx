from Point import Point

cdef class Right(object):
    cpdef public zero
    cpdef public vector

    def __init__(self, p1, p2):
        self.zero = p1.clone()
        self.vector = Point(p2.x - p1.x, p2.y - p1.y)

    cpdef void rotate(self, float theta):
        self.vector.rotate(theta)

    def __repr__(self):
        return self.zero.__repr__() + '(' + str(self.x) + ", " + str(self.y) + ')'

    def __str__(self):
        return self.__repr__()

    cpdef clone(self):
        return Right(self.zero.clone(), self.vector.clone())


cpdef intersection(Right r1, Right r2):
    
    return None



