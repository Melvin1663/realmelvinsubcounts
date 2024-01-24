import tkinter as tk
from time import time
 
clicks = []
 
def click():
    now = time()
    print(now)
    clicks.append(now)
 
    start_time = now - 1
 
    while clicks and clicks[0] < start_time:
        clicks.pop(0)
 
    # if len(clicks) > 1:
        # print(len(clicks)/(clicks[-1] - clicks[0]))
    # else:
        # print(1)
 
root = tk.Tk()
 
tk.Button(root, text='Click', command=click).pack(padx=5, pady=5)
 
tk.mainloop()