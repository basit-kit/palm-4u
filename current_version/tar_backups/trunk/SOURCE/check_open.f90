!> @file check_open.f90
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
! You should have received a copy of the GNU fGeneral Public License along with
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
! $Id: check_open.f90 2041 2016-10-27 12:58:47Z gronemeier $
!
! 2040 2016-10-26 16:58:09Z gronemeier
! Removed open of file 'PLOTTS_DATA' ( CASE(50:59) ) as it is no longer needed
! 
! 2000 2016-08-20 18:09:15Z knoop
! Forced header and separation lines into 80 columns
! 
! 1988 2016-08-10 14:49:06Z gronemeier
! informative message added if files cannot be opened in newly created directory
! 
! 1986 2016-08-10 14:07:17Z gronemeier
! Bugfix: check if output can be opened in newly created directory. If not
! wait one second and try again.
! 
! 1974 2016-07-26 08:43:25Z gronemeier
! Bugfix: MPI barriers after deleting non-extendable files must only be called
! in case of parallel I/O
! 
! 1957 2016-07-07 10:43:48Z suehring
! flight module added
!
! 1804 2016-04-05 16:30:18Z maronga
! Removed code for parameter file check (__check)
!
! 1783 2016-03-06 18:36:17Z raasch
! name change of netcdf routines and module + related changes
!
! 1779 2016-03-03 08:01:28Z raasch
! coupling_char is trimmed at every place it occurs, because it can have
! different length now
!
! 1745 2016-02-05 13:06:51Z gronemeier
! Bugfix: added MPI barrier after deleting existing non-extendable file by PE0
! 
! 1682 2015-10-07 23:56:08Z knoop
! Code annotations made doxygen readable 
! 
! 1551 2015-03-03 14:18:16Z maronga
! Removed redundant output for combine_plot_fields
! 
! 1468 2014-09-24 14:06:57Z maronga
! Adapted for use on up to 6-digit processor cores
! Added file unit 117 (PROGRESS)
! 
! 1359 2014-04-11 17:15:14Z hoffmann
! Format of particle exchange statistics extended to reasonable numbers of      
! particles.
! 
! 1353 2014-04-08 15:21:23Z heinze
! REAL constants provided with KIND-attribute,
! declaration for unused variables xkoor, ykoor, zkoor removed
! 
! 1327 2014-03-21 11:00:16Z raasch
! parts concerning iso2d and avs output removed
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
! 1106 2013-03-04 05:31:38Z raasch
! array_kind renamed precision_kind
!
! 1092 2013-02-02 11:24:22Z raasch
! unused variables removed
!
! 1036 2012-10-22 13:43:42Z raasch
! code put under GPL (PALM 3.9)
!
! 1031 2012-10-19 14:35:30Z raasch
! netCDF4 without parallel file support implemented,
! opening of netCDF files are done by new routines create_netcdf_file and
! open_write_netcdf_file
!
! 964 2012-07-26 09:14:24Z raasch
! old profil-units (40:49) removed,
! append feature removed from unit 14
!
! 849 2012-03-15 10:35:09Z raasch
! comment changed
!
! 809 2012-01-30 13:32:58Z maronga
! Bugfix: replaced .AND. and .NOT. with && and ! in the preprocessor directives
!
! 807 2012-01-25 11:53:51Z maronga
! New cpp directive "__check" implemented which is used by check_namelist_files
!
! Revision 1.1  1997/08/11 06:10:55  raasch
! Initial revision
!
!
! Description:
! ------------
!> Check if file unit is open. If not, open file and, if necessary, write a
!> header or start other initializing actions, respectively.
!------------------------------------------------------------------------------!
SUBROUTINE check_open( file_id )
 

    USE arrays_3d,                                                             &
        ONLY:  zu

    USE control_parameters,                                                    &
        ONLY:  avs_data_file, coupling_char, data_output_2d_on_each_pe, host,  &
               max_masks, message_string, mid, nz_do3d, openfile,              &
               return_addres, return_username, run_description_header, runnr

    USE grid_variables,                                                        &
        ONLY:  dx, dy

    USE indices,                                                               &
        ONLY:  nbgp, nx, nxl, nxr, ny, nyn, nyng, nys, nysg, nz, nzb, nzt 

    USE kinds

#if defined( __netcdf )
    USE NETCDF
