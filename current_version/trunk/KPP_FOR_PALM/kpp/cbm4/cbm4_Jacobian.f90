! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! The ODE Jacobian of Chemical Model File
! 
! Generated by KPP-2.2.3 symbolic chemistry Kinetics PreProcessor
!       (http://www.cs.vt.edu/~asandu/Software/KPP)
! KPP is distributed under GPL, the general public licence
!       (http://www.gnu.org/copyleft/gpl.html)
! (C) 1995-1997, V. Damian & A. Sandu, CGRER, Univ. Iowa
! (C) 1997-2005, A. Sandu, Michigan Tech, Virginia Tech
!     With important contributions from:
!        M. Damian, Villanova University, USA
!        R. Sander, Max-Planck Institute for Chemistry, Mainz, Germany
! 
! File                 : cbm4_Jacobian.f90
! Time                 : Mon Mar  6 12:48:45 2017
! Working directory    : /pd/home/khan-b/palm/current_version/trunk/KPP_FOR_PALM/kpp/cbm
! Equation file        : cbm4.kpp
! Output root filename : cbm4
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



MODULE cbm4_Jacobian

  USE cbm4_Parameters
  USE cbm4_JacobianSP

  IMPLICIT NONE

CONTAINS


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Jac_SP - the Jacobian of Variables in sparse matrix representation
!   Arguments :
!      V         - Concentrations of variable species (local)
!      F         - Concentrations of fixed species (local)
!      RCT       - Rate constants (local)
!      JVS       - sparse Jacobian of variables
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Jac_SP ( V, F, RCT, JVS )

! V - Concentrations of variable species (local)
  REAL(kind=dp) :: V(NVAR)
! F - Concentrations of fixed species (local)
  REAL(kind=dp) :: F(NFIX)
! RCT - Rate constants (local)
  REAL(kind=dp) :: RCT(NREACT)
! JVS - sparse Jacobian of variables
  REAL(kind=dp) :: JVS(LU_NONZERO)


! Local variables
! B - Temporary array
  REAL(kind=dp) :: B(138)

! B(1) = dA(1)/dV(26)
  B(1) = RCT(1)
! B(2) = dA(2)/dV(29)
  B(2) = RCT(2)
! B(3) = dA(3)/dV(25)
  B(3) = RCT(3)*V(31)
! B(4) = dA(3)/dV(31)
  B(4) = RCT(3)*V(25)
! B(5) = dA(4)/dV(26)
  B(5) = 9.3e-12*V(29)
! B(6) = dA(4)/dV(29)
  B(6) = 9.3e-12*V(26)
! B(7) = dA(5)/dV(26)
  B(7) = RCT(5)*V(29)
! B(8) = dA(5)/dV(29)
  B(8) = RCT(5)*V(26)
! B(9) = dA(6)/dV(29)
  B(9) = RCT(6)*V(31)
! B(10) = dA(6)/dV(31)
  B(10) = RCT(6)*V(29)
! B(11) = dA(7)/dV(25)
  B(11) = RCT(7)*V(26)
! B(12) = dA(7)/dV(26)
  B(12) = RCT(7)*V(25)
! B(13) = dA(8)/dV(25)
  B(13) = RCT(8)
! B(14) = dA(9)/dV(25)
  B(14) = RCT(9)
! B(15) = dA(10)/dV(1)
  B(15) = RCT(10)
! B(16) = dA(11)/dV(1)
  B(16) = 2.2e-10*F(1)
! B(18) = dA(12)/dV(25)
  B(18) = RCT(12)*V(27)
! B(19) = dA(12)/dV(27)
  B(19) = RCT(12)*V(25)
! B(20) = dA(13)/dV(25)
  B(20) = RCT(13)*V(28)
! B(21) = dA(13)/dV(28)
  B(21) = RCT(13)*V(25)
! B(22) = dA(14)/dV(30)
  B(22) = RCT(14)
! B(23) = dA(15)/dV(30)
  B(23) = RCT(15)*V(31)
! B(24) = dA(15)/dV(31)
  B(24) = RCT(15)*V(30)
! B(25) = dA(16)/dV(26)
  B(25) = RCT(16)*V(30)
! B(26) = dA(16)/dV(30)
  B(26) = RCT(16)*V(26)
! B(27) = dA(17)/dV(26)
  B(27) = RCT(17)*V(30)
! B(28) = dA(17)/dV(30)
  B(28) = RCT(17)*V(26)
! B(29) = dA(18)/dV(6)
  B(29) = 1.3e-21*F(1)
! B(31) = dA(19)/dV(6)
  B(31) = RCT(19)
! B(32) = dA(20)/dV(31)
  B(32) = RCT(20)*2*V(31)
! B(33) = dA(21)/dV(26)
  B(33) = 4.39999e-40*V(31)*F(1)
! B(34) = dA(21)/dV(31)
  B(34) = 4.39999e-40*V(26)*F(1)
! B(36) = dA(22)/dV(27)
  B(36) = RCT(22)*V(31)
! B(37) = dA(22)/dV(31)
  B(37) = RCT(22)*V(27)
! B(38) = dA(23)/dV(9)
  B(38) = RCT(23)
! B(39) = dA(24)/dV(9)
  B(39) = 6.6e-12*V(27)
! B(40) = dA(24)/dV(27)
  B(40) = 6.6e-12*V(9)
! B(41) = dA(25)/dV(9)
  B(41) = 1e-20*2*V(9)
! B(42) = dA(26)/dV(26)
  B(42) = RCT(26)*V(27)
! B(43) = dA(26)/dV(27)
  B(43) = RCT(26)*V(26)
! B(44) = dA(27)/dV(12)
  B(44) = RCT(27)*V(27)
! B(45) = dA(27)/dV(27)
  B(45) = RCT(27)*V(12)
! B(46) = dA(28)/dV(28)
  B(46) = RCT(28)*V(31)
! B(47) = dA(28)/dV(31)
  B(47) = RCT(28)*V(28)
! B(48) = dA(29)/dV(26)
  B(48) = RCT(29)*V(28)
! B(49) = dA(29)/dV(28)
  B(49) = RCT(29)*V(26)
! B(50) = dA(30)/dV(10)
  B(50) = RCT(30)
! B(51) = dA(31)/dV(10)
  B(51) = RCT(31)*V(27)
! B(52) = dA(31)/dV(27)
  B(52) = RCT(31)*V(10)
! B(53) = dA(32)/dV(28)
  B(53) = RCT(32)*2*V(28)
! B(54) = dA(33)/dV(28)
  B(54) = RCT(33)*2*V(28)*F(1)
! B(56) = dA(34)/dV(2)
  B(56) = RCT(34)
! B(57) = dA(35)/dV(2)
  B(57) = RCT(35)*V(27)
! B(58) = dA(35)/dV(27)
  B(58) = RCT(35)*V(2)
! B(59) = dA(36)/dV(16)
  B(59) = 2.2e-13*V(27)
! B(60) = dA(36)/dV(27)
  B(60) = 2.2e-13*V(16)
! B(61) = dA(37)/dV(21)
  B(61) = 1e-11*V(27)
! B(62) = dA(37)/dV(27)
  B(62) = 1e-11*V(21)
! B(63) = dA(38)/dV(21)
  B(63) = RCT(38)
! B(64) = dA(39)/dV(21)
  B(64) = RCT(39)
! B(65) = dA(40)/dV(21)
  B(65) = RCT(40)*V(29)
! B(66) = dA(40)/dV(29)
  B(66) = RCT(40)*V(21)
! B(67) = dA(41)/dV(21)
  B(67) = 6.3e-16*V(30)
! B(68) = dA(41)/dV(30)
  B(68) = 6.3e-16*V(21)
! B(69) = dA(42)/dV(24)
  B(69) = RCT(42)*V(29)
! B(70) = dA(42)/dV(29)
  B(70) = RCT(42)*V(24)
! B(71) = dA(43)/dV(24)
  B(71) = RCT(43)*V(27)
! B(72) = dA(43)/dV(27)
  B(72) = RCT(43)*V(24)
! B(73) = dA(44)/dV(24)
  B(73) = 2.5e-15*V(30)
! B(74) = dA(44)/dV(30)
  B(74) = 2.5e-15*V(24)
! B(75) = dA(45)/dV(24)
  B(75) = RCT(45)
! B(76) = dA(46)/dV(31)
  B(76) = RCT(46)*V(32)
! B(77) = dA(46)/dV(32)
  B(77) = RCT(46)*V(31)
! B(78) = dA(47)/dV(26)
  B(78) = RCT(47)*V(32)
! B(79) = dA(47)/dV(32)
  B(79) = RCT(47)*V(26)
! B(80) = dA(48)/dV(3)
  B(80) = RCT(48)
! B(81) = dA(49)/dV(32)
  B(81) = 2e-12*2*V(32)
! B(82) = dA(50)/dV(28)
  B(82) = 6.5e-12*V(32)
! B(83) = dA(50)/dV(32)
  B(83) = 6.5e-12*V(28)
! B(84) = dA(51)/dV(27)
  B(84) = RCT(51)
! B(85) = dA(52)/dV(20)
  B(85) = 8.1e-13*V(27)
! B(86) = dA(52)/dV(27)
  B(86) = 8.1e-13*V(20)
! B(87) = dA(53)/dV(13)
  B(87) = RCT(53)
! B(88) = dA(54)/dV(13)
  B(88) = 1600
! B(89) = dA(55)/dV(13)
  B(89) = 1.5e-11*V(26)
! B(90) = dA(55)/dV(26)
  B(90) = 1.5e-11*V(13)
! B(91) = dA(56)/dV(23)
  B(91) = RCT(56)*V(29)
! B(92) = dA(56)/dV(29)
  B(92) = RCT(56)*V(23)
! B(93) = dA(57)/dV(23)
  B(93) = RCT(57)*V(27)
! B(94) = dA(57)/dV(27)
  B(94) = RCT(57)*V(23)
! B(95) = dA(58)/dV(23)
  B(95) = RCT(58)*V(25)
! B(96) = dA(58)/dV(25)
  B(96) = RCT(58)*V(23)
! B(97) = dA(59)/dV(23)
  B(97) = 7.7e-15*V(30)
! B(98) = dA(59)/dV(30)
  B(98) = 7.7e-15*V(23)
! B(99) = dA(60)/dV(17)
  B(99) = RCT(60)*V(29)
! B(100) = dA(60)/dV(29)
  B(100) = RCT(60)*V(17)
! B(101) = dA(61)/dV(17)
  B(101) = RCT(61)*V(27)
! B(102) = dA(61)/dV(27)
  B(102) = RCT(61)*V(17)
! B(103) = dA(62)/dV(17)
  B(103) = RCT(62)*V(25)
! B(104) = dA(62)/dV(25)
  B(104) = RCT(62)*V(17)
! B(105) = dA(63)/dV(5)
  B(105) = RCT(63)*V(27)
! B(106) = dA(63)/dV(27)
  B(106) = RCT(63)*V(5)
! B(107) = dA(64)/dV(11)
  B(107) = 8.1e-12*V(31)
! B(108) = dA(64)/dV(31)
  B(108) = 8.1e-12*V(11)
! B(109) = dA(65)/dV(11)
  B(109) = 4.2
! B(110) = dA(66)/dV(14)
  B(110) = 4.1e-11*V(27)
! B(111) = dA(66)/dV(27)
  B(111) = 4.1e-11*V(14)
! B(112) = dA(67)/dV(14)
  B(112) = 2.2e-11*V(30)
! B(113) = dA(67)/dV(30)
  B(113) = 2.2e-11*V(14)
! B(114) = dA(68)/dV(4)
  B(114) = 1.4e-11*V(26)
! B(115) = dA(68)/dV(26)
  B(115) = 1.4e-11*V(4)
! B(116) = dA(69)/dV(7)
  B(116) = RCT(69)*V(27)
! B(117) = dA(69)/dV(27)
  B(117) = RCT(69)*V(7)
! B(118) = dA(70)/dV(19)
  B(118) = 3e-11*V(27)
! B(119) = dA(70)/dV(27)
  B(119) = 3e-11*V(19)
! B(120) = dA(71)/dV(19)
  B(120) = RCT(71)
! B(121) = dA(72)/dV(19)
  B(121) = RCT(72)*V(25)
! B(122) = dA(72)/dV(25)
  B(122) = RCT(72)*V(19)
! B(123) = dA(73)/dV(15)
  B(123) = 1.7e-11*V(27)
! B(124) = dA(73)/dV(27)
  B(124) = 1.7e-11*V(15)
! B(125) = dA(74)/dV(15)
  B(125) = RCT(74)
! B(126) = dA(75)/dV(22)
  B(126) = 1.8e-11*V(29)
! B(127) = dA(75)/dV(29)
  B(127) = 1.8e-11*V(22)
! B(128) = dA(76)/dV(22)
  B(128) = 9.6e-11*V(27)
! B(129) = dA(76)/dV(27)
  B(129) = 9.6e-11*V(22)
! B(130) = dA(77)/dV(22)
  B(130) = 1.2e-17*V(25)
! B(131) = dA(77)/dV(25)
  B(131) = 1.2e-17*V(22)
! B(132) = dA(78)/dV(22)
  B(132) = 3.2e-13*V(30)
! B(133) = dA(78)/dV(30)
  B(133) = 3.2e-13*V(22)
! B(134) = dA(79)/dV(18)
  B(134) = 8.1e-12*V(31)
! B(135) = dA(79)/dV(31)
  B(135) = 8.1e-12*V(18)
! B(136) = dA(80)/dV(18)
  B(136) = RCT(80)*2*V(18)
! B(137) = dA(81)/dV(8)
  B(137) = 6.8e-13*V(31)
! B(138) = dA(81)/dV(31)
  B(138) = 6.8e-13*V(8)

! Construct the Jacobian terms from B's
! JVS(1) = Jac_FULL(1,1)
  JVS(1) = -B(15)-B(16)
! JVS(2) = Jac_FULL(1,25)
  JVS(2) = B(14)
! JVS(3) = Jac_FULL(2,2)
  JVS(3) = -B(56)-B(57)
! JVS(4) = Jac_FULL(2,27)
  JVS(4) = -B(58)
! JVS(5) = Jac_FULL(2,28)
  JVS(5) = B(53)+B(54)
! JVS(6) = Jac_FULL(3,3)
  JVS(6) = -B(80)
! JVS(7) = Jac_FULL(3,26)
  JVS(7) = B(78)
! JVS(8) = Jac_FULL(3,32)
  JVS(8) = B(79)
! JVS(9) = Jac_FULL(4,4)
  JVS(9) = -B(114)
! JVS(10) = Jac_FULL(4,14)
  JVS(10) = 0.4*B(110)+B(112)
! JVS(11) = Jac_FULL(4,26)
  JVS(11) = -B(115)
! JVS(12) = Jac_FULL(4,27)
  JVS(12) = 0.4*B(111)
! JVS(13) = Jac_FULL(4,30)
  JVS(13) = B(113)
! JVS(14) = Jac_FULL(5,5)
  JVS(14) = -B(105)
! JVS(15) = Jac_FULL(5,27)
  JVS(15) = -B(106)
! JVS(16) = Jac_FULL(6,6)
  JVS(16) = -B(29)-B(31)
! JVS(17) = Jac_FULL(6,26)
  JVS(17) = B(27)
! JVS(18) = Jac_FULL(6,30)
  JVS(18) = B(28)
! JVS(19) = Jac_FULL(7,7)
  JVS(19) = -B(116)
! JVS(20) = Jac_FULL(7,27)
  JVS(20) = -B(117)
! JVS(21) = Jac_FULL(8,8)
  JVS(21) = -B(137)
! JVS(22) = Jac_FULL(8,13)
  JVS(22) = 0.04*B(87)
! JVS(23) = Jac_FULL(8,20)
  JVS(23) = 0.13*B(85)
! JVS(24) = Jac_FULL(8,22)
  JVS(24) = 0.13*B(128)+B(132)
! JVS(25) = Jac_FULL(8,23)
  JVS(25) = 0.02*B(91)+0.09*B(97)
! JVS(26) = Jac_FULL(8,27)
  JVS(26) = 0.13*B(86)+0.13*B(129)
! JVS(27) = Jac_FULL(8,29)
  JVS(27) = 0.02*B(92)
! JVS(28) = Jac_FULL(8,30)
  JVS(28) = 0.09*B(98)+B(133)
! JVS(29) = Jac_FULL(8,31)
  JVS(29) = -B(138)
! JVS(30) = Jac_FULL(9,9)
  JVS(30) = -B(38)-B(39)-2*B(41)
! JVS(31) = Jac_FULL(9,26)
  JVS(31) = 2*B(33)
! JVS(32) = Jac_FULL(9,27)
  JVS(32) = B(36)-B(40)
! JVS(33) = Jac_FULL(9,31)
  JVS(33) = 2*B(34)+B(37)
! JVS(34) = Jac_FULL(10,10)
  JVS(34) = -B(50)-B(51)
! JVS(35) = Jac_FULL(10,26)
  JVS(35) = B(48)
! JVS(36) = Jac_FULL(10,27)
  JVS(36) = -B(52)
! JVS(37) = Jac_FULL(10,28)
  JVS(37) = B(49)
! JVS(38) = Jac_FULL(11,5)
  JVS(38) = 0.56*B(105)
! JVS(39) = Jac_FULL(11,7)
  JVS(39) = 0.3*B(116)
! JVS(40) = Jac_FULL(11,11)
  JVS(40) = -B(107)-B(109)
! JVS(41) = Jac_FULL(11,27)
  JVS(41) = 0.56*B(106)+0.3*B(117)
! JVS(42) = Jac_FULL(11,31)
  JVS(42) = -B(108)
! JVS(43) = Jac_FULL(12,6)
  JVS(43) = 2*B(29)
! JVS(44) = Jac_FULL(12,12)
  JVS(44) = -B(44)
! JVS(45) = Jac_FULL(12,14)
  JVS(45) = B(112)
! JVS(46) = Jac_FULL(12,21)
  JVS(46) = B(67)
! JVS(47) = Jac_FULL(12,24)
  JVS(47) = B(73)
! JVS(48) = Jac_FULL(12,26)
  JVS(48) = B(42)
! JVS(49) = Jac_FULL(12,27)
  JVS(49) = B(43)-B(45)
! JVS(50) = Jac_FULL(12,30)
  JVS(50) = B(68)+B(74)+B(113)
! JVS(51) = Jac_FULL(13,13)
  JVS(51) = -0.98*B(87)-B(88)-B(89)
! JVS(52) = Jac_FULL(13,20)
  JVS(52) = 0.76*B(85)
! JVS(53) = Jac_FULL(13,26)
  JVS(53) = -B(90)
! JVS(54) = Jac_FULL(13,27)
  JVS(54) = 0.76*B(86)
! JVS(55) = Jac_FULL(14,5)
  JVS(55) = 0.36*B(105)
! JVS(56) = Jac_FULL(14,7)
  JVS(56) = 0.2*B(116)
! JVS(57) = Jac_FULL(14,11)
  JVS(57) = B(109)
! JVS(58) = Jac_FULL(14,14)
  JVS(58) = -B(110)-B(112)
! JVS(59) = Jac_FULL(14,27)
  JVS(59) = 0.36*B(106)-B(111)+0.2*B(117)
! JVS(60) = Jac_FULL(14,30)
  JVS(60) = -B(113)
! JVS(61) = Jac_FULL(14,31)
  JVS(61) = 0
! JVS(62) = Jac_FULL(15,7)
  JVS(62) = 0.8*B(116)
! JVS(63) = Jac_FULL(15,15)
  JVS(63) = -B(123)-B(125)
! JVS(64) = Jac_FULL(15,19)
  JVS(64) = 0.2*B(121)
! JVS(65) = Jac_FULL(15,22)
  JVS(65) = 0.4*B(128)+0.2*B(130)
! JVS(66) = Jac_FULL(15,25)
  JVS(66) = 0.2*B(122)+0.2*B(131)
! JVS(67) = Jac_FULL(15,27)
  JVS(67) = 0.8*B(117)-B(124)+0.4*B(129)
! JVS(68) = Jac_FULL(16,15)
  JVS(68) = B(125)
! JVS(69) = Jac_FULL(16,16)
  JVS(69) = -B(59)
! JVS(70) = Jac_FULL(16,17)
  JVS(70) = B(99)+0.42*B(103)
! JVS(71) = Jac_FULL(16,19)
  JVS(71) = 2*B(118)+B(120)+0.69*B(121)
! JVS(72) = Jac_FULL(16,21)
  JVS(72) = B(61)+B(63)+B(64)+B(65)+B(67)
! JVS(73) = Jac_FULL(16,22)
  JVS(73) = 0.5*B(126)+0.06*B(130)
! JVS(74) = Jac_FULL(16,23)
  JVS(74) = 0.3*B(91)+0.33*B(95)
! JVS(75) = Jac_FULL(16,24)
  JVS(75) = B(75)
! JVS(76) = Jac_FULL(16,25)
  JVS(76) = 0.33*B(96)+0.42*B(104)+0.69*B(122)+0.06*B(131)
! JVS(77) = Jac_FULL(16,27)
  JVS(77) = -B(60)+B(62)+2*B(119)
! JVS(78) = Jac_FULL(16,29)
  JVS(78) = B(66)+0.3*B(92)+B(100)+0.5*B(127)
! JVS(79) = Jac_FULL(16,30)
  JVS(79) = B(68)
! JVS(80) = Jac_FULL(17,17)
  JVS(80) = -B(99)-B(101)-B(103)
! JVS(81) = Jac_FULL(17,22)
  JVS(81) = 0.45*B(126)+B(128)+0.55*B(130)
! JVS(82) = Jac_FULL(17,25)
  JVS(82) = -B(104)+0.55*B(131)
! JVS(83) = Jac_FULL(17,27)
  JVS(83) = -B(102)+B(129)
! JVS(84) = Jac_FULL(17,29)
  JVS(84) = -B(100)+0.45*B(127)
! JVS(85) = Jac_FULL(18,5)
  JVS(85) = 0.08*B(105)
! JVS(86) = Jac_FULL(18,7)
  JVS(86) = 0.5*B(116)
! JVS(87) = Jac_FULL(18,13)
  JVS(87) = 0.96*B(87)
! JVS(88) = Jac_FULL(18,14)
  JVS(88) = 0.6*B(110)
! JVS(89) = Jac_FULL(18,15)
  JVS(89) = B(123)
! JVS(90) = Jac_FULL(18,17)
  JVS(90) = 0.7*B(99)+B(101)
! JVS(91) = Jac_FULL(18,18)
  JVS(91) = -B(134)-2*B(136)
! JVS(92) = Jac_FULL(18,19)
  JVS(92) = B(118)+0.03*B(121)
! JVS(93) = Jac_FULL(18,20)
  JVS(93) = 0.87*B(85)
! JVS(94) = Jac_FULL(18,22)
  JVS(94) = 0.5*B(126)+B(128)
! JVS(95) = Jac_FULL(18,23)
  JVS(95) = 0.28*B(91)+B(93)+0.22*B(95)+0.91*B(97)
! JVS(96) = Jac_FULL(18,24)
  JVS(96) = B(75)
! JVS(97) = Jac_FULL(18,25)
  JVS(97) = 0.22*B(96)+0.03*B(122)
! JVS(98) = Jac_FULL(18,26)
  JVS(98) = 0
! JVS(99) = Jac_FULL(18,27)
  JVS(99) = B(84)+0.87*B(86)+B(94)+B(102)+0.08*B(106)+0.6*B(111)+0.5*B(117)+B(119)+B(124)+B(129)
! JVS(100) = Jac_FULL(18,28)
  JVS(100) = 0.79*B(82)
! JVS(101) = Jac_FULL(18,29)
  JVS(101) = 0.28*B(92)+0.7*B(100)+0.5*B(127)
! JVS(102) = Jac_FULL(18,30)
  JVS(102) = 0.91*B(98)
! JVS(103) = Jac_FULL(18,31)
  JVS(103) = B(76)-B(135)
! JVS(104) = Jac_FULL(18,32)
  JVS(104) = B(77)+2*B(81)+0.79*B(83)
! JVS(105) = Jac_FULL(19,11)
  JVS(105) = 0.9*B(107)
! JVS(106) = Jac_FULL(19,14)
  JVS(106) = 0.3*B(110)
! JVS(107) = Jac_FULL(19,19)
  JVS(107) = -B(118)-B(120)-B(121)
! JVS(108) = Jac_FULL(19,25)
  JVS(108) = -B(122)
! JVS(109) = Jac_FULL(19,27)
  JVS(109) = 0.3*B(111)-B(119)
! JVS(110) = Jac_FULL(19,30)
  JVS(110) = 0
! JVS(111) = Jac_FULL(19,31)
  JVS(111) = 0.9*B(108)
! JVS(112) = Jac_FULL(20,7)
  JVS(112) = 1.1*B(116)
! JVS(113) = Jac_FULL(20,13)
  JVS(113) = -2.1*B(87)
! JVS(114) = Jac_FULL(20,20)
  JVS(114) = -1.11*B(85)
! JVS(115) = Jac_FULL(20,22)
  JVS(115) = 0.9*B(126)+0.1*B(130)
! JVS(116) = Jac_FULL(20,23)
  JVS(116) = 0.22*B(91)-B(93)-B(95)-B(97)
! JVS(117) = Jac_FULL(20,25)
  JVS(117) = -B(96)+0.1*B(131)
! JVS(118) = Jac_FULL(20,26)
  JVS(118) = 0
! JVS(119) = Jac_FULL(20,27)
  JVS(119) = -1.11*B(86)-B(94)+1.1*B(117)
! JVS(120) = Jac_FULL(20,29)
  JVS(120) = 0.22*B(92)+0.9*B(127)
! JVS(121) = Jac_FULL(20,30)
  JVS(121) = -B(98)
! JVS(122) = Jac_FULL(21,17)
  JVS(122) = B(99)+1.56*B(101)+B(103)
! JVS(123) = Jac_FULL(21,19)
  JVS(123) = B(118)+0.7*B(121)
! JVS(124) = Jac_FULL(21,21)
  JVS(124) = -B(61)-B(63)-B(64)-B(65)-B(67)
! JVS(125) = Jac_FULL(21,22)
  JVS(125) = B(128)+B(130)
! JVS(126) = Jac_FULL(21,23)
  JVS(126) = 0.2*B(91)+B(93)+0.74*B(95)+B(97)
! JVS(127) = Jac_FULL(21,24)
  JVS(127) = B(75)
! JVS(128) = Jac_FULL(21,25)
  JVS(128) = 0.74*B(96)+B(104)+0.7*B(122)+B(131)
! JVS(129) = Jac_FULL(21,27)
  JVS(129) = -B(62)+B(84)+B(94)+1.56*B(102)+B(119)+B(129)
! JVS(130) = Jac_FULL(21,28)
  JVS(130) = 0.79*B(82)
! JVS(131) = Jac_FULL(21,29)
  JVS(131) = -B(66)+0.2*B(92)+B(100)
! JVS(132) = Jac_FULL(21,30)
  JVS(132) = -B(68)+B(98)
! JVS(133) = Jac_FULL(21,31)
  JVS(133) = B(76)
! JVS(134) = Jac_FULL(21,32)
  JVS(134) = B(77)+2*B(81)+0.79*B(83)
! JVS(135) = Jac_FULL(22,22)
  JVS(135) = -B(126)-B(128)-B(130)-B(132)
! JVS(136) = Jac_FULL(22,25)
  JVS(136) = -B(131)
! JVS(137) = Jac_FULL(22,27)
  JVS(137) = -B(129)
! JVS(138) = Jac_FULL(22,29)
  JVS(138) = -B(127)
! JVS(139) = Jac_FULL(22,30)
  JVS(139) = -B(133)
! JVS(140) = Jac_FULL(23,22)
  JVS(140) = 0.55*B(126)
! JVS(141) = Jac_FULL(23,23)
  JVS(141) = -B(91)-B(93)-B(95)-B(97)
! JVS(142) = Jac_FULL(23,25)
  JVS(142) = -B(96)
! JVS(143) = Jac_FULL(23,27)
  JVS(143) = -B(94)
! JVS(144) = Jac_FULL(23,29)
  JVS(144) = -B(92)+0.55*B(127)
! JVS(145) = Jac_FULL(23,30)
  JVS(145) = -B(98)
! JVS(146) = Jac_FULL(24,13)
  JVS(146) = 1.1*B(87)
! JVS(147) = Jac_FULL(24,17)
  JVS(147) = 0.22*B(101)
! JVS(148) = Jac_FULL(24,19)
  JVS(148) = 0.03*B(121)
! JVS(149) = Jac_FULL(24,20)
  JVS(149) = 0.11*B(85)
! JVS(150) = Jac_FULL(24,22)
  JVS(150) = 0.8*B(126)+0.2*B(128)+0.4*B(130)
! JVS(151) = Jac_FULL(24,23)
  JVS(151) = 0.63*B(91)+B(93)+0.5*B(95)+B(97)
! JVS(152) = Jac_FULL(24,24)
  JVS(152) = -B(69)-B(71)-B(73)-B(75)
! JVS(153) = Jac_FULL(24,25)
  JVS(153) = 0.5*B(96)+0.03*B(122)+0.4*B(131)
! JVS(154) = Jac_FULL(24,26)
  JVS(154) = 0
! JVS(155) = Jac_FULL(24,27)
  JVS(155) = -B(72)+0.11*B(86)+B(94)+0.22*B(102)+0.2*B(129)
! JVS(156) = Jac_FULL(24,29)
  JVS(156) = -B(70)+0.63*B(92)+0.8*B(127)
! JVS(157) = Jac_FULL(24,30)
  JVS(157) = -B(74)+B(98)
! JVS(158) = Jac_FULL(24,31)
  JVS(158) = 0
! JVS(159) = Jac_FULL(25,17)
  JVS(159) = -B(103)
! JVS(160) = Jac_FULL(25,19)
  JVS(160) = -B(121)
! JVS(161) = Jac_FULL(25,22)
  JVS(161) = -B(130)
! JVS(162) = Jac_FULL(25,23)
  JVS(162) = -B(95)
! JVS(163) = Jac_FULL(25,25)
  JVS(163) = -B(3)-B(11)-B(13)-B(14)-B(18)-B(20)-B(96)-B(104)-B(122)-B(131)
! JVS(164) = Jac_FULL(25,26)
  JVS(164) = -B(12)
! JVS(165) = Jac_FULL(25,27)
  JVS(165) = -B(19)
! JVS(166) = Jac_FULL(25,28)
  JVS(166) = -B(21)
! JVS(167) = Jac_FULL(25,29)
  JVS(167) = B(2)
! JVS(168) = Jac_FULL(25,30)
  JVS(168) = 0
! JVS(169) = Jac_FULL(25,31)
  JVS(169) = -B(4)
! JVS(170) = Jac_FULL(26,3)
  JVS(170) = B(80)
! JVS(171) = Jac_FULL(26,4)
  JVS(171) = -B(114)
! JVS(172) = Jac_FULL(26,6)
  JVS(172) = B(31)
! JVS(173) = Jac_FULL(26,9)
  JVS(173) = B(39)+B(41)
! JVS(174) = Jac_FULL(26,10)
  JVS(174) = B(50)+B(51)
! JVS(175) = Jac_FULL(26,11)
  JVS(175) = 0.9*B(107)
! JVS(176) = Jac_FULL(26,13)
  JVS(176) = -B(89)
! JVS(177) = Jac_FULL(26,14)
  JVS(177) = 0
! JVS(178) = Jac_FULL(26,18)
  JVS(178) = B(134)
! JVS(179) = Jac_FULL(26,19)
  JVS(179) = 0
! JVS(180) = Jac_FULL(26,20)
  JVS(180) = 0
! JVS(181) = Jac_FULL(26,22)
  JVS(181) = 0
! JVS(182) = Jac_FULL(26,23)
  JVS(182) = B(97)
! JVS(183) = Jac_FULL(26,24)
  JVS(183) = 0
! JVS(184) = Jac_FULL(26,25)
  JVS(184) = B(3)-B(11)
! JVS(185) = Jac_FULL(26,26)
  JVS(185) = -B(1)-B(5)-B(7)-B(12)-B(27)-B(33)-B(42)-B(48)-B(78)-B(90)-B(115)
! JVS(186) = Jac_FULL(26,27)
  JVS(186) = B(40)-B(43)+B(52)
! JVS(187) = Jac_FULL(26,28)
  JVS(187) = B(46)-B(49)
! JVS(188) = Jac_FULL(26,29)
  JVS(188) = -B(6)-B(8)+B(9)
! JVS(189) = Jac_FULL(26,30)
  JVS(189) = 0.89*B(22)+2*B(23)-B(28)+B(98)
! JVS(190) = Jac_FULL(26,31)
  JVS(190) = B(4)+B(10)+2*B(24)+2*B(32)-B(34)+B(47)+B(76)+0.9*B(108)+B(135)
! JVS(191) = Jac_FULL(26,32)
  JVS(191) = B(77)-B(79)
! JVS(192) = Jac_FULL(27,1)
  JVS(192) = 2*B(16)
! JVS(193) = Jac_FULL(27,2)
  JVS(193) = 2*B(56)-B(57)
! JVS(194) = Jac_FULL(27,5)
  JVS(194) = -B(105)
! JVS(195) = Jac_FULL(27,7)
  JVS(195) = -B(116)
! JVS(196) = Jac_FULL(27,9)
  JVS(196) = B(38)-B(39)
! JVS(197) = Jac_FULL(27,10)
  JVS(197) = -B(51)
! JVS(198) = Jac_FULL(27,12)
  JVS(198) = -B(44)
! JVS(199) = Jac_FULL(27,14)
  JVS(199) = -B(110)
! JVS(200) = Jac_FULL(27,15)
  JVS(200) = -B(123)
! JVS(201) = Jac_FULL(27,16)
  JVS(201) = -B(59)
! JVS(202) = Jac_FULL(27,17)
  JVS(202) = 0.3*B(99)-B(101)
! JVS(203) = Jac_FULL(27,19)
  JVS(203) = -B(118)+0.08*B(121)
! JVS(204) = Jac_FULL(27,20)
  JVS(204) = -B(85)
! JVS(205) = Jac_FULL(27,21)
  JVS(205) = -B(61)+B(65)
! JVS(206) = Jac_FULL(27,22)
  JVS(206) = -B(128)+0.1*B(130)
! JVS(207) = Jac_FULL(27,23)
  JVS(207) = 0.2*B(91)-B(93)+0.1*B(95)
! JVS(208) = Jac_FULL(27,24)
  JVS(208) = B(69)-B(71)
! JVS(209) = Jac_FULL(27,25)
  JVS(209) = -B(18)+B(20)+0.1*B(96)+0.08*B(122)+0.1*B(131)
! JVS(210) = Jac_FULL(27,26)
  JVS(210) = -B(42)
! JVS(211) = Jac_FULL(27,27)
  JVS(211) = -B(19)-B(36)-B(40)-B(43)-B(45)-B(52)-B(58)-B(60)-B(62)-B(72)-B(84)-B(86)-B(94)-B(102)-B(106)-B(111)-B(117)&
               &-B(119)-B(124)-B(129)
! JVS(212) = Jac_FULL(27,28)
  JVS(212) = B(21)+B(46)+0.79*B(82)
! JVS(213) = Jac_FULL(27,29)
  JVS(213) = B(66)+B(70)+0.2*B(92)+0.3*B(100)
! JVS(214) = Jac_FULL(27,30)
  JVS(214) = 0
! JVS(215) = Jac_FULL(27,31)
  JVS(215) = -B(37)+B(47)
! JVS(216) = Jac_FULL(27,32)
  JVS(216) = 0.79*B(83)
! JVS(217) = Jac_FULL(28,2)
  JVS(217) = B(57)
! JVS(218) = Jac_FULL(28,5)
  JVS(218) = 0.44*B(105)
! JVS(219) = Jac_FULL(28,7)
  JVS(219) = 0.7*B(116)
! JVS(220) = Jac_FULL(28,10)
  JVS(220) = B(50)
! JVS(221) = Jac_FULL(28,11)
  JVS(221) = 0.9*B(107)+B(109)
! JVS(222) = Jac_FULL(28,13)
  JVS(222) = 0.94*B(87)+B(88)
! JVS(223) = Jac_FULL(28,14)
  JVS(223) = 0.6*B(110)
! JVS(224) = Jac_FULL(28,15)
  JVS(224) = B(125)
! JVS(225) = Jac_FULL(28,16)
  JVS(225) = B(59)
! JVS(226) = Jac_FULL(28,17)
  JVS(226) = 1.7*B(99)+B(101)+0.12*B(103)
! JVS(227) = Jac_FULL(28,19)
  JVS(227) = 2*B(118)+B(120)+0.76*B(121)
! JVS(228) = Jac_FULL(28,20)
  JVS(228) = 0.11*B(85)
! JVS(229) = Jac_FULL(28,21)
  JVS(229) = B(61)+2*B(63)+B(65)+B(67)
! JVS(230) = Jac_FULL(28,22)
  JVS(230) = 0.6*B(126)+0.67*B(128)+0.44*B(130)
! JVS(231) = Jac_FULL(28,23)
  JVS(231) = 0.38*B(91)+B(93)+0.44*B(95)
! JVS(232) = Jac_FULL(28,24)
  JVS(232) = 2*B(75)
! JVS(233) = Jac_FULL(28,25)
  JVS(233) = B(18)-B(20)+0.44*B(96)+0.12*B(104)+0.76*B(122)+0.44*B(131)
! JVS(234) = Jac_FULL(28,26)
  JVS(234) = -B(48)
! JVS(235) = Jac_FULL(28,27)
  JVS(235) = B(19)+B(58)+B(60)+B(62)+B(84)+0.11*B(86)+B(94)+B(102)+0.44*B(106)+0.6*B(111)+0.7*B(117)+2*B(119)+0.67&
               &*B(129)
! JVS(236) = Jac_FULL(28,28)
  JVS(236) = -B(21)-B(46)-B(49)-2*B(53)-2*B(54)-0.21*B(82)
! JVS(237) = Jac_FULL(28,29)
  JVS(237) = B(66)+0.38*B(92)+1.7*B(100)+0.6*B(127)
! JVS(238) = Jac_FULL(28,30)
  JVS(238) = B(68)
! JVS(239) = Jac_FULL(28,31)
  JVS(239) = -B(47)+B(76)+0.9*B(108)
! JVS(240) = Jac_FULL(28,32)
  JVS(240) = B(77)+2*B(81)-0.21*B(83)
! JVS(241) = Jac_FULL(29,1)
  JVS(241) = B(15)
! JVS(242) = Jac_FULL(29,17)
  JVS(242) = -B(99)
! JVS(243) = Jac_FULL(29,21)
  JVS(243) = -B(65)
! JVS(244) = Jac_FULL(29,22)
  JVS(244) = -B(126)
! JVS(245) = Jac_FULL(29,23)
  JVS(245) = -B(91)
! JVS(246) = Jac_FULL(29,24)
  JVS(246) = -B(69)
! JVS(247) = Jac_FULL(29,25)
  JVS(247) = B(13)
! JVS(248) = Jac_FULL(29,26)
  JVS(248) = B(1)-B(5)-B(7)
! JVS(249) = Jac_FULL(29,27)
  JVS(249) = 0
! JVS(250) = Jac_FULL(29,28)
  JVS(250) = 0
! JVS(251) = Jac_FULL(29,29)
  JVS(251) = -B(2)-B(6)-B(8)-B(9)-B(66)-B(70)-B(92)-B(100)-B(127)
! JVS(252) = Jac_FULL(29,30)
  JVS(252) = 0.89*B(22)
! JVS(253) = Jac_FULL(29,31)
  JVS(253) = -B(10)
! JVS(254) = Jac_FULL(29,32)
  JVS(254) = 0
! JVS(255) = Jac_FULL(30,6)
  JVS(255) = B(31)
! JVS(256) = Jac_FULL(30,12)
  JVS(256) = B(44)
! JVS(257) = Jac_FULL(30,14)
  JVS(257) = -B(112)
! JVS(258) = Jac_FULL(30,21)
  JVS(258) = -B(67)
! JVS(259) = Jac_FULL(30,22)
  JVS(259) = -B(132)
! JVS(260) = Jac_FULL(30,23)
  JVS(260) = -B(97)
! JVS(261) = Jac_FULL(30,24)
  JVS(261) = -B(73)
! JVS(262) = Jac_FULL(30,25)
  JVS(262) = B(11)
! JVS(263) = Jac_FULL(30,26)
  JVS(263) = B(7)+B(12)-B(25)-B(27)
! JVS(264) = Jac_FULL(30,27)
  JVS(264) = B(45)
! JVS(265) = Jac_FULL(30,28)
  JVS(265) = 0
! JVS(266) = Jac_FULL(30,29)
  JVS(266) = B(8)
! JVS(267) = Jac_FULL(30,30)
  JVS(267) = -B(22)-B(23)-B(26)-B(28)-B(68)-B(74)-B(98)-B(113)-B(133)
! JVS(268) = Jac_FULL(30,31)
  JVS(268) = -B(24)
! JVS(269) = Jac_FULL(30,32)
  JVS(269) = 0
! JVS(270) = Jac_FULL(31,8)
  JVS(270) = -B(137)
! JVS(271) = Jac_FULL(31,9)
  JVS(271) = B(38)+B(41)
! JVS(272) = Jac_FULL(31,11)
  JVS(272) = -B(107)
! JVS(273) = Jac_FULL(31,13)
  JVS(273) = 0
! JVS(274) = Jac_FULL(31,18)
  JVS(274) = -B(134)
! JVS(275) = Jac_FULL(31,19)
  JVS(275) = 0
! JVS(276) = Jac_FULL(31,20)
  JVS(276) = 0
! JVS(277) = Jac_FULL(31,22)
  JVS(277) = 0
! JVS(278) = Jac_FULL(31,23)
  JVS(278) = 0
! JVS(279) = Jac_FULL(31,24)
  JVS(279) = 0
! JVS(280) = Jac_FULL(31,25)
  JVS(280) = -B(3)
! JVS(281) = Jac_FULL(31,26)
  JVS(281) = B(1)+B(5)+B(25)-B(33)
! JVS(282) = Jac_FULL(31,27)
  JVS(282) = -B(36)
! JVS(283) = Jac_FULL(31,28)
  JVS(283) = -B(46)
! JVS(284) = Jac_FULL(31,29)
  JVS(284) = B(6)-B(9)
! JVS(285) = Jac_FULL(31,30)
  JVS(285) = 0.11*B(22)-B(23)+B(26)
! JVS(286) = Jac_FULL(31,31)
  JVS(286) = -B(4)-B(10)-B(24)-2*B(32)-B(34)-B(37)-B(47)-B(76)-B(108)-B(135)-B(138)
! JVS(287) = Jac_FULL(31,32)
  JVS(287) = -B(77)
! JVS(288) = Jac_FULL(32,3)
  JVS(288) = B(80)
! JVS(289) = Jac_FULL(32,15)
  JVS(289) = B(123)+B(125)
! JVS(290) = Jac_FULL(32,19)
  JVS(290) = B(118)+B(120)+0.62*B(121)
! JVS(291) = Jac_FULL(32,22)
  JVS(291) = 0.2*B(128)
! JVS(292) = Jac_FULL(32,24)
  JVS(292) = B(69)+B(71)+B(73)
! JVS(293) = Jac_FULL(32,25)
  JVS(293) = 0.62*B(122)
! JVS(294) = Jac_FULL(32,26)
  JVS(294) = -B(78)
! JVS(295) = Jac_FULL(32,27)
  JVS(295) = B(72)+B(119)+B(124)+0.2*B(129)
! JVS(296) = Jac_FULL(32,28)
  JVS(296) = -B(82)
! JVS(297) = Jac_FULL(32,29)
  JVS(297) = B(70)
! JVS(298) = Jac_FULL(32,30)
  JVS(298) = B(74)
! JVS(299) = Jac_FULL(32,31)
  JVS(299) = -B(76)
! JVS(300) = Jac_FULL(32,32)
  JVS(300) = -B(77)-B(79)-2*B(81)-B(83)
      
END SUBROUTINE Jac_SP

! End of Jac_SP function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Jac_SP_Vec - function for sparse multiplication: sparse Jacobian times vector
!   Arguments :
!      JVS       - sparse Jacobian of variables
!      UV        - User vector for variables
!      JUV       - Jacobian times user vector
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Jac_SP_Vec ( JVS, UV, JUV )

! JVS - sparse Jacobian of variables
  REAL(kind=dp) :: JVS(LU_NONZERO)
! UV - User vector for variables
  REAL(kind=dp) :: UV(NVAR)
! JUV - Jacobian times user vector
  REAL(kind=dp) :: JUV(NVAR)

  JUV(1) = JVS(1)*UV(1)+JVS(2)*UV(25)
  JUV(2) = JVS(3)*UV(2)+JVS(4)*UV(27)+JVS(5)*UV(28)
  JUV(3) = JVS(6)*UV(3)+JVS(7)*UV(26)+JVS(8)*UV(32)
  JUV(4) = JVS(9)*UV(4)+JVS(10)*UV(14)+JVS(11)*UV(26)+JVS(12)*UV(27)+JVS(13)*UV(30)
  JUV(5) = JVS(14)*UV(5)+JVS(15)*UV(27)
  JUV(6) = JVS(16)*UV(6)+JVS(17)*UV(26)+JVS(18)*UV(30)
  JUV(7) = JVS(19)*UV(7)+JVS(20)*UV(27)
  JUV(8) = JVS(21)*UV(8)+JVS(22)*UV(13)+JVS(23)*UV(20)+JVS(24)*UV(22)+JVS(25)*UV(23)+JVS(26)*UV(27)+JVS(27)*UV(29)&
             &+JVS(28)*UV(30)+JVS(29)*UV(31)
  JUV(9) = JVS(30)*UV(9)+JVS(31)*UV(26)+JVS(32)*UV(27)+JVS(33)*UV(31)
  JUV(10) = JVS(34)*UV(10)+JVS(35)*UV(26)+JVS(36)*UV(27)+JVS(37)*UV(28)
  JUV(11) = JVS(38)*UV(5)+JVS(39)*UV(7)+JVS(40)*UV(11)+JVS(41)*UV(27)+JVS(42)*UV(31)
  JUV(12) = JVS(43)*UV(6)+JVS(44)*UV(12)+JVS(45)*UV(14)+JVS(46)*UV(21)+JVS(47)*UV(24)+JVS(48)*UV(26)+JVS(49)*UV(27)&
              &+JVS(50)*UV(30)
  JUV(13) = JVS(51)*UV(13)+JVS(52)*UV(20)+JVS(53)*UV(26)+JVS(54)*UV(27)
  JUV(14) = JVS(55)*UV(5)+JVS(56)*UV(7)+JVS(57)*UV(11)+JVS(58)*UV(14)+JVS(59)*UV(27)+JVS(60)*UV(30)
  JUV(15) = JVS(62)*UV(7)+JVS(63)*UV(15)+JVS(64)*UV(19)+JVS(65)*UV(22)+JVS(66)*UV(25)+JVS(67)*UV(27)
  JUV(16) = JVS(68)*UV(15)+JVS(69)*UV(16)+JVS(70)*UV(17)+JVS(71)*UV(19)+JVS(72)*UV(21)+JVS(73)*UV(22)+JVS(74)*UV(23)&
              &+JVS(75)*UV(24)+JVS(76)*UV(25)+JVS(77)*UV(27)+JVS(78)*UV(29)+JVS(79)*UV(30)
  JUV(17) = JVS(80)*UV(17)+JVS(81)*UV(22)+JVS(82)*UV(25)+JVS(83)*UV(27)+JVS(84)*UV(29)
  JUV(18) = JVS(85)*UV(5)+JVS(86)*UV(7)+JVS(87)*UV(13)+JVS(88)*UV(14)+JVS(89)*UV(15)+JVS(90)*UV(17)+JVS(91)*UV(18)&
              &+JVS(92)*UV(19)+JVS(93)*UV(20)+JVS(94)*UV(22)+JVS(95)*UV(23)+JVS(96)*UV(24)+JVS(97)*UV(25)+JVS(99)*UV(27)&
              &+JVS(100)*UV(28)+JVS(101)*UV(29)+JVS(102)*UV(30)+JVS(103)*UV(31)+JVS(104)*UV(32)
  JUV(19) = JVS(105)*UV(11)+JVS(106)*UV(14)+JVS(107)*UV(19)+JVS(108)*UV(25)+JVS(109)*UV(27)+JVS(111)*UV(31)
  JUV(20) = JVS(112)*UV(7)+JVS(113)*UV(13)+JVS(114)*UV(20)+JVS(115)*UV(22)+JVS(116)*UV(23)+JVS(117)*UV(25)+JVS(119)&
              &*UV(27)+JVS(120)*UV(29)+JVS(121)*UV(30)
  JUV(21) = JVS(122)*UV(17)+JVS(123)*UV(19)+JVS(124)*UV(21)+JVS(125)*UV(22)+JVS(126)*UV(23)+JVS(127)*UV(24)+JVS(128)&
              &*UV(25)+JVS(129)*UV(27)+JVS(130)*UV(28)+JVS(131)*UV(29)+JVS(132)*UV(30)+JVS(133)*UV(31)+JVS(134)*UV(32)
  JUV(22) = JVS(135)*UV(22)+JVS(136)*UV(25)+JVS(137)*UV(27)+JVS(138)*UV(29)+JVS(139)*UV(30)
  JUV(23) = JVS(140)*UV(22)+JVS(141)*UV(23)+JVS(142)*UV(25)+JVS(143)*UV(27)+JVS(144)*UV(29)+JVS(145)*UV(30)
  JUV(24) = JVS(146)*UV(13)+JVS(147)*UV(17)+JVS(148)*UV(19)+JVS(149)*UV(20)+JVS(150)*UV(22)+JVS(151)*UV(23)+JVS(152)&
              &*UV(24)+JVS(153)*UV(25)+JVS(155)*UV(27)+JVS(156)*UV(29)+JVS(157)*UV(30)
  JUV(25) = JVS(159)*UV(17)+JVS(160)*UV(19)+JVS(161)*UV(22)+JVS(162)*UV(23)+JVS(163)*UV(25)+JVS(164)*UV(26)+JVS(165)&
              &*UV(27)+JVS(166)*UV(28)+JVS(167)*UV(29)+JVS(169)*UV(31)
  JUV(26) = JVS(170)*UV(3)+JVS(171)*UV(4)+JVS(172)*UV(6)+JVS(173)*UV(9)+JVS(174)*UV(10)+JVS(175)*UV(11)+JVS(176)*UV(13)&
              &+JVS(178)*UV(18)+JVS(182)*UV(23)+JVS(184)*UV(25)+JVS(185)*UV(26)+JVS(186)*UV(27)+JVS(187)*UV(28)+JVS(188)&
              &*UV(29)+JVS(189)*UV(30)+JVS(190)*UV(31)+JVS(191)*UV(32)
  JUV(27) = JVS(192)*UV(1)+JVS(193)*UV(2)+JVS(194)*UV(5)+JVS(195)*UV(7)+JVS(196)*UV(9)+JVS(197)*UV(10)+JVS(198)*UV(12)&
              &+JVS(199)*UV(14)+JVS(200)*UV(15)+JVS(201)*UV(16)+JVS(202)*UV(17)+JVS(203)*UV(19)+JVS(204)*UV(20)+JVS(205)&
              &*UV(21)+JVS(206)*UV(22)+JVS(207)*UV(23)+JVS(208)*UV(24)+JVS(209)*UV(25)+JVS(210)*UV(26)+JVS(211)*UV(27)&
              &+JVS(212)*UV(28)+JVS(213)*UV(29)+JVS(215)*UV(31)+JVS(216)*UV(32)
  JUV(28) = JVS(217)*UV(2)+JVS(218)*UV(5)+JVS(219)*UV(7)+JVS(220)*UV(10)+JVS(221)*UV(11)+JVS(222)*UV(13)+JVS(223)*UV(14)&
              &+JVS(224)*UV(15)+JVS(225)*UV(16)+JVS(226)*UV(17)+JVS(227)*UV(19)+JVS(228)*UV(20)+JVS(229)*UV(21)+JVS(230)&
              &*UV(22)+JVS(231)*UV(23)+JVS(232)*UV(24)+JVS(233)*UV(25)+JVS(234)*UV(26)+JVS(235)*UV(27)+JVS(236)*UV(28)&
              &+JVS(237)*UV(29)+JVS(238)*UV(30)+JVS(239)*UV(31)+JVS(240)*UV(32)
  JUV(29) = JVS(241)*UV(1)+JVS(242)*UV(17)+JVS(243)*UV(21)+JVS(244)*UV(22)+JVS(245)*UV(23)+JVS(246)*UV(24)+JVS(247)&
              &*UV(25)+JVS(248)*UV(26)+JVS(251)*UV(29)+JVS(252)*UV(30)+JVS(253)*UV(31)
  JUV(30) = JVS(255)*UV(6)+JVS(256)*UV(12)+JVS(257)*UV(14)+JVS(258)*UV(21)+JVS(259)*UV(22)+JVS(260)*UV(23)+JVS(261)&
              &*UV(24)+JVS(262)*UV(25)+JVS(263)*UV(26)+JVS(264)*UV(27)+JVS(266)*UV(29)+JVS(267)*UV(30)+JVS(268)*UV(31)
  JUV(31) = JVS(270)*UV(8)+JVS(271)*UV(9)+JVS(272)*UV(11)+JVS(274)*UV(18)+JVS(280)*UV(25)+JVS(281)*UV(26)+JVS(282)&
              &*UV(27)+JVS(283)*UV(28)+JVS(284)*UV(29)+JVS(285)*UV(30)+JVS(286)*UV(31)+JVS(287)*UV(32)
  JUV(32) = JVS(288)*UV(3)+JVS(289)*UV(15)+JVS(290)*UV(19)+JVS(291)*UV(22)+JVS(292)*UV(24)+JVS(293)*UV(25)+JVS(294)&
              &*UV(26)+JVS(295)*UV(27)+JVS(296)*UV(28)+JVS(297)*UV(29)+JVS(298)*UV(30)+JVS(299)*UV(31)+JVS(300)*UV(32)
      
END SUBROUTINE Jac_SP_Vec

! End of Jac_SP_Vec function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! JacTR_SP_Vec - sparse multiplication: sparse Jacobian transposed times vector
!   Arguments :
!      JVS       - sparse Jacobian of variables
!      UV        - User vector for variables
!      JTUV      - Jacobian transposed times user vector
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE JacTR_SP_Vec ( JVS, UV, JTUV )

! JVS - sparse Jacobian of variables
  REAL(kind=dp) :: JVS(LU_NONZERO)
! UV - User vector for variables
  REAL(kind=dp) :: UV(NVAR)
! JTUV - Jacobian transposed times user vector
  REAL(kind=dp) :: JTUV(NVAR)

  JTUV(1) = JVS(1)*UV(1)+JVS(192)*UV(27)+JVS(241)*UV(29)
  JTUV(2) = JVS(3)*UV(2)+JVS(193)*UV(27)+JVS(217)*UV(28)
  JTUV(3) = JVS(6)*UV(3)+JVS(170)*UV(26)+JVS(288)*UV(32)
  JTUV(4) = JVS(9)*UV(4)+JVS(171)*UV(26)
  JTUV(5) = JVS(14)*UV(5)+JVS(38)*UV(11)+JVS(55)*UV(14)+JVS(85)*UV(18)+JVS(194)*UV(27)+JVS(218)*UV(28)
  JTUV(6) = JVS(16)*UV(6)+JVS(43)*UV(12)+JVS(172)*UV(26)+JVS(255)*UV(30)
  JTUV(7) = JVS(19)*UV(7)+JVS(39)*UV(11)+JVS(56)*UV(14)+JVS(62)*UV(15)+JVS(86)*UV(18)+JVS(112)*UV(20)+JVS(195)*UV(27)&
              &+JVS(219)*UV(28)
  JTUV(8) = JVS(21)*UV(8)+JVS(270)*UV(31)
  JTUV(9) = JVS(30)*UV(9)+JVS(173)*UV(26)+JVS(196)*UV(27)+JVS(271)*UV(31)
  JTUV(10) = JVS(34)*UV(10)+JVS(174)*UV(26)+JVS(197)*UV(27)+JVS(220)*UV(28)
  JTUV(11) = JVS(40)*UV(11)+JVS(57)*UV(14)+JVS(105)*UV(19)+JVS(175)*UV(26)+JVS(221)*UV(28)+JVS(272)*UV(31)
  JTUV(12) = JVS(44)*UV(12)+JVS(198)*UV(27)+JVS(256)*UV(30)
  JTUV(13) = JVS(22)*UV(8)+JVS(51)*UV(13)+JVS(87)*UV(18)+JVS(113)*UV(20)+JVS(146)*UV(24)+JVS(176)*UV(26)+JVS(222)*UV(28)
  JTUV(14) = JVS(10)*UV(4)+JVS(45)*UV(12)+JVS(58)*UV(14)+JVS(88)*UV(18)+JVS(106)*UV(19)+JVS(199)*UV(27)+JVS(223)*UV(28)&
               &+JVS(257)*UV(30)
  JTUV(15) = JVS(63)*UV(15)+JVS(68)*UV(16)+JVS(89)*UV(18)+JVS(200)*UV(27)+JVS(224)*UV(28)+JVS(289)*UV(32)
  JTUV(16) = JVS(69)*UV(16)+JVS(201)*UV(27)+JVS(225)*UV(28)
  JTUV(17) = JVS(70)*UV(16)+JVS(80)*UV(17)+JVS(90)*UV(18)+JVS(122)*UV(21)+JVS(147)*UV(24)+JVS(159)*UV(25)+JVS(202)&
               &*UV(27)+JVS(226)*UV(28)+JVS(242)*UV(29)
  JTUV(18) = JVS(91)*UV(18)+JVS(178)*UV(26)+JVS(274)*UV(31)
  JTUV(19) = JVS(64)*UV(15)+JVS(71)*UV(16)+JVS(92)*UV(18)+JVS(107)*UV(19)+JVS(123)*UV(21)+JVS(148)*UV(24)+JVS(160)&
               &*UV(25)+JVS(203)*UV(27)+JVS(227)*UV(28)+JVS(290)*UV(32)
  JTUV(20) = JVS(23)*UV(8)+JVS(52)*UV(13)+JVS(93)*UV(18)+JVS(114)*UV(20)+JVS(149)*UV(24)+JVS(204)*UV(27)+JVS(228)*UV(28)
  JTUV(21) = JVS(46)*UV(12)+JVS(72)*UV(16)+JVS(124)*UV(21)+JVS(205)*UV(27)+JVS(229)*UV(28)+JVS(243)*UV(29)+JVS(258)&
               &*UV(30)
  JTUV(22) = JVS(24)*UV(8)+JVS(65)*UV(15)+JVS(73)*UV(16)+JVS(81)*UV(17)+JVS(94)*UV(18)+JVS(115)*UV(20)+JVS(125)*UV(21)&
               &+JVS(135)*UV(22)+JVS(140)*UV(23)+JVS(150)*UV(24)+JVS(161)*UV(25)+JVS(206)*UV(27)+JVS(230)*UV(28)+JVS(244)&
               &*UV(29)+JVS(259)*UV(30)+JVS(291)*UV(32)
  JTUV(23) = JVS(25)*UV(8)+JVS(74)*UV(16)+JVS(95)*UV(18)+JVS(116)*UV(20)+JVS(126)*UV(21)+JVS(141)*UV(23)+JVS(151)*UV(24)&
               &+JVS(162)*UV(25)+JVS(182)*UV(26)+JVS(207)*UV(27)+JVS(231)*UV(28)+JVS(245)*UV(29)+JVS(260)*UV(30)
  JTUV(24) = JVS(47)*UV(12)+JVS(75)*UV(16)+JVS(96)*UV(18)+JVS(127)*UV(21)+JVS(152)*UV(24)+JVS(208)*UV(27)+JVS(232)&
               &*UV(28)+JVS(246)*UV(29)+JVS(261)*UV(30)+JVS(292)*UV(32)
  JTUV(25) = JVS(2)*UV(1)+JVS(66)*UV(15)+JVS(76)*UV(16)+JVS(82)*UV(17)+JVS(97)*UV(18)+JVS(108)*UV(19)+JVS(117)*UV(20)&
               &+JVS(128)*UV(21)+JVS(136)*UV(22)+JVS(142)*UV(23)+JVS(153)*UV(24)+JVS(163)*UV(25)+JVS(184)*UV(26)+JVS(209)&
               &*UV(27)+JVS(233)*UV(28)+JVS(247)*UV(29)+JVS(262)*UV(30)+JVS(280)*UV(31)+JVS(293)*UV(32)
  JTUV(26) = JVS(7)*UV(3)+JVS(11)*UV(4)+JVS(17)*UV(6)+JVS(31)*UV(9)+JVS(35)*UV(10)+JVS(48)*UV(12)+JVS(53)*UV(13)&
               &+JVS(164)*UV(25)+JVS(185)*UV(26)+JVS(210)*UV(27)+JVS(234)*UV(28)+JVS(248)*UV(29)+JVS(263)*UV(30)+JVS(281)&
               &*UV(31)+JVS(294)*UV(32)
  JTUV(27) = JVS(4)*UV(2)+JVS(12)*UV(4)+JVS(15)*UV(5)+JVS(20)*UV(7)+JVS(26)*UV(8)+JVS(32)*UV(9)+JVS(36)*UV(10)+JVS(41)&
               &*UV(11)+JVS(49)*UV(12)+JVS(54)*UV(13)+JVS(59)*UV(14)+JVS(67)*UV(15)+JVS(77)*UV(16)+JVS(83)*UV(17)+JVS(99)&
               &*UV(18)+JVS(109)*UV(19)+JVS(119)*UV(20)+JVS(129)*UV(21)+JVS(137)*UV(22)+JVS(143)*UV(23)+JVS(155)*UV(24)&
               &+JVS(165)*UV(25)+JVS(186)*UV(26)+JVS(211)*UV(27)+JVS(235)*UV(28)+JVS(264)*UV(30)+JVS(282)*UV(31)+JVS(295)&
               &*UV(32)
  JTUV(28) = JVS(5)*UV(2)+JVS(37)*UV(10)+JVS(100)*UV(18)+JVS(130)*UV(21)+JVS(166)*UV(25)+JVS(187)*UV(26)+JVS(212)*UV(27)&
               &+JVS(236)*UV(28)+JVS(283)*UV(31)+JVS(296)*UV(32)
  JTUV(29) = JVS(27)*UV(8)+JVS(78)*UV(16)+JVS(84)*UV(17)+JVS(101)*UV(18)+JVS(120)*UV(20)+JVS(131)*UV(21)+JVS(138)*UV(22)&
               &+JVS(144)*UV(23)+JVS(156)*UV(24)+JVS(167)*UV(25)+JVS(188)*UV(26)+JVS(213)*UV(27)+JVS(237)*UV(28)+JVS(251)&
               &*UV(29)+JVS(266)*UV(30)+JVS(284)*UV(31)+JVS(297)*UV(32)
  JTUV(30) = JVS(13)*UV(4)+JVS(18)*UV(6)+JVS(28)*UV(8)+JVS(50)*UV(12)+JVS(60)*UV(14)+JVS(79)*UV(16)+JVS(102)*UV(18)&
               &+JVS(121)*UV(20)+JVS(132)*UV(21)+JVS(139)*UV(22)+JVS(145)*UV(23)+JVS(157)*UV(24)+JVS(189)*UV(26)+JVS(238)&
               &*UV(28)+JVS(252)*UV(29)+JVS(267)*UV(30)+JVS(285)*UV(31)+JVS(298)*UV(32)
  JTUV(31) = JVS(29)*UV(8)+JVS(33)*UV(9)+JVS(42)*UV(11)+JVS(103)*UV(18)+JVS(111)*UV(19)+JVS(133)*UV(21)+JVS(169)*UV(25)&
               &+JVS(190)*UV(26)+JVS(215)*UV(27)+JVS(239)*UV(28)+JVS(253)*UV(29)+JVS(268)*UV(30)+JVS(286)*UV(31)+JVS(299)&
               &*UV(32)
  JTUV(32) = JVS(8)*UV(3)+JVS(104)*UV(18)+JVS(134)*UV(21)+JVS(191)*UV(26)+JVS(216)*UV(27)+JVS(240)*UV(28)+JVS(287)&
               &*UV(31)+JVS(300)*UV(32)
      
END SUBROUTINE JacTR_SP_Vec

! End of JacTR_SP_Vec function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



END MODULE cbm4_Jacobian
