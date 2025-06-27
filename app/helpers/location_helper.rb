module LocationHelper
  def states_for_country
    CS.states("US").map { |code, name| [ name, code ] }.sort
  end

  def cities_for_state(state_code)
    return [] unless state_code.present?

    CS.states("US")
    CS.cities(state_code)
  end
end
