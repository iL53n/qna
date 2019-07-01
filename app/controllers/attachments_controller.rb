class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    if current_user.author_of?(@attachment.record)
      @attachment.purge
    else
      render plain: 'Forbidden', status: 403
    end
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
