nstool
======

<<<<<<< HEAD
Outputs content for a header file defining macros that alias class, symbol and
protocol names.

This allows an objective-c library to be embedded privately in other libraries
without causing a name collision if a library user also links to that library.

Arguments: 
* library-path: Path to a .dylib or .a library 
* namespace-suffix: String appended to all symbol names. 
* filtered-prefixes: Optional list of prefixes to classes and functions that should
    not be aliased (eg. NS and UI).

Inspired by a similar tool in NimbusKit.
=======
Generates a header file of prefix macros suitable for namespacing an objective-c library
>>>>>>> 62acd9e74aa72dd8cefaf6c267f2a3f34d830795
