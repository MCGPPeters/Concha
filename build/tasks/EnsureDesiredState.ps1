# Setups

function EnsureDirectory {
    param($directory)

    if(!(test-path $directory)) {
        mkdir $directory
    }
}