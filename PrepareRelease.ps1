$v = "1.0"
$files = "VesaLiftPodMount.scad", "lib\*.scad"

$openscad = "C:\Program Files\OpenSCAD\openscad.exe"

$releaseDir = Join-Path publish $v
$releasedScad = Join-Path $releaseDir "VesaLiftPod_$v.scad"
$releasedJson = Join-Path $releaseDir "VesaLiftPod_$v.json"

if (-not (Test-Path $releaseDir)) { New-Item $releaseDir -ItemType "Directory" }

Get-Content $files | Select-Object -Skip 4 | Add-Content $releasedScad
Copy-Item VesaLiftPodMount.json $releasedJson

$parameterSets = "Basic 75x75", "Basic 100x100"
foreach ($parameterSet in $parameterSets) {
    $stlFile = Join-Path $releaseDir "VesaLiftPod_${v}_${parameterSet}.stl" 
    &$openscad -p "VesaLiftPodMount.json" -P $parameterSet -o $stlFile "VesaLiftPodMount.scad" | Out-File "${stlFile}.log"
}