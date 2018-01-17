# Shared configuration for all our supported platforms

gn_args += \
    use_qt=true \
    is_component_build=false \
    is_shared=true \
    enable_nacl=false \
    enable_remoting=false \
    enable_reporting=false \
    enable_web_speech=false \
    use_allocator_shim=false \
    use_allocator=\"none\" \
    v8_use_external_startup_data=false \
    treat_warnings_as_errors=false \
    enable_swiftshader=false \
    use_custom_libcxx=false \
    use_jumbo_build=true \
    jumbo_file_merge_limit=50

qtConfig(webengine-printing-and-pdf) {
    gn_args += enable_basic_printing=true enable_print_preview=true
    gn_args += enable_pdf=true
} else {
    gn_args += enable_basic_printing=false enable_print_preview=false
    gn_args += enable_pdf=false
}

qtConfig(webengine-pepper-plugins) {
    gn_args += enable_plugins=true enable_widevine=true
} else {
    gn_args += enable_plugins=false enable_widevine=false
}

qtConfig(webengine-spellchecker) {
    gn_args += enable_spellcheck=true
} else {
    gn_args += enable_spellcheck=false
}

qtConfig(webengine-webrtc) {
    gn_args += enable_webrtc=true
} else {
    gn_args += enable_webrtc=false
}

qtConfig(webengine-proprietary-codecs): gn_args += proprietary_codecs=true ffmpeg_branding=\"Chrome\"

CONFIG(release, debug|release) {
    force_debug_info {
        # Level 1 is not enough to generate all Chromium debug symbols on Windows
        msvc: gn_args += symbol_level=2
        else: gn_args += symbol_level=1
    } else {
        gn_args += symbol_level=0
    }
}

CONFIG(debug, debug|release) {
    gn_args += use_debug_fission=false
}

!webcore_debug: gn_args += remove_webcore_debug_symbols=true
!v8base_debug: gn_args += remove_v8base_debug_symbols=true

# Compiling with -Os makes a huge difference in binary size
optimize_size: gn_args += optimize_for_size=true

# We don't want to apply sanitizer options to the build tools (GN, dict convert, etc).
!host_build {
    sanitizer: gn_args += sanitizer_keep_symbols=true
    sanitize_address: gn_args += is_asan=true
    sanitize_thread: gn_args += is_tsan=true
    sanitize_memory: gn_args += is_msan=true
    # rtti is required for a specific check of ubsan, -fsanitize=vptr, which uses the runtime
    # type information to check that correct derived objects are assigned to base pointers. Without
    # rtti, linking would fail at build time.
    sanitize_undefined: gn_args += is_ubsan=true use_rtti=true
}
