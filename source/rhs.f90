
subroutine rhs

  use arrays
  use global_numbers
  

  implicit none

  integer i, j, k

  real(kind=8), dimension(1:2) :: rho_L, u_L, w_L, p_L, E_L, a_L
  real(kind=8), dimension(1:2) :: rho_R, u_R, w_R, p_R, E_R, a_R
  real(kind=8) :: a,b,c,d
  real(kind=8) :: sigma
  real(kind=8), dimension(1:nvars, 0:Nr, 0:Nr) :: src

  real(kind=8), dimension (1:nvars,1:2) :: u_before, u_after !(1 en x, 2 en y)
  ! real(kind=8), dimension (1:nvars) :: u_after
  real(kind=8), dimension (1:nvars,1:2) :: f_left, f_right
  real(kind=8), dimension(1:2) :: s_left, s_right



  
      if (approx_method.eq.'FV') then
      do i = 0, Nr-1
         do k = 0, Nr-1
            do j=1,nvars
               if ((i.eq.0).OR.(i.eq.(Nr-1)).OR.(k.eq.0).OR.(k.eq.(Nr-1))) then
                  u_before(j,1) = u(j,i,k+1)
                  u_before(j,2) = u(j,i+1,k)

                  u_after(j,1) = u(j,i+1,k+1)
                  u_after(j,2) = u(j,i+1,k+1)

               else
                     ! Slopes en x
                     a = (u(j,i,k+1)-u(j,i-1,k+1))
                     b = (u(j,i+1,k+1)-u(j,i,k+1))
                     ! Slopes en y 
                     c = (u(j,i+1,k)-u(j,i+1,k-1))
                     d = (u(j,i+1,k+1)-u(j,i+1,k))

                     u_before(j,1) = u(j,i,k+1) + sigma(a,b)/2.0
                     u_before(j,2) = u(j,i+1,k) + sigma(c,d)/2.0
                     u_after(j,1) = u(j,i+1,k+1) - sigma(a,b)/2.0
                     u_after(j,2) = u(j,i+1,k+1) - sigma(c,d)/2.0
               end if
            end do
         
            
            ! Left state
            rho_L = u_before(1,:)
            u_L = u_before(2,:)/ u_before(1,:) ! Velocidad x
            w_L = u_before(3,:)/ u_before(1,:) ! Velocidad y
            E_L = u_before(4,:)
            p_L = (gamma-1)*(u_before(4,:)-1/2.0*(u_before(2,:)**2 + u_before(3,:)**2)/u_before(1,:))  ! Presión
            a_L = sqrt(gamma*p_L(:)/rho_L(:))  ! Velocidad del sonido

            ! Right state
            rho_R = u_after(1,:)
            u_R = u_after(2,:)/ u_after(1,:)
            w_R = u_after(3,:)/ u_after(1,:)
            E_R = u_after(4,:)
            p_R = (gamma-1)*(u_after(4,:)-1/2.0*(u_after(2,:)**2 + u_after(3,:)**2)/u_after(1,:))  
            a_R = sqrt(gamma*p_R(:)/rho_R(:))
            
            ! Ecuación de masa (j=1)
            f_left(1,1) = rho_L(1) * u_L(1)
            f_left(1,2) = rho_L(2) * w_L(2)
            f_right(1,1) = rho_R(1) * u_R(1)
            f_right(1,2) = rho_R(2) * w_R(2)

            ! Ecuación de momento x (j=2)
            f_left(2,1) = rho_L(1) * u_L(1)**2 + p_L(1)
            f_left(2,2) = rho_L(2) * u_L(2) * w_L(2)
            f_right(2,1) = rho_R(1) * u_R(1)**2 + p_R(1)
            f_right(2,2) = rho_R(2) * u_R(2) * w_R(2)

            ! Ecuación de momento y (j=3)
            f_left(3,1) = rho_L(1) * u_L(1) * w_L(1)
            f_left(3,2) = rho_L(2) * w_L(2)**2 + p_L(2)
            f_right(3,1) = rho_R(1) * u_R(1) * w_R(1)
            f_right(3,2) = rho_R(2) * w_R(2)**2 + p_R(2)

            ! Ecuación de energía (j=4)
            f_left(4,1) = u_L(1) * (E_L(1) + p_L(1))
            f_left(4,2) = w_L(2) * (E_L(2) + p_L(2))
            f_right(4,1) = u_R(1) * (E_R(1) + p_R(1))
            f_right(4,2) = w_R(2) * (E_R(2) + p_R(2))

            ! if (t.le.0.001) then
            !    print *, "i=", i, "Flujo masa:", f_left(1), "Flujo momento:", f_left(2), "Flujo energía:", f_left(3)
            ! end if

            s_left(1)  = min(u_L(1) - a_L(1), w_L(1) - a_L(1), u_R(1) - a_R(1), w_R(1) - a_R(1), 0.0d0)
            s_right(1) = max(u_L(1) + a_L(1), w_L(1) + a_L(1), u_R(1) + a_R(1), w_R(1) + a_R(1), 0.0d0)
            s_left(2)  = min(u_L(2) - a_L(2), w_L(2) - a_L(2), u_R(2) - a_R(2), w_R(2) - a_R(2), 0.0d0)
            s_right(2) = max(u_L(2) + a_L(2), w_L(2) + a_L(2), u_R(2) + a_R(2), w_R(2) + a_R(2), 0.0d0)

            ! Flujo numérico (HLL)
            do j = 1, nvars
              if (k.le.Nr-2) then
               Flux_x(j,i,k) = (s_right(1)*f_left(j,1) - s_left(1)*f_right(j,1) + s_left(1)*s_right(1)&
                                 *(u_after(j,1)-u_before(j,1))) / (s_right(1) - s_left(1))
              end if
              if (i.le.Nr-2) then
               Flux_y(j,i,k) = (s_right(2)*f_left(j,2) - s_left(2)*f_right(j,2) + s_left(2)*s_right(2)&
                                 *(u_after(j,2)-u_before(j,2))) / (s_right(2) - s_left(2))
              end if
            end do
         end do
      end do

      ! Término fuente gravitacional

      src(1,:,:) = 0.0d0
      src(2,:,:) = 0.0d0
      src(3,:,:) = - u(1,:,:)*grav
      src(4,:,:) = - u(3,:,:)*grav


      ! Actualización del residuo
      do j = 1, nvars
          do i = 1, Nr-1
            do k = 1, Nr-1
               rhs_u(j,i,k) = -(Flux_x(j,i,k-1) - Flux_x(j,i-1,k-1))/dr - (Flux_y(j,i-1,k) - Flux_y(j,i-1,k-1))/dr + src(j,i,k)
            end do
          end do
      end do
      !print*, Flux_x(j,20,20-1)
   end if

end subroutine rhs

real(kind=8) Function sigma(a,b) RESULT(val)
   real(kind=8) :: a,b
   if ((a.ge.0).AND.(b.ge.0)) then
      val = min(a,b)
   else if ((a.le.0).AND.(b.le.0)) then
      val = max(a,b)
   else
      val = 0
   end if
end Function sigma