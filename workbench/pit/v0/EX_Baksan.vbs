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
  Station = "HHP Baksan"
' ---------------------------------------------
PiConst = 4*atn(1)
MainFolder = "D:\PhD.Calculation\Workbench_NSGAII_13.09.2019\"
ExternalCircuit = "CC_NoLoadBaksan.sph"
IncTitle = "" ' "example" & IncTitle & ".csv"
Solver = 1 ' If 0 then Maxwell else ANSYS R19.1
' ---------------------------------------------
' Stator geometry
' ---------------------------------------------
DiaGap = 2500 ' Core diameter on gap side [mm]
LengthCore = 750 ' Stator core length [mm]
LenghtTurn = 3596 ' One stator winding turn length [mm]
Z1 = 180 ' Numbers of slots [-]
Bs1 = 21.12 ' Slot wedge maximum width [mm]
Bs2 = 16.6 ' Slot body width [mm]
Hs1 = 5.5 ' Slot wedge height [mm]
Hs2 = .5 ' Slot closed bridge height [mm]
Bsw = Bs2 - 5.1 ' Stator winding width [mm]
Hsw = 52*11.5/Bsw' Stator winding height [mm]
Hsw_gap = 2.95 ' Distance between stator winding and slot bottom [mm]
Hsw_between = 6.9 ' Distance between stator windings [mm]
Hs0 = 2*Hsw+Hsw_between+Hsw_gap+5.95 ' Slot opening height [mm]
DiaYoke = 3140 ' Core diameter on yoke side [mm]
Alphas1 = PiConst/3 ' Angle base of wedge  [rad]
AirGap = 13 ' Air gap [mm]
Ns = 13 ' Air duct number of stator core [-]
Bs = 7 ' Air duct width of stator core  [mm]
Ksr = .95 ' Stacking factor of stator core [-]
Branches = 1 ' Numbers of branches [-]
CoilPitch = 12 ' Stator coil pitch [-] (1-13)
SVolt = 6300 ' Stator winding voltage [V]
SCurrent = 916 ' Stator winding current [A]
Frequency = 50 ' Frequency [Hz]
ExValue = Array(350, 37600) ' 0.Rotor current [A], 1.losses [W]
TypeCore = 0 ' 0 is without joins, 1 is with joins
StYLoss = Array(221,  Round(2.99*0.5^2, 2),  .27) ' B50/1.0=1.1[W/kg] losses ratio for d Yoke
StTLoss = Array(273,  Round(2.99*0.5^2, 2), .27) ' B50/1.0=1.36[W/kg] losses ratio for q Tooth
' ---------------------------------------------
' Rotor geometry 
' ---------------------------------------------
Poles = 12 ' Numbers of poles [-]
RadiusPole = 970 ' Pole radius [mm]
DiaDamper = 14.4 ' Pole damper diameter [mm]
LocusDamper = 953 ' Locus damper radius [mm]
LengthDamper = 962 ' Damper length [mm]
AlphaD = 2*PiConst/108.86 ' Angle between dampers [rad]
ShoeWidthMinor = 475 ' Minor pole shoe width [mm]
ShoeWidthMajor = 495 ' Major pole shoe width [mm]
ShoeHeight = 65 ' Pole shoe height [mm]
PoleWidth = 315 ' Pole body width [mm]
PoleHeight = 225 ' Pole body height [mm]
PoleLength = 700 ' Pole body length [mm]
SlotPole = 8 ' Numbers of damper slots per pole [-]
SlotPoleOpen = 4 ' Numbers of damper slots per pole with opening width [-]
Bso = 3 ' Slot opening width [mm]
RadiusInRimRotor = 370 ' Inner radius of rotor rim [mm]
Srw = 6 ' Distance between rotor winding and pole body [mm]
Srh = 18 ' Distance between rotor winding and shoe bottom [mm]
Hrw = PoleHeight - Srh - 17 ' Rotor winding height [mm]
Brw = 45 ' Rotor winding width [mm]
Tsheet = 2 ' Sheet thickness [mm]
RotLoss = Array(4500, Round(2.99*Tsheet^2, 2), 0)
' ---------------------------------------------
' Calculation setting. Boundary setting. Excitation setting
' ---------------------------------------------
CoilRotor = 1 ' Rotor winding for drawing[-]
CoilRotorPr = 35 ' Rotor winding for winding parameters[-]
CalArea = 1 ' Rotor poles for calculation [-]
AngleD = Z1/Poles/2-.5 ' Rotation angle of stator slot is in a counter-clockwise direction. Share of 2*pi()/Z1. 
' If AngleD mod 2 is 0 then D-axis slot, .5 is tooth. The value is about Z1/2/Poles [-]
NNull = 0 ' Stator winding is in a clockwise direction [-]
AngleR = 0 ' Rotation angle of rotor is in a counter-clockwise direction [rad]
Imax = 60 ' Maximum stator current [A]
SolutionType = 0 ' Solution type. 0 is x, 1 is x', 2 is x"
ResistanceRotor_15C = .09 ' Calculated rotor active resistance 15 C [ohm]
ResistanceStator_15C = .01 ' Calculated phase stator active resistance 15 C [ohm]
TestTime = 10 ' Test time [s]
NoLoadTime = 1 ' Initial time of no-load running [s] 
VoltageRotor = 10 ' Rotor voltage [V]
CurrentRotor = 336 ' Rotor current [A]
RotLoss = Array(4500, Round(2.99*Tsheet^2, 2), 0)
' ---------------------------------------------
WindingTop =    Array ("a", "a", "a", "a", "a", "z", "z", "z", "z", "z", "b", "b", "b", "b", "b")
WindingBottom = Array ("a", "a", "a", "z", "z", "z", "z", "z", "b", "b", "b", "b", "b", "x", "x")
' ---------------------------------------------
' Mesh settings
' ---------------------------------------------
MSizeWSt = 5 ' Mesh size of stator windings, dampers, diaTooth, poleShoe, band, rotor windings [mm]
MSizeRotBody = 10 ' Mesh size of rotor body [mm]
MSizeRimRotOut = 10 ' Mesh size of outside rotor rim [mm]
MSizeRimRotIn = 30 ' Mesh size of inside rotor rim [mm]
MSizeDiaYoke = 15 ' Mesh size of yoke side [mm]
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
' Transient setup: NumberSteps has to be «200»
' ---------------------------------------------
NumberSteps = 100
TimeStopStr = "10ms"
RtFrq=2

'Include("MW_MainPart")
'Include("MW_FieldReport")
'Include("MW_DamperSolid")
'Include("MW_SolvedValues")

' ---------------------------------------------
' MW_MainPart
' Script Recorded by Ansoft Maxwell Version 14.0.0
' 10:00:00  Feb 24, 2018 by Gulay Stanislav 
' ---------------------------------------------
' Material 
' ---------------------------------------------
Material_stator_yoke = "m 270-50A d" ' Material of stator core [T = f (A/m)]
Material_stator_tooth = "m 270-50A q" ' Material of stator core [T = f (A/m)]
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
AirGapMax = DiaGap/2-((PoleCenter+(RadiusPole^2-ShoeWidthMinor^2/4)^0.5)^2+ShoeWidthMinor^2/4)^0.5 ' Maximum of air gap [mm]
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
' Program start. Nil properties
' ---------------------------------------------
If Solver = 0 then
	Set oAnsoftApp = CreateObject("AnsoftMaxwell.MaxwellScriptInterface")
Else 
	Set oAnsoftApp = CreateObject("Ansoft.ElectronicsDesktop")
End If
Set oDesktop = oAnsoftApp.GetAppDesktop()
oDesktop.RestoreWindow
Set oProject = oDesktop.GetActiveProject()
Set oDesign = oProject.GetActiveDesign()
Set oDefinitionManager = oProject.GetDefinitionManager()
Set oEditor = oDesign.SetActiveEditor("3D Modeler")
Set oModule = oDesign.GetModule("BoundarySetup")
If IncTitle <> "" then
	oProject.SaveAs MainFolder & mid(Station, 5) & mid(IncTitle, 6)  & ".aedt", true
End If

' ----------------------------------------------
ChPrArray = array ("$DiaGap", "$DiaYoke", "$Z1", "$Poles", _
"$Alphas1", "$Bs1", "$Bs2", "$Hs0", "$Hs1", "$Hs2", "$Hsw", "$Bsw", _
"$Hsw_gap", "$Hsw_between", "$DiaCal1", "$AirGap", "$Ns", "$Bs", "$Ksr", "LengthCore", "LenghtTurn", "Branches", _
"$RadiusPole", "$DiaDamper", "$LocusDamper", "LengthDamper", "$AlphaD", _
"$ShoeWidthMinor", "$ShoeWidthMajor", "$ShoeHeight", "$PoleWidth", "$PoleHeight", "PoleLength", _
"$SlotPole", "$SlotPoleOpen", "$Bso", "$Brw", "$Hrw", "$Srw", "$Srh", "$CoilRotor", "$CoilRotorPr", _ 
"$RadiusInRimRotor", "$RadiusOutRimRotor", "$CalArea", "$Imax", _
"$AngleD", "$NNull", "$NumberWSE", "$MSizeWSt", _
"$MSizeRotBody", "$MSizeRimRotOut", "$MSizeRimRotIn", "$MSizeDiaYoke", _
"$MSizeAirIn", "$AngleR", "$MaxAngleR", _
"SVolt", "SCurrent", "Frequency", "GenLength", "ActiveResistanceRotor", _
"ActiveResistanceStator", "NoLoadTime", "TestTime", "VoltageRotor")
' ----------------------------------------------
' Properties nil
' ----------------------------------------------
Sub ChPr(PrName)
  oProject.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:ProjectVariableTab", _
  Array("NAME:PropServers", "ProjectVariables"), _
  Array("NAME:NewProps", _
  Array("NAME:" & PrName, _
  "PropType:=", "VariableProp", _
  "UserDef:=", true, _
  "Value:=", "0"))))
End Sub
For i = 0 to ubound(ChPrArray)  
  ChPr(ChPrArray(i))
Next
' ---------------------------------------------
' Check the solution type
' ---------------------------------------------
If oDesign.GetSolutionType <> "Transient" then
  oDesign.SetSolutionType "Transient", "XY"
End If
' ---------------------------------------------
' Change properties
' ---------------------------------------------
' 8mm is frame insulation
' $Bs2+2*$Hs1*0.433012701 where 0.433012701 is mere geometrical calculation
' $LocusDamper = 16mm - previous value
' ---------------------------------------------
ChPrArray = array ("$DiaGap", CStr(DiaGap) & "mm", "Core diameter on gap side*", _
"$DiaYoke", CStr(DiaYoke) & "mm", "Core diameter on yoke side*", _ 
"$Z1", CStr(Z1), "Numbers of slots", _
"$Poles", CStr(Poles), "Numbers of poles", _
"$Alphas1", CStr(Alphas1) & "rad", "Angle base of wedge", _
"$Bs1", "$Bs2+2*$Hs1*0.4330127019", "Slot wedge maximum width", _
"$Bs2", CStr(Bs2) & "mm", "Slot body width*", _
"$Hs0", CStr(Hs0) & "mm", "Slot opening height", _
"$Hs1", CStr(Hs1) & "mm", "Slot wedge height", _
"$Hs2", CStr(Hs2) & "mm", "Slot closed bridge height", _
"$Hsw", CStr(Hsw) & "mm", "Stator winding height", _
"$Bsw", CStr(Bsw) & "mm", "Stator winding width", _ 
"$Hsw_gap", CStr(Hsw_gap) & "mm", "Distance between stator winding and slot bottom", _
"$Hsw_between", CStr(Hsw_between) & "mm", "Distance between stator windings", _
"$DiaCal1", "$DiaGap+2*($Hs0+2*$Hs1+$Hs2)", "Calculated diameter", _
"$AirGap", CStr(AirGap) & "mm", "Air gap between stator and rotor*", _
"$Ns", CStr(Ns), "Air duct number of stator core", _
"$Bs", CStr(Bs) & "mm", "Air duct width of stator core", _
"$Ksr", CStr(Ksr), "Stacking factor of stator core", _
"$RadiusPole", CStr(RadiusPole) & "mm", "Pole radius*", _
"$DiaDamper", CStr(DiaDamper) & "mm", "Pole damper diameter", _
"$LocusDamper", CStr(LocusDamper) & "mm", "Locus damper radius", _
"$AlphaD", CStr(AlphaD) & "rad", "Angle between dampers", _
"$ShoeWidthMinor", CStr(ShoeWidthMinor) & "mm", "Minor pole shoe width*", _
"$ShoeWidthMajor", CStr(ShoeWidthMajor) & "mm", "Major pole shoe width*", _
"$ShoeHeight", CStr(ShoeHeight) & "mm", "Pole shoe height*", _
"$PoleWidth", CStr(PoleWidth) & "mm", "Pole body width*", _
"$PoleHeight", CStr(PoleHeight) & "mm", "Pole body height", _
"$SlotPole", CStr(SlotPole), "Numbers of damper slots per pole", _
"$SlotPoleOpen", CStr(SlotPoleOpen), "Numbers of damper slots per pole with opening width", _
"$Bso", CStr(Bso) & "mm", "Slot opening width", _
"$Brw", CStr(Brw) & "mm", "Rotor winding width*", _
"$Hrw", CStr(Hrw) & "mm", "Rotor winding height", _
"$Srw", CStr(Srw) & "mm", "Distance between rotor winding and pole body", _
"$Srh", CStr(Srh) & "mm", "Distance between rotor winding and shoe bottom", _
"$CoilRotor", CStr(CoilRotor), "Number of rotor winding for drawing", _
"$CoilRotorPr", CStr(CoilRotorPr), "Number of rotor winding for winding parameters", _
"$RadiusInRimRotor", CStr(RadiusInRimRotor) & "mm", "Inner radius of rotor rim", _
"$RadiusOutRimRotor", "(($DiaGap/2-$AirGap-$ShoeHeight-$PoleHeight)^2+$PoleWidth^2/4)^0.5", "Outer radius of rotor rim", _
"$CalArea", CStr(CalArea) , "Number of poles for calculation", _
"$Imax", CStr(Imax) & "A", "Maximum stator current", _
"$AngleD", CStr(AngleD), "Rotation angle of stator slot is in a counter-clockwise direction. Percentage of 2*Pi()/Z1=0..0.5. 0 is slot, 0.5 is tooth", _
"$NNull", CStr(NNull), "Stator winding is in a counter-clockwise direction", _
"$NumberWSE", CStr(NumberWSE), "Number stator winding with excitation", _
"$MSizeWSt", CStr(MSizeWSt) & "mm", "Mesh size of stator windings, dampers, diaTooth, poleShoe, band, rotor windings", _
"$MSizeRotBody", CStr(MSizeRotBody) & "mm", "Mesh size of yoke side", _
"$MSizeRimRotOut", CStr(MSizeRimRotOut) & "mm", "Mesh size of rotor body", _
"$MSizeRimRotIn", CStr(MSizeRimRotIn) & "mm", "Mesh size of outside rotor rim", _
"$MSizeDiaYoke", CStr(MSizeDiaYoke) & "mm", "Mesh size of inside rotor rim", _
"$MSizeAirIn", CStr(MSizeAirIn) & "mm", "Mesh size of inside air", _
"$AngleR", CStr(AngleR) & "rad", "Rotation angle of rotor is in a clockwise direction", _
"$MaxAngleR", CStr(MaxAngleR) & "rad", "Maximum of rotation angle of rotor", _
"$Branches", CStr(Branches), "Numbers of branches", _
"$SVolt", CStr(SVolt) & "V", "Stator winding voltage", _
"$SCurrent", CStr(SCurrent) & "A", "Stator winding current", _
"$Frequency", CStr(Frequency) & "Hz", "Frequency", _
"$LengthCore", CStr(LengthCore) & "mm", "Calculated length of generator", _
"$PoleLength", CStr(PoleLength) & "mm", "Pole length", _
"$LengthDamper", CStr(LengthDamper) & "mm", "Damper length", _
"$GenLength", CStr(GenLength) & "mm", "Calculated length of generator", _
"$LenghtTurn", CStr(LenghtTurn) & "mm", "One stator winding turn length", _
"$ActiveResistanceRotor", CStr(ActiveResistanceRotor) & "ohm", "Rotor active resistance reduced to 75 Celsius degree and length for calculation", _
"$ActiveResistanceStator", CStr(ActiveResistanceStator) & "ohm", "Stator active resistance to 75 Celsius degree and length for calculation", _
"$NoLoadTime", CStr(NoLoadTime) & "s", "Initial time of no-load running", _
"$TestTime ", CStr(TestTime) & "s", "Test time", _
"$VoltageRotor", CStr(VoltageRotor) & "V", "Rotor voltage")
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
' ----------------------------------------------
' Check materials: vacuum-air
' ----------------------------------------------
'If (oDefinitionManager.DoesMaterialExist("vacuum-air")) then
'Else
  oDefinitionManager.AddMaterial _
  Array("NAME:vacuum-air", _
  "CoordinateSystemType:=", "Cartesian", _
  Array("NAME:AttachedData"), _
  Array("NAME:ModifierData"), _
  "permeability:=", "1")
'End if
' ----------------------------------------------
' Check materials: copper 75 C
' ----------------------------------------------
'If (oDefinitionManager.DoesMaterialExist("copper-75C")) then
'Else
  oDefinitionManager.AddMaterial Array("NAME:copper-75C", "CoordinateSystemType:=", "Cartesian", _
  Array("NAME:AttachedData"), _
  Array("NAME:ModifierData"), _
  "permittivity:=", "1", _
  "permeability:=", "0.999991", _
  "conductivity:=", "47500000", _
  "mass_density:=", "8933")
