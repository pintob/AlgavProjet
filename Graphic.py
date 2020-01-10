from tkinter import Tk, Canvas
from Algo import *
from Cercle import Cercle
from ListOfPointGenerator import randomCercle, randomRectangle

class GUI(object):
    def __init__(self):
        self.root = Tk()
        self.canvas = Canvas(self.root, background="white")
        self.canvas.config(width=800, height=600)

    def updateDisplay(self):
        self.canvas.grid()
        self.root.mainloop()

    def displayPoint(self, lst, color='red'):
        for p in lst:
            x1, y1 = (p.x - 2), (p.y - 2)
            x2, y2 = (p.x + 2), (p.y + 2)
            self.canvas.create_oval(x1, y1, x2, y2, fill=color, outline=color)

    def displayLine(self, p1, p2, color='green'):
        self.canvas.create_line(p1.x, p1.y, p2.x, p2.y, fill=color)

    def displayCercle(self, cercle, color="black"):
        self.canvas.create_oval(cercle.center.x - cercle.radius,
                           cercle.center.y - cercle.radius,
                           cercle.center.x + cercle.radius,
                           cercle.center.y + cercle.radius, outline = color)

    def displayPolygone(self, lst):
        for i in range(0, len(lst)-1):
            self.displayLine(lst[i], lst[i+1], 'blue')
        self.displayLine(lst[0], lst[-1], 'blue')

lst = randomRectangle(500)

gui = GUI()

res = toussain(lst)
p = enveloppeConvexe(lst)

gui.displayPoint(lst)
gui.displayPolygone(res)
gui.displayPolygone(p)

gui.updateDisplay()