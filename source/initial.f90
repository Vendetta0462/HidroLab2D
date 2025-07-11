
subroutine initial

  use arrays
  use global_numbers

  implicit none

  !--------------------------------------------------------------
  ! Perturbación sinusoidal en el eje vertical

  integer i, j
  real(kind=8) :: pi

  ! Parámetros para las interfaces sinusoidales
  real(kind=8) :: delta, amplitude, wavelength, k_wave
  real(kind=8) :: y_lower, y_upper
  pi = 4.0d0*atan(1.0d0)
  ! Definir parámetros de las interfaces
  delta = 0.2       ! Separación media entre interfaces (ajusta según tu dominio)
  amplitude = 0.06    ! Amplitud de la sinusoide (ajusta según necesites)
  wavelength = 0.5   ! Longitud de onda (ajusta según tu dominio en x)
  k_wave = 2.0 * pi / wavelength  ! Número de onda

  ! Bucle principal con interfaces sinusoidales
  do i = 0, Nr
    do j = 0, Nr  ! Asumiendo que j es el índice en dirección x
      
      ! Calcular las posiciones de las interfaces sinusoidales
      y_lower = -delta + amplitude * sin(k_wave * (y(j) + wavelength/2.0) + pi)  ! Interface inferior
      y_upper = +delta + amplitude * sin(k_wave * (y(j) + wavelength/2.0))  ! Interface superior
      
      ! Asignar propiedades según la región
      if (x(i).le.y_lower) then
          ! Región inferior: fluido menos denso
          primi(2,i,j) = u_0_R      ! Velocidad u
          primi(3,i,j) = w_0_R      ! Velocidad w  
          primi(4,i,j) = p_0_R      ! Presión
          primi(1,i,j) = rho_0_R    ! Densidad baja
          
      else if ((x(i).ge.y_lower).and.(x(i).le.y_upper)) then
          ! Región central: fluido denso (río)
          primi(1,i,j) = rho_0_L    ! Densidad alta
          primi(2,i,j) = u_0_L      ! Velocidad u
          primi(3,i,j) = w_0_L      ! Velocidad w
          primi(4,i,j) = p_0_L      ! Presión
      else if (x(i).ge.y_upper) then
          ! Región superior: fluido menos denso
          primi(1,i,j) = rho_0_R    ! Densidad baja
          primi(2,i,j) = u_0_R      ! Velocidad u
          primi(3,i,j) = w_0_R      ! Velocidad w
          primi(4,i,j) = p_0_R      ! Presión

      end if
    end do
  end do

  u(1,:,:) = primi(1,:,:)
  u(2,:,:) = primi(2,:,:)*primi(1,:,:)
  u(3,:,:) = primi(3,:,:)*primi(1,:,:)
  u(4,:,:) = (primi(2,:,:)**2 + primi(3,:,:)**2)*primi(1,:,:)/2.0d0 + primi(4,:,:)/(gamma-1)

end subroutine initial







