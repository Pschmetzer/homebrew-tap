class Deploys < Formula
  desc "Turn off Git auto-deploy on Vercel, Render and more, then deploy by hand"
  homepage "https://deploycenter.app/"
  url "https://github.com/Pschmetzer/deploy-center/releases/download/v0.12.0/deploys-cli-0.12.0.tar.gz"
  sha256 "2d316ecbe800e264a825e06b5fd11c9385374fa4b355dc9ca573bf8a7db085c1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "jq"
  uses_from_macos "bash"
  uses_from_macos "curl"

  def install
    libexec.install "deploys", "VERSION"
    libexec.install "providers" if File.directory?("providers")
    # lib/: team file, two-person rule, observers, GitLab, simulate and ledger. deploys reads
    # it next to itself (libexec), like providers/.
    libexec.install "lib" if File.directory?("lib")
    (bin/"deploys").write_env_script libexec/"deploys", {}
    doc.install "README-CLI.md"
    man1.install "man/deploys.1" if File.exist?("man/deploys.1")
  end

  def caveats
    <<~EOS
      Homebrew 6 installs from this tap only after you trust it once:
        brew trust pschmetzer/tap
      For Vercel install the Vercel CLI (npm install -g vercel); for what is waiting
      to deploy, the GitHub CLI (brew install gh). Then run: deploys doctor
      Manual page: man deploys.
      Tab completion: eval "$(deploys completion zsh)" in ~/.zshrc (or bash in ~/.bashrc).
    EOS
  end

  test do
    ENV["DEPLOYS_CONFIG"] = (testpath/"config").to_s
    assert_equal version.to_s, shell_output("#{bin}/deploys --version").strip
    assert_match "deploys doctor", shell_output("#{bin}/deploys --help")
  end
end