'End if
' ----------------------------------------------
' Check materials: material stator
' ----------------------------------------------
' Material stator yoke
  oDefinitionManager.AddMaterial Array("NAME:" & Material_stator_yoke, "CoordinateSystemType:=",  _
  "Cartesian", Array("NAME:AttachedData"), Array("NAME:ModifierData"), Array("NAME:permeability", "property_type:=",  _
  "nonlinear", "HUnit:=", "A_per_meter", "BUnit:=", "tesla", Array("NAME:BHCoordinates", _
  Array("NAME:Coordinate", "X:=", 0, "Y:=", 0), _
  Array("NAME:Coordinate", "X:=", 1.5, "Y:=",  0.01*RatioStator), Array("NAME:Coordinate", "X:=", 3.1, "Y:=",  0.02*RatioStator), _
  Array("NAME:Coordinate", "X:=", 4.6, "Y:=",  0.03*RatioStator), Array("NAME:Coordinate", "X:=", 6.1, "Y:=",  0.04*RatioStator), _
  Array("NAME:Coordinate", "X:=", 7.7, "Y:=",  0.05*RatioStator), Array("NAME:Coordinate", "X:=", 9.2, "Y:=",  0.06*RatioStator), _
  Array("NAME:Coordinate", "X:=", 10.7, "Y:=", 0.07*RatioStator), Array("NAME:Coordinate", "X:=", 12.3, "Y:=", 0.08*RatioStator), _
  Array("NAME:Coordinate", "X:=", 13.8, "Y:=", 0.09*RatioStator), Array("NAME:Coordinate", "X:=", 15.3, "Y:=", 0.10*RatioStator), _
  Array("NAME:Coordinate", "X:=", 16.9, "Y:=", 0.11*RatioStator), Array("NAME:Coordinate", "X:=", 18.4, "Y:=", 0.12*RatioStator), _
  Array("NAME:Coordinate", "X:=", 19.9, "Y:=", 0.13*RatioStator), Array("NAME:Coordinate", "X:=", 21.5, "Y:=", 0.14*RatioStator), _
  Array("NAME:Coordinate", "X:=", 23, "Y:=",   0.15*RatioStator), Array("NAME:Coordinate", "X:=", 24.5, "Y:=", 0.16*RatioStator), _
  Array("NAME:Coordinate", "X:=", 26.1, "Y:=", 0.17*RatioStator), Array("NAME:Coordinate", "X:=", 27.6, "Y:=", 0.18*RatioStator), _
  Array("NAME:Coordinate", "X:=", 29.1, "Y:=", 0.19*RatioStator), Array("NAME:Coordinate", "X:=", 30.7, "Y:=", 0.20*RatioStator), _
  Array("NAME:Coordinate", "X:=", 32.2, "Y:=", 0.21*RatioStator), Array("NAME:Coordinate", "X:=", 33.7, "Y:=", 0.22*RatioStator), _
  Array("NAME:Coordinate", "X:=", 35.3, "Y:=", 0.23*RatioStator), Array("NAME:Coordinate", "X:=", 36.8, "Y:=", 0.24*RatioStator), _
  Array("NAME:Coordinate", "X:=", 38.3, "Y:=", 0.25*RatioStator), Array("NAME:Coordinate", "X:=", 39.9, "Y:=", 0.26*RatioStator), _
  Array("NAME:Coordinate", "X:=", 41.4, "Y:=", 0.27*RatioStator), Array("NAME:Coordinate", "X:=", 42.9, "Y:=", 0.28*RatioStator), _
  Array("NAME:Coordinate", "X:=", 44.5, "Y:=", 0.29*RatioStator), Array("NAME:Coordinate", "X:=", 46, "Y:=",   0.30*RatioStator), _
  Array("NAME:Coordinate", "X:=", 46.6, "Y:=", 0.31*RatioStator), Array("NAME:Coordinate", "X:=", 47.2, "Y:=", 0.32*RatioStator), _
  Array("NAME:Coordinate", "X:=", 47.8, "Y:=", 0.33*RatioStator), Array("NAME:Coordinate", "X:=", 48.4, "Y:=", 0.34*RatioStator), _
  Array("NAME:Coordinate", "X:=", 49, "Y:=",   0.35*RatioStator), Array("NAME:Coordinate", "X:=", 49.8, "Y:=", 0.36*RatioStator), _
  Array("NAME:Coordinate", "X:=", 50.7, "Y:=", 0.37*RatioStator), Array("NAME:Coordinate", "X:=", 51.6, "Y:=", 0.38*RatioStator), _
  Array("NAME:Coordinate", "X:=", 52.5, "Y:=", 0.39*RatioStator), Array("NAME:Coordinate", "X:=", 53.4, "Y:=", 0.40*RatioStator), _
  Array("NAME:Coordinate", "X:=", 54, "Y:=",   0.41*RatioStator), Array("NAME:Coordinate", "X:=", 54.5, "Y:=", 0.42*RatioStator), _
  Array("NAME:Coordinate", "X:=", 55, "Y:=",   0.43*RatioStator), Array("NAME:Coordinate", "X:=", 55.5, "Y:=", 0.44*RatioStator), _
  Array("NAME:Coordinate", "X:=", 55.9, "Y:=", 0.45*RatioStator), Array("NAME:Coordinate", "X:=", 56.7, "Y:=", 0.46*RatioStator), _
  Array("NAME:Coordinate", "X:=", 57.5, "Y:=", 0.47*RatioStator), Array("NAME:Coordinate", "X:=", 58.4, "Y:=", 0.48*RatioStator), _
  Array("NAME:Coordinate", "X:=", 59.2, "Y:=", 0.49*RatioStator), Array("NAME:Coordinate", "X:=", 60, "Y:=",   0.50*RatioStator), _
  Array("NAME:Coordinate", "X:=", 61, "Y:=",   0.51*RatioStator), Array("NAME:Coordinate", "X:=", 62, "Y:=",   0.52*RatioStator), _
  Array("NAME:Coordinate", "X:=", 63, "Y:=",   0.53*RatioStator), Array("NAME:Coordinate", "X:=", 64, "Y:=",   0.54*RatioStator), _
  Array("NAME:Coordinate", "X:=", 65, "Y:=",   0.55*RatioStator), Array("NAME:Coordinate", "X:=", 66, "Y:=",   0.56*RatioStator), _
  Array("NAME:Coordinate", "X:=", 67, "Y:=",   0.57*RatioStator), Array("NAME:Coordinate", "X:=", 68, "Y:=",   0.58*RatioStator), _
  Array("NAME:Coordinate", "X:=", 69, "Y:=",   0.59*RatioStator), Array("NAME:Coordinate", "X:=", 69.5, "Y:=", 0.60*RatioStator), _
  Array("NAME:Coordinate", "X:=", 70.4, "Y:=", 0.61*RatioStator), Array("NAME:Coordinate", "X:=", 71.3, "Y:=", 0.62*RatioStator), _
  Array("NAME:Coordinate", "X:=", 72.2, "Y:=", 0.63*RatioStator), Array("NAME:Coordinate", "X:=", 73.1, "Y:=", 0.64*RatioStator), _
  Array("NAME:Coordinate", "X:=", 74, "Y:=",   0.65*RatioStator), Array("NAME:Coordinate", "X:=", 74.8, "Y:=", 0.66*RatioStator), _
  Array("NAME:Coordinate", "X:=", 75.6, "Y:=", 0.67*RatioStator), Array("NAME:Coordinate", "X:=", 76.4, "Y:=", 0.68*RatioStator), _
  Array("NAME:Coordinate", "X:=", 77.2, "Y:=", 0.69*RatioStator), Array("NAME:Coordinate", "X:=", 78, "Y:=",   0.70*RatioStator), _
  Array("NAME:Coordinate", "X:=", 79.1, "Y:=", 0.71*RatioStator), Array("NAME:Coordinate", "X:=", 80.2, "Y:=", 0.72*RatioStator), _
  Array("NAME:Coordinate", "X:=", 81.3, "Y:=", 0.73*RatioStator), Array("NAME:Coordinate", "X:=", 82.4, "Y:=", 0.74*RatioStator), _
  Array("NAME:Coordinate", "X:=", 83.5, "Y:=", 0.75*RatioStator), Array("NAME:Coordinate", "X:=", 84.6, "Y:=", 0.76*RatioStator), _
  Array("NAME:Coordinate", "X:=", 85.7, "Y:=", 0.77*RatioStator), Array("NAME:Coordinate", "X:=", 86.8, "Y:=", 0.78*RatioStator), _
  Array("NAME:Coordinate", "X:=", 87.9, "Y:=", 0.79*RatioStator), Array("NAME:Coordinate", "X:=", 89, "Y:=",   0.80*RatioStator), _
  Array("NAME:Coordinate", "X:=", 90.5, "Y:=", 0.81*RatioStator), Array("NAME:Coordinate", "X:=", 92, "Y:=",   0.82*RatioStator), _
  Array("NAME:Coordinate", "X:=", 93, "Y:=",   0.83*RatioStator), Array("NAME:Coordinate", "X:=", 94, "Y:=",   0.84*RatioStator), _
  Array("NAME:Coordinate", "X:=", 95, "Y:=", 0.85*RatioStator), Array("NAME:Coordinate", "X:=", 96, "Y:=", 0.86*RatioStator), _
  Array("NAME:Coordinate", "X:=", 97, "Y:=", 0.87*RatioStator), Array("NAME:Coordinate", "X:=", 98, "Y:=", 0.88*RatioStator), _
  Array("NAME:Coordinate", "X:=", 99, "Y:=", 0.89*RatioStator), Array("NAME:Coordinate", "X:=", 100, "Y:=", 0.9*RatioStator), _
  Array("NAME:Coordinate", "X:=", 101.2, "Y:=", 0.91*RatioStator), Array("NAME:Coordinate", "X:=", 102.4, "Y:=", 0.92*RatioStator), _
  Array("NAME:Coordinate", "X:=", 103.6, "Y:=", 0.93*RatioStator), Array("NAME:Coordinate", "X:=", 104.8, "Y:=", 0.94*RatioStator), _
  Array("NAME:Coordinate", "X:=", 106, "Y:=", 0.95*RatioStator), Array("NAME:Coordinate", "X:=", 107.2, "Y:=", 0.96*RatioStator), _
  Array("NAME:Coordinate", "X:=", 108.4, "Y:=", 0.97*RatioStator), Array("NAME:Coordinate", "X:=", 109.6, "Y:=", 0.98*RatioStator), _
  Array("NAME:Coordinate", "X:=", 110.8, "Y:=", 0.99*RatioStator), Array("NAME:Coordinate", "X:=", 112, "Y:=", 1*RatioStator), _
  Array("NAME:Coordinate", "X:=", 120, "Y:=", 1.01*RatioStator), Array("NAME:Coordinate", "X:=", 122.5, "Y:=", 1.02*RatioStator), _
  Array("NAME:Coordinate", "X:=", 124.8, "Y:=", 1.03*RatioStator), Array("NAME:Coordinate", "X:=", 127, "Y:=", 1.04*RatioStator), _ 
  Array("NAME:Coordinate", "X:=", 129, "Y:=", 1.05*RatioStator), Array("NAME:Coordinate", "X:=", 132, "Y:=", 1.06*RatioStator), _
  Array("NAME:Coordinate", "X:=", 134, "Y:=", 1.07*RatioStator), Array("NAME:Coordinate", "X:=", 137, "Y:=", 1.08*RatioStator), _
  Array("NAME:Coordinate", "X:=", 139, "Y:=", 1.09*RatioStator), Array("NAME:Coordinate", "X:=", 142, "Y:=", 1.1*RatioStator), _
  Array("NAME:Coordinate", "X:=", 144, "Y:=", 1.11*RatioStator), Array("NAME:Coordinate", "X:=", 146, "Y:=", 1.12*RatioStator), _
  Array("NAME:Coordinate", "X:=", 149, "Y:=", 1.13*RatioStator), Array("NAME:Coordinate", "X:=", 152, "Y:=", 1.14*RatioStator), _
  Array("NAME:Coordinate", "X:=", 154, "Y:=", 1.15*RatioStator), Array("NAME:Coordinate", "X:=", 159, "Y:=", 1.16*RatioStator), _
  Array("NAME:Coordinate", "X:=", 164, "Y:=", 1.17*RatioStator), Array("NAME:Coordinate", "X:=", 169, "Y:=", 1.18*RatioStator), _
  Array("NAME:Coordinate", "X:=", 174, "Y:=", 1.19*RatioStator), Array("NAME:Coordinate", "X:=", 180, "Y:=", 1.2*RatioStator), _
  Array("NAME:Coordinate", "X:=", 188, "Y:=", 1.21*RatioStator), Array("NAME:Coordinate", "X:=", 196, "Y:=", 1.22*RatioStator), _
  Array("NAME:Coordinate", "X:=", 205, "Y:=", 1.23*RatioStator), Array("NAME:Coordinate", "X:=", 213, "Y:=", 1.24*RatioStator), _
  Array("NAME:Coordinate", "X:=", 230, "Y:=", 1.25*RatioStator), Array("NAME:Coordinate", "X:=", 246, "Y:=", 1.26*RatioStator), _
  Array("NAME:Coordinate", "X:=", 262, "Y:=", 1.27*RatioStator), Array("NAME:Coordinate", "X:=", 278, "Y:=", 1.28*RatioStator), _
  Array("NAME:Coordinate", "X:=", 294, "Y:=", 1.29*RatioStator), Array("NAME:Coordinate", "X:=", 310, "Y:=", 1.3*RatioStator), _
  Array("NAME:Coordinate", "X:=", 318, "Y:=", 1.31*RatioStator), Array("NAME:Coordinate", "X:=", 326, "Y:=", 1.32*RatioStator), _
  Array("NAME:Coordinate", "X:=", 334, "Y:=", 1.33*RatioStator), Array("NAME:Coordinate", "X:=", 342, "Y:=", 1.34*RatioStator), _
  Array("NAME:Coordinate", "X:=", 350, "Y:=", 1.35*RatioStator), Array("NAME:Coordinate", "X:=", 393, "Y:=", 1.36*RatioStator), _
  Array("NAME:Coordinate", "X:=", 436, "Y:=", 1.37*RatioStator), Array("NAME:Coordinate", "X:=", 480, "Y:=", 1.38*RatioStator), _
  Array("NAME:Coordinate", "X:=", 523, "Y:=", 1.39*RatioStator), Array("NAME:Coordinate", "X:=", 566, "Y:=", 1.4*RatioStator), _
  Array("NAME:Coordinate", "X:=", 673, "Y:=", 1.41*RatioStator), Array("NAME:Coordinate", "X:=", 780, "Y:=", 1.42*RatioStator), _
  Array("NAME:Coordinate", "X:=", 886, "Y:=", 1.43*RatioStator), Array("NAME:Coordinate", "X:=", 993, "Y:=", 1.44*RatioStator), _
  Array("NAME:Coordinate", "X:=", 1100, "Y:=", 1.45*RatioStator), Array("NAME:Coordinate", "X:=", 1250, "Y:=", 1.46*RatioStator), _
  Array("NAME:Coordinate", "X:=", 1400, "Y:=", 1.47*RatioStator), Array("NAME:Coordinate", "X:=", 1550, "Y:=", 1.48*RatioStator), _
  Array("NAME:Coordinate", "X:=", 1700, "Y:=", 1.49*RatioStator), Array("NAME:Coordinate", "X:=", 1850, "Y:=", 1.5*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2010, "Y:=", 1.51*RatioStator), Array("NAME:Coordinate", "X:=", 2180, "Y:=", 1.52*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2340, "Y:=", 1.53*RatioStator), Array("NAME:Coordinate", "X:=", 2500, "Y:=", 1.54*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2660, "Y:=", 1.55*RatioStator), Array("NAME:Coordinate", "X:=", 2810, "Y:=", 1.56*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2970, "Y:=", 1.57*RatioStator), Array("NAME:Coordinate", "X:=", 3130, "Y:=", 1.58*RatioStator), _
  Array("NAME:Coordinate", "X:=", 3282, "Y:=", 1.59*RatioStator), Array("NAME:Coordinate", "X:=", 3550, "Y:=", 1.6*RatioStator), _
  Array("NAME:Coordinate", "X:=", 3910, "Y:=", 1.61*RatioStator), Array("NAME:Coordinate", "X:=", 4280, "Y:=", 1.62*RatioStator), _
  Array("NAME:Coordinate", "X:=", 4640, "Y:=", 1.63*RatioStator), Array("NAME:Coordinate", "X:=", 5000, "Y:=", 1.64*RatioStator), _
  Array("NAME:Coordinate", "X:=", 5400, "Y:=", 1.65*RatioStator), Array("NAME:Coordinate", "X:=", 5670, "Y:=", 1.66*RatioStator), _
  Array("NAME:Coordinate", "X:=", 5940, "Y:=", 1.67*RatioStator), Array("NAME:Coordinate", "X:=", 6210, "Y:=", 1.68*RatioStator), _
  Array("NAME:Coordinate", "X:=", 6480, "Y:=", 1.69*RatioStator), Array("NAME:Coordinate", "X:=", 6750, "Y:=", 1.7*RatioStator), _
  Array("NAME:Coordinate", "X:=", 7050, "Y:=", 1.71*RatioStator), Array("NAME:Coordinate", "X:=", 7350, "Y:=", 1.72*RatioStator), _
  Array("NAME:Coordinate", "X:=", 7640, "Y:=", 1.73*RatioStator), Array("NAME:Coordinate", "X:=", 7940, "Y:=", 1.74*RatioStator), _
  Array("NAME:Coordinate", "X:=", 8240, "Y:=", 1.75*RatioStator), Array("NAME:Coordinate", "X:=", 8830, "Y:=", 1.76*RatioStator), _
  Array("NAME:Coordinate", "X:=", 9410, "Y:=", 1.77*RatioStator), Array("NAME:Coordinate", "X:=", 10000, "Y:=", 1.78*RatioStator), _
  Array("NAME:Coordinate", "X:=", 10540, "Y:=", 1.79*RatioStator), Array("NAME:Coordinate", "X:=", 11080, "Y:=", 1.8*RatioStator), _
  Array("NAME:Coordinate", "X:=", 11670, "Y:=", 1.81*RatioStator), Array("NAME:Coordinate", "X:=", 12270, "Y:=", 1.82*RatioStator), _
  Array("NAME:Coordinate", "X:=", 12860, "Y:=", 1.83*RatioStator), Array("NAME:Coordinate", "X:=", 13460, "Y:=", 1.84*RatioStator), _
  Array("NAME:Coordinate", "X:=", 14050, "Y:=", 1.85*RatioStator), Array("NAME:Coordinate", "X:=", 14800, "Y:=", 1.86*RatioStator), _
  Array("NAME:Coordinate", "X:=", 15560, "Y:=", 1.87*RatioStator), Array("NAME:Coordinate", "X:=", 16350, "Y:=", 1.88*RatioStator), _
  Array("NAME:Coordinate", "X:=", 17070, "Y:=", 1.89*RatioStator), Array("NAME:Coordinate", "X:=", 17820, "Y:=", 1.9*RatioStator), _
  Array("NAME:Coordinate", "X:=", 18530, "Y:=", 1.91*RatioStator), Array("NAME:Coordinate", "X:=", 19230, "Y:=", 1.92*RatioStator), _
  Array("NAME:Coordinate", "X:=", 19940, "Y:=", 1.93*RatioStator), Array("NAME:Coordinate", "X:=", 20640, "Y:=", 1.94*RatioStator), _
  Array("NAME:Coordinate", "X:=", 21350, "Y:=", 1.95*RatioStator), Array("NAME:Coordinate", "X:=", 22530, "Y:=", 1.96*RatioStator), _
  Array("NAME:Coordinate", "X:=", 23710, "Y:=", 1.97*RatioStator), Array("NAME:Coordinate", "X:=", 24890, "Y:=", 1.98*RatioStator), _
  Array("NAME:Coordinate", "X:=", 26070, "Y:=", 1.99*RatioStator), Array("NAME:Coordinate", "X:=", 27250, "Y:=", 2*RatioStator), _
  Array("NAME:Coordinate", "X:=", 29040, "Y:=", 2.01*RatioStator), Array("NAME:Coordinate", "X:=", 30820, "Y:=", 2.02*RatioStator), _
  Array("NAME:Coordinate", "X:=", 32610, "Y:=", 2.03*RatioStator), Array("NAME:Coordinate", "X:=", 34390, "Y:=", 2.04*RatioStator), _
  Array("NAME:Coordinate", "X:=", 36180, "Y:=", 2.05*RatioStator), Array("NAME:Coordinate", "X:=", 39570, "Y:=", 2.06*RatioStator), _
  Array("NAME:Coordinate", "X:=", 42960, "Y:=", 2.07*RatioStator), Array("NAME:Coordinate", "X:=", 46340, "Y:=", 2.08*RatioStator), _
  Array("NAME:Coordinate", "X:=", 49730, "Y:=", 2.09*RatioStator), Array("NAME:Coordinate", "X:=", 53120, "Y:=", 2.1*RatioStator), _
  Array("NAME:Coordinate", "X:=", 56270, "Y:=", 2.11*RatioStator), Array("NAME:Coordinate", "X:=", 59410, "Y:=", 2.12*RatioStator), _
  Array("NAME:Coordinate", "X:=", 62560, "Y:=", 2.13*RatioStator), Array("NAME:Coordinate", "X:=", 65700, "Y:=", 2.14*RatioStator), _
  Array("NAME:Coordinate", "X:=", 68850, "Y:=", 2.15*RatioStator))), "conductivity:=",  "1818100", _
  Array("NAME:magnetic_coercivity", "property_type:=", "VectorProperty", "Magnitude:=", _
  "0A_per_meter", "DirComp1:=", "1", "DirComp2:=", "0", "DirComp3:=", "0"), Array("NAME:core_loss_type", "property_type:=",  _
  "ChoiceProperty", "Choice:=", "Electrical Steel"), "core_loss_kh:=", CStr(StYLoss(0)), "core_loss_kc:=",  _
  CStr(StYLoss(1)), "core_loss_ke:=", CStr(StYLoss(2)), "core_loss_kdc:=", "0", "mass_density:=",  _
  "7800")
