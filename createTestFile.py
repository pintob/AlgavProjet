import os

from ListOfPointGenerator import randomCercle, randomRectangle

name = ""


def createTest(algo, name):
    if not os.path.exists(name):
        os.makedirs(name)

    for i in range(1664):
        file = open(name+"/"+"file"+str(i)+".points", "w")
        lst = algo(255 + i%100)
        for p in lst:
            file.write(str((int)(p.x)) + " " + str((int)(p.y)) + '\n')

        file.close()

# createTest(randomCercle, "randomCercle")
createTest(randomRectangle, "randomRectangle")