#endif

    USE netcdf_interface,                                                      &
        ONLY:  id_set_fl, id_set_mask, id_set_pr, id_set_prt, id_set_pts,      &
               id_set_sp, id_set_ts, id_set_xy, id_set_xz, id_set_yz,          &
               id_set_3d, nc_stat, netcdf_create_file, netcdf_data_format,     &
               netcdf_define_header, netcdf_handle_error, netcdf_open_write_file

    USE particle_attributes,                                                   &
        ONLY:  max_number_of_particle_groups, number_of_particle_groups,       &
               particle_groups

    USE pegrid

    USE posix_calls_from_fortran,                                              &
        ONLY:  fortran_sleep

    USE profil_parameter,                                                      &
        ONLY:  cross_ts_numbers, cross_ts_number_count


    IMPLICIT NONE

    CHARACTER (LEN=2)   ::  mask_char               !<
    CHARACTER (LEN=2)   ::  suffix                  !<
    CHARACTER (LEN=20)  ::  xtext = 'time in s'     !<
    CHARACTER (LEN=30)  ::  filename                !<
    CHARACTER (LEN=40)  ::  avs_coor_file           !<
    CHARACTER (LEN=40)  ::  avs_coor_file_localname !<
    CHARACTER (LEN=40)  ::  avs_data_file_localname !<
    CHARACTER (LEN=80)  ::  rtext                   !<
    CHARACTER (LEN=100) ::  avs_coor_file_catalog   !<
    CHARACTER (LEN=100) ::  avs_data_file_catalog   !<
    CHARACTER (LEN=100) ::  batch_scp               !<
    CHARACTER (LEN=100) ::  line                    !<
    CHARACTER (LEN=400) ::  command                 !<

    INTEGER(iwp) ::  av          !<
    INTEGER(iwp) ::  numline = 1 !<
    INTEGER(iwp) ::  cranz       !<
    INTEGER(iwp) ::  file_id     !<
    INTEGER(iwp) ::  i           !<
    INTEGER(iwp) ::  iaddres     !<
    INTEGER(iwp) ::  ioerr       !< IOSTAT flag for IO-commands ( 0 = no error )
    INTEGER(iwp) ::  iusern      !<
    INTEGER(iwp) ::  j           !<
    INTEGER(iwp) ::  k           !<
    INTEGER(iwp) ::  legpos = 1  !<
    INTEGER(iwp) ::  timodex = 1 !<
    
    INTEGER(iwp), DIMENSION(10) ::  klist !<

    LOGICAL ::  avs_coor_file_found = .FALSE. !<
    LOGICAL ::  avs_data_file_found = .FALSE. !<
    LOGICAL ::  datleg = .TRUE.               !<
    LOGICAL ::  get_filenames                 !<
    LOGICAL ::  grid = .TRUE.                 !<
    LOGICAL ::  netcdf_extend                 !<
    LOGICAL ::  rand = .TRUE.                 !<
    LOGICAL ::  swap = .TRUE.                 !<
    LOGICAL ::  twoxa = .TRUE.                !<
    LOGICAL ::  twoya = .TRUE.                !<

    REAL(wp) ::  ansx = -999.999_wp !<
    REAL(wp) ::  ansy = -999.999_wp !<
    REAL(wp) ::  gwid = 0.1_wp      !<
    REAL(wp) ::  rlegfak = 1.5_wp   !<
    REAL(wp) ::  sizex = 250.0_wp   !<
    REAL(wp) ::  sizey = 40.0_wp    !<
    REAL(wp) ::  texfac = 1.5_wp    !<

    REAL(wp), DIMENSION(:), ALLOCATABLE      ::  eta !<
    REAL(wp), DIMENSION(:), ALLOCATABLE      ::  ho  !<
    REAL(wp), DIMENSION(:), ALLOCATABLE      ::  hu  !<
 


    NAMELIST /RAHMEN/  numline, cranz, datleg, rtext, swap
    NAMELIST /CROSS/   ansx, ansy, grid, gwid, klist, legpos,                  &
                       rand, rlegfak, sizex, sizey, texfac,                    &
                       timodex, twoxa, twoya, xtext
                       

!
!-- Immediate return if file already open
    IF ( openfile(file_id)%opened )  RETURN

!
!-- Only certain files are allowed to be re-opened
!-- NOTE: some of the other files perhaps also could be re-opened, but it
!--       has not been checked so far, if it works!
    IF ( openfile(file_id)%opened_before )  THEN
       SELECT CASE ( file_id )
          CASE ( 13, 14, 21, 22, 23, 80:85, 117 )
             IF ( file_id == 14 .AND. openfile(file_id)%opened_before )  THEN
                message_string = 're-open of unit ' //                         &
                                 '14 is not verified. Please check results!'
                CALL message( 'check_open', 'PA0165', 0, 1, 0, 6, 0 )       
             ENDIF

          CASE DEFAULT
             WRITE( message_string, * ) 're-opening of file-id ', file_id,     &
                                        ' is not allowed'
             CALL message( 'check_open', 'PA0166', 0, 1, 0, 6, 0 )    
               
             RETURN

       END SELECT
    ENDIF

