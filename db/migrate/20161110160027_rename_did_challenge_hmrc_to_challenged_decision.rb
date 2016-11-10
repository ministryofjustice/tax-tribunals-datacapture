class RenameDidChallengeHmrcToChallengedDecision < ActiveRecord::Migration[5.0]
  def change
    rename_column :tribunal_cases, :did_challenge_hmrc, :challenged_decision
  end
end
