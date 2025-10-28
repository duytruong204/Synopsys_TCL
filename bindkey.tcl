## Default binding set
db::setPrefValue giBindingSet -value Maestro
## Turn-off Infix Mode
db::setPrefValue deInFixMode  -value 0
proc selectLayer { layerName purposeName } { 
  set design [ed]
  set lpp [de::getLPPs "$layerName $purposeName" -from $design]
  de::setActiveLPP $lpp
}
proc changeVisSelLPPsAll { } {
  db::setAttr visible -of [de::getLPPs -from [ed]] -value true
  db::setAttr selectable -of [de::getLPPs -from [ed]] -value true
}
proc changeVisSelLPPsNone { } {
  db::setAttr visible -of [de::getLPPs -from [ed]] -value false
  db::setAttr selectable -of [de::getLPPs -from [ed]] -value false
}
proc changeMetLayerSet { layerName purposeName } {
  db::setPrefValue leLPPSet -value "$layerName" -scope [de::getContexts -window [de::getActiveEditorWindow]]
  db::setAttr visible -of [de::getLPPs -from [ed] -filter {%valid}] -value true
  db::setAttr selectable -of [de::getLPPs -from [ed] -filter {%valid}] -value true
  de::setActiveLPP [de::getLPPs -from [ed] -filter {%lpp =="$layerName $purposeName"}]
}
proc toggleLayerVisibility { layerName purposeName } {
    set target_lpp [de::getLPPs -from [ed] -filter {%lpp == "$layerName $purposeName"}]
    set currentVisibility [db::getAttr visible -of $target_lpp]
 ;# If currentVisibility is empty, treat it as 0 (not visible)
    set currentVisibility [expr { $currentVisibility eq "" ? 0 : $currentVisibility }]
    ;# Toggle visibility
    db::setAttr visible -of $target_lpp -value [expr {!$currentVisibility}]
    db::setAttr selectable -of $target_lpp -value [expr {!$currentVisibility}]
}
proc toggleAnyAngle { } {
    set Angle [db::getPrefValue leCreateAngleMode -scope [de::getActiveContext]]
    if {$Angle != "anyAngle"} {
        db::setPrefValue  leCreateAngleMode   -value "anyAngle" -scope [de::getActiveContext]
        puts "anyAngle is on"
    } else {
        db::setPrefValue  leCreateAngleMode   -value "orthogonal" -scope [de::getActiveContext]
        puts "orthogonal is on"
    }
}
gi::createBinding -windowType leLayout -event Ctrl-Shift-k -command {toggleAnyAngle} -set Maestro

proc toggleAutoAbutment { } {
    set AutoAbutment [db::getPrefValue leAutoAbutment -scope [de::getActiveContext]]
    db::setPrefValue  leAutoAbutment -value [expr {!$AutoAbutment}] -scope [de::getActiveContext]
    puts "AutoAbutment [expr {!$AutoAbutment == 1 ? "On"  : "Off"}]"
}
gi::createBinding -windowType leLayout -event Ctrl-Shift-b -command {toggleAutoAbutment} -set Maestro
proc toggleDimming { } {
    set Shawdow [db::getPrefValue leShadowSelection -scope [de::getActiveContext]]
    set Dimming [db::getPrefValue leDimUnselected -scope [de::getActiveContext]]
    db::setPrefValue  leDimUnselected   -value [expr {!$Shawdow}] -scope [de::getActiveContext]
    db::setPrefValue  leShadowSelection -value [expr {!$Shawdow}] -scope [de::getActiveContext]
    puts "Layout Dimming [expr {!$Shawdow == 1 ? "On"  : "Off"}]"
}
gi::createBinding -windowType leLayout -event Ctrl-Shift-d -command {toggleDimming} -set Maestro
gi::createBinding -windowType leLayout -event Ctrl-t    -action leLabel                                         -set Maestro
gi::createBinding -windowType leLayout -event Ctrl-p    -action lePin                                           -set Maestro

gi::createBinding -windowType leLayout -event Ctrl-a    -action deSelectAll                                     -set Maestro
gi::createBinding -windowType leLayout -event c         -action leCopy                                          -set Maestro
gi::createBinding -windowType leLayout -event m         -action leMove                                          -set Maestro
gi::createBinding -windowType leLayout -event a         -action leAlign                                         -set Maestro
gi::createBinding -windowType leLayout -event Shift-c   -action leChop                                          -set Maestro
gi::createBinding -windowType leLayout -event Shift-m   -action leMerge                                         -set Maestro
gi::createBinding -windowType leLayout -event Ctrl-o    -action deSetOrigin                                     -set Maestro
gi::createBinding -windowType leLayout -event r         -action leRectangle                                     -set Maestro
gi::createBinding -windowType leLayout -event Shift-r   -action lePolygon                                       -set Maestro
gi::createBinding -windowType leLayout -event s         -action leStretch                                       -set Maestro
gi::createBinding -windowType leLayout -event u         -action deUndo                                          -set Maestro
gi::createBinding -windowType leLayout -event Shift-u   -action deRedo                                          -set Maestro
gi::createBinding -windowType leLayout -event y         -action leYank                                          -set Maestro
gi::createBinding -windowType leLayout -event Shift-y   -action lePaste                                         -set Maestro
gi::createBinding -windowType leLayout -event Delete    -action leDelete                                        -set Maestro
gi::createBinding -windowType leLayout -event h         -action leFlipHorizontal                                -set Maestro
gi::createBinding -windowType leLayout -event j         -action leFlipVertical                                  -set Maestro
gi::createBinding -windowType leLayout -event t         -action leTrimWire                                      -set Maestro
gi::createBinding -windowType leLayout -event e         -action deDescendInPlace                                -set Maestro
gi::createBinding -windowType leLayout -event x         -action deDescend                                       -set Maestro
gi::createBinding -windowType leLayout -event Shift-x   -action deReturn                                        -set Maestro
gi::createBinding -windowType leLayout -event f         -action deFitView                                       -set Maestro
gi::createBinding -windowType leLayout -event Shift-j   -action dbShowFindReplace                               -set Maestro
gi::createBinding -windowType leLayout -event "Shift-Greater" -command "de::replayCommand"                      -set Maestro
gi::createBinding -windowType leLayout -event 1         -command {selectLayer M1 e1; selectLayer M1 e2; selectLayer M1 e3; selectLayer M1 drawing}              -set Maestro
gi::createBinding -windowType leLayout -event 2         -command {selectLayer M2 drawing }              -set Maestro

