!> @file wall_fluxes.f90
!------------------------------------------------------------------------------!
! This file is part of PALM.
!
! PALM is free software: you can redistribute it and/or modify it under the
! terms of the GNU General Public License as published by the Free Software
! Foundation, either version 3 of the License, or (at your option) any later
! version.
!
! PALM is distributed in the hope that it will be useful, but WITHOUT ANY
! WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
! A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License along with
! PALM. If not, see <http://www.gnu.org/licenses/>.
!
! Copyright 1997-2016 Leibniz Universitaet Hannover
!------------------------------------------------------------------------------!
!
! Current revisions:
! -----------------
! 
! 
! Former revisions:
! -----------------
! $Id: wall_fluxes.f90 2001 2016-08-20 18:41:22Z knoop $
!
! 2000 2016-08-20 18:09:15Z knoop
! Forced header and separation lines into 80 columns
! 
! 1873 2016-04-18 14:50:06Z maronga
! Module renamed (removed _mod)
! 
! 
! 1850 2016-04-08 13:29:27Z maronga
! Module renamed
! 
! 
! 1691 2015-10-26 16:17:44Z maronga
! Renamed rif_min and rif_max with zeta_min and zeta_max, respectively.
! 
! 1682 2015-10-07 23:56:08Z knoop
! Code annotations made doxygen readable 
! 
! 1374 2014-04-25 12:55:07Z raasch
! pt removed from acc-present-list
! 
! 1353 2014-04-08 15:21:23Z heinze
! REAL constants provided with KIND-attribute
!
! 1320 2014-03-20 08:40:49Z raasch
! ONLY-attribute added to USE-statements,
! kind-parameters added to all INTEGER and REAL declaration statements, 
! kinds are defined in new module kinds, 
! old module precision_kind is removed,
! revision history before 2012 removed,
! comment fields (!:) to be used for variable explanations added to
! all variable declaration statements 
!
! 1257 2013-11-08 15:18:40Z raasch
! openacc loop and loop vector clauses removed
!
! 1153 2013-05-10 14:33:08Z raasch
! code adjustments of accelerator version required by PGI 12.3 / CUDA 5.0
!
! 1128 2013-04-12 06:19:32Z raasch
! loop index bounds in accelerator version replaced by i_left, i_right, j_south,
! j_north
!
! 1036 2012-10-22 13:43:42Z raasch
! code put under GPL (PALM 3.9)
!
! 1015 2012-09-27 09:23:24Z raasch
! accelerator version (*_acc) added
!
! Initial version (2007/03/07)
!
! Description:
! ------------
!> Calculates momentum fluxes at vertical walls assuming Monin-Obukhov
!> similarity.
!> Indices: usvs a=1, vsus b=1, wsvs c1=1, wsus c2=1 (other=0).
!> The all-gridpoint version of wall_fluxes_e is not used so far, because
!> it gives slightly different results from the ij-version for some unknown
!> reason.
!>
!> @todo Rename rif to zeta throughout the routine
!------------------------------------------------------------------------------!
 MODULE wall_fluxes_mod
 
    PRIVATE
    PUBLIC wall_fluxes, wall_fluxes_acc, wall_fluxes_e, wall_fluxes_e_acc
    
    INTERFACE wall_fluxes
       MODULE PROCEDURE wall_fluxes
       MODULE PROCEDURE wall_fluxes_ij
    END INTERFACE wall_fluxes
    
    INTERFACE wall_fluxes_acc
       MODULE PROCEDURE wall_fluxes_acc
    END INTERFACE wall_fluxes_acc

    INTERFACE wall_fluxes_e
       MODULE PROCEDURE wall_fluxes_e
       MODULE PROCEDURE wall_fluxes_e_ij
    END INTERFACE wall_fluxes_e
 
    INTERFACE wall_fluxes_e_acc
       MODULE PROCEDURE wall_fluxes_e_acc
    END INTERFACE wall_fluxes_e_acc

 CONTAINS