' Material stator tooth
  oDefinitionManager.AddMaterial Array("NAME:" & Material_stator_tooth, "CoordinateSystemType:=",  _
  "Cartesian", Array("NAME:AttachedData"), Array("NAME:ModifierData"), Array("NAME:permeability", "property_type:=",  _
  "nonlinear", "HUnit:=", "A_per_meter", "BUnit:=", "tesla", Array("NAME:BHCoordinates", _
  Array("NAME:Coordinate", "X:=", 0, "Y:=", 0), _
  Array("NAME:Coordinate", "X:=", 1.5, "Y:=",  0.01*RatioStator), Array("NAME:Coordinate", "X:=", 3.1, "Y:=",  0.02*RatioStator), _
  Array("NAME:Coordinate", "X:=", 4.6, "Y:=",  0.03*RatioStator), Array("NAME:Coordinate", "X:=", 6.1, "Y:=",  0.04*RatioStator), _
  Array("NAME:Coordinate", "X:=", 7.7, "Y:=",  0.05*RatioStator), Array("NAME:Coordinate", "X:=", 9.2, "Y:=",  0.06*RatioStator), _
  Array("NAME:Coordinate", "X:=", 10.7, "Y:=", 0.07*RatioStator), Array("NAME:Coordinate", "X:=", 12.3, "Y:=", 0.08*RatioStator), _
  Array("NAME:Coordinate", "X:=", 13.8, "Y:=", 0.09*RatioStator), Array("NAME:Coordinate", "X:=", 15.3, "Y:=", 0.10*RatioStator), _
  Array("NAME:Coordinate", "X:=", 16.9, "Y:=", 0.11*RatioStator), Array("NAME:Coordinate", "X:=", 18.4, "Y:=", 0.12*RatioStator), _
  Array("NAME:Coordinate", "X:=", 19.9, "Y:=", 0.13*RatioStator), Array("NAME:Coordinate", "X:=", 21.5, "Y:=", 0.14*RatioStator), _
  Array("NAME:Coordinate", "X:=", 23, "Y:=",   0.15*RatioStator), Array("NAME:Coordinate", "X:=", 24.5, "Y:=", 0.16*RatioStator), _
  Array("NAME:Coordinate", "X:=", 26.1, "Y:=", 0.17*RatioStator), Array("NAME:Coordinate", "X:=", 27.6, "Y:=", 0.18*RatioStator), _
  Array("NAME:Coordinate", "X:=", 29.1, "Y:=", 0.19*RatioStator), Array("NAME:Coordinate", "X:=", 30.7, "Y:=", 0.20*RatioStator), _
  Array("NAME:Coordinate", "X:=", 32.2, "Y:=", 0.21*RatioStator), Array("NAME:Coordinate", "X:=", 33.7, "Y:=", 0.22*RatioStator), _
  Array("NAME:Coordinate", "X:=", 35.3, "Y:=", 0.23*RatioStator), Array("NAME:Coordinate", "X:=", 36.8, "Y:=", 0.24*RatioStator), _
  Array("NAME:Coordinate", "X:=", 38.3, "Y:=", 0.25*RatioStator), Array("NAME:Coordinate", "X:=", 39.9, "Y:=", 0.26*RatioStator), _
  Array("NAME:Coordinate", "X:=", 41.4, "Y:=", 0.27*RatioStator), Array("NAME:Coordinate", "X:=", 42.9, "Y:=", 0.28*RatioStator), _
  Array("NAME:Coordinate", "X:=", 44.5, "Y:=", 0.29*RatioStator), Array("NAME:Coordinate", "X:=", 46, "Y:=",   0.30*RatioStator), _
  Array("NAME:Coordinate", "X:=", 46.6, "Y:=", 0.31*RatioStator), Array("NAME:Coordinate", "X:=", 47.2, "Y:=", 0.32*RatioStator), _
  Array("NAME:Coordinate", "X:=", 47.8, "Y:=", 0.33*RatioStator), Array("NAME:Coordinate", "X:=", 48.4, "Y:=", 0.34*RatioStator), _
  Array("NAME:Coordinate", "X:=", 49, "Y:=",   0.35*RatioStator), Array("NAME:Coordinate", "X:=", 49.8, "Y:=", 0.36*RatioStator), _
  Array("NAME:Coordinate", "X:=", 50.7, "Y:=", 0.37*RatioStator), Array("NAME:Coordinate", "X:=", 51.6, "Y:=", 0.38*RatioStator), _
  Array("NAME:Coordinate", "X:=", 52.5, "Y:=", 0.39*RatioStator), Array("NAME:Coordinate", "X:=", 53.4, "Y:=", 0.40*RatioStator), _
  Array("NAME:Coordinate", "X:=", 54, "Y:=",   0.41*RatioStator), Array("NAME:Coordinate", "X:=", 54.5, "Y:=", 0.42*RatioStator), _
  Array("NAME:Coordinate", "X:=", 55, "Y:=",   0.43*RatioStator), Array("NAME:Coordinate", "X:=", 55.5, "Y:=", 0.44*RatioStator), _
  Array("NAME:Coordinate", "X:=", 55.9, "Y:=", 0.45*RatioStator), Array("NAME:Coordinate", "X:=", 56.7, "Y:=", 0.46*RatioStator), _
  Array("NAME:Coordinate", "X:=", 57.5, "Y:=", 0.47*RatioStator), Array("NAME:Coordinate", "X:=", 58.4, "Y:=", 0.48*RatioStator), _
  Array("NAME:Coordinate", "X:=", 59.2, "Y:=", 0.49*RatioStator), Array("NAME:Coordinate", "X:=", 60, "Y:=",   0.50*RatioStator), _
  Array("NAME:Coordinate", "X:=", 61, "Y:=",   0.51*RatioStator), Array("NAME:Coordinate", "X:=", 62, "Y:=",   0.52*RatioStator), _
  Array("NAME:Coordinate", "X:=", 63, "Y:=",   0.53*RatioStator), Array("NAME:Coordinate", "X:=", 64, "Y:=",   0.54*RatioStator), _
  Array("NAME:Coordinate", "X:=", 65, "Y:=",   0.55*RatioStator), Array("NAME:Coordinate", "X:=", 66, "Y:=",   0.56*RatioStator), _
  Array("NAME:Coordinate", "X:=", 67, "Y:=",   0.57*RatioStator), Array("NAME:Coordinate", "X:=", 68, "Y:=",   0.58*RatioStator), _
  Array("NAME:Coordinate", "X:=", 69, "Y:=",   0.59*RatioStator), Array("NAME:Coordinate", "X:=", 69.5, "Y:=", 0.60*RatioStator), _
  Array("NAME:Coordinate", "X:=", 70.4, "Y:=", 0.61*RatioStator), Array("NAME:Coordinate", "X:=", 71.3, "Y:=", 0.62*RatioStator), _
  Array("NAME:Coordinate", "X:=", 72.2, "Y:=", 0.63*RatioStator), Array("NAME:Coordinate", "X:=", 73.1, "Y:=", 0.64*RatioStator), _
  Array("NAME:Coordinate", "X:=", 74, "Y:=",   0.65*RatioStator), Array("NAME:Coordinate", "X:=", 74.8, "Y:=", 0.66*RatioStator), _
  Array("NAME:Coordinate", "X:=", 75.6, "Y:=", 0.67*RatioStator), Array("NAME:Coordinate", "X:=", 76.4, "Y:=", 0.68*RatioStator), _
  Array("NAME:Coordinate", "X:=", 77.2, "Y:=", 0.69*RatioStator), Array("NAME:Coordinate", "X:=", 78, "Y:=",   0.70*RatioStator), _
  Array("NAME:Coordinate", "X:=", 79.1, "Y:=", 0.71*RatioStator), Array("NAME:Coordinate", "X:=", 80.2, "Y:=", 0.72*RatioStator), _
  Array("NAME:Coordinate", "X:=", 81.3, "Y:=", 0.73*RatioStator), Array("NAME:Coordinate", "X:=", 82.4, "Y:=", 0.74*RatioStator), _
  Array("NAME:Coordinate", "X:=", 83.5, "Y:=", 0.75*RatioStator), Array("NAME:Coordinate", "X:=", 84.6, "Y:=", 0.76*RatioStator), _
  Array("NAME:Coordinate", "X:=", 85.7, "Y:=", 0.77*RatioStator), Array("NAME:Coordinate", "X:=", 86.8, "Y:=", 0.78*RatioStator), _
  Array("NAME:Coordinate", "X:=", 87.9, "Y:=", 0.79*RatioStator), Array("NAME:Coordinate", "X:=", 89, "Y:=",   0.80*RatioStator), _
  Array("NAME:Coordinate", "X:=", 90.5, "Y:=", 0.81*RatioStator), Array("NAME:Coordinate", "X:=", 92, "Y:=",   0.82*RatioStator), _
  Array("NAME:Coordinate", "X:=", 93, "Y:=",   0.83*RatioStator), Array("NAME:Coordinate", "X:=", 94, "Y:=",   0.84*RatioStator), _
  Array("NAME:Coordinate", "X:=", 95, "Y:=", 0.85*RatioStator), Array("NAME:Coordinate", "X:=", 96, "Y:=", 0.86*RatioStator), _
  Array("NAME:Coordinate", "X:=", 97, "Y:=", 0.87*RatioStator), Array("NAME:Coordinate", "X:=", 98, "Y:=", 0.88*RatioStator), _
  Array("NAME:Coordinate", "X:=", 99, "Y:=", 0.89*RatioStator), Array("NAME:Coordinate", "X:=", 100, "Y:=", 0.9*RatioStator), _
  Array("NAME:Coordinate", "X:=", 101.2, "Y:=", 0.91*RatioStator), Array("NAME:Coordinate", "X:=", 102.4, "Y:=", 0.92*RatioStator), _
  Array("NAME:Coordinate", "X:=", 103.6, "Y:=", 0.93*RatioStator), Array("NAME:Coordinate", "X:=", 104.8, "Y:=", 0.94*RatioStator), _
  Array("NAME:Coordinate", "X:=", 106, "Y:=", 0.95*RatioStator), Array("NAME:Coordinate", "X:=", 107.2, "Y:=", 0.96*RatioStator), _
  Array("NAME:Coordinate", "X:=", 108.4, "Y:=", 0.97*RatioStator), Array("NAME:Coordinate", "X:=", 109.6, "Y:=", 0.98*RatioStator), _
  Array("NAME:Coordinate", "X:=", 110.8, "Y:=", 0.99*RatioStator), Array("NAME:Coordinate", "X:=", 112, "Y:=", 1*RatioStator), _
  Array("NAME:Coordinate", "X:=", 120, "Y:=", 1.01*RatioStator), Array("NAME:Coordinate", "X:=", 122.5, "Y:=", 1.02*RatioStator), _
  Array("NAME:Coordinate", "X:=", 124.8, "Y:=", 1.03*RatioStator), Array("NAME:Coordinate", "X:=", 127, "Y:=", 1.04*RatioStator), _ 
  Array("NAME:Coordinate", "X:=", 129, "Y:=", 1.05*RatioStator), Array("NAME:Coordinate", "X:=", 132, "Y:=", 1.06*RatioStator), _
  Array("NAME:Coordinate", "X:=", 134, "Y:=", 1.07*RatioStator), Array("NAME:Coordinate", "X:=", 137, "Y:=", 1.08*RatioStator), _
  Array("NAME:Coordinate", "X:=", 139, "Y:=", 1.09*RatioStator), Array("NAME:Coordinate", "X:=", 142, "Y:=", 1.1*RatioStator), _
  Array("NAME:Coordinate", "X:=", 144, "Y:=", 1.11*RatioStator), Array("NAME:Coordinate", "X:=", 146, "Y:=", 1.12*RatioStator), _
  Array("NAME:Coordinate", "X:=", 149, "Y:=", 1.13*RatioStator), Array("NAME:Coordinate", "X:=", 152, "Y:=", 1.14*RatioStator), _
  Array("NAME:Coordinate", "X:=", 154, "Y:=", 1.15*RatioStator), Array("NAME:Coordinate", "X:=", 159, "Y:=", 1.16*RatioStator), _
  Array("NAME:Coordinate", "X:=", 164, "Y:=", 1.17*RatioStator), Array("NAME:Coordinate", "X:=", 169, "Y:=", 1.18*RatioStator), _
  Array("NAME:Coordinate", "X:=", 174, "Y:=", 1.19*RatioStator), Array("NAME:Coordinate", "X:=", 180, "Y:=", 1.2*RatioStator), _
  Array("NAME:Coordinate", "X:=", 188, "Y:=", 1.21*RatioStator), Array("NAME:Coordinate", "X:=", 196, "Y:=", 1.22*RatioStator), _
  Array("NAME:Coordinate", "X:=", 205, "Y:=", 1.23*RatioStator), Array("NAME:Coordinate", "X:=", 213, "Y:=", 1.24*RatioStator), _
  Array("NAME:Coordinate", "X:=", 230, "Y:=", 1.25*RatioStator), Array("NAME:Coordinate", "X:=", 246, "Y:=", 1.26*RatioStator), _
  Array("NAME:Coordinate", "X:=", 262, "Y:=", 1.27*RatioStator), Array("NAME:Coordinate", "X:=", 278, "Y:=", 1.28*RatioStator), _
  Array("NAME:Coordinate", "X:=", 294, "Y:=", 1.29*RatioStator), Array("NAME:Coordinate", "X:=", 310, "Y:=", 1.3*RatioStator), _
  Array("NAME:Coordinate", "X:=", 318, "Y:=", 1.31*RatioStator), Array("NAME:Coordinate", "X:=", 326, "Y:=", 1.32*RatioStator), _
  Array("NAME:Coordinate", "X:=", 334, "Y:=", 1.33*RatioStator), Array("NAME:Coordinate", "X:=", 342, "Y:=", 1.34*RatioStator), _
  Array("NAME:Coordinate", "X:=", 350, "Y:=", 1.35*RatioStator), Array("NAME:Coordinate", "X:=", 393, "Y:=", 1.36*RatioStator), _
  Array("NAME:Coordinate", "X:=", 436, "Y:=", 1.37*RatioStator), Array("NAME:Coordinate", "X:=", 480, "Y:=", 1.38*RatioStator), _
  Array("NAME:Coordinate", "X:=", 523, "Y:=", 1.39*RatioStator), Array("NAME:Coordinate", "X:=", 566, "Y:=", 1.4*RatioStator), _
  Array("NAME:Coordinate", "X:=", 673, "Y:=", 1.41*RatioStator), Array("NAME:Coordinate", "X:=", 780, "Y:=", 1.42*RatioStator), _
  Array("NAME:Coordinate", "X:=", 886, "Y:=", 1.43*RatioStator), Array("NAME:Coordinate", "X:=", 993, "Y:=", 1.44*RatioStator), _
  Array("NAME:Coordinate", "X:=", 1100, "Y:=", 1.45*RatioStator), Array("NAME:Coordinate", "X:=", 1250, "Y:=", 1.46*RatioStator), _
  Array("NAME:Coordinate", "X:=", 1400, "Y:=", 1.47*RatioStator), Array("NAME:Coordinate", "X:=", 1550, "Y:=", 1.48*RatioStator), _
  Array("NAME:Coordinate", "X:=", 1700, "Y:=", 1.49*RatioStator), Array("NAME:Coordinate", "X:=", 1850, "Y:=", 1.5*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2010, "Y:=", 1.51*RatioStator), Array("NAME:Coordinate", "X:=", 2180, "Y:=", 1.52*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2340, "Y:=", 1.53*RatioStator), Array("NAME:Coordinate", "X:=", 2500, "Y:=", 1.54*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2660, "Y:=", 1.55*RatioStator), Array("NAME:Coordinate", "X:=", 2810, "Y:=", 1.56*RatioStator), _
  Array("NAME:Coordinate", "X:=", 2970, "Y:=", 1.57*RatioStator), Array("NAME:Coordinate", "X:=", 3130, "Y:=", 1.58*RatioStator), _
  Array("NAME:Coordinate", "X:=", 3282, "Y:=", 1.59*RatioStator), Array("NAME:Coordinate", "X:=", 3550, "Y:=", 1.6*RatioStator), _
  Array("NAME:Coordinate", "X:=", 3910, "Y:=", 1.61*RatioStator), Array("NAME:Coordinate", "X:=", 4280, "Y:=", 1.62*RatioStator), _
  Array("NAME:Coordinate", "X:=", 4640, "Y:=", 1.63*RatioStator), Array("NAME:Coordinate", "X:=", 5000, "Y:=", 1.64*RatioStator), _
  Array("NAME:Coordinate", "X:=", 5400, "Y:=", 1.65*RatioStator), Array("NAME:Coordinate", "X:=", 5670, "Y:=", 1.66*RatioStator), _
  Array("NAME:Coordinate", "X:=", 5940, "Y:=", 1.67*RatioStator), Array("NAME:Coordinate", "X:=", 6210, "Y:=", 1.68*RatioStator), _
  Array("NAME:Coordinate", "X:=", 6480, "Y:=", 1.69*RatioStator), Array("NAME:Coordinate", "X:=", 6750, "Y:=", 1.7*RatioStator), _
  Array("NAME:Coordinate", "X:=", 7050, "Y:=", 1.71*RatioStator), Array("NAME:Coordinate", "X:=", 7350, "Y:=", 1.72*RatioStator), _
  Array("NAME:Coordinate", "X:=", 7640, "Y:=", 1.73*RatioStator), Array("NAME:Coordinate", "X:=", 7940, "Y:=", 1.74*RatioStator), _
  Array("NAME:Coordinate", "X:=", 8240, "Y:=", 1.75*RatioStator), Array("NAME:Coordinate", "X:=", 8830, "Y:=", 1.76*RatioStator), _
  Array("NAME:Coordinate", "X:=", 9410, "Y:=", 1.77*RatioStator), Array("NAME:Coordinate", "X:=", 10000, "Y:=", 1.78*RatioStator), _
  Array("NAME:Coordinate", "X:=", 10540, "Y:=", 1.79*RatioStator), Array("NAME:Coordinate", "X:=", 11080, "Y:=", 1.8*RatioStator), _
  Array("NAME:Coordinate", "X:=", 11670, "Y:=", 1.81*RatioStator), Array("NAME:Coordinate", "X:=", 12270, "Y:=", 1.82*RatioStator), _
  Array("NAME:Coordinate", "X:=", 12860, "Y:=", 1.83*RatioStator), Array("NAME:Coordinate", "X:=", 13460, "Y:=", 1.84*RatioStator), _
  Array("NAME:Coordinate", "X:=", 14050, "Y:=", 1.85*RatioStator), Array("NAME:Coordinate", "X:=", 14800, "Y:=", 1.86*RatioStator), _
  Array("NAME:Coordinate", "X:=", 15560, "Y:=", 1.87*RatioStator), Array("NAME:Coordinate", "X:=", 16350, "Y:=", 1.88*RatioStator), _
  Array("NAME:Coordinate", "X:=", 17070, "Y:=", 1.89*RatioStator), Array("NAME:Coordinate", "X:=", 17820, "Y:=", 1.9*RatioStator), _
  Array("NAME:Coordinate", "X:=", 18530, "Y:=", 1.91*RatioStator), Array("NAME:Coordinate", "X:=", 19230, "Y:=", 1.92*RatioStator), _
  Array("NAME:Coordinate", "X:=", 19940, "Y:=", 1.93*RatioStator), Array("NAME:Coordinate", "X:=", 20640, "Y:=", 1.94*RatioStator), _
  Array("NAME:Coordinate", "X:=", 21350, "Y:=", 1.95*RatioStator), Array("NAME:Coordinate", "X:=", 22530, "Y:=", 1.96*RatioStator), _
  Array("NAME:Coordinate", "X:=", 23710, "Y:=", 1.97*RatioStator), Array("NAME:Coordinate", "X:=", 24890, "Y:=", 1.98*RatioStator), _
  Array("NAME:Coordinate", "X:=", 26070, "Y:=", 1.99*RatioStator), Array("NAME:Coordinate", "X:=", 27250, "Y:=", 2*RatioStator), _
  Array("NAME:Coordinate", "X:=", 29040, "Y:=", 2.01*RatioStator), Array("NAME:Coordinate", "X:=", 30820, "Y:=", 2.02*RatioStator), _
  Array("NAME:Coordinate", "X:=", 32610, "Y:=", 2.03*RatioStator), Array("NAME:Coordinate", "X:=", 34390, "Y:=", 2.04*RatioStator), _
  Array("NAME:Coordinate", "X:=", 36180, "Y:=", 2.05*RatioStator), Array("NAME:Coordinate", "X:=", 39570, "Y:=", 2.06*RatioStator), _
  Array("NAME:Coordinate", "X:=", 42960, "Y:=", 2.07*RatioStator), Array("NAME:Coordinate", "X:=", 46340, "Y:=", 2.08*RatioStator), _
  Array("NAME:Coordinate", "X:=", 49730, "Y:=", 2.09*RatioStator), Array("NAME:Coordinate", "X:=", 53120, "Y:=", 2.1*RatioStator), _
  Array("NAME:Coordinate", "X:=", 56270, "Y:=", 2.11*RatioStator), Array("NAME:Coordinate", "X:=", 59410, "Y:=", 2.12*RatioStator), _
  Array("NAME:Coordinate", "X:=", 62560, "Y:=", 2.13*RatioStator), Array("NAME:Coordinate", "X:=", 65700, "Y:=", 2.14*RatioStator), _
  Array("NAME:Coordinate", "X:=", 68850, "Y:=", 2.15*RatioStator))), "conductivity:=",  "1818100", _
  Array("NAME:magnetic_coercivity", "property_type:=", "VectorProperty", "Magnitude:=", _
  "0A_per_meter", "DirComp1:=", "1", "DirComp2:=", "0", "DirComp3:=", "0"), Array("NAME:core_loss_type", "property_type:=",  _
  "ChoiceProperty", "Choice:=", "Electrical Steel"), "core_loss_kh:=", CStr(StTLoss(0)), "core_loss_kc:=",  _
  CStr(StTLoss(1)), "core_loss_ke:=", CStr(StTLoss(2)), "core_loss_kdc:=", "0", "mass_density:=",  _
  "7800")
