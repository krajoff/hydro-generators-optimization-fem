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
  Station = "HHP Nuoja"
' ---------------------------------------------
PiConst = 4*atn(1)
MainFolder = "D:\PhD.Calculation\Matlab_NSGAII_ES_01.06.2020_All_Cases_v3\maxwell\"
ExternalCircuit = "CC_NoLoadNuoja.sph"
IncTitle = "" ' "example" & IncTitle & ".csv"
Solver = 1 ' If 0 then Maxwell else ANSYS R19.1
' ---------------------------------------------
' Stator geometry
' ---------------------------------------------
DiaGap = 6296 ' Core diameter on gap side [mm]
DiaYoke = 6900 ' Core diameter on yoke side [mm]
LengthCore = 1320 ' Stator core length [mm]
LenghtTurn = 4885 ' One stator winding turn length [mm] ' no accuracy
Z1 = 480 ' Numbers of slots [-]
Bs1 = 20.3 ' Slot wedge maximum width [mm]
Bs2 = 14.2 ' Slot body width [mm]
Hs0 = 131.4 ' Slot opening height [mm]
Hs1 = 6.5 ' Slot wedge height [mm]
Hs2 = .8 ' Slot closed bridge height [mm]
Hsw = 55.1 ' Stator winding height [mm]
Bsw = 8.7 ' Stator winding width [mm]
Hsw_gap = 4.2 ' Distance between stator winding and slot bottom [mm]
Hsw_between = 10.4 ' Distance between stator windings [mm]
Alphas1 = PiConst/3 ' Angle base of wedge  [rad]
AirGap = 13 ' Air gap [mm]
Ns = 24 ' Air duct number of stator core [-]
Bs = 7 ' Air duct width of stator core  [mm]
Ksr = .95 ' Stacking factor of stator core [-]
Branches = 2 ' Numbers of branches [-]
CoilPitch = 10 ' Stator coil pitch [-] (1-13-23)
SVolt = 10500 ' Stator winding voltage [V]
SCurrent = 2089 ' Stator winding current [A]
Frequency = 50 ' Frequency [Hz]
ExValue = Array(750, 130000, 2089) ' 0.Rotor current [A], 1.losses [W] 2.Stator current [A]
TypeCore = 0 ' 0 is without joins, 1 is with joins
Nsuns = 7
' ---------------------------------------------
' Rotor geometry
' ---------------------------------------------
Poles = 44 ' Numbers of poles [-]
RadiusPole = 1695*0 + 1450 ' Pole radius [mm]
DiaDamper = 15 ' Pole damper diameter [mm]
LocusDamper = 1440 ' Locus damper radius [mm]
LengthDamper = 1462 ' Damper length [mm]
AlphaD = 2*PiConst/160.60 ' Angle between dampers [rad]
ShoeWidthMinor = 318 ' Minor pole shoe width [mm]
ShoeWidthMajor = 318 ' Major pole shoe width [mm]
ShoeHeight = 65 ' Pole shoe height [mm]
PoleWidth = 240 ' Pole body width [mm]
PoleHeight = 230 ' Pole body height [mm]
PoleLength = 1230 ' Pole body length [mm]
SlotPole = 6 ' Numbers of damper slots per pole [-]
SlotPoleOpen = 6 ' Numbers of damper slots per pole with opening width [-]
Bso = 2 ' Slot opening width [mm]
RadiusInRimRotor = 2465 ' Inner radius of rotor rim [mm]
Brw = 45 ' Rotor winding width [mm]
Hrw = 210 ' Rotor winding height [mm]
Srw = 8 ' Distance between rotor winding and pole body [mm]
Srh = 7 ' Distance between rotor winding and shoe bottom [mm]
Tsheet = 1.0 ' Sheet thickness [mm]
RotLoss = Array(4500, Round(2.99*Tsheet^2, 2), 0)
' ---------------------------------------------
' Calculation setting. Boundary setting. Excitation setting
' ---------------------------------------------
CoilRotor = 1 ' Rotor winding for drawing[-]
CoilRotorPr = 18 ' Rotor winding for winding parameters[-]
CalArea = 11 ' 11 is needed. Rotor poles for calculation [-]
AngleD = Z1/Poles/2-.5 ' Rotation angle of stator slot is in a counter-clockwise direction. Share of 2*pi()/Z1. 
' If AngleD mod 2 is 0 then D-axis slot, .5 is tooth. The value is about Z1/2/Poles [-]
NNull = 0 ' Stator winding is in a clockwise direction [-]
AngleR = 0 ' Rotation angle of rotor is in a counter-clockwise direction [rad]
Imax = ExValue(2)*.1 ' Maximum stator current [A]
SolutionType = 0 ' Solution type. 0 is x, 1 is x', 2 is x"
ResistanceRotor_15C = .150 ' Calculated rotor active resistance 15 C [ohm]
ResistanceStator_15C = .01014 ' Calculated phase stator active resistance 15 C [ohm]
TestTime = 10 ' Test time [s]
NoLoadTime = 1 ' Initial time of no-load running [s] 
VoltageRotor = 10 ' Rotor voltage [V]
CurrentRotor = 645 ' Rotor current [A]
' ---------------------------------------------
WindingTop =    Array ("a", "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", _
					   "x", "x", "x", "x", "c", "c", "c", "c", "y", "y", "y", _
					   "a", "a", "a", "a", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "x", "c", "c", "c", "y", "y", "y", "y", _
					   "a", "a", "a", "a", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "x", "c", "c", "c", "y", "y", "y", "y", _
					   "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "c", "c", "c", "c", "y", "y", "y", "y", _
					   "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "c", "c", "c", "c", "y", "y", "y", _
					   "a", "a", "a", "a", "z", "z", "z", "z", "b", "b", "b")
