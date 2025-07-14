class OpenrestyOpenssl3 < Formula
  desc "This OpenSSL 3 library build is specifically for OpenResty uses"
  homepage "https://www.openssl.org/"
  VERSION = "3.5.1".freeze
  revision 1

  stable do
    url "https://github.com/openssl/openssl/releases/download/openssl-#{VERSION}/openssl-#{VERSION}.tar.gz"
    sha256 "529043b15cffa5f36077a4d0af83f3de399807181d607441d734196d889b641f"

    patch do
      url "https://raw.githubusercontent.com/openresty/openresty/master/patches/openssl-3.5.0-sess_set_get_cb_yield.patch"
      sha256 "fa2e0fbb4dcc880c0b7f28c4511a356b01ff85b9fa35c74b8fe3274d76782ac4"
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
    etc/"openssl@(3.5.1)"
  end
end
