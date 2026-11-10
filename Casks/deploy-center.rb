cask "deploy-center" do
  version "0.7.0"
  sha256 "2df6056cc354010072d1df9430fb34f62be3cdc32095a0fd683b25acb2386070"

  url "https://github.com/Pschmetzer/deploy-center/releases/download/v#{version}/DeployCenter-#{version}-universal.zip"
  name "Deploy Center"
  desc "Deploy Vercel and Render projects by hand and keep build costs down"
  homepage "https://github.com/Pschmetzer/deploy-center"

  depends_on macos: ">= :sequoia"

  app "Deploy Center.app"
end
