
  subroutine allocate

  use arrays
  use global_numbers 

  implicit none

  allocate( x(0:Nr))
  allocate( y(0:Nr))

  ! Vector
  allocate(primi(1:nvars,0:Nr,0:Nr))
  allocate(    u(1:nvars,0:Nr,0:Nr))
  allocate(  u_p(1:nvars,0:Nr,0:Nr))
  allocate(rhs_u(1:nvars,0:Nr,0:Nr))
  allocate(Flux_x(1:nvars,0:Nr-1,0:Nr-2))
  allocate(Flux_y(1:nvars,0:Nr-2,0:Nr-1))
    
 

 ! ----- arrays for RKDP ------------
  allocate(k1_u(1:nvars,0:Nr,0:Nr))
  allocate(k2_u(1:nvars,0:Nr,0:Nr))
  allocate(k3_u(1:nvars,0:Nr,0:Nr))
  allocate(k4_u(1:nvars,0:Nr,0:Nr))
  allocate(k5_u(1:nvars,0:Nr,0:Nr))
  allocate(k6_u(1:nvars,0:Nr,0:Nr))
  allocate(k7_u(1:nvars,0:Nr,0:Nr))


  end subroutine allocate 