!------------------------------------------------------------------------------!
! Description:
! ------------
!> Call for all grid points
!------------------------------------------------------------------------------!
    SUBROUTINE wall_fluxes( wall_flux, a, b, c1, c2, nzb_uvw_inner,            &
                            nzb_uvw_outer, wall )

       USE arrays_3d,                                                          &
           ONLY:  rif_wall, u, v, w, z0, pt
       
       USE control_parameters,                                                 &
           ONLY:  g, kappa, zeta_max, zeta_min
       
       USE grid_variables,                                                     &
           ONLY:  dx, dy
       
       USE indices,                                                            &
           ONLY:  nxl, nxlg, nxr, nxrg, nyn, nyng, nys, nysg, nzb, nzt
       
       USE kinds
       
       USE statistics,                                                         &
           ONLY:  hom

       IMPLICIT NONE

       INTEGER(iwp) ::  i            !< 
       INTEGER(iwp) ::  j            !< 
       INTEGER(iwp) ::  k            !< 
       INTEGER(iwp) ::  wall_index   !< 

       INTEGER(iwp),                                                           &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             nzb_uvw_inner   !< 
       INTEGER(iwp),                                                           &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             nzb_uvw_outer   !< 
       
       REAL(wp) ::  a           !< 
       REAL(wp) ::  b           !< 
       REAL(wp) ::  c1          !< 
       REAL(wp) ::  c2          !< 
       REAL(wp) ::  h1          !< 
       REAL(wp) ::  h2          !< 
       REAL(wp) ::  zp          !< 
       REAL(wp) ::  pts         !< 
       REAL(wp) ::  pt_i        !< 
       REAL(wp) ::  rifs        !< 
       REAL(wp) ::  u_i         !< 
       REAL(wp) ::  v_i         !< 
       REAL(wp) ::  us_wall     !< 
       REAL(wp) ::  vel_total   !< 
       REAL(wp) ::  ws          !< 
       REAL(wp) ::  wspts       !< 

       REAL(wp),                                                               &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             wall   !< 
       
       REAL(wp),                                                               &
          DIMENSION(nzb:nzt+1,nys:nyn,nxl:nxr) ::                              &
             wall_flux   !< 


       zp         = 0.5_wp * ( (a+c1) * dy + (b+c2) * dx )
       wall_flux  = 0.0_wp
       wall_index = NINT( a+ 2*b + 3*c1 + 4*c2 )

       DO  i = nxl, nxr
          DO  j = nys, nyn

             IF ( wall(j,i) /= 0.0_wp )  THEN
!
!--             All subsequent variables are computed for the respective
!--             location where the respective flux is defined.
                DO  k = nzb_uvw_inner(j,i)+1, nzb_uvw_outer(j,i)

!
!--                (1) Compute rifs, u_i, v_i, ws, pt' and w'pt'
                   rifs  = rif_wall(k,j,i,wall_index)

                   u_i   = a * u(k,j,i) + c1 * 0.25_wp *                       &
                           ( u(k+1,j,i+1) + u(k+1,j,i) + u(k,j,i+1) + u(k,j,i) )

                   v_i   = b * v(k,j,i) + c2 * 0.25_wp *                       &
                           ( v(k+1,j+1,i) + v(k+1,j,i) + v(k,j+1,i) + v(k,j,i) )

                   ws    = ( c1 + c2 ) * w(k,j,i) + 0.25_wp * (                &
                     a * ( w(k-1,j,i-1) + w(k-1,j,i) + w(k,j,i-1) + w(k,j,i) ) &
                   + b * ( w(k-1,j-1,i) + w(k-1,j,i) + w(k,j-1,i) + w(k,j,i) ) &
                                                              )
                   pt_i  = 0.5_wp * ( pt(k,j,i) + a *  pt(k,j,i-1) +           &
                                   b * pt(k,j-1,i) + ( c1 + c2 ) * pt(k+1,j,i) )

                   pts   = pt_i - hom(k,1,4,0)
                   wspts = ws * pts

!
!--                (2) Compute wall-parallel absolute velocity vel_total
                   vel_total = SQRT( ws**2 + (a+c1) * u_i**2 + (b+c2) * v_i**2 )

!
!--                (3) Compute wall friction velocity us_wall
                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      us_wall = kappa * vel_total / ( LOG( zp / z0(j,i) ) +    &
                                         5.0_wp * rifs * ( zp - z0(j,i) ) / zp &
                                                    )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      us_wall = kappa * vel_total / (                          &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                    )
                   ENDIF

!
!--                (4) Compute zp/L (corresponds to neutral Richardson flux
!--                    number rifs)
                   rifs = -1.0_wp * zp * kappa * g * wspts /                   &
                          ( pt_i * ( us_wall**3 + 1E-30 ) )

!
!--                Limit the value range of the Richardson numbers.
!--                This is necessary for very small velocities (u,w --> 0),
!--                because the absolute value of rif can then become very
!--                large, which in consequence would result in very large
!--                shear stresses and very small momentum fluxes (both are
!--                generally unrealistic).
                   IF ( rifs < zeta_min )  rifs = zeta_min
                   IF ( rifs > zeta_max )  rifs = zeta_max

!
!--                (5) Compute wall_flux (u'v', v'u', w'v', or w'u')
                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      wall_flux(k,j,i) = kappa *                               &
                              ( a*u(k,j,i) + b*v(k,j,i) + (c1+c2)*w(k,j,i) ) / &
                              (  LOG( zp / z0(j,i) ) +                         &
                                 5.0_wp * rifs * ( zp - z0(j,i) ) / zp         &
                              )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      wall_flux(k,j,i) = kappa *                               &
                           ( a*u(k,j,i) + b*v(k,j,i) + (c1+c2)*w(k,j,i) ) / (  &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                                            )
                   ENDIF
                   wall_flux(k,j,i) = -wall_flux(k,j,i) * us_wall

