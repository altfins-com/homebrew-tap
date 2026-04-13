class AltfinsSkills < Formula
  desc "Install and package reusable altFINS AI skills"
  homepage "https://github.com/altfins-com/altfins-ai-skills"
  url "https://github.com/altfins-com/altfins-ai-skills/releases/download/v0.1.2/altfins-ai-skills-src.tar.gz"
  sha256 "3a641f4eb385b960baa429a7dacf5dbf571504e6506ad5e64bb77961d4e489ec"
  version "0.1.2"
  license "Apache-2.0"

  depends_on "python@3.12"

  def install
    (libexec/"repo").install Dir["*"]

    (bin/"altfins-skills").write <<~SH
      #!/bin/bash
      export ALTFINS_SKILLS_ROOT="#{libexec}/repo"
      export ALTFINS_SKILLS_PYTHON="#{Formula["python@3.12"].opt_bin}/python3.12"
      exec "$ALTFINS_SKILLS_PYTHON" "$ALTFINS_SKILLS_ROOT/scripts/skills.py" "$@"
    SH
  end

  test do
    output = shell_output("#{bin}/altfins-skills list --json")
    assert_match "altfins-market-analyst", output
  end
end
