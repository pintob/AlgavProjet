from tkinter import Tk, Canvas
import time
from Algo import *
from ListOfPointGenerator import randomCercle, randomRectangle
from Parsing import *
from Cercle import *

def chrono(fonction, arg):
    startTime = time.time()
    res = fonction(arg)
    finalTime = time.time() - startTime
    finalTime *= 1000
    return (res, finalTime)


def displayPoint(lst, canvas, color='red'):
    for p in lst:
        x1, y1 = (p.x - 2), (p.y - 2)
        x2, y2 = (p.x + 2), (p.y + 2)
        canvas.create_oval(x1, y1, x2, y2, fill=color, outline=color)

def displayLine(p1, p2, canvas, color = 'green'):
    canvas.create_line(p1.x, p1.y, p2.x, p2.y, fill=color)

def displayCercle(cercle, canvas):
    canvas.create_oval(cercle.center.x - cercle.radius,
                       cercle.center.y - cercle.radius,
                       cercle.center.x + cercle.radius,
                       cercle.center.y + cercle.radius)


def displayPolygone(lst, canvas):
    for i in range(0, len(lst)-1):
        displayLine(lst[i], lst[i+1], canvas, color='blue')
    displayLine(lst[0], lst[-1], canvas, color='blue')

lst = randomRectangle(500)

root = Tk()
canvas = Canvas(root, background="white")
canvas.config(width=800, height=600)
from Parsing import parsePoint

for p in lst:
    displayPoint(lst, canvas)

res = ritter(lst)

displayCercle(res, canvas)


canvas.grid()
root.mainloop()