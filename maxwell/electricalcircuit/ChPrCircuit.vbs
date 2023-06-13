' ---------------------------------------------
' Script Recorded by Ansoft Maxwell Version 14.0.0
' 10:00:00  Feb 24, 2018 by Gulay Stanislav 
' ---------------------------------------------
Dim oAnsoftApp, oDesktop, oProject, oDesign, oEditor, oModule
Dim DiaGap, DiaYoke, Bs1, Bs2, Hs0, Hs1, Hs2, Hs, AirGap
Dim Z1, Hsw, Bsw, Hsw_gap, Hsw_between, DiaCal1, Alphas1
Dim Material_stator, Material_rotor, Material_winding, Brw
Dim CoilRotor, Poles, RadiusPole, AlphaD, ShoeWidth, Bso
Dim WindingTop, WindingBottom, DiaDamper, RadiusOutRimRotor
Dim LocusDamper, ShoeHeight, PoleWidth, RadiusInRimRotor
Dim PoleHeight, SlotPole, SlotPoleOpen, Hrw, Srw, Srh, Delete
Dim CurrentTop, CurrentBottom, axColor, byColor, czColor, AngleD
Dim NNull, Imax, MeshOne(), MeshTwo(), MeshThree(), MeshFour()
Dim EdgeIdWR(), EdgeIdDamper(), Branches, SVolt, SCurrent, Frequency 
Dim GenLength
' ---------------------------------------------
' Initial parameters in mm, rad, T, A/m, A
  Station = "HHP Sayany"
