require "test_helper"

class HerbVersionTest < ActiveSupport::TestCase
  test "the version in .herb.yml matches the installed herb tools" do
    config = YAML.safe_load_file(Rails.root.join(".herb.yml"))
    expected = config.fetch("version")

    ["formatter", "linter"].each do |tool|
      package_path = Rails.root.join("node_modules", "@herb-tools", tool, "package.json")
      version = JSON.parse(File.read(package_path)).fetch("version")

      message = ".herb.yml expects herb #{expected}, but @herb-tools/#{tool} is #{version}. " \
                "Run `npm install` (or update .herb.yml) to bring them in sync."

      assert_equal(expected, version, message)
    end
  end
end
