{ stdenv, fetchurl, pkgconfig, libXft, cairo, harfbuzz
, libintlOrEmpty, gobjectIntrospection
}:

with stdenv.lib;

let
  ver_maj = "1.40";
  ver_min = "3";
in
stdenv.mkDerivation rec {
  name = "pango-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/pango/${ver_maj}/${name}.tar.xz";
    sha256 = "abba8b5ce728520c3a0f1535eab19eac3c14aeef7faa5aded90017ceac2711d3";
  };

  outputs = [ "bin" "dev" "out" "devdoc" ];

  buildInputs = [ gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ cairo harfbuzz libXft ] ++ libintlOrEmpty;

  enableParallelBuilding = true;

  doCheck = false; # test-layout fails on 1.40.3 (fails to find font config)
  # jww (2014-05-05): The tests currently fail on Darwin:
  #
  # ERROR:testiter.c:139:iter_char_test: assertion failed: (extents.width == x1 - x0)
  # .../bin/sh: line 5: 14823 Abort trap: 6 srcdir=. PANGO_RC_FILE=./pangorc ${dir}$tst
  # FAIL: testiter

  configureFlags = optional stdenv.isDarwin "--without-x";

  meta = with stdenv.lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin urkud ];
    platforms = with platforms; linux ++ darwin;
  };
}