!
!-- Check if file may be opened on the relevant PE
    SELECT CASE ( file_id )

       CASE ( 15, 16, 17, 18, 19, 50:59, 81:84, 104:105, 107, 109, 117 )
	      
          IF ( myid /= 0 )  THEN
             WRITE( message_string, * ) 'opening file-id ',file_id,            &
                                        ' not allowed for PE ',myid
             CALL message( 'check_open', 'PA0167', 2, 2, -1, 6, 1 )
          ENDIF

       CASE ( 101:103, 106, 111:113, 116, 201:200+2*max_masks )

          IF ( netcdf_data_format < 5 )  THEN
          
             IF ( myid /= 0 )  THEN
                WRITE( message_string, * ) 'opening file-id ',file_id,         &
                                           ' not allowed for PE ',myid
                CALL message( 'check_open', 'PA0167', 2, 2, -1, 6, 1 )
             ENDIF
	     
          ENDIF

       CASE ( 21, 22, 23 )

          IF ( .NOT.  data_output_2d_on_each_pe )  THEN
             IF ( myid /= 0 )  THEN
                WRITE( message_string, * ) 'opening file-id ',file_id,         &
                                           ' not allowed for PE ',myid
                CALL message( 'check_open', 'PA0167', 2, 2, -1, 6, 1 )
             END IF
          ENDIF

       CASE ( 27, 28, 29, 31, 33, 71:73, 90:99 )

!
!--       File-ids that are used temporarily in other routines
          WRITE( message_string, * ) 'opening file-id ',file_id,               &
                                    ' is not allowed since it is used otherwise'
          CALL message( 'check_open', 'PA0168', 0, 1, 0, 6, 0 ) 
          
    END SELECT

!
!-- Open relevant files
    SELECT CASE ( file_id )

       CASE ( 11 )

          OPEN ( 11, FILE='PARIN'//TRIM( coupling_char ), FORM='FORMATTED',    &
                     STATUS='OLD' )

       CASE ( 13 )

          IF ( myid_char == '' )  THEN
             OPEN ( 13, FILE='BININ'//TRIM( coupling_char )//myid_char,        &
                        FORM='UNFORMATTED', STATUS='OLD' )
          ELSE