!
!--                store rifs for next time step
                   rif_wall(k,j,i,wall_index) = rifs

                ENDDO

             ENDIF

          ENDDO
       ENDDO

    END SUBROUTINE wall_fluxes


!------------------------------------------------------------------------------!
! Description:
! ------------
!> Call for all grid points - accelerator version
!------------------------------------------------------------------------------!
    SUBROUTINE wall_fluxes_acc( wall_flux, a, b, c1, c2, nzb_uvw_inner,        &
                                nzb_uvw_outer, wall )

       USE arrays_3d,                                                          &
           ONLY:  rif_wall, pt, u, v, w, z0
       
       USE control_parameters,                                                 &
           ONLY:  g, kappa, zeta_max, zeta_min
       
       USE grid_variables,                                                     &
           ONLY:  dx, dy
       
       USE indices,                                                            &
           ONLY:  i_left, i_right, j_north, j_south, nxl, nxlg, nxr, nxrg,     &
                  nyn, nyng, nys, nysg, nzb, nzt
       
       USE kinds
       
       USE statistics,                                                         &
           ONLY:  hom

       IMPLICIT NONE

       INTEGER(iwp) ::  i            !< 
       INTEGER(iwp) ::  j            !< 
       INTEGER(iwp) ::  k            !< 
       INTEGER(iwp) ::  max_outer    !< 
       INTEGER(iwp) ::  min_inner    !< 
       INTEGER(iwp) ::  wall_index   !< 

       INTEGER(iwp),                                                           &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             nzb_uvw_inner   !< 
       INTEGER(iwp),                                                           &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             nzb_uvw_outer   !< 
       
       REAL(wp) ::  a           !< 
       REAL(wp) ::  b           !< 
       REAL(wp) ::  c1          !< 
       REAL(wp) ::  c2          !< 
       REAL(wp) ::  h1          !< 
       REAL(wp) ::  h2          !< 
       REAL(wp) ::  zp          !< 
       REAL(wp) ::  pts         !< 
       REAL(wp) ::  pt_i        !< 
       REAL(wp) ::  rifs        !< 
       REAL(wp) ::  u_i         !< 
       REAL(wp) ::  v_i         !< 
       REAL(wp) ::  us_wall     !< 
       REAL(wp) ::  vel_total   !< 
       REAL(wp) ::  ws          !< 
       REAL(wp) ::  wspts       !< 

       REAL(wp),                                                               &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             wall   !< 
       
       REAL(wp),                                                               &
          DIMENSION(nzb:nzt+1,nys:nyn,nxl:nxr) ::                              &
             wall_flux   !< 


       zp         = 0.5_wp * ( (a+c1) * dy + (b+c2) * dx )
       wall_flux  = 0.0_wp
       wall_index = NINT( a+ 2*b + 3*c1 + 4*c2 )

       min_inner = MINVAL( nzb_uvw_inner(nys:nyn,nxl:nxr) ) + 1
       max_outer = MINVAL( nzb_uvw_outer(nys:nyn,nxl:nxr) )

       !$acc kernels present( hom, nzb_uvw_inner, nzb_uvw_outer, pt, rif_wall ) &
       !$acc         present( u, v, w, wall, wall_flux, z0 )
       !$acc loop independent
       DO  i = i_left, i_right
          DO  j = j_south, j_north

             IF ( wall(j,i) /= 0.0_wp )  THEN
!
!--             All subsequent variables are computed for the respective
!--             location where the respective flux is defined.
                !$acc loop independent
                DO  k = nzb_uvw_inner(j,i)+1, nzb_uvw_outer(j,i)

!
!--                (1) Compute rifs, u_i, v_i, ws, pt' and w'pt'
                   rifs  = rif_wall(k,j,i,wall_index)

                   u_i   = a * u(k,j,i) + c1 * 0.25_wp *                       &
                           ( u(k+1,j,i+1) + u(k+1,j,i) + u(k,j,i+1) + u(k,j,i) )

                   v_i   = b * v(k,j,i) + c2 * 0.25_wp *                       &
                           ( v(k+1,j+1,i) + v(k+1,j,i) + v(k,j+1,i) + v(k,j,i) )

                   ws    = ( c1 + c2 ) * w(k,j,i) + 0.25_wp * (                &
                     a * ( w(k-1,j,i-1) + w(k-1,j,i) + w(k,j,i-1) + w(k,j,i) ) &
                   + b * ( w(k-1,j-1,i) + w(k-1,j,i) + w(k,j-1,i) + w(k,j,i) ) &
                                                              )
                   pt_i  = 0.5_wp * ( pt(k,j,i) + a *  pt(k,j,i-1) +           &
                                   b * pt(k,j-1,i) + ( c1 + c2 ) * pt(k+1,j,i) )

                   pts   = pt_i - hom(k,1,4,0)
                   wspts = ws * pts

!
!--                (2) Compute wall-parallel absolute velocity vel_total
                   vel_total = SQRT( ws**2 + (a+c1) * u_i**2 + (b+c2) * v_i**2 )

