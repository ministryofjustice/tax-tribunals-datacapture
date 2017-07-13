class RemoveLetterCheckboxesFromTribunalCase < ActiveRecord::Migration[5.0]
  def up
    update_old_draft_cases!

    remove_column :tribunal_cases, :original_notice_provided
    remove_column :tribunal_cases, :review_conclusion_provided
  end

  def down
    add_column :tribunal_cases, :original_notice_provided, :boolean, default: false
    add_column :tribunal_cases, :review_conclusion_provided, :boolean, default: false
  end

  private

  # This will find any draft cases (i.e. cases associated to an user, not yet submitted)
  # that made it to the previous iteration of our `documents checklist` step and, as we
  # were using a different document key to store their documents, they will not see them
  # in the `check your answers` page now, so the safest thing to do is reset their
  # `navigation_stack` so next time they resume the case (as they will, if they want to
  # submit it) we take them back to the first step (case type).
  #
  # It is not an ideal solution but the affected number of cases should be very low, and
  # all the steps will be pre-filled already so the user only have to click `continue`
  # until they reach the new `letter upload` step.
  #
  def update_old_draft_cases!
    drafts_found = TribunalCase.with_owner.not_submitted.select do |draft|
      draft.original_notice_provided? || draft.review_conclusion_provided?
    end

    if drafts_found.any?
      puts "update_old_draft_cases! #{drafts_found.size} cases found"

      # This will not modify any date in the case, nor have any other side effects
      TribunalCase.where(id: drafts_found.pluck(:id)).update_all(
        navigation_stack: ['/steps/appeal/case_type']
      )
    end
  end
end
