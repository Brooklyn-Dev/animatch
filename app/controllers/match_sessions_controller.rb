class MatchSessionsController < ApplicationController
  before_action :set_match_session, only: %i[ show edit update destroy ]

  # GET /match_sessions or /match_sessions.json
  def index
    @match_sessions = MatchSession.all
  end

  # GET /match_sessions/1 or /match_sessions/1.json
  def show
  end

  # GET /match_sessions/new
  def new
    @match_session = MatchSession.new
  end

  # GET /match_sessions/1/edit
  def edit
  end

  # POST /match_sessions or /match_sessions.json
  def create
    @match_session = MatchSession.new(match_session_params)

    respond_to do |format|
      if @match_session.save
        format.html { redirect_to @match_session, notice: "Match session was successfully created." }
        format.json { render :show, status: :created, location: @match_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match_session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /match_sessions/1 or /match_sessions/1.json
  def update
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
      params.expect(match_session: [ :username1, :username2, :edit_token, :shared_anime, :recommendations ])
    end
end
