from tkinter import Tk, Canvas

from Algo import *
from Parsing import *

def displayPoint(lst, canvas, color='red'):
    for p in lst:
        x1, y1 = (p.x - 2), (p.y - 2)
        x2, y2 = (p.x + 2), (p.y + 2)
        canvas.create_oval(x1, y1, x2, y2, fill=color, outline=color)

def displayLine(p1, p2, canvas, color = 'green'):
    canvas.create_line(p1.x, p1.y, p2.x, p2.y, fill=color)

def displayPolygone(lst, canvas):
    for i in range(0, len(lst)-1):
        displayLine(lst[i], lst[i+1], canvas, color='blue')
    displayLine(lst[0], lst[-1], canvas, color='blue')

lst = parsePoint("LittleTest/1.txt")

root = Tk()
canvas = Canvas(root, background="white")
canvas.config(width=800, height=600)

displayPoint(lst, canvas)


res = calculPairesAntipodales(lst)


for p1, p2 in res:
    displayLine(p1, p2, canvas)

res = enveloppeConvexe(lst)

displayPolygone(res, canvas)

canvas.grid()
root.mainloop()