
subroutine evolve

  use arrays
  use global_numbers

  implicit none

  integer l

  call allocate
  call initializing_arrays
  call grid
  call Info_Screen

  t = 0.0d0

  print *,'----------------------------'
  print *,'|  Time step  |    Time    |'
  print *,'----------------------------'
  write(*,"(A5,I6,A6,ES9.2,A3)") ' |   ',0,'    | ',t,'  |'
  print *,'cpu time = ',cpu_t-cpu_it,'secs'

  call initial

  call save2Ddata_x(u(1,:,:),'rho',0)
  ! call save2Ddata_x(u(2,:,:),'mx',0)
  ! call save2Ddata_x(u(3,:,:),'my',0)
  ! call save2Ddata_x(u(4,:,:),'E',0)

  ! call save2Ddata_x(primi(2,:,:),'vx',0)
  ! call save2Ddata_x(primi(3,:,:),'vy',0)
  call save2Ddata_x(primi(4,:,:),'P',0)

  call save0Ddata_x(dt,'dt', 0)
  
  ! ****************************************************************
  ! ****************************************************************
  ! ******************      Integration Loop        ****************
  ! ****************************************************************
  ! ****************************************************************

!stop

  do l=1,Nt
     t = t + dt

     if (mod(l,every_1D).eq.0) then
        call cpu_time(cpu_t)
        write(*,"(A5,I6,A6,ES9.2,A3)") ' |   ',l,'    | ',t,'  |'
        print *,'cpu time = ',cpu_t-cpu_it,'secs'
     end if

     if (integrator.eq.'RKDP') then  
        call RKDP
     else
        print*, 'The integrator has not been implemented yet'
        stop
     end if

     ! calculamos las nuevas variables primitivas
     primi(1,:,:) = u(1,:,:)
     primi(2,:,:) = u(2,:,:)/u(1,:,:)
     primi(3,:,:) = u(3,:,:)/u(1,:,:)
     primi(4,:,:) = (gamma-1)*(u(4,:,:)-1/2.0*(u(2,:,:)**2 + u(3,:,:)**2)/u(1,:,:))

     ! call exact 

     if (mod(l,every_0D).eq.0) then
         call save0Ddata_x(dt,'dt', 1)
     end if

     if (mod(l,every_1D).eq.0) then
        call save2Ddata_x(u(1,:,:),'rho',1)
        ! call save22Ddata_x(u(2,:,:),'mx',1)
        ! call save2Ddata_x(u(3,:,:),'my',1)
        ! call save2Ddata_x(u(4,:,:),'E',1)

        ! call save2Ddata_x(primi(2,:,:),'vx',1)
        ! call save2Ddata_x(primi(3,:,:),'vy',1)
        call save2Ddata_x(primi(4,:,:),'P',1)
     end if

     ! Calculamos el Courant advectivo y elegimos el mínimo
     if (approx_method.eq.'FV') then
      dt_courant = courant * dr / max(maxval(primi(2,:,:)), maxval(primi(3,:,:)))
      dt = min(dt_courant,dt)
     end if
  end do

end subroutine evolve

