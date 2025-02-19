class ResultadosController < ApplicationController
  before_action :set_resultado, only: [:show, :update, :destroy]

  def index
    @resultados = Resultado.includes(:cliente).all

    render json: @resultados, each_serializer: ResultadoSerializer
  end

  def show
    render json: ResultadoSerializer.new(@resultado, includes: :cliente)
  end

  def create
    @resultado = Resultado.new(resultado_params.compact_blank)

    if @resultado.save
      render json: @resultado, status: :created, location: @resultado
    else
      render json: { errors: @resultado.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @resultado.update(resultado_params)
      render json: @resultado, location: @resultado, status: :ok
    else
      render json: { errors: @resultado.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @resultado.destroy
    render json: { status: :no_content }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resultado
      @resultado = Resultado.includes(:cliente).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resultado_params
      params.require(:resultado).permit(:cliente_id, :periodo, :valor_meta, :valor_realizado)
    end
end
