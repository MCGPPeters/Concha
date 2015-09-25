https://github.com/aspnet/Home/wiki/Dependency-Resolution

& "$tools_directory\.nuget\NuGet.exe" install "$tools_directory\.nuget\packages.config" -OutputDirectory "$base_directory\src\packages"
	
	Get-SolutionPackages |% {
        "Restoring " + $_
        &$nuget_path install $_ -o $package_folder -configfile $nugetConfig_path
		
		
		function Get-SolutionPackages {
    gci $src_folder -Recurse "packages.config" -ea SilentlyContinue | foreach-object { $_.FullName }
}