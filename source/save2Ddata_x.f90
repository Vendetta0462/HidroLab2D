
  subroutine save2Ddata_x(fval,base_name,first_index)

    use arrays
    use global_numbers

    implicit none

    character(len=20) filestatus
    logical firstcall
    data firstcall / .true. /
    save firstcall

    character(len=*), intent(IN) :: base_name
    real(kind=8), dimension(0:Nr,0:Nr), intent(IN) :: fval

    character(len=256) :: filename
    integer i,j,l,first_index

    ! Crear nombre de archivo basado en res_num
    write(filename, '(A,A,I0,A)') base_name, '_', res_num, '.xl'

    filename = 'results/' // filename

    if (first_index.eq.0) then
       filestatus = 'replace'
    else
       filestatus = 'old'
    end if

    
    if (filestatus=='replace') then
      open(1,file=filename,status=filestatus)
    else
      open(1,file=filename,status=filestatus,position='append')
    end if

    ! Escribir header con información del tiempo
    write(1,'(A,ES26.18)') '# Time = ', t
    
    ! Solo escribir las dimensiones y posiciones en el primer paso de tiempo
    if (first_index.eq.0) then
      write(1,'(A,I6,A,I6)') '# Nr = ', Nr
      write(1,'(A)',advance='no') '# x positions: '
      do i=0,Nr,2**(res_num-1)
        write(1,'(ES14.6)',advance='no') x(i)
        write(1,'(A1)',advance='no') ' '
      end do
      write(1,*)
      
      write(1,'(A)',advance='no') '# y positions: '
      do j=0,Nr,2**(res_num-1)
        write(1,'(ES14.6)',advance='no') y(j)
        write(1,'(A1)',advance='no') ' '
      end do
      write(1,*)
    end if

    ! Escribir los datos 2D
    ! Cada fila corresponde a un valor fijo de y
    do j=0,Nr,2**(res_num-1)
      do i=0,Nr,2**(res_num-1)
        write(1,'(ES26.18)',advance='no') fval(i,j)
        if (i < Nr) write(1,'(A1)',advance='no') ' '
      end do
      write(1,*)
    end do
    
    ! Línea en blanco para separar bloques de tiempo
    write(1,*)

    close(1)

  end subroutine save2Ddata_x

