# frozen_string_literal: true

require "rails_helper"

RSpec.describe Human do
  describe "automatic normalization of handle" do
    it "normalizes handles to a slug-like thing" do
      human = described_class.create!(handle: "Marc Paffi", email: "marc@example.com")
      expect(human.handle).to eq("marc_paffi")
    end
  end
end
