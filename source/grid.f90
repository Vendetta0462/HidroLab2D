
subroutine grid

  use arrays
  use global_numbers

  implicit none

  integer i

  dr  = ( rmax - rmin ) / dble(Nr)

  do i=0,Nr
           x(i)  = rmin + dble(i) * dr
           y(i)  = rmin + dble(i) * dr
  end do

  dt_courant = 1.0/2.0 * courant * dr**2
  dt = dt_courant

end subroutine grid
