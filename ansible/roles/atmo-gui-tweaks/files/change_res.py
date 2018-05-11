#!/usr/bin/python
from Tkinter import *
from subprocess import PIPE, Popen, call

def change_res(res):
   call(("/usr/bin/xrandr -s %s" % res).split(), stdout=PIPE)
   selection = "\nYour new resolution is " + res
   text.config(text = selection)

def get_res():
    xrandr_lines = Popen("/usr/bin/xrandr", stdout=PIPE).communicate()[0].split("\n")
    for line in xrandr_lines:
        if '*' in line:
            return ''.join(line.split()[1:4])

resolutions = [
        "1024x700",
        "1024x768",
        "1200x740",
        "1280x800",
        "1280x960",
        "1280x1024",
        "1600x1000",
        "1600x1200",
        "1680x1050",
        "1920x1080",
        "1920x1200",
        "3200x1000",
        "3200x1200",
        "3360x1050"
        ]

# Create window
window = Tk()
window.title("Change Desktop Resolution")

# Create label
label_var = StringVar()
label = Label(window, textvariable = label_var)
label_var.set("Select desired desktop resolution\n")
label.pack()

# Get current resolution
cur_res = get_res()

var = StringVar(window)
var.set(cur_res)

text = Label(window)
menu = OptionMenu(window, var, *resolutions, command=change_res)

menu.pack()
text.pack()
window.mainloop()
