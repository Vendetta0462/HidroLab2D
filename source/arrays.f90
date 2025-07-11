
  module arrays

  implicit none

  ! --------------- arrays for grid ---------------------
  
  real(kind=8), allocatable, dimension (:) :: x
  real(kind=8), allocatable, dimension (:) :: y

  ! --------------- arrays for hydro --------------------

  ! Vector
  real(kind=8), allocatable, dimension (:,:,:) :: primi
  real(kind=8), allocatable, dimension (:,:,:) :: u
  real(kind=8), allocatable, dimension (:,:,:) :: u_p
  real(kind=8), allocatable, dimension (:,:,:) :: rhs_u
  real(kind=8), allocatable, dimension (:,:,:) :: Flux_x
  real(kind=8), allocatable, dimension (:,:,:) :: Flux_y

  ! --------------- arrays for RKDP --------------------

  real(kind=8), allocatable, dimension (:,:,:) :: k1_u
  real(kind=8), allocatable, dimension (:,:,:) :: k2_u
  real(kind=8), allocatable, dimension (:,:,:) :: k3_u
  real(kind=8), allocatable, dimension (:,:,:) :: k4_u
  real(kind=8), allocatable, dimension (:,:,:) :: k5_u
  real(kind=8), allocatable, dimension (:,:,:) :: k6_u
  real(kind=8), allocatable, dimension (:,:,:) :: k7_u

    

  end module arrays
