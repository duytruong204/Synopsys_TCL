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


