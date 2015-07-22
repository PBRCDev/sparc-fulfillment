class DocumentsController < ApplicationController

  before_action :find_document, only: [:show]
  before_action :authorize_document_access, only: [:show]
  before_action :validate_presence_of_upload, only: [:create]

  def index
    respond_to do |format|
      format.html { render }
      format.js {
        find_documentable

        @documents = @documentable.documents
        @documentable_id = document_params[:documentable_id]
        @documentable_type = document_params[:documentable_type]
        @documentable_sym = @documentable_type.downcase.to_sym
      }
      format.json {
        @documents = find_documentable.documents.order("CREATED_AT DESC")
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        send_data File.read(@document.path),
          type: @document.content_type,
          disposition: "attachment; filename=#{@document.original_filename}"
        mark_document_as_accessed
      }
      format.json {
        render json: { document: { state: @document.state } }
      }
    end
  end

  def new
    respond_to do |format|
      format.js {
        @document = Document.new(document_params)
      }
    end
  end

  def create
    respond_to do |format|
      format.js {
        @document = Document.create(document_params.merge!(original_filename: params[:document][:document].original_filename,
                                                           content_type: params[:document][:document].content_type))

        create_document_file

        flash.now[:success] = t(:documents)[:flash_messages][:created]
      }
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    # only allow title to be updated
    @document = Document.find(params[:id])
    @document.title = params[:document][:title]
    if @document.valid?
      @document.save
      flash.now[:success] = t(:documents)[:flash_messages][:updated]
    else
      @errors = @document.errors
    end
  end

  private

  def validate_presence_of_upload
    unless params[:document][:document].present?
      @error = t(:documents)[:flash_messages][:no_file_chosen]

      render
    end
  end

  def create_document_file
    uploaded_io = params[:document][:document]

    File.open(@document.path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end

  def find_documentable
    if params[:document].present? && (params[:document][:documentable_id].present? && params[:document][:documentable_type].present?)
      id    = params[:document][:documentable_id]
      type  = params[:document][:documentable_type]
    else
      id    = current_identity.id
      type  = 'Identity'
    end

    @documentable ||= type.constantize.find id
  end

  def find_document
    @document = Document.find(params[:id])
  end

  def authorize_document_access
    render nothing: true unless @document.accessible_by?(current_identity)
  end

  def mark_document_as_accessed
    update_identity_unaccessed_documents_counter
    @document.update_attributes last_accessed_at: Time.current
  end

  def update_identity_unaccessed_documents_counter
    if !@document.downloaded? && @document.belongs_to_identity?
      current_identity.update_counter :unaccessed_documents, -1
    end
  end

  def document_params
    params.require(:document).permit(:documentable_type, :documentable_id, :title)
  end
end
