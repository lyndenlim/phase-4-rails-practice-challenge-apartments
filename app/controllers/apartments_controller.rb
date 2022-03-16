class ApartmentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    apartments = Apartment.all
    render json: apartments
  end

  def show
    if params[:id]
      render json: find_apartment
    end
  end

  def create
    apartment = Apartment.create!(apartment_params)
    render json: apartment, status: :created
  end

  def update
    find_apartment.update(apartment_params)
    render json: find_apartment
  end

  def destroy
    find_apartment.destroy
    head :no_content
  end

  private

  def find_apartment
    Apartment.find(params[:id])
  end

  def apartment_params
    params.permit(:number)
  end

  def render_not_found_response
    render json: { error: "Apartment not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
