class OpenrestyOpenssl3 < Formula
  desc "This OpenSSL 3 library build is specifically for OpenResty uses"
  homepage "https://www.openssl.org/"
  VERSION = "3.0.15".freeze
  revision 1

  stable do
    url "https://github.com/openssl/openssl/releases/download/openssl-#{VERSION}/openssl-#{VERSION}.tar.gz"
    sha256 "23c666d0edf20f14249b3d8f0368acaee9ab585b09e1de82107c66e1f3ec9533"

    patch do
      url "https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-3.0.15-sess_set_get_cb_yield.patch"
      sha256 "4c9925018f49c70ebd2f197a4cb15d9517416ad08366bac9849afb0d2b8ec922"
    end
  end

  keg_only "only for use with OpenResty"

  # Only needs 5.10 to run, but needs >5.13.4 to run the testsuite.
  # https://github.com/openssl/openssl/blob/4b16fa791d3ad8/README.PERL
  # The MacOS ML tag is same hack as the way we handle most :python deps.
  depends_on "perl" if build.with?("test") && MacOS.version <= :mountain_lion

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args; %W[
    --prefix=#{prefix}
    --openssldir=#{openssldir}
    --libdir=lib
    no-threads
    shared
    zlib
    -g
    enable-ssl3
    enable-ssl3-method
  ]
  end

  def install
    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    if which("perl") == Formula["perl"].opt_bin/"perl"
      ENV["PERL"] = Formula["perl"].opt_bin/"perl"
    end

    arch_args = %W[darwin64-#{Hardware::CPU.arch}-cc enable-ec_nistp_64_gcc_128]

    #ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "test" if build.with?("test")
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl@(3.0.15)"
  end
end