!
!--          First opening of unit 13 openes file _000000 on all PEs because
!--          only this file contains the global variables
             IF ( .NOT. openfile(file_id)%opened_before )  THEN
                OPEN ( 13, FILE='BININ'//TRIM( coupling_char )//'/_000000',    &
                           FORM='UNFORMATTED', STATUS='OLD' )
             ELSE
                OPEN ( 13, FILE='BININ'//TRIM( coupling_char )//'/'//          &
                           myid_char, FORM='UNFORMATTED', STATUS='OLD' )
             ENDIF
          ENDIF

       CASE ( 14 )

          IF ( myid_char == '' )  THEN
             OPEN ( 14, FILE='BINOUT'//TRIM( coupling_char )//myid_char,       &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ELSE
             IF ( myid == 0  .AND. .NOT. openfile(file_id)%opened_before )  THEN
                CALL local_system( 'mkdir  BINOUT' // TRIM( coupling_char ) )
             ENDIF
#if defined( __parallel )
!
!--          Set a barrier in order to allow that all other processors in the 
!--          directory created by PE0 can open their file
             CALL MPI_BARRIER( comm2d, ierr )
#endif
             ioerr = 1
             DO WHILE ( ioerr /= 0 )
                OPEN ( 14, FILE='BINOUT'//TRIM(coupling_char)//'/'//myid_char, &
                           FORM='UNFORMATTED', IOSTAT=ioerr )
                IF ( ioerr /= 0 )  THEN
                   WRITE( 9, * )  '*** could not open "BINOUT'//         &
                                  TRIM(coupling_char)//'/'//myid_char//  &
                                  '"! Trying again in 1 sec.'
                   CALL fortran_sleep( 1 )
                ENDIF
             ENDDO

          ENDIF

       CASE ( 15 )

          OPEN ( 15, FILE='RUN_CONTROL'//TRIM( coupling_char ),                &
                     FORM='FORMATTED' )

       CASE ( 16 )

          OPEN ( 16, FILE='LIST_PROFIL'//TRIM( coupling_char ),                &
                     FORM='FORMATTED' )

       CASE ( 17 )

          OPEN ( 17, FILE='LIST_PROFIL_1D'//TRIM( coupling_char ),             &
                     FORM='FORMATTED' )

       CASE ( 18 )

          OPEN ( 18, FILE='CPU_MEASURES'//TRIM( coupling_char ),               &
                     FORM='FORMATTED' )

       CASE ( 19 )

          OPEN ( 19, FILE='HEADER'//TRIM( coupling_char ), FORM='FORMATTED' )

       CASE ( 20 )

          IF ( myid == 0  .AND. .NOT. openfile(file_id)%opened_before )  THEN
             CALL local_system( 'mkdir  DATA_LOG' // TRIM( coupling_char ) )
          ENDIF
          IF ( myid_char == '' )  THEN
             OPEN ( 20, FILE='DATA_LOG'//TRIM( coupling_char )//'/_000000',    &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ELSE
#if defined( __parallel )
!
!--          Set a barrier in order to allow that all other processors in the 
!--          directory created by PE0 can open their file
             CALL MPI_BARRIER( comm2d, ierr )
#endif
             ioerr = 1
             DO WHILE ( ioerr /= 0 )
                OPEN ( 20, FILE='DATA_LOG'//TRIM( coupling_char )//'/'//       &
                           myid_char, FORM='UNFORMATTED', POSITION='APPEND',   &
                           IOSTAT=ioerr )
                IF ( ioerr /= 0 )  THEN
                   WRITE( 9, * )  '*** could not open "DATA_LOG'//         &
                                  TRIM( coupling_char )//'/'//myid_char//  &
                                  '"! Trying again in 1 sec.'
                   CALL fortran_sleep( 1 )
                ENDIF
             ENDDO

          ENDIF

       CASE ( 21 )

          IF ( data_output_2d_on_each_pe )  THEN
             OPEN ( 21, FILE='PLOT2D_XY'//TRIM( coupling_char )//myid_char,    &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ELSE
             OPEN ( 21, FILE='PLOT2D_XY'//TRIM( coupling_char ),                       &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ENDIF

          IF ( myid == 0  .AND.  .NOT. openfile(file_id)%opened_before )  THEN
!
!--          Output for combine_plot_fields
             IF ( data_output_2d_on_each_pe  .AND.  myid_char /= '' )  THEN
                WRITE (21)  -nbgp, nx+nbgp, -nbgp, ny+nbgp    ! total array size
                WRITE (21)   0, nx+1,  0, ny+1    ! output part
             ENDIF
!
!--          Determine and write ISO2D coordiante header
             ALLOCATE( eta(0:ny+1), ho(0:nx+1), hu(0:nx+1) )
             hu = 0.0_wp
             ho = (ny+1) * dy
             DO  i = 1, ny
                eta(i) = REAL( i ) / ( ny + 1.0_wp )
             ENDDO
             eta(0)    = 0.0_wp
             eta(ny+1) = 1.0_wp

             WRITE (21)  dx,eta,hu,ho
             DEALLOCATE( eta, ho, hu )

          ENDIF

       CASE ( 22 )

          IF ( data_output_2d_on_each_pe )  THEN
             OPEN ( 22, FILE='PLOT2D_XZ'//TRIM( coupling_char )//myid_char,    &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ELSE
             OPEN ( 22, FILE='PLOT2D_XZ'//TRIM( coupling_char ),               &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ENDIF

          IF ( myid == 0  .AND.  .NOT. openfile(file_id)%opened_before )  THEN
!
!--          Output for combine_plot_fields
             IF ( data_output_2d_on_each_pe  .AND.  myid_char /= '' )  THEN
                WRITE (22)  -nbgp, nx+nbgp, 0, nz+1    ! total array size
                WRITE (22)   0, nx+1, 0, nz+1    ! output part
             ENDIF
!
!--          Determine and write ISO2D coordinate header
             ALLOCATE( eta(0:nz+1), ho(0:nx+1), hu(0:nx+1) )
             hu = 0.0_wp
             ho = zu(nz+1)
             DO  i = 1, nz
                eta(i) = REAL( zu(i) ) / zu(nz+1)
             ENDDO
             eta(0)    = 0.0_wp
             eta(nz+1) = 1.0_wp

             WRITE (22)  dx,eta,hu,ho
             DEALLOCATE( eta, ho, hu )

          ENDIF

       CASE ( 23 )

          IF ( data_output_2d_on_each_pe )  THEN
             OPEN ( 23, FILE='PLOT2D_YZ'//TRIM( coupling_char )//myid_char,    &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ELSE
             OPEN ( 23, FILE='PLOT2D_YZ'//TRIM( coupling_char ),               &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ENDIF

          IF ( myid == 0  .AND.  .NOT. openfile(file_id)%opened_before )  THEN
!
!--          Output for combine_plot_fields
             IF ( data_output_2d_on_each_pe  .AND.  myid_char /= '' )  THEN
                WRITE (23)  -nbgp, ny+nbgp, 0, nz+1    ! total array size
                WRITE (23)   0, ny+1, 0, nz+1    ! output part
             ENDIF
!
!--          Determine and write ISO2D coordiante header
             ALLOCATE( eta(0:nz+1), ho(0:ny+1), hu(0:ny+1) )
             hu = 0.0_wp
             ho = zu(nz+1)
             DO  i = 1, nz
                eta(i) = REAL( zu(i) ) / zu(nz+1)
             ENDDO
             eta(0)    = 0.0_wp
             eta(nz+1) = 1.0_wp

             WRITE (23)  dx,eta,hu,ho
             DEALLOCATE( eta, ho, hu )

          ENDIF

       CASE ( 30 )

          OPEN ( 30, FILE='PLOT3D_DATA'//TRIM( coupling_char )//myid_char,     &
                     FORM='UNFORMATTED' )
!
!--       Write coordinate file for AVS
          IF ( myid == 0 )  THEN
#if defined( __parallel )
!
!--          Specifications for combine_plot_fields
             WRITE ( 30 )  -nbgp,nx+nbgp,-nbgp,ny+nbgp
             WRITE ( 30 )  0,nx+1,0,ny+1,0,nz_do3d
#endif
          ENDIF

       CASE ( 80 )

          IF ( myid_char == '' )  THEN
             OPEN ( 80, FILE='PARTICLE_INFOS'//TRIM(coupling_char)//myid_char, &
                        FORM='FORMATTED', POSITION='APPEND' )
          ELSE
             IF ( myid == 0  .AND.  .NOT. openfile(80)%opened_before )  THEN
                CALL local_system( 'mkdir  PARTICLE_INFOS' //                  &
                                   TRIM( coupling_char ) )
             ENDIF
#if defined( __parallel )
!
!--          Set a barrier in order to allow that thereafter all other
!--          processors in the directory created by PE0 can open their file.
!--          WARNING: The following barrier will lead to hanging jobs, if
!--                   check_open is first called from routine
!--                   allocate_prt_memory!
             IF ( .NOT. openfile(80)%opened_before )  THEN
                CALL MPI_BARRIER( comm2d, ierr )
             ENDIF
#endif
             OPEN ( 80, FILE='PARTICLE_INFOS'//TRIM( coupling_char )//'/'//    &
                             myid_char,                                        &
                        FORM='FORMATTED', POSITION='APPEND' )
          ENDIF

          IF ( .NOT. openfile(80)%opened_before )  THEN
             WRITE ( 80, 8000 )  TRIM( run_description_header )
          ENDIF

       CASE ( 81 )

             OPEN ( 81, FILE='PLOTSP_X_PAR'//TRIM( coupling_char ),            &
                        FORM='FORMATTED', DELIM='APOSTROPHE', RECL=1500,       &
                        POSITION='APPEND' )

       CASE ( 82 )

             OPEN ( 82, FILE='PLOTSP_X_DATA'//TRIM( coupling_char ),           &
                        FORM='FORMATTED', POSITION = 'APPEND' )

       CASE ( 83 )

             OPEN ( 83, FILE='PLOTSP_Y_PAR'//TRIM( coupling_char ),            &
                        FORM='FORMATTED', DELIM='APOSTROPHE', RECL=1500,       &
                        POSITION='APPEND' )

       CASE ( 84 )

             OPEN ( 84, FILE='PLOTSP_Y_DATA'//TRIM( coupling_char ),           &
                        FORM='FORMATTED', POSITION='APPEND' )

       CASE ( 85 )

          IF ( myid_char == '' )  THEN
             OPEN ( 85, FILE='PARTICLE_DATA'//TRIM(coupling_char)//myid_char,  &
                        FORM='UNFORMATTED', POSITION='APPEND' )
          ELSE
             IF ( myid == 0  .AND.  .NOT. openfile(85)%opened_before )  THEN
                CALL local_system( 'mkdir  PARTICLE_DATA' //                   &
                                   TRIM( coupling_char ) )
             ENDIF
#if defined( __parallel )
!
!--          Set a barrier in order to allow that thereafter all other
!--          processors in the directory created by PE0 can open their file
             CALL MPI_BARRIER( comm2d, ierr )
#endif
             ioerr = 1
             DO WHILE ( ioerr /= 0 )
                OPEN ( 85, FILE='PARTICLE_DATA'//TRIM( coupling_char )//'/'//  &
                           myid_char,                                          &
                           FORM='UNFORMATTED', POSITION='APPEND', IOSTAT=ioerr )
                IF ( ioerr /= 0 )  THEN
                   WRITE( 9, * )  '*** could not open "PARTICLE_DATA'//    &
                                  TRIM( coupling_char )//'/'//myid_char//  &
                                  '"! Trying again in 1 sec.'
                   CALL fortran_sleep( 1 )
                ENDIF
             ENDDO

          ENDIF

          IF ( .NOT. openfile(85)%opened_before )  THEN
             WRITE ( 85 )  run_description_header
!
!--          Attention: change version number whenever the output format on
!--                     unit 85 is changed (see also in routine
!--                     lpm_data_output_particles)
             rtext = 'data format version 3.1'
             WRITE ( 85 )  rtext
             WRITE ( 85 )  number_of_particle_groups,                          &
                           max_number_of_particle_groups
             WRITE ( 85 )  particle_groups
             WRITE ( 85 )  nxl, nxr, nys, nyn, nzb, nzt, nbgp
          ENDIF

#if defined( __netcdf )
       CASE ( 101, 111 )
!
!--       Set filename depending on unit number
          IF ( file_id == 101 )  THEN
             filename = 'DATA_2D_XY_NETCDF' // TRIM( coupling_char )
             av = 0
          ELSE
             filename = 'DATA_2D_XY_AV_NETCDF' // TRIM( coupling_char )
             av = 1
          ENDIF
!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its dimensions and variables match the
!--       actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )
          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_xy(av), .TRUE., 20 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'xy', netcdf_extend, av )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_xy(av) )
                CALL netcdf_handle_error( 'check_open', 21 )
                IF ( myid == 0 )  CALL local_system( 'rm ' // TRIM( filename ) )
#if defined( __parallel )
!
!--             Set a barrier in order to assure that PE0 deleted the old file
!--             before any other processor tries to open a new file.
!--             Barrier is only needed in case of parallel I/O
                IF ( netcdf_data_format > 4 )  CALL MPI_BARRIER( comm2d, ierr )
#endif
             ENDIF

          ENDIF

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_xy(av), .TRUE., 22 )

!
!--          Define the header
             CALL netcdf_define_header( 'xy', netcdf_extend, av )

!
!--          In case of parallel netCDF output, create flag file which tells
!--          combine_plot_fields that nothing is to do.
             IF ( myid == 0  .AND.  netcdf_data_format > 4 )  THEN
                OPEN( 99, FILE='NO_COMBINE_PLOT_FIELDS_XY' )
                WRITE ( 99, '(A)' )  'no combine_plot_fields.x neccessary'
                CLOSE( 99 )
             ENDIF

          ENDIF

       CASE ( 102, 112 )
!
!--       Set filename depending on unit number
          IF ( file_id == 102 )  THEN
             filename = 'DATA_2D_XZ_NETCDF' // TRIM( coupling_char )
             av = 0
          ELSE
             filename = 'DATA_2D_XZ_AV_NETCDF' // TRIM( coupling_char )
             av = 1
          ENDIF
!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its dimensions and variables match the
!--       actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_xz(av), .TRUE., 23 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'xz', netcdf_extend, av )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_xz(av) )
                CALL netcdf_handle_error( 'check_open', 24 )
                IF ( myid == 0 )  CALL local_system( 'rm ' // TRIM( filename ) )
#if defined( __parallel )
!
!--             Set a barrier in order to assure that PE0 deleted the old file
!--             before any other processor tries to open a new file
!--             Barrier is only needed in case of parallel I/O
                IF ( netcdf_data_format > 4 )  CALL MPI_BARRIER( comm2d, ierr )
#endif
             ENDIF

          ENDIF

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_xz(av), .TRUE., 25 )

!
!--          Define the header
             CALL netcdf_define_header( 'xz', netcdf_extend, av )

!
!--          In case of parallel netCDF output, create flag file which tells
!--          combine_plot_fields that nothing is to do.
             IF ( myid == 0  .AND.  netcdf_data_format > 4 )  THEN
                OPEN( 99, FILE='NO_COMBINE_PLOT_FIELDS_XZ' )
                WRITE ( 99, '(A)' )  'no combine_plot_fields.x neccessary'
                CLOSE( 99 )
             ENDIF

          ENDIF

       CASE ( 103, 113 )
!
!--       Set filename depending on unit number
          IF ( file_id == 103 )  THEN
             filename = 'DATA_2D_YZ_NETCDF' // TRIM( coupling_char )
             av = 0
          ELSE
             filename = 'DATA_2D_YZ_AV_NETCDF' // TRIM( coupling_char )
             av = 1
          ENDIF
!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its dimensions and variables match the
!--       actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_yz(av), .TRUE., 26 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'yz', netcdf_extend, av )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_yz(av) )
                CALL netcdf_handle_error( 'check_open', 27 )
                IF ( myid == 0 )  CALL local_system( 'rm ' // TRIM( filename ) )
#if defined( __parallel )
!
!--             Set a barrier in order to assure that PE0 deleted the old file
!--             before any other processor tries to open a new file
!--             Barrier is only needed in case of parallel I/O
                IF ( netcdf_data_format > 4 )  CALL MPI_BARRIER( comm2d, ierr )
#endif
             ENDIF

          ENDIF

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_yz(av), .TRUE., 28 )

!
!--          Define the header
             CALL netcdf_define_header( 'yz', netcdf_extend, av )

!
!--          In case of parallel netCDF output, create flag file which tells
!--          combine_plot_fields that nothing is to do.
             IF ( myid == 0  .AND.  netcdf_data_format > 4 )  THEN
                OPEN( 99, FILE='NO_COMBINE_PLOT_FIELDS_YZ' )
                WRITE ( 99, '(A)' )  'no combine_plot_fields.x neccessary'
                CLOSE( 99 )
             ENDIF

          ENDIF

       CASE ( 104 )
!
!--       Set filename
          filename = 'DATA_1D_PR_NETCDF' // TRIM( coupling_char )

!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its variables match the actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_pr, .FALSE., 29 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'pr', netcdf_extend, 0 )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_pr )
                CALL netcdf_handle_error( 'check_open', 30 )
                CALL local_system( 'rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_pr, .FALSE., 31 )
!
!--          Define the header
             CALL netcdf_define_header( 'pr', netcdf_extend, 0 )

          ENDIF

       CASE ( 105 )
!
!--       Set filename
          filename = 'DATA_1D_TS_NETCDF' // TRIM( coupling_char )

!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its variables match the actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_ts, .FALSE., 32 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'ts', netcdf_extend, 0 )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_ts )
                CALL netcdf_handle_error( 'check_open', 33 )
                CALL local_system( 'rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_ts, .FALSE., 34 )
!
!--          Define the header
             CALL netcdf_define_header( 'ts', netcdf_extend, 0 )

          ENDIF


       CASE ( 106, 116 )
!
!--       Set filename depending on unit number
          IF ( file_id == 106 )  THEN
             filename = 'DATA_3D_NETCDF' // TRIM( coupling_char )
             av = 0
          ELSE
             filename = 'DATA_3D_AV_NETCDF' // TRIM( coupling_char )
             av = 1
          ENDIF
!
!--       Inquire, if there is a netCDF file from a previous run. This should
!--       be opened for extension, if its dimensions and variables match the
!--       actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_3d(av), .TRUE., 35 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( '3d', netcdf_extend, av )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_3d(av) )
                CALL netcdf_handle_error( 'check_open', 36 )
                IF ( myid == 0 )  CALL local_system( 'rm ' // TRIM( filename ) )
#if defined( __parallel )
!
!--             Set a barrier in order to assure that PE0 deleted the old file
!--             before any other processor tries to open a new file
!--             Barrier is only needed in case of parallel I/O
                IF ( netcdf_data_format > 4 )  CALL MPI_BARRIER( comm2d, ierr )
#endif
             ENDIF

          ENDIF

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_3d(av), .TRUE., 37 )

!
!--          Define the header
             CALL netcdf_define_header( '3d', netcdf_extend, av )

!
!--          In case of parallel netCDF output, create flag file which tells
!--          combine_plot_fields that nothing is to do.
             IF ( myid == 0  .AND.  netcdf_data_format > 4 )  THEN
                OPEN( 99, FILE='NO_COMBINE_PLOT_FIELDS_3D' )
                WRITE ( 99, '(A)' )  'no combine_plot_fields.x neccessary'
                CLOSE( 99 )
             ENDIF

          ENDIF


       CASE ( 107 )
!
!--       Set filename
          filename = 'DATA_1D_SP_NETCDF' // TRIM( coupling_char )

!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its variables match the actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_sp, .FALSE., 38 )

