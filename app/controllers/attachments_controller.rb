class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    if current_user.author_of?(@attachment.record)
      @attachment.purge
    else
      head :forbidden
    end
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