' ----------------------------------------------
' Check materials: material rotor
' ----------------------------------------------
   oDefinitionManager.AddMaterial Array("NAME:" & Material_rotor, "CoordinateSystemType:=",  _
  "Cartesian", Array("NAME:AttachedData"), Array("NAME:ModifierData"), Array("NAME:permeability", "property_type:=",  _
  "nonlinear", "HUnit:=", "A_per_meter", "BUnit:=", "tesla", Array("NAME:BHCoordinates", Array("NAME:Coordinate", "X:=",  _
  0, "Y:=", 0), Array("NAME:Coordinate", "X:=", 25, "Y:=", 0.05), Array("NAME:Coordinate", "X:=",  _
  49, "Y:=", 0.1), Array("NAME:Coordinate", "X:=", 74, "Y:=", 0.15), Array("NAME:Coordinate", "X:=",  _
  98, "Y:=", 0.2), Array("NAME:Coordinate", "X:=", 123, "Y:=", 0.25), Array("NAME:Coordinate", "X:=",  _
  148, "Y:=", 0.3), Array("NAME:Coordinate", "X:=", 172, "Y:=", 0.35), Array("NAME:Coordinate", "X:=",  _
  197, "Y:=", 0.4), Array("NAME:Coordinate", "X:=", 221, "Y:=", 0.45), Array("NAME:Coordinate", "X:=",  _
  246, "Y:=", 0.5), Array("NAME:Coordinate", "X:=", 270, "Y:=", 0.55), Array("NAME:Coordinate", "X:=",  _
  295, "Y:=", 0.6), Array("NAME:Coordinate", "X:=", 320, "Y:=", 0.65), Array("NAME:Coordinate", "X:=",  _
  345, "Y:=", 0.7), Array("NAME:Coordinate", "X:=", 375, "Y:=", 0.75), Array("NAME:Coordinate", "X:=",  _
  405, "Y:=", 0.8), Array("NAME:Coordinate", "X:=", 440, "Y:=", 0.85), Array("NAME:Coordinate", "X:=",  _
  480, "Y:=", 0.9), Array("NAME:Coordinate", "X:=", 490, "Y:=", 0.91), Array("NAME:Coordinate", "X:=",  _
  495, "Y:=", 0.92), Array("NAME:Coordinate", "X:=", 505, "Y:=", 0.93), Array("NAME:Coordinate", "X:=",  _
  510, "Y:=", 0.94), Array("NAME:Coordinate", "X:=", 520, "Y:=", 0.95), Array("NAME:Coordinate", "X:=",  _
  530, "Y:=", 0.96), Array("NAME:Coordinate", "X:=", 540, "Y:=", 0.97), Array("NAME:Coordinate", "X:=",  _
  550, "Y:=", 0.98), Array("NAME:Coordinate", "X:=", 560, "Y:=", 0.99), Array("NAME:Coordinate", "X:=",  _
  570, "Y:=", 1), Array("NAME:Coordinate", "X:=", 582, "Y:=", 1.01), Array("NAME:Coordinate", "X:=",  _
  595, "Y:=", 1.02), Array("NAME:Coordinate", "X:=", 607, "Y:=", 1.03), Array("NAME:Coordinate", "X:=",  _
  615, "Y:=", 1.04), Array("NAME:Coordinate", "X:=", 630, "Y:=", 1.05), Array("NAME:Coordinate", "X:=",  _
  642, "Y:=", 1.06), Array("NAME:Coordinate", "X:=", 655, "Y:=", 1.07), Array("NAME:Coordinate", "X:=",  _
  665, "Y:=", 1.08), Array("NAME:Coordinate", "X:=", 680, "Y:=", 1.09), Array("NAME:Coordinate", "X:=",  _
  690, "Y:=", 1.1), Array("NAME:Coordinate", "X:=", 703, "Y:=", 1.11), Array("NAME:Coordinate", "X:=",  _
  720, "Y:=", 1.12), Array("NAME:Coordinate", "X:=", 731, "Y:=", 1.13), Array("NAME:Coordinate", "X:=",  _
  748, "Y:=", 1.14), Array("NAME:Coordinate", "X:=", 760, "Y:=", 1.15), Array("NAME:Coordinate", "X:=",  _
  775, "Y:=", 1.16), Array("NAME:Coordinate", "X:=", 790, "Y:=", 1.17), Array("NAME:Coordinate", "X:=",  _
  808, "Y:=", 1.18), Array("NAME:Coordinate", "X:=", 825, "Y:=", 1.19), Array("NAME:Coordinate", "X:=",  _
  845, "Y:=", 1.2), Array("NAME:Coordinate", "X:=", 860, "Y:=", 1.21), Array("NAME:Coordinate", "X:=",  _
  880, "Y:=", 1.22), Array("NAME:Coordinate", "X:=", 900, "Y:=", 1.23), Array("NAME:Coordinate", "X:=",  _
  920, "Y:=", 1.24), Array("NAME:Coordinate", "X:=", 940, "Y:=", 1.25), Array("NAME:Coordinate", "X:=",  _
  960, "Y:=", 1.26), Array("NAME:Coordinate", "X:=", 992, "Y:=", 1.27), Array("NAME:Coordinate", "X:=",  _
  1015, "Y:=", 1.28), Array("NAME:Coordinate", "X:=", 1045, "Y:=", 1.29), Array("NAME:Coordinate", "X:=",  _
  1080, "Y:=", 1.3), Array("NAME:Coordinate", "X:=", 1112, "Y:=", 1.31), Array("NAME:Coordinate", "X:=",  _
  1145, "Y:=", 1.32), Array("NAME:Coordinate", "X:=", 1175, "Y:=", 1.33), Array("NAME:Coordinate", "X:=",  _
  1220, "Y:=", 1.34), Array("NAME:Coordinate", "X:=", 1260, "Y:=", 1.35), Array("NAME:Coordinate", "X:=",  _
  1300, "Y:=", 1.36), Array("NAME:Coordinate", "X:=", 1350, "Y:=", 1.37), Array("NAME:Coordinate", "X:=",  _
  1393, "Y:=", 1.38), Array("NAME:Coordinate", "X:=", 1450, "Y:=", 1.39), Array("NAME:Coordinate", "X:=",  _
  1490, "Y:=", 1.4), Array("NAME:Coordinate", "X:=", 1530, "Y:=", 1.41), Array("NAME:Coordinate", "X:=",  _
  1595, "Y:=", 1.42), Array("NAME:Coordinate", "X:=", 1645, "Y:=", 1.43), Array("NAME:Coordinate", "X:=",  _
  1700, "Y:=", 1.44), Array("NAME:Coordinate", "X:=", 1750, "Y:=", 1.45), Array("NAME:Coordinate", "X:=",  _
  1835, "Y:=", 1.46), Array("NAME:Coordinate", "X:=", 1920, "Y:=", 1.47), Array("NAME:Coordinate", "X:=",  _
  2010, "Y:=", 1.48), Array("NAME:Coordinate", "X:=", 2110, "Y:=", 1.49), Array("NAME:Coordinate", "X:=",  _
  2270, "Y:=", 1.5), Array("NAME:Coordinate", "X:=", 2450, "Y:=", 1.51), Array("NAME:Coordinate", "X:=",  _
  2560, "Y:=", 1.52), Array("NAME:Coordinate", "X:=", 2710, "Y:=", 1.53), Array("NAME:Coordinate", "X:=",  _
  2880, "Y:=", 1.54), Array("NAME:Coordinate", "X:=", 3050, "Y:=", 1.55), Array("NAME:Coordinate", "X:=",  _
  3200, "Y:=", 1.56), Array("NAME:Coordinate", "X:=", 3400, "Y:=", 1.57), Array("NAME:Coordinate", "X:=",  _
  3650, "Y:=", 1.58), Array("NAME:Coordinate", "X:=", 3750, "Y:=", 1.59), Array("NAME:Coordinate", "X:=",  _
  4000, "Y:=", 1.6), Array("NAME:Coordinate", "X:=", 4250, "Y:=", 1.61), Array("NAME:Coordinate", "X:=",  _
  4500, "Y:=", 1.62), Array("NAME:Coordinate", "X:=", 4750, "Y:=", 1.63), Array("NAME:Coordinate", "X:=",  _
  5000, "Y:=", 1.64), Array("NAME:Coordinate", "X:=", 5250, "Y:=", 1.65), Array("NAME:Coordinate", "X:=",  _
  5580, "Y:=", 1.66), Array("NAME:Coordinate", "X:=", 5950, "Y:=", 1.67), Array("NAME:Coordinate", "X:=",  _
  6230, "Y:=", 1.68), Array("NAME:Coordinate", "X:=", 6600, "Y:=", 1.69), Array("NAME:Coordinate", "X:=",  _
  7050, "Y:=", 1.7), Array("NAME:Coordinate", "X:=", 7530, "Y:=", 1.71), Array("NAME:Coordinate", "X:=",  _
  7950, "Y:=", 1.72), Array("NAME:Coordinate", "X:=", 8400, "Y:=", 1.73), Array("NAME:Coordinate", "X:=",  _
  8850, "Y:=", 1.74), Array("NAME:Coordinate", "X:=", 9320, "Y:=", 1.75), Array("NAME:Coordinate", "X:=",  _
  9800, "Y:=", 1.76), Array("NAME:Coordinate", "X:=", 10300, "Y:=", 1.77), Array("NAME:Coordinate", "X:=",  _
  10800, "Y:=", 1.78), Array("NAME:Coordinate", "X:=", 11400, "Y:=", 1.79), Array("NAME:Coordinate", "X:=",  _
  11900, "Y:=", 1.8), Array("NAME:Coordinate", "X:=", 12400, "Y:=", 1.81), Array("NAME:Coordinate", "X:=",  _
  13000, "Y:=", 1.82), Array("NAME:Coordinate", "X:=", 13500, "Y:=", 1.83), Array("NAME:Coordinate", "X:=",  _
  14100, "Y:=", 1.84), Array("NAME:Coordinate", "X:=", 14800, "Y:=", 1.85), Array("NAME:Coordinate", "X:=",  _
  15600, "Y:=", 1.86), Array("NAME:Coordinate", "X:=", 16200, "Y:=", 1.87), Array("NAME:Coordinate", "X:=",  _
  17000, "Y:=", 1.88), Array("NAME:Coordinate", "X:=", 17800, "Y:=", 1.89), Array("NAME:Coordinate", "X:=",  _
  18800, "Y:=", 1.9), Array("NAME:Coordinate", "X:=", 19700, "Y:=", 1.91), Array("NAME:Coordinate", "X:=",  _
  20700, "Y:=", 1.92), Array("NAME:Coordinate", "X:=", 21500, "Y:=", 1.93), Array("NAME:Coordinate", "X:=",  _
  22600, "Y:=", 1.94), Array("NAME:Coordinate", "X:=", 23500, "Y:=", 1.95), Array("NAME:Coordinate", "X:=",  _
  24500, "Y:=", 1.96), Array("NAME:Coordinate", "X:=", 25600, "Y:=", 1.97), Array("NAME:Coordinate", "X:=",  _
  26500, "Y:=", 1.98), Array("NAME:Coordinate", "X:=", 27500, "Y:=", 1.99), Array("NAME:Coordinate", "X:=",  _
  29000, "Y:=", 2), Array("NAME:Coordinate", "X:=", 30200, "Y:=", 2.01), Array("NAME:Coordinate", "X:=",  _
  31500, "Y:=", 2.02), Array("NAME:Coordinate", "X:=", 32800, "Y:=", 2.03), Array("NAME:Coordinate", "X:=",  _
  34200, "Y:=", 2.04), Array("NAME:Coordinate", "X:=", 36100, "Y:=", 2.05), Array("NAME:Coordinate", "X:=",  _
  38000, "Y:=", 2.06), Array("NAME:Coordinate", "X:=", 40000, "Y:=", 2.07), Array("NAME:Coordinate", "X:=",  _
  42000, "Y:=", 2.08), Array("NAME:Coordinate", "X:=", 44000, "Y:=", 2.09), Array("NAME:Coordinate", "X:=",  _
  46000, "Y:=", 2.1), Array("NAME:Coordinate", "X:=", 48000, "Y:=", 2.11), Array("NAME:Coordinate", "X:=",  _
  50000, "Y:=", 2.12), Array("NAME:Coordinate", "X:=", 52000, "Y:=", 2.13), Array("NAME:Coordinate", "X:=",  _
  54000, "Y:=", 2.14), Array("NAME:Coordinate", "X:=", 56000, "Y:=", 2.15), Array("NAME:Coordinate", "X:=",  _
  58000, "Y:=", 2.16), Array("NAME:Coordinate", "X:=", 60000, "Y:=", 2.17), Array("NAME:Coordinate", "X:=",  _
  62000, "Y:=", 2.18), Array("NAME:Coordinate", "X:=", 64000, "Y:=", 2.19))), "conductivity:=",  _
  "7690000", Array("NAME:magnetic_coercivity", "property_type:=", "VectorProperty", "Magnitude:=",  _
  "0A_per_meter", "DirComp1:=", "1", "DirComp2:=", "0", "DirComp3:=", "0"), Array("NAME:core_loss_type", "property_type:=",  _
  "ChoiceProperty", "Choice:=", "Electrical Steel"), "core_loss_kh:=", CStr(RotLoss(0)), "core_loss_kc:=",  _
  CStr(RotLoss(1)), "core_loss_ke:=", CStr(RotLoss(2)), "core_loss_kdc:=", "0", "mass_density:=",  _
  "7800")
' ----------------------------------------------
' Create band, small air sector, mover
' ----------------------------------------------
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "$DiaYoke/2", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "Band", "Flags:=", "", _
  "Color:=", "(255 255 255)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & "vacuum-air" & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "0mm", "OriginY:=", "0mm", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1/tan(2*" & CStr(PiConst) & "/$Poles/2)*1mm", "XAxisYvec:=", "1mm", "XAxisZvec:=", "0mm", _
  "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "SplitPoleLeft")
oEditor.Split Array("NAME:Selections", _
  "Selections:=", "Band", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:SplitToParameters", _
  "SplitPlane:=", "YZ", _
  "WhichSide:=", "PositiveOnly", _
  "SplitCrossingObjectsOnly:=", false, _
  "DeleteInvalidObjects:=", true)
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "Global")
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "0mm", "OriginY:=", "0mm", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "-1/tan(2*" & CStr(PiConst) & "/$Poles*($CalArea-.5))*1mm", "XAxisYvec:=", "1mm", "XAxisZvec:=", "0mm", _
  "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "SplitPoleRight")
oEditor.Split Array("NAME:Selections", _
  "Selections:=", "Band", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:SplitToParameters", _
  "SplitPlane:=", "YZ", _
  "WhichSide:=", "PositiveOnly", _
  "SplitCrossingObjectsOnly:=", false, _
  "DeleteInvalidObjects:=", true)
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "Global")
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "$RadiusInRimRotor", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "SmallAirSector", "Flags:=", "", _
  "Color:=", "(255 255 255)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & "vacuum-air" & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "($DiaGap-$AirGap)/2", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "Mover", "Flags:=", "", _
  "Color:=", "(255 255 255)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & "vacuum-air" & Chr(34) & "", _
  "SolveInside:=", true)  
' ----------------------------------------------
' Create stator. Create yoke side
' ----------------------------------------------
If AngleD <> 0 Then
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "0mm", "OriginY:=", "0mm", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1/tan(2*" & CStr(PiConst) & "*$AngleD/$Z1)*1mm", "XAxisYvec:=", "1mm", "XAxisZvec:=", "0mm", _
  "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "AngleD")
End If
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "$DiaCal1/2", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "DiaCal1_1", "Flags:=", "", _
  "Color:=", "(192 192 192)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_stator_yoke & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "$DiaYoke/2", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "DiaYoke", "Flags:=", "", _
  "Color:=", "(192 192 192)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_stator_yoke & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.Subtract Array("NAME:Selections", _ 
  "Blank Parts:=", "DiaYoke", _
  "Tool Parts:=", "DiaCal1_1"), _
  Array("NAME:SubtractParameters", "KeepOriginals:=", false)
' ----------------------------------------------
' Create gap side 
' ----------------------------------------------
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "$DiaCal1/2", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "DiaTooth", "Flags:=", "", _
  "Color:=", "(192 192 192)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_stator_tooth & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "$DiaGap/2", "WhichAxis:=",  "Z", "NumSegments:=", "0"), _ 
  Array("NAME:Attributes", "Name:=", "DiaGap_1", "Flags:=", "", _
  "Color:=", "(192 192 192)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_stator_tooth & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.Subtract Array("NAME:Selections", "Blank Parts:=", "DiaTooth", "Tool Parts:=", "DiaGap_1"), _
Array("NAME:SubtractParameters", "KeepOriginals:=", false)
' ----------------------------------------------
' Create a stator slot
' ----------------------------------------------
oEditor.CreatePolyline Array("NAME:PolylineParameters", "IsPolylineCovered:=", _
  true, "IsPolylineClosed:=", true, Array("NAME:PolylinePoints",  _
  Array("NAME:PLPoint", "X:=", "$Bs2/2", "Y:=", "$DiaGap/2+$Hs0+$Hs1+$Hs2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "$Bs2/2", "Y:=", "$DiaGap/2+$Hs1+$Hs2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "$Bs1/2", "Y:=", "$DiaGap/2+$Hs1+$Hs2-($Bs1-$Bs2)/(2*tan($Alphas1))", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "$Bs2/2", "Y:=", "$DiaGap/2+$Hs2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "$Bs2/2", "Y:=", "$DiaGap/2-$AirGap/2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "-$Bs2/2", "Y:=", "$DiaGap/2-$AirGap/2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "-$Bs2/2", "Y:=", "$DiaGap/2+$Hs2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "-$Bs1/2", "Y:=", "$DiaGap/2+$Hs1+$Hs2-($Bs1-$Bs2)/(2*tan($Alphas1))", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "-$Bs2/2", "Y:=", "$DiaGap/2+$Hs1+$Hs2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "-$Bs2/2", "Y:=", "$DiaGap/2+$Hs0+$Hs1+$Hs2", "Z:=", "0mm"),  _
  Array("NAME:PLPoint", "X:=", "$Bs2/2", "Y:=", "$DiaGap/2+$Hs0+$Hs1+$Hs2", "Z:=", "0mm")),  _
  Array("NAME:PolylineSegments", Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 0, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 1, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 2, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 3, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 4, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 5, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 6, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 7, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 8, "NoOfPoints:=", 2), Array("NAME:PLSegment", "SegmentType:=",  _
  "Line", "StartIndex:=", 9, "NoOfPoints:=", 2)), Array("NAME:PolylineXSection", "XSectionType:=",  _
  "None", "XSectionOrient:=", "Auto", "XSectionWidth:=", "0mm", "XSectionTopWidth:=",  _
  "0mm", "XSectionHeight:=", "0mm", "XSectionNumSegments:=", "0", "XSectionBendType:=",  _
  "Corner")), Array("NAME:Attributes", "Name:=", "Slot", "Flags:=", "", "Color:=",  _
  "(0 0 0)", "Transparency:=", 0, "PartCoordinateSystem:=", "Global", "UDMId:=",  _
  "", "MaterialValue:=", "" & Chr(34) & "vacuum-air" & Chr(34) & "", "SolveInside:=",  _
  true)
oEditor.DuplicateAroundAxis Array("NAME:Selections", _
  "Selections:=", "Slot", "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateAroundAxisParameters", _
  "CreateNewObjects:=", false, "WhichAxis:=", "Z", _
  "AngleStr:=", "2*" & CStr(PiConst) & "/$Z1", "NumClones:=", "$Z1"), _
  Array("NAME:Options", "DuplicateAssignments:=", false)
oEditor.Subtract Array("NAME:Selections", _
  "Blank Parts:=", "DiaTooth", _
  "Tool Parts:=", "Slot"), _
  Array("NAME:SubtractParameters", "KeepOriginals:=", false)
' ----------------------------------------------
' Create stator winding
' ----------------------------------------------
oEditor.CreateRectangle Array("NAME:RectangleParameters", "IsCovered:=", true, _
  "XStart:=", "-$Bsw/2", "YStart:=", "$DiaGap/2+$Hs0+$Hs1+$Hs2-$Hsw_gap", "ZStart:=", "0mm", _
  "Width:=", "$Bsw", "Height:=", "-$Hsw", "WhichAxis:=", "Z"), _
  Array("NAME:Attributes", "Name:=", "StW_B", "Flags:=", "", _
  "Color:=", "(132 132 193)", "Transparency:=", 0, "PartCoordinateSystem:=", "Global", _
  "UDMId:=", "", "MaterialValue:=", "" & Chr(34) & "copper-75C" & Chr(34) & "", "SolveInside:=", true)
oEditor.DuplicateAroundAxis Array("NAME:Selections", _
  "Selections:=", "StW_B", "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateAroundAxisParameters", "CreateNewObjects:=", true, "WhichAxis:=", "Z", _
  "AngleStr:=", "-2*" & CStr(PiConst) & "/$Z1", "NumClones:=", "$NumberWSE"), _
  Array("NAME:Options", "DuplicateAssignments:=", false)
oEditor.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:Geometry3DAttributeTab", _
  Array("NAME:PropServers", "StW_B"), _
  Array("NAME:ChangedProps", _
  Array("NAME:Name", "Value:=", "StW_B_0"))))
