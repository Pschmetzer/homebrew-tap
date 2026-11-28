cask "deploy-center" do
  version "0.16.0"
  sha256 "e4f8bea3860d94b7c927ed7c776ee70efd0bd7e7852d8565b96346ec862ae0fe"

  url "https://github.com/Pschmetzer/deploy-center/releases/download/v#{version}/DeployCenter-#{version}-universal.zip"
  name "Deploy Center"
  desc "Turn off Git auto-deploy on Vercel, Render and more, and deploy by hand"
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

  # The launchd jobs of guard, autofix and the daily deploy would call a deleted program otherwise.
  uninstall launchctl: [
              "app.deploycenter.guard",
              "app.deploycenter.autofix",
              "app.deploycenter.daily",
            ],
            quit:      "app.deploycenter.mac"

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
