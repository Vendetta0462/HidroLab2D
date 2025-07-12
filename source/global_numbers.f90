 
module global_numbers

  ! Grid Variables
  real(kind=8) rmin, rmax
  real(kind=8) dr 
  real(kind=8) t, dt, courant, dt_courant
  integer Nr, Nt 
  integer every_0D, every_1D
  integer res_num

  
  integer nvars

  ! Boundary Conditions
  character(len=10) :: bconditions

  ! Integrators
  character(len=5) :: integrator
  character(len=5) :: approx_method

  !Parameters to compute the CPU time
  real (kind=8) cpu_it
  real (kind=8) cpu_ft
  real (kind=8) cpu_t

  ! Variables de control del error RKDP
  real(kind=8) error
  real(kind=8) safety
  integer ctrl ! Para activar y desactivar el paso adaptativo
  real(kind=8) min_dt ! Límites de paso en RKDP
  real(kind=8) max_dt

  ! Variables for NavierStokes
  real(kind=8) :: r_0
  real(kind=8) :: gamma = 5.0/3.0
  real(kind=8) :: grav = 9.8d0
  real(kind=8) :: rho_0_L, rho_0_R      
  real(kind=8) :: u_0_L, u_0_R  
  real(kind=8) :: w_0_L, w_0_R      
  real(kind=8) :: p_0_L, p_0_R          
  ! real(kind=8) :: E_0_L, E_0_R          
  ! real(kind=8) :: a_0_L, a_0_R 



end module global_numbers