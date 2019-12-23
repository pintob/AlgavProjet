from Right import *
from Point import *

p1 = Point(5, 5)

for _ in range(4):
    p1.rotate(math.pi/2)
    print(p1)