class Deploys < Formula
  desc "Turn off auto-deploy on Vercel and Render, then deploy what changed by hand"
  homepage "https://deploycenter.app/"
  url "https://github.com/Pschmetzer/deploy-center/releases/download/v0.11.0/deploys-cli-0.11.0.tar.gz"
  sha256 "15c0afab36390441257027bddf5e2d5a73c24862837353b9e456e3a2a6ec7736"
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
  end

  def caveats
    <<~EOS
      Homebrew 6 installs from this tap only after you trust it once:
        brew trust pschmetzer/tap
      For Vercel install the Vercel CLI (npm install -g vercel); for what is waiting
      to deploy, the GitHub CLI (brew install gh). Then run: deploys doctor
      Tab completion: eval "$(deploys completion zsh)" in ~/.zshrc (or bash in ~/.bashrc).
    EOS
  end

  test do
    ENV["DEPLOYS_CONFIG"] = (testpath/"config").to_s
    assert_equal version.to_s, shell_output("#{bin}/deploys --version").strip
    assert_match "deploys doctor", shell_output("#{bin}/deploys --help")
  end
end
