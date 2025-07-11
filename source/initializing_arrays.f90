
  subroutine initializing_arrays
 
  use arrays
  use global_numbers

  implicit none 


 ! --------------- arrays for grid ---------------------

   x  = 0.0d0
   y  = 0.0d0

 ! --------------- arrays for wave  -------------------- 
   
   primi = 0.0d0
   u     = 0.0d0
   u_p   = 0.0d0
   rhs_u = 0.0d0
   Flux_x= 0.0d0
   Flux_y= 0.0d0
   
  
   
  end subroutine initializing_arrays
