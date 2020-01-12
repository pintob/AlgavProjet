import math

cdef class Point(object):
    cpdef public float x
    cpdef public float y

    def __init__(self, x, y):
        self.x = x
        self.y = y

    cpdef float distance(self, point):
        return math.sqrt(self.squareDist(point))

    cpdef float squareDist(self, point):
        return (self.x - point.x) * (self.x - point.x) + (self.y - point.y) * (self.y - point.y)

    cpdef float dot(self, point):
        return self.x * point.x + self.y * point.y

    cpdef negate(self):
        self.x = -self.x
        self.y = -self.y

    cpdef orthogonal(self):
        return Point(self.y, -self.x)

    def __repr__(self):
        return '('+ str(self.x) + ', ' + str(self.y) + ')'

    def __str__(self):
        return self.__repr__()

    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)

    cpdef normalize(self):
        l = math.sqrt(self.x * self.x + self.y * self.y)
        self.x /= l
        self.y /= l

    cpdef clone(self):
        return Point(self.x, self.y)

    cpdef void rotate(self, float theta):
        cdef float x, y
        x = self.x * math.cos(theta) - self.y * math.sin(theta)
        y = self.x * math.sin(theta) + self.y * math.cos(theta)

        self.x = x
        self.y = y

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


cpdef Point centerPoint(Point p1, Point p2):
    return Point((p1.x + p2.x)/2, (p1.y + p2.y)/2)

cpdef float dotProduct(p, q, s, t):
    return ((q.x - p.x) * (t.x - s.x) + (q.y - p.y) * (t.y - s.y))

cpdef float crossProduct(p, q, s, t):
    return ((q.x - p.x) * (t.y - s.y) - (q.y - p.y) * (t.x - s.x))
