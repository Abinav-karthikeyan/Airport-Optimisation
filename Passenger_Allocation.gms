$title Passenger Allocation Problem


 Sets
 i         classes                         /Schengen*NonSchengen/
 t         periods                         /slot1*slot6/
 ;
 
 Alias(t,tt); 

 Table c(i,t) unit cost per product i in period t ($)
             slot1          slot2       slot3       slot4  slot5  slot6
  Schengen   0.80          0.42        0.42         0.42  0.42   0.80
  NonSchengen   1             1           1          0.8  0.8     1
   

  ;
           

 Parameter h_(i) unit backlogging penalty cost per passenger i;
           h_(i)=10;
        

 Table d(i,t) Number of Arrivals for passenger class i in period t (i : {Schengen.Non-Schengen})

               slot1        slot2       slot3       slot4  slot5  slot6
  Schengen      158          65          199        91     124    104
  NonSchengen   117          165         74         221    168    90
  
  ;

 Parameter cap(t) Handling capacity of period t (passengers);
 
           cap('slot1') = 245;
           cap('slot2') = 245;
           cap('slot3') = 270;
           cap('slot4') = 320;
           cap('slot5') = 300;
           cap('slot6') = 245;


 Parameter bigM(i) big number;
  bigM(i) = sum(t,d(i,t));
  

 Variables
  x(i,t)         Number of Passengers of class i cleared in slot t
  I_(i,t)        Backlogging of Passengers of type i in period t
  of             Objective function value (Cost)

 Positive variables x, I_ The constraint here is that there should ideally be no backlog after slot 6;
 
 I_.up(i,'slot6')=0;  
 


 Equations
  obj_func,
  inv_balance,
  regular_cap,
  setup
  ;

  obj_func..         OF =E= sum((i,t),c(i,t)*X(i,t)+ h_(i)*I_(i,t));
  inv_balance(i,t)..      x(i,t) + I_(i,t) =e= d(i,t) +I_(i,t-1);
  regular_cap(t)..        sum(i,x(i,t)) =l= cap(t);


 Model Passenger_Allocation
  /
  obj_func,
  inv_balance,
  regular_cap,
  /;


 Solve Passenger_Allocation using MIP minimizing of;
 Display x.l, x.m, of.l,of.m;





