$nuget = ls .\packages\NuGet.CommandLine*\tools\NuGet.exe

$buildRoot = ".\NuGetBuild"
$settingsProviderDestination = "$buildRoot\content\Settings"
rm $buildRoot -force -recurse -ErrorAction SilentlyContinue
mkdir $settingsProviderDestination | out-null
mkdir "$buildRoot\Tools" | out-null
cp .\SettingsProviderNet\SettingsProvider.cs (Join-Path $settingsProviderDestination "SettingsProvider.cs.pp")
$eaFile = Join-Path $settingsProviderDestination SettingsProvider.cs.pp
(Get-Content $eaFile) | 
Foreach-Object { $_ -replace 'namespace SettingsProviderNet', 'namespace $rootnamespace$.Settings' } | 
Set-Content $eaFile

$nuspecFile = "SettingsProviderNet.nuspec"
cp .\SettingsProviderNet\SettingsProviderNet.nuspec "$buildRoot\$nuspecFile"
cp .\SettingsProviderNet\install.ps1 "$buildRoot\Tools\install.ps1"
pushd $buildRoot

    & $nuget pack $nuspecFile

popd