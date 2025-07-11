
subroutine BC

  use arrays
  use global_numbers

  implicit none

  integer j

! Nodos en los extremos
  ! u(1,0) = 0.0d0
  ! u(2,0) = 0.0d0

  ! u(1,Nr) = 0.0d0
  ! u(2,Nr) = 0.0d0

  ! selección de condiciones de frontera
  if (bconditions.eq.'Periodical') then
  ! Condición periódica
    do j = 1,nvars
      !x=0
      u(j,0,:) = u(j,Nr-1,:)
      !y=0
      u(j,:,0) = u(j,:,Nr-1)
      !x=Nr
      u(j,Nr,:) = u(j,1,:)
      !y=Nr
      u(j,:,Nr) = u(j,:,1)
    end do
  else if (bconditions.eq.'Neumann') then
  ! Condiciones Neumann Homogeneas
    do j = 1,nvars
      !x=0
      u(j,0,:) = u(j,1,:)
      !y=0
      u(j,:,0) = u(j,:,1)
      !x=Nr
      u(j,Nr,:) = u(j,Nr-1,:)
      !y=Nr
      u(j,:,Nr) = u(j,:,Nr-1)
    end do
  end if
end subroutine BC