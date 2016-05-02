$customModulesDestination = Join-Path $env:SystemDrive "\Program Files\WindowsPowerShell\Modules"
$customModulesSource = "\\prm-core-dc\DscResources"

Copy-Item -Verbose -Force -Recurse -Path (Join-Path $customModulesSource xSqlServer) -Destination $customModulesDestination
Copy-Item -Verbose -Force -Recurse -Path (Join-Path $customModulesSource xDatabase) -Destination $customModulesDestination
Copy-Item -Verbose -Force -Recurse -Path (Join-Path $customModulesSource xReleaseManagement) -Destination $customModulesDestination