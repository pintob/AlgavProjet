from Point import Point

cpdef list parsePoint(path):
    cdef lst = list()

    try:
        with open(path, "r") as file:
            for line in file.readlines():
                temp = line.split(' ')
                p = Point(int(temp[0]), int(temp[1][:-1]))
                lst.append(p)
            file.close()
    except IOError:
        print(path + " unreadable")
        lst.append(Point(100, 100))
        lst.append(Point(100, 200))
        lst.append(Point(200, 100))
        lst.append(Point(200, 200))
    return lst