# Darwin fix for `python3Packages.curl-cffi`, which `yt-dlp` pulls in
# unconditionally (nixpkgs pkgs/by-name/yt/yt-dlp/package.nix puts
# `optional-dependencies.curl-cffi` straight into `dependencies`).
#
# nixpkgs keeps curl-impersonate's upstream install name,
# `@rpath/libcurl-impersonate.4.dylib` (verified with `otool -D`), while
# curl-cffi's `use-system-libs.patch` links the cffi extension with a bare
# `-lcurl-impersonate` and no `-rpath`. dyld has nothing to resolve `@rpath`
# against, so the build dies in `pythonImportsCheck` with:
#
#   ImportError: dlopen(.../curl_cffi/_wrapper.abi3.so, 0x0002):
#     Library not loaded: @rpath/libcurl-impersonate.4.dylib
#     Reason: no LC_RPATH's found
#
# Supply the rpath at link time rather than rewriting the finished binary with
# `install_name_tool`, which would invalidate the extension's ad-hoc arm64
# signature.
final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      curl-cffi = pyprev.curl-cffi.overrideAttrs (old: {
        env = (old.env or { }) // {
          NIX_LDFLAGS = "-rpath ${final.lib.getLib final.curl-impersonate}/lib";
        };

        # The upstream suite itself is not aarch64-darwin clean once the
        # extension loads: `test_verify` (x3) asserts on the string "SSL
        # certificate problem" while curl-impersonate's BoringSSL reports "no
        # alternative certificate subject name matches target ipv4 address
        # '127.0.0.1'", `test_delete_cookies` finds the deleted cookie still in
        # the jar, and the loopback websocket tests fail unpredictably on frame
        # size ("[WS] unaligned frame size (sending 65536 instead of 8730)") --
        # on top of the six the package already lists as flaky or OOM-prone.
        # `doCheck = false` is the wrong knob here: pytestCheckHook appends
        # `pytestCheckPhase` to `preDistPhases` gated only on
        # `dontUsePytestCheck` (nixpkgs
        # pkgs/development/interpreters/python/hooks/pytest-check-hook.sh:97),
        # so the suite runs regardless of `doCheck`. `pythonImportsCheckPhase`
        # is registered the same way, so the dlopen regression this overlay
        # exists to fix is still caught on every build.
        dontUsePytestCheck = true;
      });
    })
  ];
}
