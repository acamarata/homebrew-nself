class Nself < Formula
  desc "Self-hosted infrastructure manager for developers"
  homepage "https://nself.org"
  url "https://github.com/acamarata/nself/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "1cc117486d5de1b8d4a8f33c5acbe250d662ebabb1fda8377c77091a1fd7879e"
  license "MIT"
  head "https://github.com/acamarata/nself.git", branch: "main"

  depends_on "docker"
  depends_on "bash" if OS.linux?

  def install
    # Install all files to libexec
    libexec.install Dir["*"]
    
    # Create wrapper script
    (bin/"nself").write <<~EOS
      #!/bin/bash
      export NSELF_HOME="#{libexec}"
      export PATH="#{libexec}/bin:$PATH"
      exec "#{libexec}/bin/nself" "$@"
    EOS
    
    chmod 0755, bin/"nself"
    
    # Install completions
    bash_completion.install "#{libexec}/completions/nself.bash" if File.exist?("#{libexec}/completions/nself.bash")
    zsh_completion.install "#{libexec}/completions/_nself" if File.exist?("#{libexec}/completions/_nself")
  end

  def caveats
    <<~EOS
      nself has been installed!
      
      To get started:
        mkdir my-project && cd my-project
        nself init
        nself build
        nself start
      
      Documentation: https://github.com/acamarata/nself
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nself version")
    assert_match "init", shell_output("#{bin}/nself help")
  end
end
