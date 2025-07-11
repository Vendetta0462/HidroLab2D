
  subroutine save0Ddata_x(fval, base_name,first_index)

  use arrays
  use global_numbers

  implicit none

  character(len=20) filestatus
  logical firstcall
  data firstcall / .true. /
  save firstcall

  character(len=*), intent(IN) :: base_name
  real(kind=8), intent(IN) :: fval

  character(len=256) :: filename

  integer i,j,l,first_index, auxcounter,after,before

  if (res_num.eq.1) then
    filename = base_name // '_1.xl'
  else if (res_num.eq.2) then
    filename = base_name // '_2.xl'
  else if (res_num.eq.3) then
    filename = base_name // '_3.xl'
  else if (res_num.eq.4) then
    filename = base_name // '_4.xl'
  else if (res_num.eq.5) then
    filename = base_name // '_5.xl'
  end if

  filename = 'results/' // filename

  if (first_index.eq.0) then
     filestatus = 'replace'
  else
     filestatus = 'old'
  end if

  
  if (filestatus=='replace') then
    ! Escribir la primera fila con los titulos
    open(1,file=filename,status=filestatus)
    write(1,'(A26, A2, A26)') 'Time', '', base_name
  else
     open(1,file=filename,status=filestatus,position='append')
  end if

  

  ! Escribir cada fila con el paso, el tiempo y el valor
  write(1,'(ES26.18, A2, ES26.18)') t, '', fval

  close(1)

  end subroutine save0Ddata_x

