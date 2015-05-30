class ActivationCallRequest < ActiveRecord::Base

  validate :validated_already_called
  before_validation :reset_attempt_count

  scope :by_imi_number, ->(imi_number) { where(imi_number: imi_number) }
  scope :by_cell_number, ->(cell_number) { where(cell_number: cell_number) }

  def requests
    ActivationCallRequest.where('imi_number=? OR cell_number=?', imi_number, cell_number)
  end

  def requests_exist?
    requests.count >= 1
  end

  def previously_called?
    attempt.to_i >= 1 ? "YES" : "NO"
  end

  def validated_already_called
    errors.add(:domain, "Validation Failed Previously Called.") if requests_exist?
  end

  def reset_attempt_count
    requests.last.update_column(:attempt, attempt.to_i+1) if requests_exist?
  end

end

