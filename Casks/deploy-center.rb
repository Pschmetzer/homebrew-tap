cask "deploy-center" do
  version "0.9.1"
  sha256 "4d8f150d668e8f4e14a64506386f4a56055409cb09ed4e968a2f0390dae23e3a"

  url "https://github.com/Pschmetzer/deploy-center/releases/download/v#{version}/DeployCenter-#{version}-universal.zip"
  name "Deploy Center"
  desc "Deploy Vercel and Render projects by hand and keep build costs down"
  homepage "https://deploycenter.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "jq"
  depends_on macos: :sequoia

  # The app updates itself (Sparkle, signed appcast on deploycenter.app), so "brew upgrade"
  # leaves it alone unless --greedy is given; brew still sees the new version via livecheck.
  auto_updates true

  app "Deploy Center.app"

  uninstall quit: "app.deploycenter.mac"

  # ~/.config/deploys stays: it holds which repo each disconnected Vercel project came from.
  zap trash: [
    "~/Library/Logs/DeployCenter.log",
    "~/Library/Preferences/app.deploycenter.mac.plist",
  ]

  caveats <<~EOS
    Homebrew 6 installs from this tap only after you trust it once:
      brew trust pschmetzer/tap
    Without admin rights, install into your own Applications folder:
      brew install --cask --appdir="$HOME/Applications" deploy-center
  EOS
end
