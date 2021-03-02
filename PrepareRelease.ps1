param([switch] $VesaMount, [switch]$TiltArm)

$vVesaMount = "1.0"
$VesaFile = "VesaLiftPodMount.scad"
$VesaParamsFile = "VesaLiftPodMount.json"

$vTiltArm = "1.0" 
$TiltArmFile = "TiltArmLiftPod.scad"
$TiltArmParamsFile = "TiltArmLiftPod.json"

$libFiles = "lib\*.scad"

function New-STLsPackage {
    param ($Name, $MainFile, $LibFiles, $ParametersFile, $Version)

    $openscad = "C:\Program Files\OpenSCAD\openscad.exe"

    $releaseDir = Join-Path "publish" "${Name}_${Version}"
    $releasedScad = Join-Path $releaseDir "${Name}_${Version}.scad"
    $releasedJson = Join-Path $releaseDir "${Name}_${Version}.json"

    #Create Release dir
    if (-not (Test-Path $releaseDir)) { New-Item $releaseDir -ItemType "Directory" }

    #Compile files into one
    $files = $MainFile, $libFiles
    Get-Content $files | Select-Object -Skip 4 | Add-Content $releasedScad
    Copy-Item VesaLiftPodMount.json $releasedJson
    
    #Generate predefined STLs
    $parameterSets = (Get-Content $ParametersFile -Raw | ConvertFrom-Json).parameterSets.psobject.properties.name         
    foreach ($parameterSet in $parameterSets) {
        $stlFile = Join-Path $releaseDir "${Name}_${Version}_${parameterSet}.stl" 
        & $openscad -p $ParametersFile -P $parameterSet -o $stlFile $MainFile | Out-File "${stlFile}.log"
    }
}

if ($VesaMount) {
    New-STLsPackage -Name "VesaLiftPod" -MainFile $VesaFile -LibFiles $libFiles -ParametersFile $VesaParamsFile -Version $vVesaMount
}
if ($TiltArm) {
    New-STLsPackage -Name "LiftPodTiltArm" -MainFile $TiltArmFile -LibFiles $libFiles -ParametersFile $TiltArmParamsFile -Version $vTiltArm
}
