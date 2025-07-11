
subroutine check_parameters

  use arrays
  use global_numbers

  implicit none


  if ((integrator.ne.'RK2').and. &
       (integrator.ne.'RK3').and. &
       (integrator.ne.'RK4') .and. &
       (integrator.ne. 'RKDP')) then
     print *, '================================================================================'
     print *, 'The integrator you selected --->',integrator,'<--- is not available'
     print *, '================================================================================'
     stop
  end if
  
       if ((approx_method.ne.'FV')) then
     print *, '================================================================================'
     print *, 'The approximation method you selected --->',approx_method,'<--- is not available'
     print *, '================================================================================'
     stop
  end if
  if ((bconditions.ne.'Periodical').and. &
       (bconditions.ne.'Neumann')) then
     print *, '================================================================================'
     print *, 'The boundary condition you selected --->',bconditions,'<--- is not available'
     print *, '================================================================================'
     stop
  end if


end subroutine check_parameters