oEditor.CreateRectangle Array("NAME:RectangleParameters", "IsCovered:=", true, _
  "XStart:=", "-$Bsw/2", "YStart:=", "$DiaGap/2+$Hs0+$Hs1+$Hs2-$Hsw_gap-$Hsw_between-$Hsw", "ZStart:=", "0mm", _
  "Width:=", "$Bsw", "Height:=", "-$Hsw", "WhichAxis:=", "Z"), _
  Array("NAME:Attributes", "Name:=", "StW_T", "Flags:=", "", _
  "Color:=", "(132 132 193)", "Transparency:=", 0, "PartCoordinateSystem:=", "Global", "UDMId:=", "", _ 
  "MaterialValue:=", "" & Chr(34) & "copper-75C" & Chr(34) & "", "SolveInside:=", true)
oEditor.DuplicateAroundAxis Array("NAME:Selections", _
  "Selections:=", "StW_T", "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateAroundAxisParameters", "CreateNewObjects:=", true, "WhichAxis:=", "Z", _
  "AngleStr:=", "-2*" & CStr(PiConst) & "/$Z1", "NumClones:=", "$NumberWSE"), _
  Array("NAME:Options", "DuplicateAssignments:=", false) 
oEditor.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:Geometry3DAttributeTab", _
  Array("NAME:PropServers", "StW_T"), _
  Array("NAME:ChangedProps", _
  Array("NAME:Name", "Value:=", "StW_T_0"))))
If AngleD <> 0 Then
  oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "Global")
End If
' ----------------------------------------------
' Stator current a-x is Imax, b-y and c-z is Imax/2
' ----------------------------------------------
Dim SwArrayM()
rgt = Ubound(WindingTop)
ReDim SwArrayM(rgt,1)
If CalArea = 1 then 
  ReDim SwArrayM(2*(2*rgt+1)+1,1)
Else  
  ReDim SwArrayM(2*rgt+1,1)
End If
' Join WindingTop and WindingBottom 	   
For i = 0 to rgt
  SwArrayM(i,0) = WindingTop(i)
  SwArrayM(i,1) = WindingBottom(i)
Next
' SwArrayM multiplied by two 	
For j = 0 to 1
  For i = 0 to rgt
    If CalArea mod 2 = 1 then
      Select Case SwArrayM(i,j)
        Case "a"
	      SwArrayM(i+rgt+1,j) =  "x"
        Case "x"
	      SwArrayM(i+rgt+1,j) =  "a"
	    Case "b"
	      SwArrayM(i+rgt+1,j) =  "y"
        Case "y"
	      SwArrayM(i+rgt+1,j) =  "b"
	    Case "c"
	      SwArrayM(i+rgt+1,j) =  "z"
        Case "z"
	      SwArrayM(i+rgt+1,j) =  "c"
      End Select
	Else
      SwArrayM(i+rgt+1,j) = SwArrayM(i,j)
	End If  
  Next
Next
' SwArrayM multiplied by two if CalArea = 1	
If CalArea = 1 then
  For j = 0 to 1
    For i = 0 to 2*rgt+1
	  SwArrayM(i+2*rgt+2,j) = SwArrayM(i,j)
    Next
  Next
End If
' Return the new arrays WindingTop and WindingBottom
For i = 0 to rgt
  WindingTop(i) =  SwArrayM(i+NNull,0)
  WindingBottom(i) = SwArrayM(i+NNull,1)
Next
' ----------------------------------------------
' Sub change colour of stator winding
' ----------------------------------------------
Sub ChPrColor(SW, ArColor)
  oEditor.ChangeProperty Array("NAME:AllTabs",  _
  Array("NAME:Geometry3DAttributeTab",  _
  Array("NAME:PropServers", SW),  _
  Array("NAME:ChangedProps",  _
  Array("NAME:Color", _
  "R:=", ArColor(0), _
  "G:=", ArColor(1), _
  "B:=", ArColor(2)))))
End Sub
' ----------------------------------------------
' Return stator current. New version. 15.03.2017
' ----------------------------------------------
Sub WindingGroup(phase)
  oModule.AssignWindingGroup Array("NAME:WindingStator" & phase, _
  "Type:=", "External", _
  "IsSolid:=", false, _
  "Current:=", "0A", _
  "Resistance:=", "0ohm", _
  "Inductance:=", "0mH", _
  "Voltage:=", "0V", _
  "ParallelBranchesNum:=", "$Branches")
End Sub
Sub CoilsAdd(phase, drc, str)
  oModule.EditCoil str, _
  Array("NAME:"& str, _
  "ParentBndID:=", "WindingStator" & phase, _
  "Conductor number:=", "1", _
  "Winding:=", "WindingStator" & phase, _
  "PolarityType:=", drc)
End Sub
  WindingGroup("AX")
  WindingGroup("BY")
  WindingGroup("CZ")
For j=0 to 1
  If j=0 Then 
    SWArray = WindingTop
	SWString = "StW_T_"
	SWCurrent = "CurrentT_"	
  Else 
    SWArray = WindingBottom
    SWString = "StW_B_"
	SWCurrent = "CurrentB_"
  End if
For i=0 to ubound(WindingTop)
  If SWArray(i) = "a" or SWArray(i) = "b" or SWArray(i) = "c" Then
    oModule.AssignCoil Array("NAME:" & SWCurrent & CStr(i), _
	"Objects:=", Array(SWString & CStr(i)), _
	"Conductor number:=", "1", _
	"PolarityType:=", "Positive")
	Select Case SWArray(i)
      Case "a"
        ChPrColor SWString & CStr(i), axColor
		CoilsAdd "AX", "Positive", SWCurrent & CStr(i)
	  Case "b"
	    ChPrColor SWString & CStr(i), byColor
		CoilsAdd "BY", "Positive", SWCurrent & CStr(i)
	  Case "c"
	    ChPrColor SWString & CStr(i), czColor
		CoilsAdd "CZ", "Positive", SWCurrent & CStr(i)
    End Select
  Else
    oModule.AssignCoil Array("NAME:" & SWCurrent & CStr(i), _
	"Objects:=", Array(SWString & CStr(i)), _
	"Conductor number:=", "1", _
	"PolarityType:=", "Negative")
	Select Case SWArray(i)
      Case "x"
        ChPrColor SWString & CStr(i), axColor
		CoilsAdd "AX", "Negative", SWCurrent & CStr(i)
	  Case "y"
	    ChPrColor SWString & CStr(i), byColor
		CoilsAdd "BY", "Negative", SWCurrent & CStr(i)
	  Case "z"
	    ChPrColor SWString & CStr(i), czColor
		CoilsAdd "CZ", "Negative", SWCurrent & CStr(i)		
    End Select
  End If
Next
Next
' ----------------------------------------------
' Create rotor. New version. 14.03.2017. Start
' ----------------------------------------------
If AngleR <> 0 Then
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "0mm", "OriginY:=", "0mm", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1/abs(tan($AngleR))*1mm", _
  "XAxisYvec:=", "$AngleR/abs($AngleR)*1mm", _
  "XAxisZvec:=", "0mm", _
  "YAxisXvec:=", "0mm", _
  "YAxisYvec:=", "1mm", _
  "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "AngleR")
End If
If AngleR <> 0 Then
  CSRotor = "AngleR"
Else
  CSRotor = "Global"
End If 
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "$DiaGap/2-$AirGap-$RadiusPole", "ZCenter:=", "0mm", _
  "Radius:=", "$RadiusPole", "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "PoleShoe", "Flags:=", "", _
  "Color:=", "(192 192 192)", "Transparency:=", 0, "PartCoordinateSystem:=",  _
  CSRotor, "UDMId:=", "", "MaterialValue:=", "" & Chr(34) & Material_rotor & Chr(34) & "", _
  "SolveInside:=", true)
' Split of pole shoe right ZX - bottom
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "$ShoeWidthMajor/2", "OriginY:=", "$DiaGap/2-$AirGap-$ShoeHeight", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1mm", "XAxisYvec:=", "0mm", "XAxisZvec:=", "0mm", "YAxisXvec:=", "0mm", _
  "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "PoleShoeZX_Right")
oEditor.Split Array("NAME:Selections", "Selections:=", "PoleShoe", "NewPartsModelFlag:=",  _
  "Model"), Array("NAME:SplitToParameters", "SplitPlane:=", "ZX", "WhichSide:=",  _
  "PositiveOnly", "SplitCrossingObjectsOnly:=", false, "DeleteInvalidObjects:=",  _
  true)
' Split of pole shoe right YZ - skew
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", CSRotor)  
If ShoeWidthMinor <> ShoeWidthMajor Then
  oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "$ShoeWidthMajor/2", "OriginY:=", "$DiaGap/2-$AirGap-$ShoeHeight", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "2*($ShoeHeight-$RadiusPole+cos(asin($ShoeWidthMinor/(2*$RadiusPole)))*$RadiusPole)/($ShoeWidthMajor-$ShoeWidthMinor)*1mm", _
  "XAxisYvec:=", "1mm", "XAxisZvec:=", "0mm", _
  "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "PoleShoeYZ_Right")  
Else
  oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "$ShoeWidthMajor/2", "OriginY:=", "$DiaGap/2-$AirGap-$ShoeHeight", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1mm", "XAxisYvec:=", "0mm", "XAxisZvec:=", "0mm", _
  "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "PoleShoeYZ_Right")  
End If
oEditor.Split Array("NAME:Selections", "Selections:=", "PoleShoe", "NewPartsModelFlag:=",  _
  "Model"), Array("NAME:SplitToParameters", "SplitPlane:=", "YZ", "WhichSide:=",  _
  "NegativeOnly", "SplitCrossingObjectsOnly:=", false, "DeleteInvalidObjects:=",  _
  true)
' Split of pole shoe left YZ - skew  
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", CSRotor)
If ShoeWidthMinor <> ShoeWidthMajor Then
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "-$ShoeWidthMajor/2", "OriginY:=", "$DiaGap/2-$AirGap-$ShoeHeight", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "2*($ShoeHeight-$RadiusPole+cos(asin($ShoeWidthMinor/(2*$RadiusPole)))*$RadiusPole)/($ShoeWidthMajor-$ShoeWidthMinor)*1mm", _
  "XAxisYvec:=", "-1mm", "XAxisZvec:=", "0mm", "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "PoleShoeYZ_Left")
Else
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "-$ShoeWidthMajor/2", "OriginY:=", "$DiaGap/2-$AirGap-$ShoeHeight", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1mm", "XAxisYvec:=", "0mm", "XAxisZvec:=", "0mm", "YAxisXvec:=", "0mm", "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=", "PoleShoeYZ_Left")
End If
oEditor.Split Array("NAME:Selections", "Selections:=", "PoleShoe", "NewPartsModelFlag:=",  _
  "Model"), Array("NAME:SplitToParameters", "SplitPlane:=", "YZ", "WhichSide:=",  _
  "PositiveOnly", "SplitCrossingObjectsOnly:=", false, "DeleteInvalidObjects:=",  _
  true)
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", CSRotor)
oEditor.CreateRectangle Array("NAME:RectangleParameters", "IsCovered:=", true, _
  "XStart:=", "$PoleWidth/2", "YStart:=", "$DiaGap/2-$AirGap-$ShoeHeight", "ZStart:=", "0mm", _
  "Width:=", "-$PoleWidth", "Height:=", "-$PoleHeight", "WhichAxis:=", "Z"), _
  Array("NAME:Attributes", "Name:=", "PoleBody", "Flags:=", "", _
  "Color:=", "(192 192 192)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", CSRotor, "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_rotor & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, "XCenter:=",  _
  "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", "Radius:=", "$RadiusOutRimRotor", "WhichAxis:=",  _
  "Z", "NumSegments:=", "0"), Array("NAME:Attributes", "Name:=", "RimRotorOut", "Flags:=",  _
  "", "Color:=", "(192 192 192)", "Transparency:=", 0, "PartCoordinateSystem:=",  _
  CSRotor, "UDMId:=", "", "MaterialValue:=", "" & Chr(34) & Material_rotor & Chr(34) & "", "SolveInside:=",  _
  true)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "(2*$RadiusOutRimRotor+$RadiusInRimRotor)/3", _
  "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "RimRotorCenter_1", _
  "Flags:=", "", "Color:=", "(192 192 192)", _
  "Transparency:=", 0, "PartCoordinateSystem:=",  _
  CSRotor, "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_rotor & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.Subtract Array("NAME:Selections", _
  "Blank Parts:=", "RimRotorOut", _
  "Tool Parts:=", "RimRotorCenter_1"), _
  Array("NAME:SubtractParameters", "KeepOriginals:=", false)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm", _
  "Radius:=", "(2*$RadiusOutRimRotor+$RadiusInRimRotor)/3", _
  "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "RimRotorIn", _
  "Flags:=", "", "Color:=", "(192 192 192)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", CSRotor, "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & Material_rotor & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _
  "XCenter:=", "0mm", "YCenter:=", "0mm", "ZCenter:=", "0mm",  _
  "Radius:=", "$RadiusInRimRotor", "WhichAxis:=", "Z", "NumSegments:=", "0"),  _
  Array("NAME:Attributes", "Name:=", "RimRotorCenter_2", "Flags:=", "", "Color:=", "(192 192 192)",  _
  "Transparency:=", 0, "PartCoordinateSystem:=", CSRotor, "UDMId:=", "", "MaterialValue:=",  _
  "" & Chr(34) & Material_rotor & Chr(34) & "", "SolveInside:=", true)
oEditor.Subtract Array("NAME:Selections", _
  "Blank Parts:=", "RimRotorIn", _
  "Tool Parts:=", "RimRotorCenter_2"), _
  Array("NAME:SubtractParameters", "KeepOriginals:=", false)
oEditor.Subtract Array("NAME:Selections", _
  "Blank Parts:=", "PoleBody", _
  "Tool Parts:=", "RimRotorOut"), _
  Array("NAME:SubtractParameters", "KeepOriginals:=", true)
' ----------------------------------------------
' Create damper. Circuit
' ----------------------------------------------
oEditor.CreateRelativeCS Array("NAME:RelativeCSParameters", _
  "OriginX:=", "0mm", "OriginY:=", "$DiaGap/2-$AirGap-$RadiusPole", "OriginZ:=", "0mm", _
  "XAxisXvec:=", "1mm", "XAxisYvec:=", "0mm", _
  "XAxisZvec:=", "0mm", "YAxisXvec:=", "0mm", _
  "YAxisYvec:=", "1mm", "YAxisZvec:=", "0mm"), _
  Array("NAME:Attributes", "Name:=",  "DamperZ")
oEditor.CreateCircle Array("NAME:CircleParameters", "IsCovered:=", true, _ 
  "XCenter:=", "-$LocusDamper*sin(($SlotPole-1)/2*$AlphaD)", _
  "YCenter:=", "$LocusDamper*cos(($SlotPole-1)/2*$AlphaD)",  _
  "ZCenter:=", "0mm", _
  "Radius:=", "$DiaDamper/2", _
  "WhichAxis:=", "Z", "NumSegments:=", "0"), _
  Array("NAME:Attributes", "Name:=", "Damper", _
  "Flags:=", "", "Color:=", "(255 128 0)", _
  "Transparency:=", 0, "PartCoordinateSystem:=", CSRotor, _
  "UDMId:=", "", "MaterialValue:=", "" & Chr(34) & "copper-75C" & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.DuplicateAroundAxis Array("NAME:Selections", _
  "Selections:=", "Damper", "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateAroundAxisParameters", _
  "CreateNewObjects:=", true, "WhichAxis:=", "Z", _
  "AngleStr:=", "-$AlphaD", _
  "NumClones:=", "$SlotPole"), _
  Array("NAME:Options", "DuplicateAssignments:=", false)
oEditor.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:Geometry3DAttributeTab", _
  Array("NAME:PropServers", "Damper"), _
  Array("NAME:ChangedProps", _
  Array("NAME:Name", "Value:=", "Damper_0"))))
Delete = ""
For i = 0 to SlotPole-1 step 1  
  Delete = Delete & "Damper_" & CStr(i) & ","
Next
Delete = Left(Delete,len(Delete)-1)
oEditor.Subtract Array("NAME:Selections", _
  "Blank Parts:=", "PoleShoe", _
  "Tool Parts:=", Delete),  _
  Array("NAME:SubtractParameters", "KeepOriginals:=", true)
' ----------------------------------------------
' Create damper. Opening slot
' ----------------------------------------------
If SlotPoleOpen > 0 then
oEditor.CreateRectangle Array("NAME:RectangleParameters", "IsCovered:=", true, _
  "XStart:=", "$Bso/2", "YStart:=", "$LocusDamper", "ZStart:=", "0mm", _
  "Width:=", "-$Bso", "Height:=", "$RadiusPole-$LocusDamper", "WhichAxis:=", "Z"), _
  Array("NAME:Attributes", "Name:=", "OpeningSlot", "Flags:=", "", _
  "Color:=", "(0 0 0)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", CSRotor, "UDMId:=", "", _
  "MaterialValue:=", "" & Chr(34) & "vacuum-air" & Chr(34) & "", _
  "SolveInside:=", true)
oEditor.Rotate Array("NAME:Selections", _
  "Selections:=", "OpeningSlot", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:RotateParameters", _
  "RotateAxis:=", "Z", "RotateAngle:=", "$AlphaD*($SlotPoleOpen-1)/2")
oEditor.DuplicateAroundAxis Array("NAME:Selections", _
  "Selections:=", "OpeningSlot", "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateAroundAxisParameters", _
  "CreateNewObjects:=", false, "WhichAxis:=", "Z", _
  "AngleStr:=", "-$AlphaD", _
  "NumClones:=", "$SlotPoleOpen"), _
  Array("NAME:Options", "DuplicateAssignments:=", false)
oEditor.Subtract Array("NAME:Selections", _
  "Blank Parts:=", "PoleShoe", _
  "Tool Parts:=", "OpeningSlot"), _
  Array("NAME:SubtractParameters", "KeepOriginals:=", false)  
