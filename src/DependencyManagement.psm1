using namespace System


    class Dependency
    {
        [DependencyName]$DependencyName
        [SemanticVersion]$SemanticVersion
    }

    class DependencyName
    {

    }

    class SemanticVersion
    {
        [int]$Mayor
        [Int]$Minor
        [Int]$Patch
    }