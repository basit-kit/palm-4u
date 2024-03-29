!> @file user_read_restart_data.f90
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
! $Id: user_read_restart_data.f90 2001 2016-08-20 18:41:22Z knoop $
!
! 2000 2016-08-20 18:09:15Z knoop
! Forced header and separation lines into 80 columns
! 
! 1682 2015-10-07 23:56:08Z knoop
! Code annotations made doxygen readable
!
! 1320 2014-03-20 08:40:49Z raasch
! kind-parameters added to all INTEGER and REAL declaration statements, 
! kinds are defined in new module kinds, 
! old module precision_kind is removed,
! revision history before 2012 removed,
! comment fields (!:) to be used for variable explanations added to
! all variable declaration statements 
!
! 1036 2012-10-22 13:43:42Z raasch
! code put under GPL (PALM 3.9)
!
! 220 2008-12-18 07:00:36Z raasch
! reading mechanism revised (subdomain/total domain size can vary arbitrarily
! between current and previous run),
! former file user_interface.f90 split into one file per subroutine
!
! Description:
! ------------
!> Reading restart data from file(s)
!> Subdomain index limits on file are given by nxl_on_file, etc.
!> Indices nxlc, etc. indicate the range of gridpoints to be mapped from the
!> subdomain on file (f) to the subdomain of the current PE (c). They have been
!> calculated in routine read_3d_binary.
!------------------------------------------------------------------------------!
 SUBROUTINE user_read_restart_data( i, nxlfa, nxl_on_file, nxrfa, nxr_on_file, &
                                    nynfa, nyn_on_file, nysfa, nys_on_file,    &
                                    offset_xa, offset_ya, overlap_count,       &
                                    tmp_2d, tmp_3d )
 

    USE control_parameters
        
    USE indices
    
    USE kinds
    
    USE pegrid
    
    USE user

    IMPLICIT NONE

    CHARACTER (LEN=20) :: field_char   !< 

    INTEGER(iwp) ::  i               !< 
    INTEGER(iwp) ::  k               !< 
    INTEGER(iwp) ::  nxlc            !< 
    INTEGER(iwp) ::  nxlf            !< 
    INTEGER(iwp) ::  nxl_on_file     !< 
    INTEGER(iwp) ::  nxrc            !< 
    INTEGER(iwp) ::  nxrf            !< 
    INTEGER(iwp) ::  nxr_on_file     !< 
    INTEGER(iwp) ::  nync            !< 
    INTEGER(iwp) ::  nynf            !< 
    INTEGER(iwp) ::  nyn_on_file     !< 
    INTEGER(iwp) ::  nysc            !< 
    INTEGER(iwp) ::  nysf            !< 
    INTEGER(iwp) ::  nys_on_file     !< 
    INTEGER(iwp) ::  overlap_count   !< 

    INTEGER(iwp), DIMENSION(numprocs_previous_run,1000) ::  nxlfa       !< 
    INTEGER(iwp), DIMENSION(numprocs_previous_run,1000) ::  nxrfa       !< 
    INTEGER(iwp), DIMENSION(numprocs_previous_run,1000) ::  nynfa       !< 
    INTEGER(iwp), DIMENSION(numprocs_previous_run,1000) ::  nysfa       !< 
    INTEGER(iwp), DIMENSION(numprocs_previous_run,1000) ::  offset_xa   !< 
    INTEGER(iwp), DIMENSION(numprocs_previous_run,1000) ::  offset_ya   !< 

    REAL(wp),                                                                  &
       DIMENSION(nys_on_file-nbgp:nyn_on_file+nbgp,nxl_on_file-nbgp:nxr_on_file+nbgp) ::&
          tmp_2d   !< 

    REAL(wp),                                                                  &
       DIMENSION(nzb:nzt+1,nys_on_file-nbgp:nyn_on_file+nbgp,nxl_on_file-nbgp:nxr_on_file+nbgp) ::&
          tmp_3d   !< 

!
!-- Here the reading of user-defined restart data follows:
!-- Sample for user-defined output
!
!    IF ( initializing_actions == 'read_restart_data' )  THEN
!       READ ( 13 )  field_char
!       DO  WHILE ( TRIM( field_char ) /= '*** end user ***' )
!
!          DO  k = 1, overlap_count
!
!             nxlf = nxlfa(i,k)
!             nxlc = nxlfa(i,k) + offset_xa(i,k)
!             nxrf = nxrfa(i,k)
!             nxrc = nxrfa(i,k) + offset_xa(i,k)
!             nysf = nysfa(i,k)
!             nysc = nysfa(i,k) + offset_ya(i,k)
!             nynf = nynfa(i,k)
!             nync = nynfa(i,k) + offset_ya(i,k)
!
!
!             SELECT CASE ( TRIM( field_char ) )
!
!                CASE ( 'u2_av' )
!                   IF ( .NOT. ALLOCATED( u2_av ) ) THEN
!                      ALLOCATE( u2_av(nzb:nzt+1,nysg:nyng,nxlg:nxrg) )
!                   ENDIF
!                   IF ( k == 1 )  READ ( 13 )  tmp_3d
!                   u2_av(:,nysc-nbgp:nync+nbgp,nxlc-nbgp:nxrc+nbgp) =           &
!                                          tmp_3d(:,nysf-nbgp:nynf+nbgp,nxlf-nbgp:nxrf+nbgp)
!
!                CASE DEFAULT
!                   WRITE( message_string, * ) 'unknown variable named "',       &
!                                         TRIM( field_char ), '" found in',      &
!                                         '&data from prior run on PE ', myid
!                   CALL message( 'user_read_restart_data', 'UI0012', 1, 2, 0, 6, 0 )
!
!             END SELECT
!
!          ENDDO
!
!          READ ( 13 )  field_char
!
!       ENDDO
!    ENDIF

 END SUBROUTINE user_read_restart_data