WindingBottom = Array ("a", "a", "a", "z", "z", "z", "z", "b", "b", "b", _
					   "x", "x", "x", "x", "c", "c", "c", "c", "y", "y", "y", _
					   "a", "a", "a", "a", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "x", "c", "c", "c", "y", "y", "y", "y", _
					   "a", "a", "a", "a", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "x", "c", "c", "c", "y", "y", "y", "y", _
					   "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "c", "c", "c", "c", "y", "y", "y", "y", _
					   "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "b", _
					   "x", "x", "x", "c", "c", "c", "c", "y", "y", "y", _
					   "a", "a", "a", "a", "z", "z", "z", "z", "b", "b", "b", "x")
' ---------------------------------------------
' Mesh settings
' ---------------------------------------------
MSizeWSt =  10/2 ' Mesh size of stator windings, dampers, diaTooth, poleShoe, band, rotor windings [mm]
MSizeRotBody =  10/2 ' Mesh size of rotor body [mm]
MSizeRimRotOut = 10/2 ' Mesh size of outside rotor rim [mm]
MSizeRimRotIn = 30 ' Mesh size of inside rotor rim [mm]
MSizeDiaYoke = 20/2 ' Mesh size of yoke side [mm]
MSizeAirIn = 75 ' Mesh size of inside air [mm]
' ---------------------------------------------
' Program start. Workbench setting
' ---------------------------------------------
If Solver = 0 then
	Set oAnsoftApp = CreateObject("AnsoftMaxwell.MaxwellScriptInterface")
Else 
	Set oAnsoftApp = CreateObject("Ansoft.ElectronicsDesktop")
End If
Set oDesktop = oAnsoftApp.GetAppDesktop()
oDesktop.RestoreWindow
Set oProject = oDesktop.NewProject
oProject.InsertDesign "Maxwell 2D", "", "Magnetostatic", ""
Set oDesign = oProject.GetActiveDesign()
Set oDefinitionManager = oProject.GetDefinitionManager()
Set oEditor = oDesign.SetActiveEditor("3D Modeler")
Set oModule = oDesign.GetModule("BoundarySetup")
If IncTitle <> "" then
	oProject.SaveAs MainFolder & mid(Station, 5) & mid(IncTitle, 6)  & ".aedt", true
End If
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
NumberSteps = 200
RtFrq = 1 ' 1 is 20ms; 2 is 10ms
If RtFrq = 1 Then
  TimeStopStr = "20ms"
ElseIf RtFrq = 2 Then
  TimeStopStr = "10ms"    
End If
' ---------------------------------------------
' Included files
' ---------------------------------------------
' Return THD, losses, mass and rotor current. Update 25.09.2019
Include("MW_StatorLossesCoefficients") 
Include("MW_MainPart_SplitCore")
Include("MW_Analyze")
Include("MW_R_Fields")
Include("MW_FieldReport_SplitCore")
' ---------------------------------------------
' Save solved values
Include("MW_SolvedValues")