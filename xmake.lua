-- set target platform
-- $ xmake f -p linux
-- $ xmake f -p mingw
--
-- build
-- $ xmake
--
-- run
-- $ xmake r
--
-- clean
-- $ xmake c -a

if is_plat("linux") then
  set_toolchains("clang")
  set_toolset("ld", "clang") -- by default it will use c++ linker
elseif is_plat("mingw") then
  set_toolchains("mingw")
end

set_languages("c17")

target("app")
do
  set_default(true) --> this is a default target
  set_kind("binary")
  add_deps("linenoise")
  -- add_cxflags("-g") --> for debugging
  -- add_ldflags("-static")
  -- set_optimize("fastest")
  add_includedirs(
    "src",
    "src/lib/linenoise"
  )
  add_files(
    "src/**.c|lib/**"
  )
end
target_end()

target("linenoise")
do
  set_default(false)
  set_kind("object")
  add_defines(
    "USE_UTF8"
  )
  add_files(
    "src/lib/linenoise/utf8.c",
    "src/lib/linenoise/stringbuf.c",
    "src/lib/linenoise/linenoise.c"
  )
end
target_end()
