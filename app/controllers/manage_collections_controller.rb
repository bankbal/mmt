# :nodoc:
class ManageCollectionsController < ManageMetadataController
  include BulkUpdates

  def show
    # If you change this number you must also change it in the corresponding test file - features/manage_metadata/open_drafts_spec.rb.
    @draft_display_max_count = 5

    @drafts = current_user.drafts.where(draft_type: 'CollectionDraft').where(provider_id: current_user.provider_id)
                          .order('updated_at DESC')
                          .limit(@draft_display_max_count + 1)

    @bulk_updates = retrieve_bulk_updates.take(@draft_display_max_count + 1)
  end
end