End If
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", CSRotor)  
' ----------------------------------------------
' Create rotor winding
' ----------------------------------------------
oEditor.CreateRectangle Array("NAME:RectangleParameters", "IsCovered:=", true, _
  "XStart:=", "$PoleWidth/2+$Srw", "YStart:=", "$DiaGap/2-$AirGap-$ShoeHeight-$Srh", "ZStart:=", "0mm", _
  "Width:=", "$Brw", "Height:=", "-$Hrw/$CoilRotor", "WhichAxis:=", "Z"), _
  Array("NAME:Attributes", "Name:=", "RotWR", "Flags:=", "", _
  "Color:=", "(255 128 0)", "Transparency:=", 0, "PartCoordinateSystem:=", CSRotor, _
  "UDMId:=", "", "MaterialValue:=", "" & Chr(34) & "copper-75C" & Chr(34) & "", "SolveInside:=", true)
If CoilRotor > 1 then
  oEditor.DuplicateAlongLine Array("NAME:Selections", _
  "Selections:=", "RotWR", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateToAlongLineParameters", _
  "CreateNewObjects:=", true, _
  "XComponent:=", "0mm", "YComponent:=", "-$Hrw/$CoilRotor", _
  "ZComponent:=", "0mm", "NumClones:=", "$CoilRotor"), _
  Array("NAME:Options", "DuplicateAssignments:=", false)
Else
End if
oEditor.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:Geometry3DAttributeTab", _
  Array("NAME:PropServers", "RotWR"), _
  Array("NAME:ChangedProps", _
  Array("NAME:Name", "Value:=", "RotWR_0"))))
RotorWindingLeft = ""
RotorWindingRight = ""
For i = 0 to CoilRotor-1 Step 1  
  RotorWindingLeft = RotorWindingLeft & "RotWR_" & CStr(i) & ","
  RotorWindingRight = RotorWindingRight & "RotWL_" & CStr(i) & ","
Next
RotorWindingLeft = Left(RotorWindingLeft,len(RotorWindingLeft)-1)
RotorWindingRight = Left(RotorWindingRight,len(RotorWindingRight)-1)
oEditor.DuplicateMirror Array("NAME:Selections", _
  "Selections:=", RotorWindingLeft, _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateToMirrorParameters", _
  "DuplicateMirrorBaseX:=", "0mm", _
  "DuplicateMirrorBaseY:=", "1mm", _
  "DuplicateMirrorBaseZ:=", "0mm", _
  "DuplicateMirrorNormalX:=",  "1mm", _
  "DuplicateMirrorNormalY:=", "0mm", _
  "DuplicateMirrorNormalZ:=", "0mm"), _
  Array("NAME:Options", _
  "DuplicateAssignments:=", false)
For i = CoilRotor-1 to 0 Step -1 
  oEditor.ChangeProperty Array("NAME:AllTabs", _
  Array("NAME:Geometry3DAttributeTab", _
  Array("NAME:PropServers", "RotWR_" & CStr(i) & "_1"), _
  Array("NAME:ChangedProps", _
  Array("NAME:Name", "Value:=", "RotWL_" & CStr(i)))))
Next
' ----------------------------------------------
' Duplicate a pole around Z-axis. New version. 31.01.2017. End
' ----------------------------------------------
If CalArea > 1 Then
oEditor.DuplicateAroundAxis Array("NAME:Selections", "Selections:=", _
  Delete & "," & RotorWindingLeft & "," & RotorWindingRight & ",PoleBody,PoleShoe", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:DuplicateAroundAxisParameters", _
  "CreateNewObjects:=", true, "WhichAxis:=", "Z", _
  "AngleStr:=", "-2*" & CStr(PiConst) & "/$Poles", _
  "NumClones:=", "$CalArea"), _
  Array("NAME:Options", "DuplicateAssignments:=", false)
End If 
' ----------------------------------------------
' Return rotor current. 16.03.2017
' ----------------------------------------------
oModule.AssignWindingGroup Array("NAME:WindingRotor", _
"Type:=", "Current", _
"IsSolid:=", false, _
"Current:=", CStr(CurrentRotor) & "A", _
"Resistance:=", "0ohm", _
"Inductance:=", "0mH", _
"Voltage:=", "0V", _
"ParallelBranchesNum:=", "1")
Sub CoilsR(drc, str)
  oModule.EditCoil str, _
  Array("NAME:"& str, _
  "ParentBndID:=", "WindingRotor", _
  "Conductor number:=", "$CoilRotorPr", _
  "Winding:=", "WindingRotor", _
  "PolarityType:=", drc)
End Sub
For i = 0 to CoilRotor-1 
  oModule.AssignCoil Array("NAME:" & "CurrentRWR_" & CStr(i), _
	"Objects:=", Array("RotWR_" & CStr(i)), _
	"Conductor number:=", "$CoilRotorPr", _
	"PolarityType:=", "Positive")
  CoilsR "Positive", "CurrentRWR_" & CStr(i)	
  oModule.AssignCoil Array("NAME:" & "CurrentRWL_" & CStr(i), _
	"Objects:=", Array("RotWL_" & CStr(i)), _
	"Conductor number:=", "$CoilRotorPr", _
	"PolarityType:=", "Negative")	
  CoilsR "Negative", "CurrentRWL_" & CStr(i)
Next
rn = CoilRotor
If CalArea >= 2 Then
  For j = 1 to CalArea-1
    For i = 0 to CoilRotor-1
	  If j mod 2 <> 0 then
	    rp = "Negative" 
	    lp = "Positive"
	  Else
	   	rp = "Positive"
	    lp = "Negative"
	  End If
	  oModule.AssignCoil Array("NAME:" & "CurrentRWR_" & CStr(rn), _
	    "Objects:=", Array("RotWR_" & CStr(i) & "_" & CStr(j)), _
	    "Conductor number:=", "$CoilRotorPr", _
	    "PolarityType:=", rp)
      CoilsR rp, "CurrentRWR_" & CStr(rn)	
      oModule.AssignCoil Array("NAME:" & "CurrentRWL_" & CStr(rn), _
	    "Objects:=", Array("RotWL_" & CStr(i) & "_" & CStr(j)), _
	    "Conductor number:=", "$CoilRotorPr", _
	    "PolarityType:=", lp)	
      CoilsR lp, "CurrentRWL_" & CStr(rn)
	  rn = rn + 1
   Next
  Next
End If
' ----------------------------------------------
' Return damper connection. 15.03.2017
' ----------------------------------------------
ReDim DmpArr(SlotPole*CalArea-1)
nd=0
For i = 0 to SlotPole-1 step 1  
  DmpArr(nd) = "Damper_" & CStr(i)
  nd = nd + 1
Next
If CalArea >= 2 Then
  For j = 2 to CalArea
    For i = 0 to SlotPole-1
	  DmpArr(nd) = "Damper_" & CStr(i) & "_" & CStr(j)
	  nd = nd + 1
	Next
  Next
End If
oModule.AssignEndConnection Array("NAME:DamperConnection", _
"Objects:=", DmpArr, _
"ResistanceValue:=", "1e-007ohm", _
"InductanceValue:=", "1e-009H")
' ----------------------------------------------
' Split DiaYoke, DiaTooth, RimRotorOut, RimRotorIn, SmallAirSector, Mover
' ----------------------------------------------
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "SplitPoleLeft")
oEditor.Split Array("NAME:Selections", _
  "Selections:=", "DiaYoke,DiaTooth,RimRotorOut,RimRotorIn,SmallAirSector,Mover", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:SplitToParameters", _
  "SplitPlane:=", "YZ", _
  "WhichSide:=", "PositiveOnly", _
  "SplitCrossingObjectsOnly:=", false, _
  "DeleteInvalidObjects:=", true)
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "SplitPoleRight")
oEditor.Split Array("NAME:Selections", _
  "Selections:=", "DiaYoke,DiaTooth,RimRotorOut,RimRotorIn,SmallAirSector,Mover", _
  "NewPartsModelFlag:=", "Model"), _
  Array("NAME:SplitToParameters", _
  "SplitPlane:=", "YZ", _
  "WhichSide:=", "PositiveOnly", _
  "SplitCrossingObjectsOnly:=", false, _
  "DeleteInvalidObjects:=", true)
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "Global")
' ----------------------------------------------
' Boundary settings
' ----------------------------------------------
oModule.AssignMaster Array("NAME:Master", _
  "Edges:=", Array(17), _
  "ReverseV:=", true)
If CalArea mod 2 = 0 Then
  oModule.AssignSlave Array("NAME:Slave", _
    "Edges:=", Array(26), _
    "ReverseU:=", false, _
    "Master:=", "Master", _
    "SameAsMaster:=", true)
Else
  oModule.AssignSlave Array("NAME:Slave", _
    "Edges:=", Array(26), _
    "ReverseU:=", false, _
    "Master:=", "Master", _
    "SameAsMaster:=", false)
End If
oModule.AssignVectorPotential Array("NAME:VectorPotential", _
  "Edges:=", Array(7), _
  "Value:=", "0", "CoordinateSystem:=", "")
' ----------------------------------------------
' Set core losses
' ----------------------------------------------  
ReDim pShoeLosses(CalArea-1+2)
k = 0
pShoeLosses(k) = "PoleShoe" 
k = k + 1
If CalArea >= 2 Then
  For i = 1 to CalArea-1
    pShoeLosses(k) = "PoleShoe_" & CStr(i)
    k = k + 1
  Next
End If  
pShoeLosses(k) = "DiaYoke"
pShoeLosses(k+1) = "DiaTooth"
oModule.SetCoreLoss pShoeLosses, false  
' ----------------------------------------------
' Polyline CenterAirGap
' ----------------------------------------------
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "SplitPoleLeft")
If CalArea > 1 Then
  PolyCalArea = 2
Else
  PolyCalArea = 1  
End If
oEditor.CreatePolyline Array("NAME:PolylineParameters", "IsPolylineCovered:=", true, "IsPolylineClosed:=", false, _
  Array("NAME:PolylinePoints", Array("NAME:PLPoint", "X:=", "0mm", "Y:=", "($DiaGap-$AirGap)/2", "Z:=", "0mm")), _
  Array("NAME:PolylineSegments", Array("NAME:PLSegment", "SegmentType:=", "AngularArc", "StartIndex:=", 0, "NoOfPoints:=", 3, _
  "NoOfSegments:=", "0", "ArcAngle:=", "-2*" & CStr(PiConst*PolyCalArea) & "/$Poles", _
  "ArcCenterX:=", "0mm", "ArcCenterY:=", "0mm", "ArcCenterZ:=", "0mm", "ArcPlane:=", "XY")), _
  Array("NAME:PolylineXSection", "XSectionType:=", "None", "XSectionOrient:=", "Auto", _
  "XSectionWidth:=", "0mm", "XSectionTopWidth:=", "0mm", "XSectionHeight:=", "0mm", "XSectionNumSegments:=", "0", "XSectionBendType:=", "Corner")), _
  Array("NAME:Attributes", "Name:=", "CenterAirGap", "Flags:=", "NonModel#", "Color:=", "(132 132 193)", "Transparency:=", 0, _
  "PartCoordinateSystem:=", "Global", "UDMId:=", "", "MaterialValue:=", "" & Chr(34) & "vacuum" & Chr(34) & "", "SolveInside:=", true)
oEditor.SetWCS Array("NAME:SetWCS Parameter", "Working Coordinate System:=", "Global")
' ----------------------------------------------
' Import external circuit
' ----------------------------------------------
oModule.EditExternalCircuit MainFolder & "electricalcircuit\" & ExternalCircuit, _
  Array("I275"), Array(1), _
  Array("$ActiveResistanceRotor", "$ActiveResistanceStator", "$NoLoadTime", "$TestTime", "$VoltageRotor"), _
  Array("$ActiveResistanceRotor", "$ActiveResistanceStator", "$NoLoadTime", "$TestTime", "$VoltageRotor")
' ----------------------------------------------
' Eddy Effect Setting
' ----------------------------------------------
Function eddy(name)
  eddy = Array("NAME:Data", "Object Name:=", name, "Eddy Effect:=", true)
End Function
ReDim aef((0*CoilRotor+SlotPole)*CalArea)
aef(0) = "NAME:EddyEffectVector"
en = 1
For i = 0 to SlotPole-1
  aef(en) = eddy("Damper_" & CStr(i))
  en = en + 1 
Next
'For i = 0 to CoilRotor-1
'  aef(en) = eddy("RotWR_" & CStr(i))
'  en = en + 1
'  aef(en) = eddy("RotWL_" & CStr(i))
'  en = en + 1
'Next
'If CalArea >= 2 Then
'  For j = 1 to CalArea-1
'    For i = 0 to CoilRotor-1
'	  aef(en) = eddy("RotWL_" & CStr(i) & "_" & CStr(j))
'      en = en + 1
'      aef(en) = eddy("RotWR_" & CStr(i) & "_" & CStr(j))
'      en = en + 1
'   Next
'  Next
'End If	
If CalArea >= 2 Then
  For j = 2 to CalArea
    For i = 0 to SlotPole-1
	  aef(en) = eddy("Damper_" & CStr(i) & "_" & CStr(j))
	  en = en + 1
	Next
  Next
End If	
oModule.SetEddyEffect Array("NAME:Eddy Effect Setting", aef)
' ----------------------------------------------
' Mover settings
' ----------------------------------------------
Set oModule = oDesign.GetModule("ModelSetup")
oModule.AssignBand Array("NAME:Data", "Move Type:=", "Rotate", _
  "Coordinate System:=", "Global", "Axis:=", "Z", _
  "Is Positive:=", true, "InitPos:=", "0deg", _
  "HasRotateLimit:=", false, "NonCylindrical:=", false, _
  "Consider Mechanical Transient:=", false, _
  "Angular Velocity:=", "($Frequency/1Hz*120)/$Poles*1rpm", "Objects:=", Array("Mover"))
oDesign.SetDesignSettings Array("NAME:Design Settings Data", "PreserveTranSolnAfterDatasetEdit:=",  _
  false, "ComputeTransientInductance:=", false, "PerfectConductorThreshold:=",  _
  1E+030, "InsulatorThreshold:=", 1, "ModelDepth:=", "$GenLength", "EnableTranTranLinkWithSimplorer:=",  _
  false, "BackgroundMaterialName:=", "vacuum-air", "Multiplier:=", "$Poles/$CalArea")  
' ----------------------------------------------
' Mesh settings 08.01.2018
' ----------------------------------------------
' Return array for MeshWSt(): stator windings, dampers, 
' diaTooth, poleShoe, band, rotor windings
' ----------------------------------------------
Set oModule = oDesign.GetModule("MeshSetup")
If Solver = 1 then
  oModule.InitialMeshSettings Array("NAME:MeshSettings", Array("NAME:GlobalSurfApproximation", "CurvedSurfaceApproxChoice:=",  _
  "UseSlider", "SliderMeshSettings:=", 5), Array("NAME:GlobalModelRes", "UseAutoLength:=", true), "MeshMethod:=", "AnsoftClassic")
End If
ReDim MeshWSt(2*NumberWSE-1+SlotPole*CalArea+2*CoilRotor*CalArea+4+(CalArea-1))
k = 0
' Stator windings
For i = 0 to NumberWSE-1
  MeshWSt(k) = "StW_T_" & CStr(i)
  MeshWSt(NumberWSE + k) = "StW_B_" & CStr(i)
  k = k + 1
Next
  k = k + NumberWSE
' Dampers
For i = 0 to SlotPole-1
  MeshWSt(k) = "Damper_" & CStr(i)
  k = k + 1
Next
If CalArea >= 2 Then
  For j = 2 to CalArea
    For i = 0 to SlotPole-1
      MeshWSt(k) = "Damper_" & CStr(i) & "_" & CStr(j)
	  k = k + 1
    Next
  Next
End If
' Rotor windings
For i = 0 to CoilRotor-1
  MeshWSt(k) = "RotWL_" & CStr(i)
  MeshWSt(k+CoilRotor) = "RotWR_" & CStr(i)
  k = k + 1
Next
k = k + CoilRotor
If CalArea >= 2 Then
  For j = 1 to CalArea-1
    For i = 0 to CoilRotor-1
      MeshWSt(k) = "RotWR_" & CStr(i) & "_" & CStr(j)
	  MeshWSt(k+CoilRotor*(CalArea-1)) = "RotWL_" & CStr(i) & "_" & CStr(j)
	  k = k + 1
    Next
  Next
End If
k = k + CoilRotor*(CalArea-1)
' DiaTooth, Pole shoes, band and mover
MeshWSt(k) = "DiaTooth" 
k = k + 1
MeshWSt(k) = "PoleShoe"
k = k + 1
MeshWSt(k) = "Band"
k = k + 1
MeshWSt(k) = "Mover"
k = k + 1
' Pole shoes
If CalArea >= 2 Then
  For i = 1 to CalArea-1
    MeshWSt(k) = "PoleShoe_" & CStr(i)
    k = k + 1
  Next
End If
' Pole bodies
ReDim MeshRotBody(CalArea-1)
MeshRotBody(0)="PoleBody"
If CalArea >= 2 Then
  For i = 1 to CalArea-1
    MeshRotBody(i) = "PoleBody_" & CStr(i)
  Next
End If
' ----------------------------------------------
's=""
'For i = 0 to ubound(MeshWSt)	
'  s = s & CStr(i) & "." & CStr(MeshWSt(i)) & " "
'  If i = 2*NumberWSE-1 Then 
'    s = s & Chr(13) & Chr(10)
'  End If
'  If i = 2*NumberWSE-1+SlotPole*CalArea Then 
'    s = s & Chr(13) & Chr(10)
'  End If
'  If i = 2*NumberWSE-1+SlotPole*CalArea+2*CoilRotor*CalArea Then 
'    s = s & Chr(13) & Chr(10)
'  End If
'  If i = 2*NumberWSE-1+SlotPole*CalArea+2*CoilRotor*CalArea+3 Then 
'    s = s & Chr(13) & Chr(10)
'  End If
'Next
'For i = 0 to ubound(MeshRotBody)	
'  s = s & CStr(i) & "." & CStr(MeshRotBody(i)) & " "
'Next
'oDesign.EditNotes s
' ----------------------------------------------
oModule.AssignLengthOp Array("NAME:1.WindingsTeethBand", _
  "RefineInside:=", true, _
  "Enabled:=", true, _
  "Objects:=", MeshWSt, _
  "RestrictElem:=", false, _
  "NumMaxElem:=", "1000", _
  "RestrictLength:=", true, _
  "MaxLength:=", CStr(MSizeWSt) & "mm")
oModule.AssignLengthOp Array("NAME:2.MeshRotBody", _
  "RefineInside:=", true, _
  "Enabled:=", true, _
  "Objects:=", MeshRotBody, _
  "RestrictElem:=", false, _
  "NumMaxElem:=", "1000", _
  "RestrictLength:=", true, _
  "MaxLength:=", CStr(MSizeRotBody) & "mm")  
oModule.AssignLengthOp Array("NAME:3.StatorYoke", _
  "RefineInside:=", true, _
  "Enabled:=", true, _
  "Objects:=", Array("DiaYoke"), _
  "RestrictElem:=", false, _
  "NumMaxElem:=", "1000", _
  "RestrictLength:=", true, _
  "MaxLength:=", CStr(MSizeDiaYoke) & "mm")
oModule.AssignLengthOp Array("NAME:4.RotorRimOut", _
  "RefineInside:=", true, _
  "Enabled:=", true, _
  "Objects:=", Array("RimRotorOut"), _
  "RestrictElem:=", false, _
  "NumMaxElem:=", "1000", _
  "RestrictLength:=", true, _
  "MaxLength:=", CStr(MSizeRimRotOut) & "mm")
oModule.AssignLengthOp Array("NAME:5.RotorRimIn", _
  "RefineInside:=", true, _
  "Enabled:=", true, _
  "Objects:=", Array("RimRotorIn"), _
  "RestrictElem:=", false, _
  "NumMaxElem:=", "1000", _
  "RestrictLength:=", true, _
  "MaxLength:=", CStr(MSizeRimRotIn) & "mm")
oModule.AssignLengthOp Array("NAME:6.AirIn", _
  "RefineInside:=", true, _
  "Enabled:=", true, _
  "Objects:=", Array("SmallAirSector"), _
  "RestrictElem:=", false, _
  "NumMaxElem:=", "1000", _
  "RestrictLength:=", true, _
  "MaxLength:=", CStr(MSizeAirIn) & "mm")
