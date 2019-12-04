import math

cdef class Point(object):
    cpdef public int x
    cpdef public int y

    def __init__(self, int _x, int _y):
        self.x = _x
        self.y = _y

    cdef float distance(self, point):
        return math.sqrt((self.x - point.x)**2 + (self.y - point.y)**2 )

    def __repr__(self):
        return '('+ str(self.x) + ', ' + str(self.y) + ')'

    def __str__(self):
        return self.__repr__()