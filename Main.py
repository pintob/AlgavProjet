from Parsing import *
#
# lst = parsePoint("LittleTest/1.txt")
#
# print(lst)
from Point import *

lst = list()

lst.append(Point(0, 0))
lst.append(Point(0, 1))
lst.append(Point(1, 1))
lst.append(Point(1, 0))

print(polygonArea(lst))