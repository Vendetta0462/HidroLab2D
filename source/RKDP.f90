!===================================================
! This is the subroutine of the integration method: 
! Runge-Kutta Dormant Prince
!===================================================

subroutine RKDP

  use arrays
  use global_numbers


  implicit none

  ! Definimos los parámetros
  integer, parameter :: nstages = 7
  
  real(kind=8) :: error_now, tolerance, dt_temp
  integer :: k
  real(kind=8), allocatable, dimension(:,:,:) :: u_high, u_low

  ! Definamos la tabla de Butcher (en este caso será 4(5))
  real(kind=8), parameter :: a2 = 1.0/5.0, a3 = 3.0/10.0, a4 = 4.0/5.0,&
       a5 = 8.0/9.0, a6 = 1.0, a7 = 1.0
  real(kind=8), parameter :: b21 = 1.0/5.0
  real(kind=8), parameter :: b31 = 3.0/40.0, b32 = 9.0/40.0
  real(kind=8), parameter :: b41 = 44.0/45.0, b42 = -56.0/15.0, b43 = 32.0/9.0
  real(kind=8), parameter :: b51 = 19372.0/6561.0, b52 = -25360.0/2187.0,&
       b53 = 64448.0/6561.0, b54 = -212.0/729.0
  real(kind=8), parameter :: b61 = 9017.0/3168.0, b62 = -355.0/33.0,&
       b63 = 46732.0/5247.0, b64 = 49.0/176.0, b65 = -5103.0/18656.0
  real(kind=8), parameter :: b71 = 35.0/384.0, b72 = 0.0, b73 = 500.0/1113.0,&
       b74 = 125.0/192.0, b75 = -2187.0/6784.0, b76 = 11.0/84.0
  real(kind=8), parameter :: c1 = 35.0/384.0, c3 = 500.0/1113.0,&
       c4 = 125.0/192.0, c5 = -2187.0/6784.0, c6 = 11.0/84.0
  real(kind=8), parameter :: e1 = 5179.0/57600.0, e3 = 7571.0/16695.0, &
       e4 = 393.0/640.0, e5 = -92097.0/339200.0, &
       e6 = 187.0/2100.0, e7 = 1.0/40.0

  ! Tolerancia del error
  tolerance = 1.0e-7

  ! Guardar el estado actual
  u_p = u

  ! Allocate
  allocate(u_high(1:nvars, 0:Nr, 0:Nr))
  allocate(u_low(1:nvars, 0:Nr, 0:Nr))


  do k=1,7

     ! Llamamos la right-hand side en cada paso para calcular el estado actual
     call rhs

     ! Calculamos u para cada k según los coeficientes de la tabla de butcher
     if (k.eq.1) then

        k1_u = rhs_u
        dt_temp = b21*dt
        u = u_p + dt_temp * k1_u

     else if (k.eq.2) then

        dt_temp = dt
        k2_u = rhs_u
        u = u_p + dt_temp*(b31 * k1_u + b32 * k2_u)

     else if (k.eq.3) then       

        dt_temp = dt
        k3_u = rhs_u
        u = u_p + dt_temp*(b41 * k1_u + b42 * k2_u + b43 * k3_u)


     else if (k.eq.4) then

        dt_temp = dt
        k4_u = rhs_u
        u = u_p + dt_temp*(b51 * k1_u + b52 * k2_u + b53 * k3_u + b54 * k4_u)


     else if (k.eq.5) then

        dt_temp = dt
        k5_u = rhs_u
        u = u_p + dt_temp* (b61 * k1_u + b62 * k2_u + b63 * k3_u + b64 * k4_u + b65 * k5_u)


     else if (k.eq.6) then

        dt_temp = dt

        k6_u = rhs_u
        
        u = u_p + dt_temp*(b71 * k1_u + b72 * k2_u + b73 * k3_u + b74 * k4_u + b75 * k5_u + b76 * k6_u)

     else if (k.eq.7) then

        dt_temp = dt

        k7_u = rhs_u

        !Calculamos las soluciones de cuarto y quinto orden
        
        u_low = u_p + dt_temp*(c1 * k1_u + c3 * k3_u + c4 * k4_u + c5 * k5_u + c6 * k6_u)

        u_high = u_p + dt_temp*(e1 * k1_u + e3 * k3_u + e4 * k4_u + e5 * k5_u + e6 * k6_u + e7*k7_u)
        
     end if
     
     call BC
  end do


  if (ctrl.eq.1) then
     ! Estimamos el error
     error_now = maxval(abs(u_high - u_low))

     ! Ajustamos el paso de tiempo según el error que obtuvimos

     if (error_now>tolerance) then   ! Si el error es mayor que la tolerancia lo aumentamos
        dt_temp = safety * dt* (tolerance/error_now)**0.2
        dt = max(min(dt_temp,dt_courant), min_dt)

     else                            ! Si el error no supera el umbral de tolerancia lo disminuimos 
        dt_temp = safety * dt * (tolerance/error_now)**0.2
        dt = min(dt_temp, dt_courant)     
  end if

     
  end if
end subroutine RKDP