!
!--                (3) Compute wall friction velocity us_wall
                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      us_wall = kappa * vel_total / ( LOG( zp / z0(j,i) ) +    &
                                         5.0_wp * rifs * ( zp - z0(j,i) ) / zp &
                                                    )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      us_wall = kappa * vel_total / (                          &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                    )
                   ENDIF

!
!--                (4) Compute zp/L (corresponds to neutral Richardson flux
!--                    number rifs)
                   rifs = -1.0_wp * zp * kappa * g * wspts /                   &
                          ( pt_i * ( us_wall**3 + 1E-30 ) )

!
!--                Limit the value range of the Richardson numbers.
!--                This is necessary for very small velocities (u,w --> 0),
!--                because the absolute value of rif can then become very
!--                large, which in consequence would result in very large
!--                shear stresses and very small momentum fluxes (both are
!--                generally unrealistic).
                   IF ( rifs < zeta_min )  rifs = zeta_min
                   IF ( rifs > zeta_max )  rifs = zeta_max

!
!--                (5) Compute wall_flux (u'v', v'u', w'v', or w'u')
                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      wall_flux(k,j,i) = kappa *                               &
                              ( a*u(k,j,i) + b*v(k,j,i) + (c1+c2)*w(k,j,i) ) / &
                              (  LOG( zp / z0(j,i) ) +                         &
                                 5.0_wp * rifs * ( zp - z0(j,i) ) / zp         &
                              )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      wall_flux(k,j,i) = kappa *                               &
                           ( a*u(k,j,i) + b*v(k,j,i) + (c1+c2)*w(k,j,i) ) / (  &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                                            )
                   ENDIF
                   wall_flux(k,j,i) = -wall_flux(k,j,i) * us_wall

!
!--                store rifs for next time step
                   rif_wall(k,j,i,wall_index) = rifs

                ENDDO

             ENDIF

          ENDDO
       ENDDO
       !$acc end kernels

    END SUBROUTINE wall_fluxes_acc


!------------------------------------------------------------------------------!
! Description:
! ------------
!> Call for all grid point i,j
!------------------------------------------------------------------------------!
    SUBROUTINE wall_fluxes_ij( i, j, nzb_w, nzt_w, wall_flux, a, b, c1, c2 )

       USE arrays_3d,                                                          &
           ONLY:  rif_wall, pt, u, v, w, z0
       
       USE control_parameters,                                                 &
           ONLY:  g, kappa, zeta_max, zeta_min
       
       USE grid_variables,                                                     &
           ONLY:  dx, dy
       
       USE indices,                                                            &
           ONLY:  nzb, nzt
       
       USE kinds
       
       USE statistics,                                                         &
           ONLY:  hom

       IMPLICIT NONE

       INTEGER(iwp) ::  i            !< 
       INTEGER(iwp) ::  j            !< 
       INTEGER(iwp) ::  k            !< 
       INTEGER(iwp) ::  nzb_w        !< 
       INTEGER(iwp) ::  nzt_w        !< 
       INTEGER(iwp) ::  wall_index   !< 
       
       REAL(wp) ::  a           !< 
       REAL(wp) ::  b           !< 
       REAL(wp) ::  c1          !< 
       REAL(wp) ::  c2          !< 
       REAL(wp) ::  h1          !< 
       REAL(wp) ::  h2          !< 
       REAL(wp) ::  zp          !< 
       REAL(wp) ::  pts         !< 
       REAL(wp) ::  pt_i        !< 
       REAL(wp) ::  rifs        !< 
       REAL(wp) ::  u_i         !< 
       REAL(wp) ::  v_i         !< 
       REAL(wp) ::  us_wall     !< 
       REAL(wp) ::  vel_total   !< 
       REAL(wp) ::  ws          !< 
       REAL(wp) ::  wspts       !< 

       REAL(wp), DIMENSION(nzb:nzt+1) ::  wall_flux   !< 


       zp         = 0.5_wp * ( (a+c1) * dy + (b+c2) * dx )
       wall_flux  = 0.0_wp
       wall_index = NINT( a+ 2*b + 3*c1 + 4*c2 )

!
!--    All subsequent variables are computed for the respective location where 
!--    the respective flux is defined.
       DO  k = nzb_w, nzt_w

!
!--       (1) Compute rifs, u_i, v_i, ws, pt' and w'pt'
          rifs  = rif_wall(k,j,i,wall_index)

          u_i   = a * u(k,j,i) + c1 * 0.25_wp *                                &
                  ( u(k+1,j,i+1) + u(k+1,j,i) + u(k,j,i+1) + u(k,j,i) )

          v_i   = b * v(k,j,i) + c2 * 0.25_wp *                                &
                  ( v(k+1,j+1,i) + v(k+1,j,i) + v(k,j+1,i) + v(k,j,i) )

          ws    = ( c1 + c2 ) * w(k,j,i) + 0.25_wp * (                         &
                     a * ( w(k-1,j,i-1) + w(k-1,j,i) + w(k,j,i-1) + w(k,j,i) ) &
                   + b * ( w(k-1,j-1,i) + w(k-1,j,i) + w(k,j-1,i) + w(k,j,i) ) &
                                                     )
          pt_i  = 0.5_wp * ( pt(k,j,i) + a *  pt(k,j,i-1) + b * pt(k,j-1,i)    &
                          + ( c1 + c2 ) * pt(k+1,j,i) )

          pts   = pt_i - hom(k,1,4,0)
          wspts = ws * pts

