
from ortools.sat.python import cp_model

# Cannot have more than 100 backlogs at a time!!

def main():
    
    # Creates the model.
    #Uses a CPSAT Solver 
    
    model = cp_model.CpModel()

    # Creates the variables.
    
    
# Decision Variables (u,v,w,z,y,z) indicate allocations of passengers for automatic scanners (Schengnen class).

    u = model.NewIntVar(58, 500, "u")
    v = model.NewIntVar(0, 500, "v")
    w = model.NewIntVar(0, 500 , "w")
    x = model.NewIntVar(0, 500, "x")
    y = model.NewIntVar(0, 500, "y")
    z = model.NewIntVar(0, 500, "z")
    
# Decision Variables (u1,v1,w1,x1,y1,z1) indicate allocations of passengers for automatic scanners (Non Schengnen class).

    u1 = model.NewIntVar(17, 500, "u1")
    v1 = model.NewIntVar(0, 500, "v1")
    w1 = model.NewIntVar(0, 500 , "w1")
    x1 = model.NewIntVar(0, 500, "x1")
    y1 = model.NewIntVar(0, 500, "y1")
    z1 = model.NewIntVar(0, 500, "z1")

# Constrains are based on the backlog limit of 100.

    model.Add(u>58)
    mode.Add(u+v>123)
    model.Add(u + v +w >=272)
    model.Add(u + v + w+ x > 363)
    model.Add(u + v + w + x + y >537)
    model.Add(u + v + w + x + y + z >=841)

# Additional constraints if we transform the problem to be capacity restricted, with capacities on each slots being:

# Slot-1 125
# Slot-2 150
# Slot-3 150
# Slot-4 150
# Slot-5 150
# Slot-6 125


# model.Add(u<=125)

# model.Add(u + v<=275)

# model.Add(u + v +w <=425)

# model.Add(u + v + w+ x <=575)

# model.Add(u + v + w + x + y <=725)

# model.Add(u + v + w + x + y + z <=850)

    
    


#  All these are constraints for the capacities that the manual personnel can handle.



    
    model.Add(u1>17)

    
    
    model.Add(u1 + v1 > 182)
    
    model.Add(u1 + v1 +w1 >256)

    model.Add(u1 + v1 + w1 + x1 >=477)
    
    model.Add(u1 + v1 + w1 + x1 + y1 >645)

    model.Add(u1 + v1 + w1 + x1 + y1 + z1 >=835)
    
    
# Additional constraints if we transform the problem to be capacity restricted, with capacities on each slots being:

# Slot-1 120
# Slot-2 120
# Slot-3 120
# Slot-4 180
# Slot-5 180
# Slot-6 120

    # model.Add(u1<=120)
    
    # model.Add(u1 + v1<=240)
    
    # model.Add(u1 + v1+w1<=360)
    
    # model.Add(u1 + v1+w1+x1<=540)
    
    # model.Add(u1 + v1 + w1 + x1 + y1<=720)
    
    # model.Add(u1 + v1 + w1 + x1 + y1 + z1<=840)
    
# Objective Function: 
# The costs come from the per passenger clearance cost and added backlog cost. Our objective is to minimise this based on the above constraints.
    
    model.Minimize(0.4526* u + 0.4746 * v + 0.466 * w + 0.4574 * x + 0.4888 * y + 0.4794 * z + 0.65 * u1 + 0.625 * v1 + 0.6 * w1 + 0.575 * x1 + 0.55 * y1 + 0.525 * z1 - 306.76)

    # Creates a solver and solves the model.
    solver = cp_model.CpSolver()
    status = solver.Solve(model)

    if status == cp_model.OPTIMAL or status == cp_model.FEASIBLE:
        print(f"Minimum of objective function: {solver.ObjectiveValue()}\n")
        print(f"u = {solver.Value(u)}")
        print(f"v = {solver.Value(v)}")
        print(f"w = {solver.Value(w)}")
        print(f"x = {solver.Value(x)}")
        print(f"y = {solver.Value(y)}")
        print(f"z = {solver.Value(z)}")

        print(f"u1 = {solver.Value(u1)}")
        print(f"v1 = {solver.Value(v1)}")
        print(f"w1 = {solver.Value(w1)}")
        print(f"x1 = {solver.Value(x1)}")
        print(f"y1= {solver.Value(y1)}")
        print(f"z1 = {solver.Value(z1)}")

    else:
        print("No solution found.")

    # Statistics.
    print("\nStatistics")
    print(f"  status   : {solver.StatusName(status)}")
    print(f"  conflicts: {solver.NumConflicts()}")
    print(f"  branches : {solver.NumBranches()}")
    print(f"  wall time: {solver.WallTime()} s")


if __name__ == "__main__":
    main()