class MatchSessionsController < ApplicationController
  before_action :set_match_session, only: %i[ show edit update destroy ]

  # GET /match_sessions/1 or /match_sessions/1.json
  def show
  end

  # GET /match_sessions/new
  def new
    @match_session = MatchSession.new
  end

  # GET /match_sessions/1/edit
  def edit
    @match_session = MatchSession.find(params[:id])
    unless params[:edit_token] == @match_session.edit_token
      head :forbidden
      return
    end
  end

  # POST /match_sessions or /match_sessions.json
  def create
    @match_session = MatchSession.new(match_session_params)

    # Get shared anime from Jikan API
    # Generate recommendations using shared anime

    respond_to do |format|
      if @match_session.save
        format.html { redirect_to edit_match_session_path(@match_session.id, @match_session.edit_token), notice: "Match session was successfully created." }
        format.json { render :show, status: :created, location: @match_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /match_sessions/1 or /match_sessions/1.json
  def update
    unless params[:edit_token] == @match_session.edit_token
      head :forbidden
      return
    end

    # Re-fetch shared anime
    # Re-generate recommendations

    respond_to do |format|
      if @match_session.update(match_session_params)
        format.html { redirect_to @match_session, notice: "Match session was successfully updated." }
        format.json { render :show, status: :ok, location: @match_session }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /match_sessions/1 or /match_sessions/1.json
  def destroy
    unless params[:edit_token] == @match_session.edit_token
      head :forbidden
      return
    end

    @match_session.destroy!

    respond_to do |format|
      format.html { redirect_to match_sessions_path, status: :see_other, notice: "Match session was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match_session
      @match_session = MatchSession.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def match_session_params
      params.expect(match_session: [ :username1, :username2 ])
    end
end