!
!--       (2) Compute wall-parallel absolute velocity vel_total
          vel_total = SQRT( ws**2 + ( a+c1 ) * u_i**2 + ( b+c2 ) * v_i**2 )

!
!--       (3) Compute wall friction velocity us_wall
          IF ( rifs >= 0.0_wp )  THEN

!
!--          Stable stratification (and neutral)
             us_wall = kappa * vel_total / ( LOG( zp / z0(j,i) ) +             &
                                         5.0_wp * rifs * ( zp - z0(j,i) ) / zp &
                                           )
          ELSE

!
!--          Unstable stratification
             h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
             h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

             us_wall = kappa * vel_total / (                                   &
                  LOG( zp / z0(j,i) ) -                                        &
                  LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (             &
                       ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +         &
                       2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )                    &
                                           )
          ENDIF

!
!--       (4) Compute zp/L (corresponds to neutral Richardson flux number 
!--           rifs)
          rifs = -1.0_wp * zp * kappa * g * wspts /                            &
                  ( pt_i * (us_wall**3 + 1E-30) )

!
!--       Limit the value range of the Richardson numbers.
!--       This is necessary for very small velocities (u,w --> 0), because
!--       the absolute value of rif can then become very large, which in
!--       consequence would result in very large shear stresses and very
!--       small momentum fluxes (both are generally unrealistic).
          IF ( rifs < zeta_min )  rifs = zeta_min
          IF ( rifs > zeta_max )  rifs = zeta_max

!
!--       (5) Compute wall_flux (u'v', v'u', w'v', or w'u')
          IF ( rifs >= 0.0_wp )  THEN

!
!--          Stable stratification (and neutral)
             wall_flux(k) = kappa *                                            &
                            ( a*u(k,j,i) + b*v(k,j,i) + (c1+c2)*w(k,j,i) ) /   &
                            (  LOG( zp / z0(j,i) ) +                           &
                               5.0_wp * rifs * ( zp - z0(j,i) ) / zp           &
                            )
          ELSE

!
!--          Unstable stratification
             h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
             h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

             wall_flux(k) = kappa *                                            &
                  ( a*u(k,j,i) + b*v(k,j,i) + (c1+c2)*w(k,j,i) ) / (           &
                  LOG( zp / z0(j,i) ) -                                        &
                  LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (             &
                       ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +         &
                       2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )                    &
                                                                   )
          ENDIF
          wall_flux(k) = -wall_flux(k) * us_wall

!
!--       store rifs for next time step
          rif_wall(k,j,i,wall_index) = rifs

       ENDDO

    END SUBROUTINE wall_fluxes_ij



!------------------------------------------------------------------------------!
! Description:
! ------------
!> Call for all grid points
!> Calculates momentum fluxes at vertical walls for routine production_e
!> assuming Monin-Obukhov similarity.
!> Indices: usvs a=1, vsus b=1, wsvs c1=1, wsus c2=1 (other=0).
!------------------------------------------------------------------------------!

    SUBROUTINE wall_fluxes_e( wall_flux, a, b, c1, c2, wall )


       USE arrays_3d,                                                          &
           ONLY:  rif_wall, u, v, w, z0
       
       USE control_parameters,                                                 &
           ONLY:  kappa
       
       USE grid_variables,                                                     &
           ONLY:  dx, dy
       
       USE indices,                                                            &
           ONLY:  nxl, nxlg, nxr, nxrg, nyn, nyng, nys, nysg, nzb,             &
                  nzb_diff_s_inner, nzb_diff_s_outer, nzt
       
       USE kinds

       IMPLICIT NONE

       INTEGER(iwp) ::  i            !< 
       INTEGER(iwp) ::  j            !< 
       INTEGER(iwp) ::  k            !< 
       INTEGER(iwp) ::  kk           !< 
       INTEGER(iwp) ::  wall_index   !< 
       
       REAL(wp) ::  a           !< 
       REAL(wp) ::  b           !< 
       REAL(wp) ::  c1          !< 
       REAL(wp) ::  c2          !< 
       REAL(wp) ::  h1          !< 
       REAL(wp) ::  h2          !< 
       REAL(wp) ::  u_i         !< 
       REAL(wp) ::  v_i         !< 
       REAL(wp) ::  us_wall     !< 
       REAL(wp) ::  vel_total   !< 
       REAL(wp) ::  vel_zp      !< 
       REAL(wp) ::  ws          !< 
       REAL(wp) ::  zp          !< 
       REAL(wp) ::  rifs        !< 

       REAL(wp),                                                               &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             wall   !< 
       
       REAL(wp),                                                               &
          DIMENSION(nzb:nzt+1,nys:nyn,nxl:nxr) ::                              &
             wall_flux   !< 


       zp         = 0.5_wp * ( (a+c1) * dy + (b+c2) * dx )
       wall_flux  = 0.0_wp
       wall_index = NINT( a+ 2*b + 3*c1 + 4*c2 )

       DO  i = nxl, nxr
          DO  j = nys, nyn

             IF ( wall(j,i) /= 0.0_wp )  THEN