!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'sp', netcdf_extend, 0 )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_sp )
                CALL netcdf_handle_error( 'check_open', 39 )
                CALL local_system( 'rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_sp, .FALSE., 40 )
!
!--          Define the header
             CALL netcdf_define_header( 'sp', netcdf_extend, 0 )

          ENDIF


       CASE ( 108 )

          IF ( myid_char == '' )  THEN
             filename = 'DATA_PRT_NETCDF' // TRIM( coupling_char )
          ELSE
             filename = 'DATA_PRT_NETCDF' // TRIM( coupling_char ) // '/' //   &
                        myid_char
          ENDIF
!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its variables match the actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_prt, .FALSE., 41 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'pt', netcdf_extend, 0 )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_prt )
                CALL netcdf_handle_error( 'check_open', 42 )
                CALL local_system( 'rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN

!
!--          For runs on multiple processors create the subdirectory
             IF ( myid_char /= '' )  THEN
                IF ( myid == 0  .AND. .NOT. openfile(file_id)%opened_before )  &
                THEN    ! needs modification in case of non-extendable sets
                   CALL local_system( 'mkdir  DATA_PRT_NETCDF' //              &
                                       TRIM( coupling_char ) // '/' )
                ENDIF
#if defined( __parallel )
! 
!--             Set a barrier in order to allow that all other processors in the
!--             directory created by PE0 can open their file
                CALL MPI_BARRIER( comm2d, ierr )
#endif
             ENDIF

!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_prt, .FALSE., 43 )

!
!--          Define the header
             CALL netcdf_define_header( 'pt', netcdf_extend, 0 )

          ENDIF

       CASE ( 109 )
!
!--       Set filename
          filename = 'DATA_1D_PTS_NETCDF' // TRIM( coupling_char )

!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its variables match the actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_pts, .FALSE., 393 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'ps', netcdf_extend, 0 )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_pts )
                CALL netcdf_handle_error( 'check_open', 394 )
                CALL local_system( 'rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_pts, .FALSE., 395 )
!
!--          Define the header
             CALL netcdf_define_header( 'ps', netcdf_extend, 0 )

          ENDIF


!
!--    Progress file that is used by the PALM watchdog
       CASE ( 117 )

          OPEN ( 117, FILE='PROGRESS'//TRIM( coupling_char ),                  &
                      STATUS='REPLACE', FORM='FORMATTED' )
!
!--    nc-file for virtual flight measurements
       CASE ( 199 )
!
!--       Set filename
          filename = 'DATA_1D_FL_NETCDF' // TRIM( coupling_char )

!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its variables match the actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_fl, .FALSE., 532 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'fl', netcdf_extend, 0 )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_fl )
                CALL netcdf_handle_error( 'check_open', 533 )
                CALL local_system( 'rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_fl, .FALSE., 534 )
!
!--          Define the header
             CALL netcdf_define_header( 'fl', netcdf_extend, 0 )

          ENDIF


       CASE ( 201:200+2*max_masks )
!
!--       Set filename depending on unit number
          IF ( file_id <= 200+max_masks )  THEN
             mid = file_id - 200
             WRITE ( mask_char,'(I2.2)')  mid
             filename = 'DATA_MASK_' // mask_char // '_NETCDF' //              &
                        TRIM( coupling_char )
             av = 0
          ELSE
             mid = file_id - (200+max_masks)
             WRITE ( mask_char,'(I2.2)')  mid
             filename = 'DATA_MASK_' // mask_char // '_AV_NETCDF' //           &
                        TRIM( coupling_char )
             av = 1
          ENDIF
!
!--       Inquire, if there is a netCDF file from a previuos run. This should
!--       be opened for extension, if its dimensions and variables match the
!--       actual run.
          INQUIRE( FILE=filename, EXIST=netcdf_extend )

          IF ( netcdf_extend )  THEN
!
!--          Open an existing netCDF file for output
             CALL netcdf_open_write_file( filename, id_set_mask(mid,av),       &
                                          .TRUE., 456 )
!
!--          Read header information and set all ids. If there is a mismatch
!--          between the previuos and the actual run, netcdf_extend is returned
!--          as .FALSE.
             CALL netcdf_define_header( 'ma', netcdf_extend, file_id )

!
!--          Remove the local file, if it can not be extended
             IF ( .NOT. netcdf_extend )  THEN
                nc_stat = NF90_CLOSE( id_set_mask(mid,av) )
                CALL netcdf_handle_error( 'check_open', 457 )
                CALL local_system('rm ' // TRIM( filename ) )
             ENDIF

          ENDIF          

          IF ( .NOT. netcdf_extend )  THEN
!
!--          Create a new netCDF output file with requested netCDF format
             CALL netcdf_create_file( filename, id_set_mask(mid,av), .TRUE., 458 )
!
!--          Define the header
             CALL netcdf_define_header( 'ma', netcdf_extend, file_id )

          ENDIF


#else

       CASE ( 101:109, 111:113, 116, 201:200+2*max_masks )

!
!--       Nothing is done in case of missing netcdf support
          RETURN

#endif

       CASE DEFAULT

          WRITE( message_string, * ) 'no OPEN-statement for file-id ',file_id
          CALL message( 'check_open', 'PA0172', 2, 2, -1, 6, 1 )

    END SELECT

!
!-- Set open flag
    openfile(file_id)%opened = .TRUE.

!
!-- Formats
3300 FORMAT ('#'/                                                              &
             'coord 1  file=',A,'  filetype=unformatted'/                      &
             'coord 2  file=',A,'  filetype=unformatted  skip=',I6/            &
             'coord 3  file=',A,'  filetype=unformatted  skip=',I6/            &
             '#')
4000 FORMAT ('# ',A)
5000 FORMAT ('# ',A/                                                           &
             '#1 E'/'#2 E*'/'#3 dt'/'#4 u*'/'#5 th*'/'#6 umax'/'#7 vmax'/      &
             '#8 wmax'/'#9 div_new'/'#10 div_old'/'#11 z_i_wpt'/'#12 z_i_pt'/  &
             '#13 w*'/'#14 w''pt''0'/'#15 w''pt'''/'#16 wpt'/'#17 pt(0)'/      &
             '#18 pt(zp)'/'#19 splptx'/'#20 splpty'/'#21 splptz')
8000 FORMAT (A/                                                                &
             '  step    time    # of parts     lPE sent/recv  rPE sent/recv  ',&
             'sPE sent/recv  nPE sent/recv    max # of parts  '/               &
             109('-'))

 END SUBROUTINE check_open
