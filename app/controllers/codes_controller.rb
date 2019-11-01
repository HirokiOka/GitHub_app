class CodesController < ApplicationController
  def new
    require 'net/http'
    require 'uri'
    require 'json'

    gist_url = 'https://api.github.com/gists/public?page=' + rand(10).to_s + '&per_page=100'
    res = Net::HTTP.get(URI.parse(gist_url))
    array = JSON.parse(res)

    code = ''
    language = ''

    for item in array
        filename = item["files"].keys.first
        language = item["files"][filename]["language"]

        if is_programming_lang?(language) && language != nil
            raw_url = item["files"][filename]["raw_url"]
            code = Net::HTTP.get(URI.parse(raw_url)).to_s.force_encoding('UTF-8')
            html_url = item["html_url"]
            Code.create(language: language, code: code, html_url: html_url)
        end
    end
  end

  private
  def is_programming_lang?(lang)
    programming_lang = ["null", "1C Enterprise", "ABAP", "AGS Script", "AMPL", "ANTLR", "APL", "ASP", "ATS", "ActionScript", "Ada", "Agda", "Alloy", "Alpine Abuild", "AngelScript", "Apex", "Apollo Guidance Computer", "AppleScript", "Arc", "AspectJ", "Assembly", "Asymptote", "Augeas", "AutoHotkey", "AutoIt", "Awk", "Ballerina", "Batchfile", "Befunge", "Bison", "BitBake", "BlitzBasic", "BlitzMax", "Bluespec", "Boo", "Brainfuck", "Brightscript", "C", "C#", "C++", "C2hs Haskell", "CLIPS", "CMake", "COBOL", "CWeb", "Cap'n Proto", "CartoCSS", "Ceylon", "Chapel", "Charity", "ChucK", "Cirru", "Clarion", "Clean", "Click", "Clojure", "CoffeeScript", "ColdFusion", "ColdFusion CFC", "Common Lisp", "Common Workflow Language", "Component Pascal", "Cool", "Coq", "Crystal", "Csound", "Csound Document", "Csound Score", "Cuda", "Cycript", "Cython", "D", "DIGITAL Command Language", "DM", "DTrace", "Dart", "DataWeave", "Dhall", "Dockerfile", "Dogescript", "Dylan", "E", "ECL", "ECLiPSe", "EQ", "Eiffel", "Elixir", "Elm", "Emacs Lisp", "EmberScript", "Erlang", "F#", "F*", "FLUX", "Factor", "Fancy", "Fantom", "Filebench WML", "Filterscript", "Forth", "Fortran", "FreeMarker", "Frege", "G-code", "GAML", "GAMS", "GAP", "GCC Machine Description", "GDB", "GDScript", "GLSL", "Game Maker Language", "Genie", "Genshi", "Gentoo Ebuild", "Gentoo Eclass", "Gherkin", "Glyph", "Gnuplot", "Go", "Golo", "Gosu", "Grace", "Grammatical Framework", "Groovy", "Groovy Server Pages", "HCL", "HLSL", "Hack", "Harbour", "Haskell", "Haxe", "HiveQL", "HolyC", "Hy", "HyPhy", "IDL", "IGOR Pro", "Idris", "Inform 7", "Inno Setup", "Io", "Ioke", "Isabelle", "Isabelle ROOT", "J", "JFlex", "JSONiq", "JSX", "Jasmin", "Java", "Java Server Pages", "JavaScript", "JavaScript+ERB", "Jison", "Jison Lex", "Jolie", "Jsonnet", "Julia", "KRL", "Kotlin", "LFE", "LLVM", "LOLCODE", "LSL", "LabVIEW", "Lasso", "Lean", "Lex", "LilyPond", "Limbo", "Literate Agda", "Literate CoffeeScript", "Literate Haskell", "LiveScript", "Logos", "Logtalk", "LookML", "LoomScript", "Lua", "M", "M4", "M4Sugar", "MATLAB", "MAXScript", "MLIR", "MQL4", "MQL5", "MUF", "Makefile", "Mako", "Mathematica", "Max", "Mercury", "Meson", "Metal", "MiniD", "Mirah", "Modelica", "Modula-2", "Modula-3", "Module Management System", "Monkey", "Moocode", "MoonScript", "Motorola 68K Assembly", "Myghty", "NCL", "NSIS", "Nearley", "Nemerle", "NetLinx", "NetLinx+ERB", "NetLogo", "NewLisp", "Nextflow", "Nim", "Nit", "Nix", "Nu", "NumPy", "OCaml", "ObjectScript", "Objective-C", "Objective-C++", "Objective-J", "Omgrofl", "Opa", "Opal", "OpenCL", "OpenEdge ABL", "OpenRC runscript", "OpenSCAD", "Ox", "Oxygene", "Oz", "P4", "PHP", "PLSQL", "PLpgSQL", "POV-Ray SDL", "Pan", "Papyrus", "Parrot", "Parrot Assembly", "Parrot Internal Representation", "Pascal", "Pawn", "Pep8", "Perl", "Perl 6", "PicoLisp", "PigLatin", "Pike", "PogoScript", "Pony", "PowerBuilder", "PowerShell", "Processing", "Prolog", "Propeller Spin", "Puppet", "PureBasic", "PureScript", "Python", "Python console", "QML", "QMake", "Quake", "R", "REALbasic", "REXX", "RPC", "Racket", "Ragel", "Rascal", "Reason", "Rebol", "Red", "Redcode", "Ren'Py", "RenderScript", "Ring", "RobotFramework", "Rouge", "Ruby", "Rust", "SAS", "SMT", "SQF", "SQLPL", "Sage", "SaltStack", "Scala", "Scheme", "Scilab", "Self", "ShaderLab", "Shell", "ShellSession", "Shen", "Slash", "Slice", "SmPL", "Smali", "Smalltalk", "Smarty", "Solidity", "SourcePawn", "Squirrel", "Stan", "Standard ML", "Stata", "SuperCollider", "Swift", "SystemVerilog", "TI Program", "TLA", "TSQL", "TSX", "TXL", "Tcl", "Tcsh", "Terra", "Thrift", "Turing", "TypeScript", "Unified Parallel C", "Unix Assembly", "Uno", "UnrealScript", "UrWeb", "V", "VCL", "VHDL", "Vala", "Verilog", "Vim script", "Visual Basic", "Volt", "WebAssembly", "WebIDL", "Wollok", "X10", "XC", "XProc", "XQuery", "XS", "XSLT", "Xojo", "Xtend", "YARA", "Yacc", "ZAP", "ZIL", "Zeek", "ZenScript", "Zephir", "Zig", "Zimpl", "eC", "fish", "mcfunction", "mupad", "nesC", "ooc", "q", "sed", "wdl", "wisp", "xBase"] 
    for item in programming_lang
        if item == lang
            return true
        end
    end
    return false
  end
end
