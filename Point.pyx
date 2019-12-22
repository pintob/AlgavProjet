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

cpdef float polygonArea(list lst):
    """
    
    :param lst: list of Point (convex polygon)
    :return: float: the area of the polygon
    """
    cpdef float acc1 = 0
    cpdef float acc2 = 0

    for i in range(len(lst)-1):
        acc1 += lst[i].x * lst[i+1].y
        acc2 += lst[i+1].x * lst[i].y

    acc1 += lst[-1].x * lst[0].y
    acc2 += lst[0].x * lst[-1].y

    return abs((1/2.) * (acc1 - acc2))