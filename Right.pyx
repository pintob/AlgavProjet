cdef class Right(object):
    cpdef public float a
    cpdef public float b

    def __init__(self, p1, p2):
        #todo
        self.a = 10.123465
        self.b = 20.897654


    def __repr__(self):
        return "{0:.2f}x+{1:.2f}".format(self.a, self.b)

    def __str__(self):
        return self.__repr__()