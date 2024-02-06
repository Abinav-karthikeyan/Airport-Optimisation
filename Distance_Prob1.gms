$title Unit Allocation

 Sets
 i        Demand Zones                      /Perth,Dundee/
 j        Distribution Center               /Gourock, Bathgate, Dunfermline, Edinburgh, Portlethen/
 ;
  

 
  ;
           

Parameter h_(i) Unit Shipping cost per mile;
           h_(i)= 3 ;
           
Parameter dem(i)  'Demand in demand zones' / Perth 600, Dundee 600 /;

Parameter cap(j)  'Supply at distribution centers' / Gourock 150, Bathgate 150, Dunfermline 100, Edinburgh 200, Portlethen 400 /;

Table dist(i,j) clearance cost per passenger of class i in period t ($)
             Gourock        Bathgate    Dunfermline  Edinburgh  Portlethen  
  Perth      106             58           28.2        43.8       76.3
  Dundee     114             70           41.5        63         61
   
Scalar penalty 'Penalty for unmet demand' / 500 /;

Scalar shippingcost /3/;

Positive Variables
   x(i,j)  'Amount of goods shipped from distribution centers to demand zones';

Variables
   totalCost 'Total cost, including penalties for unmet demand';

Equations
   supplyConstraint(j)  'Supply constraint at distribution centers'
   costObjective        'Objective function to minimize total cost';
   Unmet_diff(i)

supplyConstraint(j)..
   sum(i, x(i,j)) =l= cap(j);

costObjective..
   totalCost =e= sum((i,j), h_(i) * x(i,j) * dist(i,j)) + sum(i, penalty *(dem(i) - sum(j, x(i,j))));
   
Unmet_diff(i)..  sum(i,X(i,j))- dem(i) 

Model transport /all/;

Solve transport using LP minimizing totalCost;

Display x.l, totalCost.l;
    
  