!
!--             All subsequent variables are computed for scalar locations.
                DO  k = nzb_diff_s_inner(j,i)-1, nzb_diff_s_outer(j,i)-2
!
!--                (1) Compute rifs, u_i, v_i, and ws
                   IF ( k == nzb_diff_s_inner(j,i)-1 )  THEN
                      kk = nzb_diff_s_inner(j,i)-1
                   ELSE
                      kk = k-1
                   ENDIF
                   rifs  = 0.5_wp * (      rif_wall(k,j,i,wall_index) +        &
                                      a  * rif_wall(k,j,i+1,1)        +        &
                                      b  * rif_wall(k,j+1,i,2)        +        &
                                      c1 * rif_wall(kk,j,i,3)         +        &
                                      c2 * rif_wall(kk,j,i,4)                  &
                                    )

                   u_i   = 0.5_wp * ( u(k,j,i) + u(k,j,i+1) )
                   v_i   = 0.5_wp * ( v(k,j,i) + v(k,j+1,i) )
                   ws    = 0.5_wp * ( w(k,j,i) + w(k-1,j,i) )
!
!--                (2) Compute wall-parallel absolute velocity vel_total and
!--                interpolate appropriate velocity component vel_zp.
                   vel_total = SQRT( ws**2 + (a+c1) * u_i**2 + (b+c2) * v_i**2 )
                   vel_zp    = 0.5_wp * ( a * u_i + b * v_i + (c1+c2) * ws )
!
!--                (3) Compute wall friction velocity us_wall
                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      us_wall = kappa * vel_total / ( LOG( zp / z0(j,i) ) +    &
                                         5.0_wp * rifs * ( zp - z0(j,i) ) / zp &
                                                    )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      us_wall = kappa * vel_total / (                          &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                    )
                   ENDIF

!
!--                Skip step (4) of wall_fluxes, because here rifs is already
!--                available from (1)
!
!--                (5) Compute wall_flux (u'v', v'u', w'v', or w'u')

                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      wall_flux(k,j,i) = kappa * vel_zp / ( LOG( zp/z0(j,i) ) +&
                                         5.0_wp * rifs * ( zp-z0(j,i) ) / zp )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      wall_flux(k,j,i) = kappa * vel_zp / (                    &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                          )
                   ENDIF
                   wall_flux(k,j,i) = - wall_flux(k,j,i) * us_wall

                ENDDO

             ENDIF

          ENDDO
       ENDDO

    END SUBROUTINE wall_fluxes_e


!------------------------------------------------------------------------------!
! Description:
! ------------
!> Call for all grid points - accelerator version
!> Calculates momentum fluxes at vertical walls for routine production_e
!> assuming Monin-Obukhov similarity.
!> Indices: usvs a=1, vsus b=1, wsvs c1=1, wsus c2=1 (other=0).
!------------------------------------------------------------------------------!
    SUBROUTINE wall_fluxes_e_acc( wall_flux, a, b, c1, c2, wall )


       USE arrays_3d,                                                          &
           ONLY:  rif_wall, u, v, w, z0
       
       USE control_parameters,                                                 &
           ONLY:  kappa
       
       USE grid_variables,                                                     &
           ONLY:  dx, dy
       
       USE indices,                                                            &
           ONLY:  i_left, i_right, j_north, j_south, nxl, nxlg, nxr, nxrg,     &
                  nyn, nyng, nys, nysg, nzb, nzb_diff_s_inner,                 &
                  nzb_diff_s_outer, nzt
       
       USE kinds

       IMPLICIT NONE

       INTEGER(iwp) ::  i            !< 
       INTEGER(iwp) ::  j            !< 
       INTEGER(iwp) ::  k            !< 
       INTEGER(iwp) ::  kk           !< 
       INTEGER(iwp) ::  max_outer    !< 
       INTEGER(iwp) ::  min_inner    !< 
       INTEGER(iwp) ::  wall_index   !< 
       
       REAL(wp) ::  a           !< 
       REAL(wp) ::  b           !< 
       REAL(wp) ::  c1          !< 
       REAL(wp) ::  c2          !< 
       REAL(wp) ::  h1          !< 
       REAL(wp) ::  h2          !< 
       REAL(wp) ::  u_i         !< 
       REAL(wp) ::  v_i         !< 
       REAL(wp) ::  us_wall     !< 
       REAL(wp) ::  vel_total   !< 
       REAL(wp) ::  vel_zp      !< 
       REAL(wp) ::  ws          !< 
       REAL(wp) ::  zp          !< 
       REAL(wp) ::  rifs        !< 

       REAL(wp),                                                               &
          DIMENSION(nysg:nyng,nxlg:nxrg) ::                                    &
             wall   !< 
       
       REAL(wp),                                                               &
          DIMENSION(nzb:nzt+1,nys:nyn,nxl:nxr) ::                              &
             wall_flux   !< 


       zp         = 0.5_wp * ( (a+c1) * dy + (b+c2) * dx )
       wall_flux  = 0.0_wp
       wall_index = NINT( a+ 2*b + 3*c1 + 4*c2 )

       min_inner = MINVAL( nzb_diff_s_inner(nys:nyn,nxl:nxr) ) - 1
       max_outer = MAXVAL( nzb_diff_s_outer(nys:nyn,nxl:nxr) ) - 2

       !$acc kernels present( nzb_diff_s_inner, nzb_diff_s_outer, rif_wall )   &
       !$acc         present( u, v, w, wall, wall_flux, z0 )
       DO  i = i_left, i_right
          DO  j = j_south, j_north
             DO  k = min_inner, max_outer