' ---------------------------------------------
PiConst = 4*atn(1)
MainFolder = "F:\Matlab_NSGAII_ES_26.06.2021_All_Cases_v5\maxwell\"
ExternalCircuit = "CC_NoLoadSayany.sph"
IncTitle = "" ' "example" & IncTitle & ".csv"
Solver = 1 ' If 0 then Maxwell else ANSYS R19.1
' ---------------------------------------------
' Stator geometry
' ---------------------------------------------
DiaGap = 12100 ' Core diameter on gap side [mm]
DiaYoke = 13052 ' Core diameter on yoke side [mm]
LengthCore = 2755 ' Stator core length [mm]
LenghtTurn = 9290 ' One stator winding turn length [mm]
Z1 = 504 ' Numbers of slots [-]
Bs1 = 40 ' Slot wedge maximum width [mm]
Bs2 = 34.6801 ' Slot body width [mm]
Hs0 = 179.2 ' Slot opening height [mm]
Hs1 = 15.0 ' Slot wedge height [mm]
Hs2 = 1.0 ' Slot closed bridge height [mm]
Hsw = 74.6 ' Stator winding height [mm]
Bsw = 16.9 ' Stator winding width [mm]
Hsw_gap = 6.3 ' Distance between stator winding and slot bottom [mm]
Hsw_between = 14.6 ' Distance between stator windings [mm]
Alphas1 = PiConst/3 ' Angle base of wedge  [rad]
AirGap = 29.1438 ' Air gap [mm]
Ns = 43 ' Air duct number of stator core [-]
Bs = 7 ' Air duct width of stator core  [mm]
Ksr = .95 ' Stacking factor of stator core [-]
Branches = 6 ' Numbers of branches [-]
CoilPitch = 10 ' Stator coil pitch [-] (1-11-25)
SVolt = 15750 ' Stator winding voltage [V]
SCurrent = 26063 ' Stator winding current [A]
Frequency = 50 ' Frequency [Hz]
ExValue = Array(1520, 1103200) ' 0.Rotor current [A], 1.losses [W]
TypeCore = 0 ' 0 is without joins, 1 is with joins
StYLoss = Array(221,  Round(2.99*0.5^2, 2),  .27) ' B50/1.0=1.1[W/kg] losses ratio for d Yoke
StTLoss = Array(273,  Round(2.99*0.5^2, 2), .27) ' B50/1.0=1.36[W/kg] losses ratio for q Tooth
' ---------------------------------------------
' Rotor geometry
' ---------------------------------------------
Poles = 42 ' Numbers of poles [-]
RadiusPole = 2129 ' Pole radius [mm]
DiaDamper = 29 ' Pole damper diameter [mm]
LocusDamper = 2104.5 ' Locus damper radius [mm]
LengthDamper = 2950 ' Damper length [mm]
AlphaD = 2*PiConst/218.97 ' Angle between dampers [rad]
ShoeWidthMinor = 624 ' Minor pole shoe width [mm]
ShoeWidthMajor = 624+22 ' Major pole shoe width [mm]
ShoeHeight = 83 ' Pole shoe height [mm]
PoleWidth = 491 ' Pole body width [mm]
PoleHeight = 255 ' Pole body height [mm]
PoleLength = 2540 ' Pole body length [mm]
SlotPole = 10 ' Numbers of damper slots per pole [-]
SlotPoleOpen = 8 ' Numbers of damper slots per pole with opening width [-]
Bso = 4 ' Slot opening width [mm]
RadiusInRimRotor = 4820 ' Inner radius of rotor rim [mm]
Brw = 105 ' Rotor winding width [mm]
Hrw = 205 ' Rotor winding height [mm]
Srw = (538-490)/2 ' Distance between rotor winding and pole body [mm]
Srh = 22 ' Distance between rotor winding and shoe bottom [mm]
Tsheet = 1.5 ' Sheet thickness [mm]
RotLoss = Array(4500, Round(2.99*Tsheet^2, 2), 0)
' ---------------------------------------------
' Calculation setting. Boundary setting. Excitation setting
' ---------------------------------------------
CoilRotor = 1 ' Rotor winding for drawing[-]
CoilRotorPr = 20 ' Rotor winding for winding parameters[-]
CalArea = 2 ' Rotor poles for calculation [-]
AngleD = Z1/Poles/2-.5 ' Rotation angle of stator slot is in a counter-clockwise direction. Share of 2*pi()/Z1. 
' If AngleD mod 2 is 0 then D-axis slot, .5 is tooth. The value is about Z1/2/Poles [-]
NNull = 0 ' Stator winding is in a clockwise direction [-]
AngleR = 0 ' Rotation angle of rotor is in a counter-clockwise direction [rad]
Imax = 60 ' Maximum stator current [A]
SolutionType = 2 ' Solution type. 0 is x, 1 is x', 2 is x"
ResistanceRotor_15C = .122 ' Calculated rotor active resistance 15 C [ohm]
ResistanceStator_15C = .00096 ' Calculated phase stator active resistance 15 C [ohm]
TestTime = 10 ' Test time [s]
NoLoadTime = 1 ' Initial time of no-load running [s] 
VoltageRotor = 10 ' Rotor voltage [V]
CurrentRotor = 1550 ' Rotor current [A]
RotLoss = Array(4500, Round(2.99*Tsheet^2, 2), 0)
' ---------------------------------------------
'WindingTop =    Array ("b", "x", "x", "x", "x", "c", "c", "c", "c", "y", "y", "y") ' small
'WindingBottom = Array ("b", "b", "b", "x", "x", "x", "x", "c", "c", "c", "c", "y") ' small
WindingTop =    Array ("x", "c", "c", "c", "c", "y", "y", "y", "y", "a", "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "b", "x", "x", "x") 
WindingBottom = Array ("x", "x", "x", "c", "c", "c", "c", "y", "y", "y", "y", "a", "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "b", "x")
' ---------------------------------------------
' Mesh settings
' ---------------------------------------------
MSizeWSt =  10 ' Mesh size of stator windings, dampers, diaTooth, poleShoe, band, rotor windings [mm]
MSizeRotBody =  10 ' Mesh size of rotor body [mm]
MSizeRimRotOut = 10 ' Mesh size of outside rotor rim [mm]
MSizeRimRotIn = 30 ' Mesh size of inside rotor rim [mm]
MSizeDiaYoke = 20 ' Mesh size of yoke side [mm]
MSizeAirIn = 75 ' Mesh size of inside air [mm]
' ---------------------------------------------
' Include sub
' ---------------------------------------------
Sub Include(strScriptName)
  Dim objFSO, objFile
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Set objFile = objFSO.OpenTextFile(MainFolder & strScriptName & ".vbs")
  ExecuteGlobal objFile.ReadAll()
  objFile.Close
End Sub  

' ---------------------------------------------
' Material
' ---------------------------------------------
Material_stator = "m 270-50A" ' Material of stator core [T = f (A/m)]
Material_rotor = "rotor steel" ' Material of rotor core [T = f (A/m)]
Material_winding = "copper-75C" ' Material of winding [T = f (A/m)]
' ---------------------------------------------
' Additional or automatic settings
' ---------------------------------------------
axColor = array (225, 225, 0) ' Colour of stator winding ax [-]
byColor = array (0, 128, 128) ' Colour of stator winding by [-]
czColor = array (128, 0, 0) ' Colour of stator winding cz [-]
DiaCal1 = DiaGap+2*(Hs0+2*Hs1+Hs2) '[mm]
PoleCenter = DiaGap/2-AirGap-RadiusPole ' Additional calculation for AirGapMax [mm]
AirGapMax = DiaGap/2-((PoleCenter+(RadiusPole^2-ShoeWidth^2/4)^0.5)^2+ShoeWidth^2/4)^0.5 ' Maximum of air gap [mm]
'GenLength = (LengthCore+PoleLength)/2+2*(AirGap+(AirGapMax-AirGap)/3) ' Calculated length of generator [mm]
GenLength = (Ksr*(LengthCore-Bs*Ns)+PoleLength)/2+2*(AirGap+(AirGapMax-AirGap)/3) ' Calculated length of generator [mm]
Hs = Hs0+Hs1+Hs2 ' Slot height [mm]
EndRotorWidth = PoleWidth+2*(Srw+Brw)
ActiveResistanceRotor = ResistanceRotor_15C*(1+.004*(75-15))*(GenLength/PoleLength)*(EndRotorWidth/(EndRotorWidth+PoleLength)) ' Rotor active resistance reduced to 75 Celsius degree and length for calculation [ohm]
ActiveResistanceStator = ResistanceStator_15C*(1+.004*(75-15))*(GenLength/LengthCore)*(1-2*LengthCore/LenghtTurn) ' Stator active resistance to 75 Celsius degree and length for calculation [ohm]
RadiusOutRimRotor = ((DiaGap/2-AirGap-ShoeHeight-PoleHeight)^2+PoleWidth^2/4)^0.5 '[mm]
NumberWSE = ubound(WindingTop)+1 ' Number stator winding with excitation [-]
MaxAngleR = PiConst/Poles-atn((PoleWidth/2+Srw+Brw)/(DiaGap/2-AirGap-ShoeHeight-Srh-Hrw)) ' Maximum of rotation angle of rotor [rad]
RatioStator = (Round(Ksr*(LengthCore-Bs*Ns)/LengthCore, 2))*0 + 1
' ---------------------------------------------
' Program start
' ---------------------------------------------
Set oAnsoftApp = CreateObject("AnsoftMaxCir.MaxCirScript")
Set oDesktop = oAnsoftApp.GetAppDesktop()
oDesktop.RestoreWindow
Set oProject = oDesktop.GetActiveProject()
Set oDesign = oProject.GetActiveDesign()
Set oEditor = oDesign.SetActiveEditor("SchematicEditor")
' ---------------------------------------------
' Change properties
' ---------------------------------------------
ChPrArray = array ( _
"$ActiveResistanceStator", CStr(ActiveResistanceStator) & "Ohm", "Stator active resistance", _
"$TestTime", CStr(TestTime) & "s", "Test time", _
"$NoLoadTime", CStr(NoLoadTime) & "s", "Initial time of no-load running")
' --------------------------------------------
' Subroutine of change properties 
' --------------------------------------------
Sub ChPrValue(counter)
  oProject.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:ProjectVariableTab", _
  Array("NAME:PropServers", "ProjectVariables"), _
  Array("NAME:ChangedProps", _
  Array("NAME:" & ChPrArray(counter), _
  "PropType:=", "VariableProp", _
  "UserDef:=", true, _
  "Value:=", ChPrArray(counter+1), _
  "Description:=", ChPrArray(counter+2)))))
End Sub
For i = 0 to ubound(ChPrArray) step 3 
  ChPrValue(i)
Next

MsgBox CStr(GenLength)