' ----------------------------------------------
' Create setup. Apply mesh operations
' ----------------------------------------------
NumberSteps = 200
TimeStopStr = "10ms"
RtFrq=2
Set oModule = oDesign.GetModule("AnalysisSetup")
oModule.InsertSetup "Transient", Array("NAME:Setup", "Enabled:=", true, _
  "NonlinearSolverResidual:=", "0.0001", _
  "TimeIntegrationMethod:=", 0, _
  "StopTime:=", CStr(1.0/Frequency/RtFrq) & "s", _
  "TimeStep:=", CStr(Frequency^(-1)/NumberSteps) & "s", _
  "OutputError:=", false, "UseControlProgram:=", false, _
  "ControlProgramName:=", " ", "ControlProgramArg:=", " ", _
  "CallCtrlProgAfterLastStep:=", false, _
  "HasSweepSetup:=", false, _
  "TransientComputeHc:=", false, _
  "ThermalFeedback:=", false, _
  Array("NAME:HcOption", _
  "TransientHcNonLinearBH:=", true, _
  "TransientComputeHc:=", false), _
  "UseAdaptiveTimeStep:=", false, _
  "InitialTimeStep:=", "0.002s", _
  "MinTimeStep:=", "0.001s", _
  "MaxTimeStep:=", "0.003s", _
  "TimeStepErrTolerance:=", 0.0001)
oDesign.ApplyMeshOps Array("Setup")
' ----------------------------------------------
' Create reports
' ----------------------------------------------
' Stator current
Set oModule = oDesign.GetModule("ReportSetup")
oModule.CreateReport "StatorCurrent", "Transient", "Rectangular Plot",  _
  "Setup : Transient", Array(), Array("Time:=", Array("All")), _
  Array("X Component:=", "Time", "Y Component:=", Array("Current(WindingStatorAX)")), Array()
oModule.AddTraces "StatorCurrent", "Setup : Transient", Array(), _
  Array("Time:=", Array("All")), Array("X Component:=", "Time", _
  "Y Component:=", Array("Current(WindingStatorBY)")), Array()
oModule.AddTraces "StatorCurrent", "Setup : Transient", Array(), _
  Array("Time:=", Array("All")), Array("X Component:=", "Time", _
  "Y Component:=", Array("Current(WindingStatorCZ)")), Array()
  
' Stator voltage
oModule.CreateReport "StatorVoltage", "Transient", "Rectangular Plot",  _
  "Setup : Transient", Array(), Array("Time:=", Array("All")), _
  Array("X Component:=", "Time", "Y Component:=", Array("InducedVoltage(WindingStatorAX)-InducedVoltage(WindingStatorBY)")), Array()
oModule.AddTraces "StatorVoltage", "Setup : Transient", Array(), _
  Array("Time:=", Array("All")), Array("X Component:=", "Time", _
  "Y Component:=", Array("InducedVoltage(WindingStatorBY)-InducedVoltage(WindingStatorCZ)")), Array()
oModule.AddTraces "StatorVoltage", "Setup : Transient", Array(), _
  Array("Time:=", Array("All")), Array("X Component:=", "Time", _
  "Y Component:=", Array("InducedVoltage(WindingStatorCZ)-InducedVoltage(WindingStatorAX)")), Array()
  
' Stator voltage characteristics
If Solver = 0 then
	oModule.AddTraceCharacteristics "StatorVoltage", "rms", Array(), Array("0ms", TimeStopStr)
	oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:General", Array("NAME:PropServers",  _
	"StatorVoltage:General"), Array("NAME:ChangedProps", Array("NAME:Precision", "MustBeInt:=", true, "Value:=", "0"))))
	oModule.AddTraceCharacteristics "StatorVoltage", "max", Array(), Array("0ms", TimeStopStr)  
	oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Scaling", Array("NAME:PropServers", "StatorVoltage:AxisY1"), Array("NAME:ChangedProps", Array("NAME:Auto Units", "Value:=", false), Array("NAME:Units", "Value:=", "V"))))
Else 
	oModule.AddTraceCharacteristics "StatorVoltage", "rms", Array(), Array("Specified", "0ms", TimeStopStr)
	oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:General", Array("NAME:PropServers",  _
	"StatorVoltage:General"), Array("NAME:ChangedProps", Array("NAME:Precision", "MustBeInt:=", true, "Value:=", "0"))))
	oModule.AddTraceCharacteristics "StatorVoltage", "max", Array(), Array("Specified", "0ms", TimeStopStr)  
	oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Scaling", Array("NAME:PropServers", "StatorVoltage:AxisY1"), Array("NAME:ChangedProps", Array("NAME:Auto Units", "Value:=", false), Array("NAME:Units", "Value:=", "V"))))
End If

If RtFrq <>2 then
' FFT stator voltage
oModule.CreateReport "FFTStatorVoltage", "Transient", "Data Table",  _
  "Setup : Transient", Array("Domain:=", "Spectral", "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, _
  "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps+1, "WindowType:=", 0, "Normalize:=", 0, "Periodic:=", 0, "FundementalFreq:=", Frequency, _
  "CutoffFreq:=", 0), Array("Freq:=", Array("All")), _
  Array("X Component:=", "Freq", "Y Component:=", Array("mag(InducedVoltage(WindingStatorAX)-InducedVoltage(WindingStatorBY))")), Array()
oModule.AddTraces "FFTStatorVoltage", "Setup : Transient", Array("Domain:=", "Spectral", _
  "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, _
  "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps+1, "WindowType:=", 0, "Normalize:=", 0, "Periodic:=", 0, "FundementalFreq:=", Frequency, _
  "CutoffFreq:=", 0), Array("Freq:=", Array("All")), _
  Array("X Component:=", "Freq", "Y Component:=", Array("mag(InducedVoltage(WindingStatorBY)-InducedVoltage(WindingStatorCZ))")), Array()
oModule.AddTraces "FFTStatorVoltage", "Setup : Transient", Array("Domain:=",  _
  "Spectral", "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, _
  "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps+1, "WindowType:=", 0, "Normalize:=", 0, "Periodic:=", 0, "FundementalFreq:=", Frequency, _
  "CutoffFreq:=", 0), Array("Freq:=", Array("All")), _
  Array("X Component:=", "Freq", "Y Component:=", Array("mag(InducedVoltage(WindingStatorCZ)-InducedVoltage(WindingStatorAX))")), Array()
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTStatorVoltage:mag(InducedVoltage(WindingStatorAX)-InducedVoltage(WindingStatorBY)):Curve1"), _ 
  Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "megV"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTStatorVoltage:mag(InducedVoltage(WindingStatorAX)-InducedVoltage(WindingStatorBY)):Curve1"), _
  Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "V")))) 
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTStatorVoltage:mag(InducedVoltage(WindingStatorBY)-InducedVoltage(WindingStatorCZ)):Curve1"), _ 
  Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "megV"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTStatorVoltage:mag(InducedVoltage(WindingStatorBY)-InducedVoltage(WindingStatorCZ)):Curve1"), _ 
  Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "V"))))    
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTStatorVoltage:mag(InducedVoltage(WindingStatorCZ)-InducedVoltage(WindingStatorAX)):Curve1"), _ 
  Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "megV"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTStatorVoltage:mag(InducedVoltage(WindingStatorCZ)-InducedVoltage(WindingStatorAX)):Curve1"), _ 
  Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "V"))))   

' THD stator voltage
oModule.CreateReport "THD", "Transient", "Data Table",  _
  "Setup : Transient", Array("Domain:=", "Spectral", "Context:=", "Moving1", _
  "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps+1, "WindowType:=",  _
  0, "Normalize:=", 0, "Periodic:=", 0, "FundementalFreq:=", 0, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=",  "$DiaGap", _
  "Y Component:=", Array("100*(sum((normalize(InducedVoltage(WindingStatorAX)-InducedVoltage(WindingStatorBY)))^2)-1)^.5")), Array()
oModule.AddTraces "THD", "Setup : Transient", Array("Domain:=", "Spectral", "Context:=", "Moving1", _
  "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps+1, "WindowType:=",  _
  0, "Normalize:=", 0, "Periodic:=", 0, "FundementalFreq:=", 0, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=",  "$DiaGap", _
  "Y Component:=", Array("100*(sum((normalize(InducedVoltage(WindingStatorBY)-InducedVoltage(WindingStatorCZ)))^2)-1)^.5")), Array()
oModule.AddTraces "THD", "Setup : Transient",  Array("Domain:=", "Spectral", "Context:=", "Moving1", _
  "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps+1, "WindowType:=",  _
  0, "Normalize:=", 0, "Periodic:=", 0, "FundementalFreq:=", 0, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=",  "$DiaGap", _
  "Y Component:=", Array("100*(sum((normalize(InducedVoltage(WindingStatorCZ)-InducedVoltage(WindingStatorAX)))^2)-1)^.5")), Array()
End If

' ----------------------------------------------
' Air gap flux. So specified. 04.04.2018
' ----------------------------------------------
oModule.CreateReport "AirGapFlux", "Fields", "Rectangular Plot", "Setup : Transient", _
  Array("Context:=", "CenterAirGap", "PointCount:=", 1001), Array("Distance:=", Array("All"), _
  "Time:=", Array(CStr(1.0*Frequency^(-1)/RtFrq) & "s")), Array("X Component:=", "Distance*$Poles/(" & CStr(PiConst) _
  & "*($DiaGap-$AirGap)*2*" & CStr(Frequency) & ")*1s", "Y Component:=", Array("Flux_Lines")), Array()
' ----------------------------------------------

' Stator losses  
oModule.CreateReport "Losses", "Transient", "Rectangular Plot",  _
  "Setup : Transient", Array(), Array("Time:=", Array("All")), _
  Array("X Component:=", "Time", "Y Component:=", Array("CoreLoss")), Array()
  
' Solid damper losses 
oModule.CreateReport "SolidLosses", "Transient", "Rectangular Plot",  _
  "Setup : Transient", Array(), Array("Time:=", Array("All")), _
  Array("X Component:=", "Time", "Y Component:=", Array("SolidLoss")), Array()
  
' Rotor current  
oModule.CreateReport "RotorCurrent ", "Transient", "Rectangular Plot",  _
  "Setup : Transient", Array(), Array("Time:=", Array("All")), _
  Array("X Component:=", "Time", "Y Component:=", Array("InputCurrent(WindingRotor)")), Array()
  
' Switch
oModule.CreateReport "SwitchCurrent", "Transient", "Rectangular Plot",  _
  "Setup : Transient", Array(), Array("Time:=", Array("All")), _
  Array("X Component:=", "Time", "Y Component:=", Array("BranchCurrent(VAmmeter251)")), Array()
' ----------------------------------------------
' Notes
' ----------------------------------------------
w = 1
  s = s & "WARNING:" & Chr(13) & Chr(10)
If ubound(WindingTop) <> ubound(WindingBottom) then 
  s = s & CStr(w) & ". The arrays size of stator winding at" & _  
  "the bottom and the top of slots are different." & Chr(13) & Chr(10)
  w = w + 1
End If
If ubound(WindingTop) mod CalArea <> 0  then
  s = s & CStr(w) & ". The arrays size of stator winding cannot" & _  
  "be divided by 'number of poles for calculation' without the remainder." & Chr(13) & Chr(10)
  w = w + 1
End If
If (Z1*CalArea) mod Poles <> 0  then
  s = s & CStr(w) & ". The size of calculation area cannot" & _  
  "be divided by 'number of poles for calculation' without the remainder. The remainder is " _
  & CStr(round(((Z1*CalArea) mod Poles)/Poles, 4)) & Chr(13) & Chr(10) & Chr(13) & Chr(10)
  w = w + 1
End If
If w = 1  then
  s = ""
End If
s = s & "INFORMATION (" & Station & "):" & Chr(13) & Chr(10)
s = s & "1. Maximum of air gap is " & CStr(Round(AirGapMax, 1)) & " [mm]"  & Chr(13) & Chr(10)
s = s & "2. Maximum of rotation angle of rotor is " & CStr(Round(MaxAngleR, 3)) & " [rad]"  & Chr(13) & Chr(10)
s = s & "3. Ratio stator core is " & CStr(Round(RatioStator, 2)) & " [-]" & Chr(13) & Chr(10)
s = s & "4. GenLength is " & CStr(Round(GenLength, 0)) & " [mm]" & Chr(13) & Chr(10)
s = s & "5. Raw stator core is " & CStr(Round(Ksr*(LengthCore-Bs*Ns), 0)) & " [mm]" & Chr(13) & Chr(10)
oDesign.EditNotes s
' -----------------------------------------------
' Analysis problem
' -----------------------------------------------
Set oModule = oDesign.GetModule("AnalysisSetup")
oModule.ResetSetupToTimeZero "Setup"
oProject.Save
oDesign.AnalyzeAll

' -----------------------------------------------
' MW_FieldReport
' Fields report
' -----------------------------------------------
Set oModule = oDesign.GetModule("FieldsReporter")
Set oEditor = oDesign.SetActiveEditor("3D Modeler")
' Return project values 
Function ProjectValue(value, lsi, nround)
  StrValue = oProject.GetVariableValue(value)
  ProjectValue = CStr(Round(CDbl(Left(StrValue, Len(StrValue)-lsi)), nround))
End Function 

' -----------------------------------------------
' Return stator core area/volume  
' -----------------------------------------------
oModule.CalcStack "clear"
oModule.EnterScalar 1
oModule.EnterVol "DiaTooth"
oModule.CalcOp "Integrate"
oModule.EnterScalar 1
oModule.EnterVol "DiaYoke"
oModule.CalcOp "Integrate"
oModule.CalcOp "+"
oModule.ClcEval "Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns")
  TopValue = oModule.GetTopEntryValue("Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns"))
  LengthCore = oProject.GetVariableValue("$LengthCore")
  LengthCore = CDbl(Left(LengthCore, Len(LengthCore)-2))/10^3
  StatorCoreVolume = CDbl(TopValue(0))*LengthCore
oModule.CalcStack "clear"

' -----------------------------------------------  
' Return stator core losses
' -----------------------------------------------
If Solver = 0 then
	oModule.CopyNamedExprToStack "coreLoss"
Else 
	oModule.CopyNamedExprToStack "Core_Loss"
End If
oModule.EnterVol "DiaTooth"
oModule.CalcOp "Integrate"
If Solver = 0 then
	oModule.CopyNamedExprToStack "coreLoss"
Else 
	oModule.CopyNamedExprToStack "Core_Loss"
End If
oModule.EnterVol "DiaYoke"
oModule.CalcOp "Integrate"
oModule.CalcOp "+"
oModule.ClcEval "Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns")
  TopValue = oModule.GetTopEntryValue("Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns"))
oModule.CalcStack "clear"  
Poles = oProject.GetVariableValue("$Poles")
Poles = CDbl(Poles)
CalArea = oProject.GetVariableValue("$CalArea")
CalArea = CDbl(CalArea)
Bs = oProject.GetVariableValue("$Bs")
Bs = CDbl(Left(Bs, Len(Bs)-2))/10^3 ' [m]
Ns = oProject.GetVariableValue("$Ns")
Ns = CDbl(Ns)
Ksr = oProject.GetVariableValue("$Ksr")
Ksr = CDbl(Ksr)
StatorCoreLosses = (Poles/CalArea)*(LengthCore-Ns*Bs)*Ksr*CDbl(TopValue(0))
' -----------------------------------------------
If Solver = 0 then
	oModule.CopyNamedExprToStack "coreLoss"
Else 
	oModule.CopyNamedExprToStack "Core_Loss"
End If
oModule.EnterVol "DiaYoke"
oModule.CalcOp "Integrate"
oModule.ClcEval "Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns")
  TopValue = oModule.GetTopEntryValue("Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns"))
oModule.CalcStack "clear"  
StatorCoreYoke = (Poles/CalArea)*(LengthCore-Ns*Bs)*Ksr*CDbl(TopValue(0))
' -----------------------------------------------
If Solver = 0 then
	oModule.CopyNamedExprToStack "coreLoss"
Else 
	oModule.CopyNamedExprToStack "Core_Loss"
End If
oModule.EnterVol "DiaTooth"
oModule.CalcOp "Integrate"
oModule.ClcEval "Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns")
  TopValue = oModule.GetTopEntryValue("Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns"))
oModule.CalcStack "clear"  
StatorCoreTooth = (Poles/CalArea)*(LengthCore-Ns*Bs)*Ksr*CDbl(TopValue(0))
' -----------------------------------------------
' Return maximum value of Bm [T]
' -----------------------------------------------
oModule.CalcStack "clear"
oModule.CopyNamedExprToStack "Mag_B"
oModule.EnterSurf "Mover"
oModule.CalcOp "Maximum"
oModule.ClcEval "Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns")
TopValue = oModule.GetTopEntryValue("Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns"))
Bmair = CDbl(TopValue(0))

' -----------------------------------------------  
' Return stator teeth area [m^2]
' -----------------------------------------------
oModule.CalcStack "clear"
oModule.EnterScalar 1
oModule.EnterSurf "DiaTooth"
oModule.CalcOp "Integrate"
oModule.ClcEval "Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns")
TopValue = oModule.GetTopEntryValue("Setup : Transient", Array("Time:=", CStr(1.0*10^9/(Frequency*RtFrq)) & "ns"))
StatorTeeth = CDbl(TopValue(0))

' -----------------------------------------------	
' Return full rotation of stator voltage [V]
' -----------------------------------------------	
If RtFrq <> 1 then
' Create ado-object
  Dim objStreamV
  Set objStreamV = CreateObject("ADODB.Stream")
  objStreamV.CharSet = "utf-8"
  objStreamV.Open
' Create fso-object 
  Set oModule = oDesign.GetModule("ReportSetup")
  oModule.ExportToFile "StatorVoltage", MainFolder & "temp/" & "RP_HalfVS" & IncTitle & ".csv"
  HalfVSFolder = MainFolder & "temp/" & "RP_HalfVS" & IncTitle & ".csv"
  FullVSFolder = MainFolder & "temp/" & "RP_FullVS" & IncTitle & ".csv"
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set inputFile  = fso.OpenTextFile(HalfVSFolder)
' Return double array  
  nFluxPoints = NumberSteps+1
  Dim   outputArrV()
  Redim outputArrV(2*nFluxPoints + 1)  
  count = 1
  Do While inputFile.AtEndOfStream <> True
    arrStr = split(inputFile.ReadLine, ",")
	arrSub = array(arrStr(0), arrStr(1), arrStr(2), arrStr(3))	
	outputArrV(count) = Join(arrSub, ",")		
	If count > 2 Then
	  arrSub = array(CStr(10 + CDbl(arrStr(0))), CStr(-Round(CDbl(arrStr(1)),5)), CStr(-Round(CDbl(arrStr(2)),5)), CStr(-Round(CDbl(arrStr(3)),5)))	
	  outputArrV(nFluxPoints + count - 1) = Join(arrSub, ",")
	End If
  count = count + 1
  Loop
  inputFile.Close
' Write csv-file RP_FluxFullAirGap
  For i = 1 to 2*nFluxPoints + 1
    objStreamV.WriteText outputArrV(i) & Chr(13) & Chr(10) 
'   outputFile.WriteLine outputArr(i)   
  Next	
objStreamV.SaveToFile MainFolder & "temp/" & "RP_FullVS" & IncTitle & ".csv", 2    
oModule.DeleteTraces Array("StatorVoltage:=", Array("InducedVoltage(WindingStatorAX)-InducedVoltage(WindingStatorBY)"))
oModule.DeleteTraces Array("StatorVoltage:=", Array("InducedVoltage(WindingStatorBY)-InducedVoltage(WindingStatorCZ)")) 
oModule.DeleteTraces Array("StatorVoltage:=", Array("InducedVoltage(WindingStatorCZ)-InducedVoltage(WindingStatorAX)")) 
oModule.ImportIntoReport "StatorVoltage", MainFolder & "temp/" & "RP_FullVS" & IncTitle & ".csv"
End If
' -----------------------------------------------
' Return FFT and 1st harmonic of stator voltage [V]
' -----------------------------------------------
Set oModule = oDesign.GetModule("Solutions")
    oModule.FFTOnReport "StatorVoltage", "Rectangular", "mag"