!
!--             All subsequent variables are computed for scalar locations
                IF ( k >= nzb_diff_s_inner(j,i)-1  .AND.                       &
                     k <= nzb_diff_s_outer(j,i)-2  .AND.                       &
                     wall(j,i) /= 0.0_wp )         THEN
!
!--                (1) Compute rifs, u_i, v_i, and ws
                   IF ( k == nzb_diff_s_inner(j,i)-1 )  THEN
                      kk = nzb_diff_s_inner(j,i)-1
                   ELSE
                      kk = k-1
                   ENDIF
                   rifs  = 0.5_wp * (      rif_wall(k,j,i,wall_index) +        &
                                      a  * rif_wall(k,j,i+1,1)        +        &
                                      b  * rif_wall(k,j+1,i,2)        +        &
                                      c1 * rif_wall(kk,j,i,3)         +        &
                                      c2 * rif_wall(kk,j,i,4)                  &
                                    )

                   u_i   = 0.5_wp * ( u(k,j,i) + u(k,j,i+1) )
                   v_i   = 0.5_wp * ( v(k,j,i) + v(k,j+1,i) )
                   ws    = 0.5_wp * ( w(k,j,i) + w(k-1,j,i) )
!
!--                (2) Compute wall-parallel absolute velocity vel_total and
!--                interpolate appropriate velocity component vel_zp.
                   vel_total = SQRT( ws**2 + (a+c1) * u_i**2 + (b+c2) * v_i**2 )
                   vel_zp    = 0.5_wp * ( a * u_i + b * v_i + (c1+c2) * ws )
!
!--                (3) Compute wall friction velocity us_wall
                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      us_wall = kappa * vel_total / ( LOG( zp / z0(j,i) ) +    &
                                         5.0_wp * rifs * ( zp - z0(j,i) ) / zp &
                                                    )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      us_wall = kappa * vel_total / (                          &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                    )
                   ENDIF

!
!--                Skip step (4) of wall_fluxes, because here rifs is already
!--                available from (1)
!
!--                (5) Compute wall_flux (u'v', v'u', w'v', or w'u')

                   IF ( rifs >= 0.0_wp )  THEN

!
!--                   Stable stratification (and neutral)
                      wall_flux(k,j,i) = kappa *  vel_zp / (                   &
                                         LOG( zp/z0(j,i) ) +                   &
                                         5.0_wp * rifs * ( zp-z0(j,i) ) / zp   &
                                                           )
                   ELSE

!
!--                   Unstable stratification
                      h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
                      h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

                      wall_flux(k,j,i) = kappa * vel_zp / (                    &
                           LOG( zp / z0(j,i) ) -                               &
                           LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (    &
                                ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +&
                                2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )           &
                                                          )
                   ENDIF
                   wall_flux(k,j,i) = - wall_flux(k,j,i) * us_wall

                ENDIF

             ENDDO
          ENDDO
       ENDDO
       !$acc end kernels

    END SUBROUTINE wall_fluxes_e_acc


