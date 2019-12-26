import os
from random import random
from math import pi, cos, sin

from Parsing import *
from Crypto.Random.random import *

def parseAllFileFromRep(rep):
    list = os.listdir(rep)
    for i in range(len(list)):
        list[i] = parsePoint(rep + "/" + list[i])

    return list

cpdef list randomList(algo, nb):
    return [algo() for _ in range(nb)]

cpdef list randomCercle(int nbPoint):
    xMax = 800
    yMax = 600
    difMax = (int)(min(xMax/2, yMax/2) * 0.9)
    cdef list lst = list()

    for _ in range(nbPoint):
        dist = randint(0, difMax)
        rad = random() * pi * 2
        lst.append(Point(xMax/2 + dist*cos(rad), yMax/2 + dist*sin(rad)))

    return lst

cpdef list randomRectangle(int nbPoint):
    xMax = 800
    yMax = 600

    cdef list lst = list()

    for _ in range(nbPoint):
        lst.append(Point(randint((int)(xMax*0.1), (int)(xMax*0.9)), randint((int)(yMax*0.1), (int)(yMax*0.9))))

    return lst