puts "I am generating imports for $argv0"
puts "..."
if {$argc == 1} {
    set arg1 $argv
    regsub -all "/" $arg1  "." arg
    regsub -all ".scm" $arg1 ".so" arg
    exec csc -J -s -o $arg1 $argv
}