!------------------------------------------------------------------------------!
! Description:
! ------------
!> Call for grid point i,j
!------------------------------------------------------------------------------!
    SUBROUTINE wall_fluxes_e_ij( i, j, nzb_w, nzt_w, wall_flux, a, b, c1, c2 )

       USE arrays_3d,                                                          &
           ONLY:  rif_wall, u, v, w, z0
       
       USE control_parameters,                                                 &
           ONLY:  kappa
       
       USE grid_variables,                                                     &
           ONLY:  dx, dy
       
       USE indices,                                                            &
           ONLY:  nzb, nzt
       
       USE kinds

       IMPLICIT NONE

       INTEGER(iwp) ::  i            !< 
       INTEGER(iwp) ::  j            !< 
       INTEGER(iwp) ::  k            !< 
       INTEGER(iwp) ::  kk           !< 
       INTEGER(iwp) ::  nzb_w        !< 
       INTEGER(iwp) ::  nzt_w        !< 
       INTEGER(iwp) ::  wall_index   !< 
       
       REAL(wp) ::  a           !< 
       REAL(wp) ::  b           !< 
       REAL(wp) ::  c1          !< 
       REAL(wp) ::  c2          !< 
       REAL(wp) ::  h1          !< 
       REAL(wp) ::  h2          !< 
       REAL(wp) ::  u_i         !< 
       REAL(wp) ::  v_i         !< 
       REAL(wp) ::  us_wall     !< 
       REAL(wp) ::  vel_total   !< 
       REAL(wp) ::  vel_zp      !< 
       REAL(wp) ::  ws          !< 
       REAL(wp) ::  zp          !< 
       REAL(wp) ::  rifs        !< 

       REAL(wp), DIMENSION(nzb:nzt+1) ::  wall_flux   !< 


       zp         = 0.5_wp * ( (a+c1) * dy + (b+c2) * dx )
       wall_flux  = 0.0_wp
       wall_index = NINT( a+ 2*b + 3*c1 + 4*c2 )

!
!--    All subsequent variables are computed for scalar locations.
       DO  k = nzb_w, nzt_w

!
!--       (1) Compute rifs, u_i, v_i, and ws
          IF ( k == nzb_w )  THEN
             kk = nzb_w
          ELSE
             kk = k-1
          ENDIF
          rifs  = 0.5_wp * (      rif_wall(k,j,i,wall_index) +                 &
                             a  * rif_wall(k,j,i+1,1)        +                 &
                             b  * rif_wall(k,j+1,i,2)        +                 &
                             c1 * rif_wall(kk,j,i,3)         +                 &
                             c2 * rif_wall(kk,j,i,4)                           &
                           )

          u_i   = 0.5_wp * ( u(k,j,i) + u(k,j,i+1) )
          v_i   = 0.5_wp * ( v(k,j,i) + v(k,j+1,i) )
          ws    = 0.5_wp * ( w(k,j,i) + w(k-1,j,i) )
!
!--       (2) Compute wall-parallel absolute velocity vel_total and
!--       interpolate appropriate velocity component vel_zp.
          vel_total = SQRT( ws**2 + (a+c1) * u_i**2 + (b+c2) * v_i**2 )
          vel_zp    = 0.5_wp * ( a * u_i + b * v_i + (c1+c2) * ws )
!
!--       (3) Compute wall friction velocity us_wall
          IF ( rifs >= 0.0_wp )  THEN

!
!--          Stable stratification (and neutral)
             us_wall = kappa * vel_total / ( LOG( zp / z0(j,i) ) +             &
                                         5.0_wp * rifs * ( zp - z0(j,i) ) / zp &
                                           )
          ELSE

!
!--          Unstable stratification
             h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
             h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

             us_wall = kappa * vel_total / (                                   &
                  LOG( zp / z0(j,i) ) -                                        &
                  LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (             &
                       ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +         &
                       2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )                    &
                                           )
          ENDIF

!
!--       Skip step (4) of wall_fluxes, because here rifs is already
!--       available from (1)
!
!--       (5) Compute wall_flux (u'v', v'u', w'v', or w'u')
!--       First interpolate the velocity (this is different from 
!--       subroutine wall_fluxes because fluxes in subroutine 
!--       wall_fluxes_e are defined at scalar locations).
          vel_zp = 0.5_wp * (       a * ( u(k,j,i) + u(k,j,i+1) ) +            &
                                    b * ( v(k,j,i) + v(k,j+1,i) ) +            &
                              (c1+c2) * ( w(k,j,i) + w(k-1,j,i) )              &
                            )

          IF ( rifs >= 0.0_wp )  THEN

!
!--          Stable stratification (and neutral)
             wall_flux(k) = kappa *  vel_zp /                                  &
                     ( LOG( zp/z0(j,i) ) + 5.0_wp * rifs * ( zp-z0(j,i) ) / zp )
          ELSE

!
!--          Unstable stratification
             h1 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs ) )
             h2 = SQRT( SQRT( 1.0_wp - 16.0_wp * rifs * z0(j,i) / zp ) )

             wall_flux(k) = kappa * vel_zp / (                                 &
                  LOG( zp / z0(j,i) ) -                                        &
                  LOG( ( 1.0_wp + h1 )**2 * ( 1.0_wp + h1**2 ) / (             &
                       ( 1.0_wp + h2 )**2 * ( 1.0_wp + h2**2 )   ) ) +         &
                       2.0_wp * ( ATAN( h1 ) - ATAN( h2 ) )                    &
                                             )
          ENDIF
          wall_flux(k) = - wall_flux(k) * us_wall

       ENDDO

    END SUBROUTINE wall_fluxes_e_ij

 END MODULE wall_fluxes_mod