Set oModule = oDesign.GetModule("ReportSetup")  
FFTStatorFolder = MainFolder & "temp/" & "RP_FFTStatorVoltage" & IncTitle & ".csv"
oModule.ExportToFile "FFT StatorVoltage", MainFolder & "temp/" & "RP_FFTStatorVoltage" & IncTitle & ".csv"
' Read csv-file RP_FFTStatorVoltage
Set objFSV = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSV.OpenTextFile(FFTStatorFolder)
Dim fftNh(2)
fftNh(0)=0
fftNh(1)=0
fftNh(2)=0
For i = 1 to Round(NumberSteps/2,0)+2
    str = objFile.ReadLine
	arrStr = split(str, ",")
	If i = 3 then
	  fft1hA = CDbl(arrStr(2))/sqr(2)	  
	  fft1hB = CDbl(arrStr(4))/sqr(2)	  
	  fft1hC = CDbl(arrStr(6))/sqr(2)	  
      fft1h = (fft1hA + fft1hB + fft1hC)/3
	End If
	If i > 3 then
	  For j = 0 to 2
	    fftNh(j) = fftNh(j) + (CDbl(arrStr((j+1)*2))/sqr(2))^2
	  Next	
	End If
Next
    THDCal = (sqr(fftNh(0))/fft1hA + sqr(fftNh(1))/fft1hB + sqr(fftNh(2))/fft1hC)*100/3
	
' -----------------------------------------------	
' Return air gap flux and its FFT
' Create flux air gap if CalArea = 1
' -----------------------------------------------	
If CalArea = 1 Then
' Create ado-object
  Dim objStream
  Set objStream = CreateObject("ADODB.Stream")
  objStream.CharSet = "utf-8"
  objStream.Open
' Create fso-object 
  oModule.ExportToFile "AirGapFlux", MainFolder & "temp/" & "RP_FluxHalfAirGap" & IncTitle & ".csv"
  FluxHalfFolder = MainFolder & "temp/" & "RP_FluxHalfAirGap" & IncTitle & ".csv"
  FluxFullFolder = MainFolder & "temp/" & "RP_FluxFullAirGap" & IncTitle & ".csv"
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set inputFile  = fso.OpenTextFile(FluxHalfFolder)
' Set outputFile = fso.CreateTextFile(FluxFullFolder, ForWriting, True)
' Return double array  
  nFluxPoints = 1001
  Dim   outputArr()
  Redim outputArr(2*nFluxPoints + 1)  
  count = 1
  Do While inputFile.AtEndOfStream <> True
    arrStr = split(inputFile.ReadLine, ",")
	arrSub = array(arrStr(1), arrStr(2))	
	If count = 1 Then
	  LenStr = Len(arrStr(2))
	  arrSub = array(arrStr(1), Mid(arrStr(2), 2, LenStr-2))
    End If	
	outputArr(count) = Join(arrSub, ",")	
	If count > 2 Then
	
	  arrSub = array(CStr(500/Frequency + CDbl(arrStr(1))), CStr(-Round(CDbl(arrStr(2)), 5)))		
	  outputArr(nFluxPoints + count - 1) = Join(arrSub, ",")
	End If
  count = count + 1
  Loop
  inputFile.Close
' Write csv-file RP_FluxFullAirGap
  For i = 1 to 2*nFluxPoints + 1
    objStream.WriteText outputArr(i) & Chr(13) & Chr(10) 
'   outputFile.WriteLine outputArr(i)   
  Next	
  objStream.SaveToFile MainFolder & "temp/" & "RP_FluxFullAirGap" & IncTitle & ".csv", 2  
  oModule.DeleteTraces Array("AirGapFlux:=", Array("Flux_Lines"))
  oModule.ImportIntoReport "AirGapFlux", MainFolder & "temp/" & "RP_FluxFullAirGap" & IncTitle & ".csv"
End If
' -----------------------------------------------	
' Return FFT air gap flux
' -----------------------------------------------	
Set oModule = oDesign.GetModule("Solutions")
    oModule.FFTOnReport "AirGapFlux", "Rectangular", "mag"
Set oModule = oDesign.GetModule("ReportSetup")  
    FFTFluxFolder = MainFolder & "temp/" & "RP_FFTFluxAirGap" & IncTitle & ".csv"
    oModule.ExportToFile "FFT AirGapFlux", MainFolder & "temp/" & "RP_FFTFluxAirGap" & IncTitle & ".csv"
' Read csv-file RP_FFTFluxAirGape
Set objFSV = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSV.OpenTextFile(FFTFluxFolder)
For i = 1 to 3
    str = objFile.ReadLine
	If i = 3 then
		arrStr = split(str, ",")
		If Solver = 0 then
			Flux1f = CDbl(arrStr(1))
		Else 
			Flux1f = CDbl(arrStr(2))
		End If
	End If
Next

' -----------------------------------------------	
' Additional calculation
' -----------------------------------------------		  
w1 = 2*Z1/(2*3*Branches)
Qzp = Z1/(3*Poles)
AlfaZone = PiConst*Poles*Qzp/Z1
BetaStep = (Poles/Z1)*CoilPitch
ky1 = sin(BetaStep*PiConst/2)
kp1 = sin(AlfaZone/2)/(Qzp*sin(AlfaZone/(2*Qzp)))
k1 = ky1*kp1
FluxStatorVoltage = 2*Flux1f*PiConst*3^.5*2^.5*Frequency*w1*GenLength*10^(-3)*k1
Wt = (PiConst*(DiaGap + Hs) - Z1*Bs2)*10^(-3)/Z1
Gt = Ksr*(LengthCore-Bs*Ns)*(StatorTeeth*(Poles/CalArea))*7800
Lossesendpart = 0.142*1.8*10^6*(Bmair*0.05*Wt)^2*Gt

' -----------------------------------------------
' Damper and solid losses of rotor
' -----------------------------------------------
' Return rotor core losses
Set oModule = oDesign.GetModule("ReportSetup")
oModule.CreateReport "FFTpLosses", "Transient", "Data Table", "Setup : Transient", _
  Array("Domain:=", "Spectral", "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, _
  "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps/RtFrq+1, "WindowType:=", 0, "Normalize:=", 0, _
  "Periodic:=", 0, "FundementalFreq:=", Frequency, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=", "Freq", "Y Component:=", _
  Array("mag(CoreLoss(PoleShoe))")), Array()
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTpLosses:mag(CoreLoss(PoleShoe)):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "kW"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTpLosses:mag(CoreLoss(PoleShoe)):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "W"))))  
Set objFSV = CreateObject("Scripting.FileSystemObject")
  FFTpLosses = MainFolder & "temp/" &  "RP_FFTpLosses" & IncTitle & ".csv"
  oModule.ExportToFile "FFTpLosses", MainFolder & "temp/" & "RP_FFTpLosses" & IncTitle & ".csv"  
' Read txt-file RP_FFTpLosses.csv
Set objFile = objFSV.OpenTextFile(FFTpLosses)
For i = 1 to 2
    str = objFile.ReadLine
	If i = 2 then
		arrStr = split(str, ",")
		pLosses = CStr(CDbl(arrStr(1)))
	End If
Next
  pLosses = pLosses*(PoleLength/GenLength)

' Return damper solid losses / SolidLosses
oModule.CreateReport "FFTdLosses", "Transient", "Data Table", "Setup : Transient", _
  Array("Domain:=", "Spectral", "StartTime:=", 0, "EndTime:=", 1.0*Frequency^(-1)/RtFrq, _
  "MaxHarmonic:=", 101, "NumSamples:=", NumberSteps/RtFrq+1, "WindowType:=", 0, "Normalize:=", 0, _
  "Periodic:=", 0, "FundementalFreq:=", Frequency, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=", "Freq", "Y Component:=", _
  Array("mag(SolidLoss)")), Array()
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTdLosses:mag(SolidLoss):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "kW"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTdLosses:mag(SolidLoss):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "W"))))    
Set objFSV = CreateObject("Scripting.FileSystemObject")
FFTdLosses = MainFolder & "temp/" & "RP_FFTdLosses" & IncTitle & ".csv"
oModule.ExportToFile "FFTdLosses", MainFolder & "temp/" & "RP_FFTdLosses" & IncTitle & ".csv"
' Read txt-file RP_FFTdLosses.csv
Set objFile = objFSV.OpenTextFile(FFTdLosses)
For i = 1 to 2
    str = objFile.ReadLine
	If i = 2 then
		arrStr = split(str, ",")
		dLosses = CStr(CDbl(arrStr(1)))
	End If
Next
  dLosses = dLosses*(LengthDamper/GenLength)
  TotalLosses = Round(dLosses, 0)+Round(pLosses, 0)+Round(StatorCoreLosses, 0) 

' -----------------------------------------------	
' Notes and "SolvedValues.txt"
' -----------------------------------------------	  
' StrText = "Date	DGap[mm]	DYoke[mm]	Bs2[mm]	Gap[mm]	SCore[m2]	Losses[W]	Voltage[V]	THD[-]" & vbCrLf
StrText = ""
StrText = StrText & Day(Date) & "." &  Month(Date) & "." & Year(Date) & " " & Hour(Time) & ":" & Minute(Time) & vbTab 
StrText = StrText & Station & vbTab
StrText = StrText & _
  ProjectValue("$DiaGap", 2, 2) & vbTab & _
  ProjectValue("$DiaYoke", 2, 2) & vbTab &  _
  ProjectValue("$Bs2", 2, 2) & vbTab &   _
  ProjectValue("$AirGap", 2, 2) & vbTab
StrText = StrText & CStr(Round(StatorCoreVolume, 6)) & vbTab
StrText = StrText & CStr(Round(StatorCoreYoke, 0)) & vbTab  
StrText = StrText & CStr(Round(StatorCoreTooth, 0)) & vbTab  
StrText = StrText & CStr(Round(StatorCoreLosses, 0)) & vbTab  
StrText = StrText & CStr(Round(fft1h, 0)) & vbTab  
StrText = StrText & CStr(Round(pLosses, 0)) & vbTab 
StrText = StrText & CStr(Round(dLosses, 0)) & vbTab 
StrText = StrText & CStr(Round(THDCal, 4))  

' -----------------------------------------------	 
s = s & "RESULTS" & " (CalArea=" & CStr(CalArea) & ", ["& CStr(StYLoss(0)) & "; " & CStr(Round(StYLoss(1),2)) & "; " & CStr(StYLoss(2)) & "]):" & Chr(13) & Chr(10)
s = s & "1. Calculated stator core volume is " & CStr(Round(StatorCoreVolume, 3)) & " [m^3]" & Chr(13) & Chr(10)
s = s & "2. Stator core losses (Y+T) is " & CStr(Round(StatorCoreYoke, 0)) & " + " & CStr(Round(StatorCoreTooth, 0)) _
& " = " & CStr(Round(StatorCoreLosses, 0)) & " [W]"  & Chr(13) & Chr(10)
's = s & "3. Stator voltage is" & CStr(Round(3^0.5*StatorVoltage/3,0)) & " [V]"  & Chr(13) & Chr(10)    
s = s & "3.1. Stator voltage is " & CStr(Round(fft1h, 0)) & " [V]." & _
        " Error is " & CStr(Round((1-Round(fft1h, 0)/SVolt)*100, 1)) & "%" & Chr(13) & Chr(10)  
s = s & "3.2. Flux stator voltage (flux=" & CStr(Round(Flux1f, 3)) & "Bb/m with ky1=" & CStr(Round(ky1, 3)) & _
", kp1=" & CStr(Round(kp1, 3)) & ") is " & CStr(Round(FluxStatorVoltage, 0)) & " [V]." & _
          " Error is " & CStr(Round((1-Round(FluxStatorVoltage, 0)/SVolt)*100, 1)) & "%" & Chr(13) & Chr(10)  
s = s & "3.3. Used rotor current is " & CStr(Round(CurrentRotor,0)) & " [A]." & _
        " Error is " & CStr(Round((1-CurrentRotor/ExValue(0))*100, 1)) & "%" & Chr(13) & Chr(10)
s = s & "3.4. Expected rotor current is " & CStr(Round(CurrentRotor*SVolt/Round(fft1h, 0),0)) & " [A]"  & Chr(13) & Chr(10)
s = s & "4.1. Bm in air gap is " & CStr(Round(Bmair, 2)) & " [T]"  & Chr(13) & Chr(10)
s = s & "4.2. End part losses (0.142p(Bm*Wt)^2*Gt) is " & CStr(Round(Lossesendpart, 0)) & " [W]"  & Chr(13) & Chr(10)
s = s & "5. Rotor core losses is " & CStr(Round(pLosses, 0)) & " [W]"  & Chr(13) & Chr(10) 
s = s & "6. Damper solid losses is " & CStr(Round(dLosses, 0)) & " [W]"  & Chr(13) & Chr(10)   
s = s & "7.1. Total losses is " & CStr(TotalLosses) & " [W]"  & _
  " Error total losses is " & CStr(Round((1-TotalLosses/ExValue(1))*100, 1)) & "%"  & Chr(13) & Chr(10) 
s = s & "7.2. Total losses plus end part losses is " & CStr(TotalLosses+Round(Lossesendpart, 0)) & " [W]"  & _ 
  " Error total losses plus end part losses is " & CStr(Round((1-(TotalLosses+Round(Lossesendpart, 0))/ExValue(1))*100, 1)) & "%"  & Chr(13) & Chr(10) 
s = s & "8. THD is " & CStr(Round(THDCal, 4)) & " [%]"  &  Chr(13) & Chr(10)   

' -----------------------------------------------
' MW_DamperSolid
' MW_DamperSolid.vbs. New setup with new step 1e-4. 
' Edit setup: StartTime = .0001s, EndTime = .007s, TimeStep = .0001s
' -----------------------------------------------
Set oModule = oDesign.GetModule("BoundarySetup")
ReDim pShoeLosses(CalArea-1)
k = 0
pShoeLosses(k) = "PoleShoe" 
k = k + 1
If CalArea >= 2 Then
  For i = 1 to CalArea-1
    pShoeLosses(k) = "PoleShoe_" & CStr(i)
    k = k + 1
  Next
End If
oModule.SetCoreLoss pShoeLosses, false
Set oModule = oDesign.GetModule("AnalysisSetup")
oModule.EditSetup "Setup", Array("NAME:Setup", "Enabled:=", true, _
  "NonlinearSolverResidual:=", "0.0001", _
  "TimeIntegrationMethod:=", 0, _
  "StopTime:=", CStr(7*Frequency^(-1)/20) & "s", _
  "TimeStep:=", CStr(Frequency^(-1)/200) & "s", _ 
  "OutputError:=", false, "UseControlProgram:=", false, _
  "ControlProgramName:=", " ", "ControlProgramArg:=", " ", _
  "CallCtrlProgAfterLastStep:=", false, _
  "HasSweepSetup:=", false, _
  "TransientComputeHc:=", false, _
  "ThermalFeedback:=", false, _
  Array("NAME:HcOption", _
  "TransientHcNonLinearBH:=", true, _
  "TransientComputeHc:=", false), _
  "UseAdaptiveTimeStep:=", false, _
  "InitialTimeStep:=", "0.0001s", _
  "MinTimeStep:=", "0.00005s", _
  "MaxTimeStep:=", "0.0003s", _
  "TimeStepErrTolerance:=", 0.0001)
oModule.ResetSetupToTimeZero "Setup"
oProject.Save
oDesign.AnalyzeAll

' Return rotor core losses
Set oModule = oDesign.GetModule("ReportSetup")
oModule.CreateReport "FFTpLosses", "Transient", "Data Table", "Setup : Transient", _
  Array("Domain:=", "Spectral", "StartTime:=", 0, "EndTime:=", 7*Frequency^(-1)/20, _
  "MaxHarmonic:=", 101, "NumSamples:=", 71, "WindowType:=", 0, "Normalize:=", 0, _
  "Periodic:=", 0, "FundementalFreq:=", 142.857142857143, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=", "Freq", "Y Component:=", _
  Array("mag(CoreLoss)")), Array()
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTpLosses:mag(CoreLoss(PoleShoe)):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "kW"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTpLosses:mag(CoreLoss(PoleShoe)):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "W"))))  
Set objFSV = CreateObject("Scripting.FileSystemObject")
  FFTpLosses = MainFolder & "temp/" &  "RP_FFTpLosses" & IncTitle & ".csv"
  oModule.ExportToFile "FFTpLosses", MainFolder & "temp/" & "RP_FFTpLosses" & IncTitle & ".csv"  
' Read txt-file RP_FFTpLosses.csv
Set objFile = objFSV.OpenTextFile(FFTpLosses)
For i = 1 to 2
    str = objFile.ReadLine
	If i = 2 then
		arrStr = split(str, ",")
		pLosses = CStr(CDbl(arrStr(1)))
	End If
Next
  pLosses = pLosses*(PoleLength/GenLength)
  s = s & "5. Rotor core losses is " & CStr(Round(pLosses, 0)) & " [W]"  & Chr(13) & Chr(10) 
  
' Return damper solid losses / SolidLosses
oModule.CreateReport "FFTdLosses", "Transient", "Data Table", "Setup : Transient", _
  Array("Domain:=", "Spectral", "StartTime:=", 0, "EndTime:=", 7*Frequency^(-1)/20, _
  "MaxHarmonic:=", 101, "NumSamples:=", 71, "WindowType:=", 0, "Normalize:=", 0, _
  "Periodic:=", 0, "FundementalFreq:=", 142.857142857143, "CutoffFreq:=", 0), _
  Array("Freq:=", Array("All")), Array("X Component:=", "Freq", "Y Component:=", _
  Array("mag(SolidLoss)")), Array()
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTdLosses:mag(SolidLoss):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "kW"))))
oModule.ChangeProperty Array("NAME:AllTabs", Array("NAME:Data Filter", Array("NAME:PropServers",  _
  "FFTdLosses:mag(SolidLoss):Curve1"), Array("NAME:ChangedProps", Array("NAME:Units", "Value:=", "W"))))    
Set objFSV = CreateObject("Scripting.FileSystemObject")
FFTdLosses = MainFolder & "temp/" & "RP_FFTdLosses" & IncTitle & ".csv"
oModule.ExportToFile "FFTdLosses", MainFolder & "temp/" & "RP_FFTdLosses" & IncTitle & ".csv"
' Read txt-file RP_FFTdLosses.csv
Set objFile = objFSV.OpenTextFile(FFTdLosses)
For i = 1 to 2
    str = objFile.ReadLine
	If i = 2 then
		arrStr = split(str, ",")
		dLosses = CStr(CDbl(arrStr(1)))
	End If
Next
  dLosses = dLosses*(LengthDamper/GenLength)
  s = s & "6. Damper solid losses is " & CStr(Round(dLosses, 0)) & " [W]"  & Chr(13) & Chr(10)   
  TotalLosses = Round(dLosses, 0)+Round(pLosses, 0)+Round(StatorCoreLosses, 0)
  s = s & "7.1. Total losses is " & CStr(TotalLosses) & " [W]"  & _
  " Error total losses is " & CStr(Round((1-TotalLosses/ExValue(1))*100, 1)) & "%"  & Chr(13) & Chr(10) 
  s = s & "7.2. Total losses plus end part losses is " & CStr(TotalLosses+Round(Lossesendpart, 0)) & " [W]"  & _ 
  " Error total losses plus end part losses is " & CStr(Round((1-(TotalLosses+Round(Lossesendpart, 0))/ExValue(1))*100, 1)) & "%"  & Chr(13) & Chr(10) & Chr(13) & Chr(10) 
  oDesign.EditNotes s
 
' -----------------------------------------------	
' Notes and "SolvedValues.txt"
' -----------------------------------------------	  
StrText = StrText & CStr(Round(pLosses, 0)) & vbTab 
StrText = StrText & CStr(Round(dLosses, 0))
oDesign.EditNotes s

' -----------------------------------------------
' Create a container for txt-file
' -----------------------------------------------
Set objFSO=CreateObject("Scripting.FileSystemObject")
' Read txt-file
OutFile = MainFolder & "temp/" & "SolvedValues" & IncTitle & ".txt"
StrParag = ""
Set objFile = objFSO.OpenTextFile(OutFile)
Do Until objFile.AtEndOfStream
    StrLine = objFile.ReadLine
	StrParag = StrParag & StrLine & vbCrLf
Loop
' Write txt-file
Set objFile = objFSO.CreateTextFile(OutFile,True)
objFile.Write StrParag & StrText & vbCrLf
objFile.Close
' -----------------------------------------------
