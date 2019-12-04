from tkinter import Tk, Canvas
from Parsing import *

lst = parsePoint("LittleTest/1.txt")

root = Tk()
canvas = Canvas(root, background="white")

canvas.config(width=800, height=600)

python_green = "#476042"
for p in lst:
    x1, y1 = (p.x - 1), (p.y - 1)
    x2, y2 = (p.x + 1), (p.y + 1)
    canvas.create_oval(x1, y1, x2, y2, fill=python_green)
    print(p)

canvas.grid()
root.mainloop()